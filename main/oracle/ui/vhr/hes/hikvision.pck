create or replace package Ui_Vhr159 is
  ----------------------------------------------------------------------------------------------------
  Function Load_Data return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Save_Tracks(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Employee(p Hashmap);
end Ui_Vhr159;
/
create or replace package body Ui_Vhr159 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR159:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Data return Arraylist is
    v_Company_Id number := Ui.Company_Id;
  
    v_Device         Hashmap;
    v_Persons        Arraylist;
    v_Person         Hashmap;
    v_Photo_Shas     Array_Varchar2;
    v_Device_Type_Id number;
    v_Date           date := Trunc(sysdate);
    result           Arraylist := Arraylist();
  begin
    v_Device_Type_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
  
    for r in (select w.*, d.Location_Id
                from Htt_Devices d
                join Htt_Acms_Devices w
                  on d.Company_Id = w.Company_Id
                 and d.Device_Id = w.Device_Id
               where d.Company_Id = v_Company_Id
                 and d.Device_Type_Id = v_Device_Type_Id
                 and d.State = 'A')
    loop
      v_Device  := Fazo.Zip_Map('device_id',
                                r.Device_Id,
                                'host',
                                r.Host,
                                'login',
                                r.Login,
                                'password',
                                r.Password);
      v_Persons := Arraylist();
    
      for r_Person in (select p.*, Np.Name
                         from Htt_Persons p
                         join Mr_Natural_Persons Np
                           on p.Company_Id = v_Company_Id
                          and p.Person_Id = Np.Person_Id
                        where p.Company_Id = v_Company_Id
                          and p.Pin is not null
                          and Np.State = 'A'
                          and exists
                        (select *
                                 from Htt_Location_Persons Lp
                                where Lp.Company_Id = v_Company_Id
                                  and Lp.Location_Id = r.Location_Id
                                  and Lp.Person_Id = p.Person_Id
                                  and exists
                                (select 1
                                         from Href_Staffs s
                                        where s.Company_Id = v_Company_Id
                                          and s.Filial_Id = Lp.Filial_Id
                                          and s.Employee_Id = Lp.Person_Id
                                          and s.Hiring_Date <= v_Date
                                          and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Date)
                                          and s.State = 'A')
                                  and not exists (select *
                                         from Htt_Blocked_Person_Tracking w
                                        where w.Company_Id = Lp.Company_Id
                                          and w.Filial_Id = Lp.Filial_Id
                                          and w.Employee_Id = Lp.Person_Id)))
      loop
        v_Person := Fazo.Zip_Map('person_id',
                                 r_Person.Person_Id,
                                 'pin',
                                 r_Person.Pin,
                                 'name',
                                 r_Person.Name);
      
        select Photo_Sha
          bulk collect
          into v_Photo_Shas
          from Htt_Person_Photos
         where Company_Id = r_Person.Company_Id
           and Person_Id = r_Person.Person_Id;
      
        v_Person.Put('photo_shas', v_Photo_Shas);
      
        v_Persons.Push(v_Person);
      end loop;
    
      v_Device.Put('persons', v_Persons);
    
      Result.Push(v_Device);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Tracks(p Hashmap) return Hashmap is
    r_Device        Htt_Devices%rowtype;
    r_Track         Htt_Tracks%rowtype;
    v_Track         Hashmap;
    v_Tracks        Arraylist;
    v_Statuses      Matrix_Varchar2;
    v_Filial_Ids    Array_Number;
    v_Sysdate       date := Trunc(sysdate);
    v_Track_Type    varchar2(1);
    v_Dummy         varchar2(1);
    v_Timezone_Code Md_Timezones.Timezone_Code%type;
    result          Hashmap := Hashmap();
  begin
    r_Device := z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id,
                                   i_Device_Id  => p.r_Number('device_id'));
  
    v_Tracks   := p.r_Arraylist('tracks');
    v_Statuses := Matrix_Varchar2();
  
    r_Track.Company_Id  := r_Device.Company_Id;
    r_Track.Device_Id   := r_Device.Device_Id;
    r_Track.Location_Id := r_Device.Location_Id;
    v_Timezone_Code     := Htt_Util.Load_Timezone(i_Company_Id  => r_Track.Company_Id,
                                                  i_Location_Id => r_Track.Location_Id);
  
    for i in 1 .. v_Tracks.Count
    loop
      begin
        v_Track := Treat(v_Tracks.r_Hashmap(i) as Hashmap);
      
        z_Htt_Tracks.To_Row(r_Track, --
                            v_Track,
                            z.Person_Id,
                            z.Track_Type,
                            z.Mark_Type,
                            z.Photo_Sha);
      
        r_Track.Track_Time := Htt_Util.Convert_Timestamp(i_Date     => v_Track.r_Date('track_time',
                                                                                      Href_Pref.c_Date_Format_Second),
                                                         i_Timezone => v_Timezone_Code);
        r_Track.Is_Valid   := 'Y';
        v_Track_Type       := r_Track.Track_Type;
      
        v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Track.Company_Id,
                                                i_Location_Id => r_Track.Location_Id,
                                                i_Person_Id   => r_Track.Person_Id);
      
        if v_Filial_Ids.Count = 0 then
          b.Raise_Error(t('the person is not attached to the location where the device is installed, filial_id=$2, location_id=$1, person_id=$3',
                          r_Track.Filial_Id,
                          r_Track.Location_Id,
                          r_Track.Person_Id));
        end if;
      
        for j in 1 .. v_Filial_Ids.Count
        loop
          r_Track.Filial_Id := v_Filial_Ids(j);
          r_Track.Track_Id  := Htt_Next.Track_Id;
          v_Dummy           := null;
        
          if v_Track_Type is null then
            begin
              select Decode(Last_Track_Type,
                            Htt_Pref.c_Track_Type_Input,
                            Htt_Pref.c_Track_Type_Output,
                            Htt_Pref.c_Track_Type_Input)
                into r_Track.Track_Type
                from (select t.Track_Type as Last_Track_Type
                        from Htt_Tracks t
                       where t.Company_Id = r_Track.Company_Id
                         and t.Filial_Id = r_Track.Filial_Id
                         and t.Person_Id = r_Track.Person_Id
                         and t.Track_Date = v_Sysdate
                         and t.Track_Type <> Htt_Pref.c_Track_Type_Check
                       order by t.Track_Time desc)
               where Rownum = 1;
            exception
              when No_Data_Found then
                r_Track.Track_Type := Htt_Pref.c_Track_Type_Input;
            end;
          end if;
        
          begin
            select 'x'
              into v_Dummy
              from Htt_Tracks q
             where q.Company_Id = r_Track.Company_Id
               and q.Filial_Id = r_Track.Filial_Id
               and q.Person_Id = r_Track.Person_Id
               and q.Track_Time = r_Track.Track_Time
               and q.Original_Type = v_Track_Type;
          exception
            when No_Data_Found then
              Htt_Api.Track_Add(r_Track);
          end;
        end loop;
      
        Fazo.Push(v_Statuses, i, 'success');
      exception
        when others then
          Fazo.Push(v_Statuses, i, 'error', b.Trim_Ora_Error(sqlerrm));
      end;
    end loop;
  
    Result.Put('statuses', Fazo.Zip_Matrix(v_Statuses));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Employee(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Person_Id  number := Md_Next.Person_Id;
    v_Pin        number := p.r_Varchar2('pin');
    v_Photo_Sha  varchar2(200) := p.o_Varchar2('photo_sha');
    v_Name       varchar2(750) := p.r_Varchar2('name');
    v_Role_Id    number;
  
    v_Employee        Href_Pref.Employee_Rt;
    v_Person          Href_Pref.Person_Rt;
    v_Person_Identity Htt_Pref.Person_Rt;
    r_Data            Md_Users%rowtype;
  begin
    v_Person.Company_Id           := v_Company_Id;
    v_Person.Person_Id            := v_Person_Id;
    v_Person.First_Name           := v_Name;
    v_Person.Photo_Sha            := v_Photo_Sha;
    v_Person.Gender               := Md_Pref.c_Pg_Male;
    v_Person.Key_Person           := 'N';
    v_Person.Access_All_Employees := 'N';
    v_Person.State                := 'A';
  
    v_Employee.Person    := v_Person;
    v_Employee.Filial_Id := v_Filial_Id;
    v_Employee.State     := v_Person.State;
  
    Href_Api.Employee_Save(v_Employee);
  
    -----------------------htt persons---------------------------  
    Htt_Util.Person_New(o_Person     => v_Person_Identity,
                        i_Company_Id => v_Company_Id,
                        i_Person_Id  => v_Person_Id,
                        i_Pin        => v_Pin,
                        i_Pin_Code   => null,
                        i_Rfid_Code  => null,
                        i_Qr_Code    => Htt_Util.Qr_Code_Gen(v_Person_Id));
  
    Htt_Api.Person_Save(v_Person_Identity);
  
    if v_Photo_Sha is not null then
      Htt_Api.Person_Save_Photo(i_Company_Id => v_Company_Id,
                                i_Person_Id  => v_Person_Id,
                                i_Photo_Sha  => v_Photo_Sha,
                                i_Is_Main    => 'Y');
    end if;
  
    -------------------------md users-------------------------    
    r_Data.Company_Id := v_Company_Id;
    r_Data.User_Id    := v_Person_Id;
    r_Data.User_Kind  := Md_Pref.c_Uk_Normal;
    r_Data.State      := 'A';
    r_Data.Name       := v_Name;
  
    Md_Api.User_Save(r_Data);
  
    Md_Api.User_Add_Filial(i_Company_Id => v_Company_Id,
                           i_User_Id    => v_Person_Id,
                           i_Filial_Id  => v_Filial_Id);
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => v_Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    if v_Role_Id is not null then
      Md_Api.Role_Grant(i_Company_Id => v_Company_Id,
                        i_User_Id    => v_Person_Id,
                        i_Filial_Id  => v_Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  end;

end Ui_Vhr159;
/
