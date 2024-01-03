create or replace package Ui_Vhr343 is
  ----------------------------------------------------------------------------------------------------
  Function List_Employees(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Employee(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Employee(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Employee(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Photo(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Search_By_Npin(p Json_Object_t) return Json_Array_t;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Locations(p Hashmap);
end Ui_Vhr343;
/
create or replace package body Ui_Vhr343 is
  ----------------------------------------------------------------------------------------------------
  Function List_Employees(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Array Array_Number := Nvl(p.o_Array_Number('employee_ids'), Array_Number());
    v_Cnt   number := v_Array.Count;
  
    v_Person  Gmap;
    v_Persons Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for c in (select *
                from (select s.Employee_Id,
                             s.State,
                             q.Email,
                             t.Birthday,
                             t.First_Name,
                             t.Last_Name,
                             t.Middle_Name,
                             t.Gender,
                             w.Address,
                             w.Main_Phone,
                             w.Tin,
                             h.Iapa,
                             h.Npin,
                             q.Company_Id,
                             q.Modified_Id,
                             Nvl((select 'Y'
                                   from Htt_Person_Photos Ph
                                  where Ph.Company_Id = q.Company_Id
                                    and Ph.Person_Id = q.Person_Id
                                    and Ph.Is_Main = 'Y'
                                    and Rownum = 1),
                                 'N') Has_Photo
                        from Mhr_Employees s
                        join Md_Persons q
                          on q.Company_Id = s.Company_Id
                         and q.Person_Id = s.Employee_Id
                        join Mr_Natural_Persons t
                          on t.Company_Id = s.Company_Id
                         and t.Person_Id = s.Employee_Id
                        left join Mr_Person_Details w
                          on w.Company_Id = s.Company_Id
                         and w.Person_Id = s.Employee_Id
                        left join Href_Person_Details h
                          on h.Company_Id = s.Company_Id
                         and h.Person_Id = s.Employee_Id
                       where s.Company_Id = v_Company_Id
                         and s.Filial_Id = v_Filial_Id
                         and (v_Cnt = 0 or s.Employee_Id member of v_Array)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Person := Gmap();
    
      v_Person.Put('employee_id', c.Employee_Id);
      v_Person.Put('first_name', c.First_Name);
      v_Person.Put('last_name', c.Last_Name);
      v_Person.Put('middle_name', c.Middle_Name);
      v_Person.Put('phone_number', c.Main_Phone);
      v_Person.Put('email', c.Email);
      v_Person.Put('birthday', c.Birthday);
      v_Person.Put('gender', c.Gender);
      v_Person.Put('address', c.Address);
      v_Person.Put('tin', c.Tin);
      v_Person.Put('iapa', c.Iapa);
      v_Person.Put('npin', c.Npin);
      v_Person.Put('state', c.State);
      v_Person.Put('has_identification_photo', c.Has_Photo);
    
      v_Last_Id := c.Modified_Id;
    
      v_Persons.Push(v_Person.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Persons, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p             Hashmap,
    i_Employee_Id number
  ) is
    r_Person        Href_Pref.Person_Rt;
    r_Employee      Href_Pref.Employee_Rt;
    r_Person_Detail Mr_Person_Details%rowtype;
    r_Detail        Href_Person_Details%rowtype;
    r_Md_Person     Md_Persons%rowtype;
    v_State         varchar2(1) := z_Mr_Natural_Persons.Take(i_Company_Id => Ui.Company_Id, i_Person_Id => i_Employee_Id).State;
    v_Tin           varchar2(18) := p.o_Varchar2('tin');
    v_Iapa          varchar2(20) := p.o_Varchar2('iapa');
    v_Npin          varchar2(14) := p.o_Varchar2('npin');
  
    --------------------------------------------------                    
    Procedure Prepare_Params is
    begin
      v_Tin := case
                 when v_Tin = '-' then
                  ''
                 when v_Tin is null then
                  r_Person_Detail.Tin
                 else
                  v_Tin
               end;
      v_Iapa := case
                  when v_Iapa = '-' then
                   ''
                  when v_Iapa is null then
                   r_Detail.Iapa
                  else
                   v_Iapa
                end;
      v_Npin := case
                  when v_Npin = '-' then
                   ''
                  when v_Npin is null then
                   r_Detail.Npin
                  else
                   v_Npin
                end;
    end;
  begin
    r_Person_Detail := z_Mr_Person_Details.Take(i_Company_Id => Ui.Company_Id,
                                                i_Person_Id  => i_Employee_Id);
  
    r_Detail := z_Href_Person_Details.Take(i_Company_Id => Ui.Company_Id,
                                           i_Person_Id  => i_Employee_Id);
  
    r_Md_Person := z_Md_Persons.Take(i_Company_Id => Ui.Company_Id, i_Person_Id => i_Employee_Id);
  
    Prepare_Params;
  
    v_State := Coalesce(p.o_Varchar2('state'), v_State, 'A');
  
    Href_Util.Person_New(o_Person               => r_Person,
                         i_Company_Id           => Ui.Company_Id,
                         i_Person_Id            => i_Employee_Id,
                         i_First_Name           => p.o_Varchar2('first_name'),
                         i_Last_Name            => p.o_Varchar2('last_name'),
                         i_Middle_Name          => p.o_Varchar2('middle_name'),
                         i_Gender               => p.r_Varchar2('gender'),
                         i_Birthday             => p.o_Date('birthday'),
                         i_Nationality_Id       => r_Detail.Nationality_Id,
                         i_Photo_Sha            => r_Md_Person.Photo_Sha,
                         i_Tin                  => v_Tin,
                         i_Iapa                 => v_Iapa,
                         i_Npin                 => v_Npin,
                         i_Region_Id            => r_Person_Detail.Region_Id,
                         i_Main_Phone           => p.o_Varchar2('phone_number'),
                         i_Email                => p.o_Varchar2('email'),
                         i_Address              => p.o_Varchar2('address'),
                         i_Legal_Address        => r_Person_Detail.Legal_Address,
                         i_Key_Person           => Nvl(r_Detail.Key_Person, 'N'),
                         i_Access_All_Employees => Nvl(r_Detail.Access_All_Employees, 'N'),
                         i_State                => v_State,
                         i_Code                 => r_Md_Person.Code);
  
    r_Employee.Person    := r_Person;
    r_Employee.Filial_Id := Ui.Filial_Id;
    r_Employee.State     := v_State;
  
    Href_Api.Employee_Save(i_Employee => r_Employee);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Employee(p Hashmap) return Hashmap is
    v_Employee_Id number := Md_Next.Person_Id;
  begin
    save(p, v_Employee_Id);
  
    return Fazo.Zip_Map('employee_id', v_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Employee(p Hashmap) is
    v_Employee_Id number := p.r_Number('employee_id');
  begin
    z_Mhr_Employees.Lock_Only(i_Company_Id  => Ui.Company_Id,
                              i_Filial_Id   => Ui.Filial_Id,
                              i_Employee_Id => v_Employee_Id);
  
    save(p, v_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Employee(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Employee_Id number := p.r_Number('employee_id');
  begin
    Href_Api.Employee_Delete(i_Company_Id  => v_Company_Id,
                             i_Filial_Id   => v_Filial_Id,
                             i_Employee_Id => v_Employee_Id);
    Href_Api.Person_Delete(i_Company_Id => v_Company_Id, i_Person_Id => v_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Photo(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Employee_Id number := p.r_Number('employee_id');
    v_Photo_Sha   varchar2(64) := p.r_Varchar2('photo_sha');
    v_Person      Htt_Pref.Person_Rt;
  begin
    Md_Api.Person_Update(i_Company_Id => v_Company_Id,
                         i_Person_Id  => v_Employee_Id,
                         i_Photo_Sha  => Option_Varchar2(v_Photo_Sha));
  
    if p.o_Varchar2('photo_as_face_rec') = 'Y' then
      if not z_Htt_Persons.Exist(i_Company_Id => v_Company_Id, i_Person_Id => v_Employee_Id) then
        Htt_Util.Person_New(o_Person     => v_Person,
                            i_Company_Id => v_Company_Id,
                            i_Person_Id  => v_Employee_Id,
                            i_Pin        => null,
                            i_Pin_Code   => null,
                            i_Rfid_Code  => null,
                            i_Qr_Code    => Htt_Util.Qr_Code_Gen(v_Employee_Id));
      
        if Htt_Util.Pin_Autogenerate(v_Company_Id) = 'Y' then
          v_Person.Pin := Htt_Core.Next_Pin(v_Company_Id);
        end if;
      
        Htt_Api.Person_Save(v_Person);
      end if;
    
      Htt_Api.Person_Save_Photo(i_Company_Id => v_Company_Id,
                                i_Person_Id  => v_Employee_Id,
                                i_Photo_Sha  => v_Photo_Sha,
                                i_Is_Main    => Nvl(p.o_Varchar2('is_main'), 'N'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Search_By_Npin(p Json_Object_t) return Json_Array_t is
    v_Copmpany_Id number := Ui.Company_Id;
    v_Npins       Json_Array_t;
    v_Buff        Json_Array_t;
    v_Data        Gmap;
    --------------------------------------------------
    Function Search(i_Npin varchar2) return number is
      result number;
    begin
      select /*+ index (q HREF_PERSON_DETAILS_I2)*/
       q.Person_Id
        into result
        from Href_Person_Details q
       where q.Company_Id = v_Copmpany_Id
         and q.Npin = i_Npin;
    
      return result;
    exception
      when No_Data_Found then
        return null;
    end;
  begin
    v_Buff := Json_Array_t();
  
    v_Npins := p.Get_Array('npins');
  
    for i in 0 .. v_Npins.Get_Size - 1
    loop
      v_Data := Gmap();
      v_Data.Put('npin', v_Npins.Get_String(i));
      v_Data.Put('employee_id', Search(v_Npins.Get_String(i)));
    
      v_Buff.Append(v_Data.Val);
    end loop;
  
    return v_Buff;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Locations(p Hashmap) is
    v_Employee_Id  number := p.r_Number('employee_id');
    v_Location_Ids Array_Number := p.r_Array_Number('location_ids');
  begin
    for r in (select *
                from Htt_Location_Persons Lp
               where Lp.Company_Id = Ui.Company_Id
                 and Lp.Filial_Id = Ui.Filial_Id
                 and Lp.Location_Id --
               not member of v_Location_Ids
                 and Lp.Person_Id = v_Employee_Id
                 and Lp.Attach_Type = Htt_Pref.c_Attach_Type_Manual)
    loop
      Htt_Api.Location_Remove_Person(i_Company_Id  => Ui.Company_Id,
                                     i_Filial_Id   => Ui.Filial_Id,
                                     i_Location_Id => r.Location_Id,
                                     i_Person_Id   => v_Employee_Id);
    end loop;
  
    for i in 1 .. v_Location_Ids.Count
    loop
      Htt_Api.Location_Add_Filial(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Ids(i));
    
      Htt_Api.Location_Add_Person(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Ids(i),
                                  i_Person_Id   => v_Employee_Id);
    end loop;
  end;

end Ui_Vhr343;
/
