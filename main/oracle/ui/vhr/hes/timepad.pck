create or replace package Ui_Vhr91 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Filials return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Bind_Device(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Load_Settings(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Holidays(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Procedure Device_Update(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Settings(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Save_Tracks(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Check_Admin(p Hashmap);
end Ui_Vhr91;
/
create or replace package body Ui_Vhr91 is
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
    return b.Translate('UI-VHR91:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Filials return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from md_filials q
                      where q.company_id = :company_id
                        and q.filial_id <> :filial_head
                        and exists (select 1
                               from md_user_filials s
                              where s.company_id = q.company_id
                                and s.user_id = :user_id
                                and s.filial_id = q.filial_id)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_head',
                                 Md_Pref.Filial_Head(Ui.Company_Id),
                                 'user_id',
                                 Ui.User_Id));
  
    q.Number_Field('filial_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.location_id,
                            q.name,
                            lf.filial_id
                       from htt_locations q
                       join htt_location_filials lf
                         on lf.company_id = :company_id
                        and lf.location_id = q.location_id
                      where q.company_id = :company_id
                        and q.state = ''A''',
                    Fazo.Zip_Map('company_id', Ui.Company_Id));
  
    q.Number_Field('filial_id', 'location_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Bind_Device(p Hashmap) is
    r_Device Htt_Devices%rowtype;
  begin
    z_Htt_Devices.Init(p_Row            => r_Device,
                       i_Company_Id     => Ui.Company_Id,
                       i_Device_Id      => Htt_Next.Device_Id,
                       i_Name           => p.o_Varchar2('name'),
                       i_Device_Type_Id => Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Timepad),
                       i_Serial_Number  => p.r_Varchar2('serial_number'),
                       i_Location_Id    => p.r_Number('location_id'),
                       i_State          => 'A',
                       i_Last_Seen_On   => sysdate,
                       i_Lang_Code      => Nvl(p.o_Varchar2('lang_code'),
                                               Hes_Util.Get_Lang_Code(Ui.Company_Id)));
  
    Htt_Api.Device_Add(r_Device);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Device_Id(i_Serial_Number varchar2) return number is
    v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Timepad);
    result           number;
  begin
    select q.Device_Id
      into result
      from Htt_Devices q
     where q.Company_Id = Ui.Company_Id
       and q.Device_Type_Id = v_Device_Type_Id
       and q.Serial_Number = i_Serial_Number;
  
    Htt_Api.Device_Update(i_Company_Id   => Ui.Company_Id,
                          i_Device_Id    => result,
                          i_Last_Seen_On => Option_Date(sysdate));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Settings(p Hashmap) return Hashmap is
    r_Device    Htt_Devices%rowtype;
    v_Person    Hashmap;
    v_Persons   Arraylist;
    v_Photos    Array_Varchar2;
    v_Lang_Code varchar2(10);
    v_Settings  Hes_Pref.Timepad_Track_Settings_Rt;
    result      Hashmap;
  begin
    r_Device := z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id,
                                   i_Device_Id  => Device_Id(p.r_Varchar2('serial_number')));
  
    result := z_Htt_Devices.To_Map(r_Device, z.Name, z.Location_Id);
  
    if r_Device.Use_Settings = 'Y' then
      v_Settings := Hes_Util.Timepad_Track_Settings(Ui.Company_Id);
    
      Result.Put('track_types', v_Settings.Track_Types);
      Result.Put('mark_types', v_Settings.Mark_Types);
      Result.Put('emotion_types', v_Settings.Emotion_Types);
    
      v_Lang_Code := v_Settings.Lang_Code;
    else
      Result.Put('track_types', r_Device.Track_Types);
      Result.Put('mark_types', r_Device.Mark_Types);
      Result.Put('emotion_types', r_Device.Emotion_Types);
    
      v_Lang_Code := r_Device.Lang_Code;
    end if;
  
    Result.Put('location_name',
               z_Htt_Locations.Load(i_Company_Id => r_Device.Company_Id, --
               i_Location_Id => r_Device.Location_Id).Name);
  
    v_Persons := Arraylist();
    for r in (select k.*, --
                     s.First_Name,
                     s.Birthday
                from Htt_Location_Persons q
                join Htt_Persons k
                  on k.Company_Id = q.Company_Id
                 and k.Person_Id = q.Person_Id
                join Mr_Natural_Persons s
                  on s.Company_Id = q.Company_Id
                 and s.Person_Id = q.Person_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Location_Id = r_Device.Location_Id
                 and not exists (select *
                        from Htt_Blocked_Person_Tracking w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Employee_Id = q.Person_Id))
    loop
      v_Person := Hashmap();
      v_Person.Put('person_id', r.Person_Id);
      v_Person.Put('name', r.First_Name);
      v_Person.Put('pin', r.Pin);
      v_Person.Put('pin_code', r.Pin_Code);
      v_Person.Put('qr_code', r.Qr_Code);
      v_Person.Put('lang_code', v_Lang_Code);
      v_Person.Put('birthday', r.Birthday);
    
      select q.Photo_Sha
        bulk collect
        into v_Photos
        from Htt_Person_Photos q
       where q.Company_Id = r.Company_Id
         and q.Person_Id = r.Person_Id;
    
      v_Person.Put('photos', v_Photos);
    
      v_Persons.Push(v_Person);
    end loop;
  
    Result.Put('persons', v_Persons);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Holidays(p Hashmap) return Arraylist is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_Current_Date    date := Trunc(sysdate);
    r_Device          Htt_Devices%rowtype;
    r_Staff           Href_Staffs%rowtype;
    v_Person_Holidays Hashmap;
    v_Holidays        Arraylist;
    result            Arraylist := Arraylist();
  begin
    r_Device := z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id,
                                   i_Device_Id  => Device_Id(p.r_Varchar2('serial_number')));
  
    for r in (select q.Person_Id
                from Htt_Persons q
               where q.Company_Id = r_Device.Company_Id
                 and (exists (select 1
                                from Htt_Device_Admins k
                               where k.Company_Id = r_Device.Company_Id
                                 and k.Device_Id = r_Device.Device_Id
                                 and k.Person_Id = q.Person_Id) or --
                      exists (select 1
                                from Htt_Location_Persons s
                               where s.Company_Id = r_Device.Company_Id
                                 and s.Location_Id = r_Device.Location_Id
                                 and s.Person_Id = q.Person_Id
                                 and not exists (select *
                                        from Htt_Blocked_Person_Tracking w
                                       where w.Company_Id = s.Company_Id
                                         and w.Filial_Id = s.Filial_Id
                                         and w.Employee_Id = s.Person_Id))))
    loop
      v_Person_Holidays := Fazo.Zip_Map('person_id', r.Person_Id);
    
      r_Staff := Uit_Href.Get_Primary_Staff(i_Employee_Id => r.Person_Id, i_Date => v_Current_Date);
    
      v_Holidays := Arraylist();
    
      for h in (select d.Calendar_Date, --
                       d.Name
                  from Htt_Calendar_Days d
                 where d.Company_Id = v_Company_Id
                   and d.Filial_Id = v_Filial_Id
                   and d.Calendar_Id = (select t.Calendar_Id
                                          from Htt_Schedules t
                                         where t.Company_Id = v_Company_Id
                                           and t.Filial_Id = v_Filial_Id
                                           and t.Schedule_Id = r_Staff.Schedule_Id)
                   and d.Day_Kind = Htt_Pref.c_Day_Kind_Holiday
                   and d.Calendar_Date >= v_Current_Date)
      loop
        v_Holidays.Push(Fazo.Zip_Map('holiday_date', h.Calendar_Date, 'name', h.Name));
      end loop;
    
      v_Person_Holidays.Put('holidays', v_Holidays);
    
      Result.Push(v_Person_Holidays);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Device_Update(p Hashmap) is
  begin
    Htt_Api.Device_Update(i_Company_Id        => Ui.Company_Id,
                          i_Device_Id         => Device_Id(p.r_Varchar2('serial_number')),
                          i_Charge_Percentage => Option_Number(p.o_Number('charge_percentage')));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Settings(p Hashmap) is
  begin
    Htt_Api.Device_Update(i_Company_Id    => Ui.Company_Id,
                          i_Device_Id     => Device_Id(p.r_Varchar2('serial_number')),
                          i_Name          => Option_Varchar2(p.o_Varchar2('name')),
                          i_Location_Id   => Option_Number(p.r_Varchar2('location_id')),
                          i_Track_Types   => Option_Varchar2(p.o_Varchar2('track_types')),
                          i_Mark_Types    => Option_Varchar2(p.o_Varchar2('mark_types')),
                          i_Emotion_Types => Option_Varchar2(p.o_Varchar2('emotion_types')),
                          i_Use_Settings  => Option_Varchar2('N'),
                          i_Lang_Code     => Option_Varchar2(Nvl(p.o_Varchar2('lang_code'),
                                                                 Hes_Util.Get_Lang_Code(Ui.Company_Id))));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Tracks(p Hashmap) return Hashmap is
    r_Device        Htt_Devices%rowtype;
    r_Track         Htt_Tracks%rowtype;
    v_Track         Hashmap;
    v_Tracks        Arraylist;
    v_Track_Types   Matrix_Varchar2;
    v_Errors        Matrix_Varchar2;
    v_Sysdate       date := Trunc(sysdate);
    v_Timezone_Code Md_Timezones.Timezone_Code%type;
    result          Hashmap := Hashmap();
  begin
    r_Device := z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id,
                                   i_Device_Id  => Device_Id(p.r_Varchar2('serial_number')));
  
    v_Tracks      := p.r_Arraylist('tracks');
    v_Track_Types := Matrix_Varchar2();
    v_Errors      := Matrix_Varchar2();
  
    r_Track.Company_Id  := Ui.Company_Id;
    r_Track.Filial_Id   := Ui.Filial_Id;
    r_Track.Device_Id   := r_Device.Device_Id;
    r_Track.Location_Id := r_Device.Location_Id;
    v_Timezone_Code     := Htt_Util.Load_Timezone(i_Company_Id  => r_Track.Company_Id,
                                                  i_Location_Id => r_Track.Location_Id);
  
    for i in 1 .. v_Tracks.Count
    loop
      begin
        v_Track := Treat(v_Tracks.r_Hashmap(i) as Hashmap);
      
        z_Htt_Tracks.To_Row(r_Track,
                            v_Track,
                            z.Person_Id,
                            z.Track_Type,
                            z.Mark_Type,
                            z.Latlng,
                            z.Accuracy,
                            z.Photo_Sha,
                            z.Note);
      
        if not z_Htt_Location_Persons.Exist(i_Company_Id  => r_Track.Company_Id,
                                            i_Filial_Id   => r_Track.Filial_Id,
                                            i_Location_Id => r_Track.Location_Id,
                                            i_Person_Id   => r_Track.Person_Id) or
           z_Htt_Blocked_Person_Tracking.Exist(i_Company_Id  => r_Track.Company_Id,
                                               i_Filial_Id   => r_Track.Filial_Id,
                                               i_Employee_Id => r_Track.Person_Id) then
          b.Raise_Error(t('the person is not attached to the location where the device is installed'));
        end if;
      
        if r_Track.Mark_Type not member of Fazo.Split(r_Device.Mark_Types, ',') then
          b.Raise_Error(t('mark type not allowed for the device'));
        end if;
      
        if r_Track.Track_Type is null then
          begin
            select Decode(Last_Track_Type,
                          Htt_Pref.c_Track_Type_Input,
                          Htt_Pref.c_Track_Type_Output,
                          Htt_Pref.c_Track_Type_Input)
              into r_Track.Track_Type
              from (select q.Track_Type as Last_Track_Type
                      from Htt_Tracks q
                     where q.Company_Id = r_Track.Company_Id
                       and q.Person_Id = r_Track.Person_Id
                       and q.Track_Date = v_Sysdate
                       and q.Track_Type <> Htt_Pref.c_Track_Type_Check
                     order by q.Track_Time desc)
             where Rownum = 1;
          exception
            when No_Data_Found then
              r_Track.Track_Type := Htt_Pref.c_Track_Type_Input;
          end;
        end if;
      
        if r_Track.Track_Type not member of Fazo.Split(r_Device.Track_Types, ',') then
          b.Raise_Error(t('track type not allowed for the device'));
        end if;
      
        r_Track.Track_Id   := Htt_Next.Track_Id;
        r_Track.Track_Time := Htt_Util.Convert_Timestamp(i_Date     => v_Track.r_Date('track_time',
                                                                                      Href_Pref.c_Date_Format_Second),
                                                         i_Timezone => v_Timezone_Code);
        r_Track.Is_Valid   := 'Y';
      
        Htt_Api.Track_Add(r_Track);
      
        Fazo.Push(v_Track_Types, i, r_Track.Track_Type);
      exception
        when others then
          Fazo.Push(v_Errors, i, sqlerrm);
      end;
    end loop;
  
    Result.Put('track_types', Fazo.Zip_Matrix(v_Track_Types));
    Result.Put('errors', Fazo.Zip_Matrix(v_Errors));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Admin(p Hashmap) is
    r_Device     Htt_Devices%rowtype;
    v_Company_Id Md_Users.Company_Id%type;
    v_Login      Md_Users.Login%type;
    v_Password   varchar2(50) := p.r_Varchar2('password');
    r_User       Md_Users%rowtype;
    v_Success    varchar2(1);
  begin
    r_Device := z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id,
                                   i_Device_Id  => Device_Id(p.r_Varchar2('serial_number')));
  
    Md_Util.Parse_Login(i_Login      => p.r_Varchar2('login'),
                        o_Company_Id => v_Company_Id,
                        o_Login      => v_Login);
  
    r_User := Md_Util.User_By_Credentials(i_Company_Id => v_Company_Id,
                                          i_Login      => v_Login,
                                          i_Password   => v_Password);
  
    select 'Y'
      into v_Success
      from Htt_Device_Admins t
     where t.Company_Id = r_Device.Company_Id
       and t.Device_Id = r_Device.Device_Id
       and t.Person_Id = r_User.User_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null,
           State       = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
  end;

end Ui_Vhr91;
/
