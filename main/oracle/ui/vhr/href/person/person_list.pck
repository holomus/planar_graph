create or replace package Ui_Vhr14 is
  ----------------------------------------------------------------------------------------------------
  Function Attached_Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Detached_Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Detached_Employee_Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Attach_Employee(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_State(p Hashmap);
end Ui_Vhr14;
/
create or replace package body Ui_Vhr14 is
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
    return b.Translate('UI-VHR14:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query
  (
    i_Kind varchar2,
    p      Hashmap := Hashmap()
  ) return Fazo_Query is
    v_Matrix    Matrix_Varchar2;
    v_Query     varchar2(32767);
    v_Params    Hashmap := Hashmap();
    v_Filial_Id number := p.o_Number('filial_id');
    q           Fazo_Query;
  begin
    v_Params.Put('company_id', Ui.Company_Id);
  
    v_Query := 'select k.person_id,
                       q.photo_sha,
                       k.name,
                       k.first_name,
                       k.last_name,
                       k.middle_name,
                       k.gender,
                       k.birthday,
                       k.code,
                       w.tin,
                       w.region_id,
                       w.main_phone,
                       q.email,
                       w.address,
                       w.legal_address,
                       m.iapa,
                       m.npin,
                       m.key_person,
                       uit_href.is_blacklisted(i_company_id => k.company_id, i_person_id => k.person_id) is_blacklisted,';
  
    if i_Kind in ('H', 'E') then
      v_Query := v_Query || ' k.state';
    else
      v_Query := v_Query || ' nvl(f.state, k.state) as state';
    end if;
  
    v_Query := v_Query || --
               '  from md_persons q
                  join mr_natural_persons k
                    on k.company_id = q.company_id
                   and k.person_id = q.person_id
                  left join mr_person_details w
                    on w.company_id = k.company_id
                   and w.person_id = k.person_id
                  left join href_person_details m
                    on m.company_id = k.company_id
                   and m.person_id = k.person_id ';
  
    if i_Kind not in ('H', 'E') or v_Filial_Id is not null then
      v_Query := v_Query || --
                 'left join mrf_persons f
                    on f.company_id = k.company_id
                   and f.filial_id = :filial_id
                   and f.person_id = k.person_id ';
    end if;
  
    if i_Kind <> 'H' then
      v_Params.Put('filial_id', Ui.Filial_Id);
    elsif v_Filial_Id is not null then
      v_Params.Put('filial_id', v_Filial_Id);
    end if;
  
    v_Query := v_Query || --
               'where q.company_id = :company_id ';
  
    case i_Kind
      when 'A' then
        v_Query := v_Query || 'and f.person_id is not null';
      when 'D' then
        v_Query := v_Query || 'and f.person_id is null';
      when 'H' then
        if v_Filial_Id is not null then
          v_Query := v_Query || --
                     'and exists (select 1 
                             from mhr_employees s
                            where s.company_id = :company_id
                              and s.filial_id = :filial_id
                              and s.employee_id = f.person_id
                              and s.state = ''A'')';
        end if;
      when 'E' then
        v_Query := v_Query || --
                   'and not exists (select 1
                            from mhr_employees e
                           where e.company_id = :company_id
                             and e.filial_id = :filial_id
                             and e.employee_id = k.person_id)';
    end case;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('person_id', 'region_id');
    q.Varchar2_Field('name',
                     'first_name',
                     'last_name',
                     'middle_name',
                     'gender',
                     'photo_sha',
                     'tin',
                     'iapa',
                     'npin',
                     'main_phone');
    q.Varchar2_Field('email',
                     'address',
                     'legal_address',
                     'key_person',
                     'code',
                     'state',
                     'access_level',
                     'is_blacklisted');
    q.Date_Field('birthday');
  
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select *
                     from md_regions s 
                    where s.company_id = :company_id');
  
    v_Matrix := Md_Util.Person_Genders;
  
    q.Option_Field('gender_name', 'gender', v_Matrix(1), v_Matrix(2));
    q.Option_Field('key_person_name',
                   'key_person',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Option_Field('is_blacklisted_name',
                   'is_blacklisted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Attached_Query(p Hashmap) return Fazo_Query is
  begin
    if Ui.Is_Filial_Head then
      return Query('H', p);
    else
      return Query('A');
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Detached_Query return Fazo_Query is
  begin
    return Query('D');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Detached_Employee_Query return Fazo_Query is
  begin
    return Query('E');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap) is
    r_Person     Mr_Natural_Persons%rowtype;
    v_Person_Ids Array_Number := Fazo.Sort(p.r_Array_Number('person_id'));
  begin
    for i in 1 .. v_Person_Ids.Count
    loop
      Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Ids(i));
    
      r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                 i_Person_Id  => v_Person_Ids(i));
    
      Mrf_Api.Filial_Add_Person(i_Company_Id => Ui.Company_Id,
                                i_Filial_Id  => Ui.Filial_Id,
                                i_Person_Id  => v_Person_Ids(i),
                                i_State      => r_Person.State);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Employee(p Hashmap) is
    r_User       Md_Users%rowtype;
    r_Person     Mr_Natural_Persons%rowtype;
    v_Person_Ids Array_Number := Fazo.Sort(p.r_Array_Number('person_id'));
    r_Employee   Mhr_Employees%rowtype;
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Role_Id    number;
  begin
    r_Employee.Company_Id := v_Company_Id;
    r_Employee.Filial_Id  := v_Filial_Id;
    r_Employee.State      := 'A';
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => v_Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    for i in 1 .. v_Person_Ids.Count
    loop
      Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Ids(i));
    
      r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => v_Company_Id,
                                                 i_Person_Id  => v_Person_Ids(i));
    
      Mrf_Api.Filial_Add_Person(i_Company_Id => v_Company_Id,
                                i_Filial_Id  => v_Filial_Id,
                                i_Person_Id  => v_Person_Ids(i),
                                i_State      => r_Person.State);
    
      if not z_Mhr_Employees.Exist(i_Company_Id  => r_Employee.Company_Id,
                                   i_Filial_Id   => r_Employee.Filial_Id,
                                   i_Employee_Id => v_Person_Ids(i)) then
        r_Employee.Employee_Id := v_Person_Ids(i);
      
        Mhr_Api.Employee_Save(i_Employee => r_Employee);
      end if;
    
      if not z_Md_Users.Exist(i_Company_Id => v_Company_Id,
                              i_User_Id    => v_Person_Ids(i),
                              o_Row        => r_User) then
        z_Md_Users.Init(p_Row        => r_User,
                        i_Company_Id => r_Person.Company_Id,
                        i_User_Id    => r_Person.Person_Id,
                        i_Name       => r_Person.Name,
                        i_User_Kind  => Md_Pref.c_Uk_Normal,
                        i_Gender     => r_Person.Gender,
                        i_State      => 'A');
      
        Md_Api.User_Save(r_User);
      end if;
    
      if not z_Md_User_Filials.Exist(i_Company_Id => v_Company_Id,
                                     i_User_Id    => r_Person.Person_Id,
                                     i_Filial_Id  => v_Filial_Id) then
        Md_Api.User_Add_Filial(i_Company_Id => v_Company_Id,
                               i_User_Id    => r_Person.Person_Id,
                               i_Filial_Id  => v_Filial_Id);
      end if;
    
      if not z_Md_User_Roles.Exist(i_Company_Id => v_Company_Id,
                                   i_User_Id    => r_Person.Person_Id,
                                   i_Filial_Id  => v_Filial_Id,
                                   i_Role_Id    => v_Role_Id) then
        Md_Api.Role_Grant(i_Company_Id => v_Company_Id,
                          i_User_Id    => r_Person.Person_Id,
                          i_Filial_Id  => v_Filial_Id,
                          i_Role_Id    => v_Role_Id);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Person_Ids Array_Number := Fazo.Sort(p.r_Array_Number('person_id'));
  begin
    for i in 1 .. v_Person_Ids.Count
    loop
      Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Ids(i));
    
      Mrf_Api.Filial_Remove_Person(i_Company_Id => v_Company_Id,
                                   i_Filial_Id  => v_Filial_Id,
                                   i_Person_Id  => v_Person_Ids(i));
    
      for Loc in (select q.Location_Id
                    from Htt_Location_Persons q
                   where q.Company_Id = v_Company_Id
                     and q.Filial_Id = v_Filial_Id
                     and q.Person_Id = v_Person_Ids(i))
      loop
        Htt_Api.Location_Remove_Person(i_Company_Id  => v_Company_Id,
                                       i_Filial_Id   => v_Filial_Id,
                                       i_Location_Id => Loc.Location_Id,
                                       i_Person_Id   => v_Person_Ids(i));
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Person_Ids Array_Number := Fazo.Sort(p.r_Array_Number('person_id'));
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    for i in 1 .. v_Person_Ids.Count
    loop
      Href_Api.Person_Delete(i_Company_Id => Ui.Company_Id, --
                             i_Person_Id  => v_Person_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_State(p Hashmap) is
    r_Person     Mr_Natural_Persons%rowtype;
    v_Person_Ids Array_Number := Fazo.Sort(p.r_Array_Number('person_id'));
    v_State      varchar2(1) := p.r_Varchar2('state');
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    if Ui.Is_Filial_Head then
      for i in 1 .. v_Person_Ids.Count
      loop
        r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                   i_Person_Id  => v_Person_Ids(i));
      
        r_Person.State := v_State;
      
        Mr_Api.Natural_Person_Save(r_Person);
      end loop;
    else
      for i in 1 .. v_Person_Ids.Count
      loop
        if not z_Mrf_Persons.Exist(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Person_Id  => v_Person_Ids(i)) then
          b.Raise_Error(t('cannot change state of person not attached to filial, person_id=$1',
                          v_Person_Ids(i)));
        end if;
      
        Mrf_Api.Filial_Add_Person(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Person_Id  => v_Person_Ids(i),
                                  i_State      => v_State);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mr_Natural_Persons
       set Company_Id  = null,
           Person_Id   = null,
           First_Name  = null,
           Last_Name   = null,
           Middle_Name = null,
           Gender      = null,
           Birthday    = null,
           State       = null,
           Code        = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           Photo_Sha  = null,
           Email      = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Mr_Person_Details
       set Company_Id    = null,
           Person_Id     = null,
           Tin           = null,
           Main_Phone    = null,
           Address       = null,
           Legal_Address = null,
           Region_Id     = null;
    update Href_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Iapa       = null,
           Npin       = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
  end;

end Ui_Vhr14;
/
