create or replace package Ui_Vhr314 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Nationalities return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Robots(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Ftes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Search(i_Search_Text varchar2) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Recommended_Logins(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Login_Is_Valid(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Npin_Is_Valid(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Passport_Is_Valid(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Robot(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Hidden_Salary_Job(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Phone_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Email_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Employee(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Upload_Images(p Hashmap) return Hashmap;
end Ui_Vhr314;
/
create or replace package body Ui_Vhr314 is
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
    return b.Translate('UI-VHR314:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Nationalities return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_nationalities',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('nationality_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Robots(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select p.*,
                            q.division_id,
                            q.job_id,
                            q.name,
                            (select min(fte)
                               from hrm_robot_turnover rob
                              where rob.company_id = p.company_id
                                and rob.filial_id = p.filial_id
                                and rob.robot_id = p.robot_id
                                and (rob.period >= :hiring_date or
                                    rob.period = (select max(rt.period)
                                                  from hrm_robot_turnover rt
                                                 where rt.company_id = rob.company_id
                                                   and rt.filial_id = rob.filial_id
                                                   and rt.robot_id = rob.robot_id
                                                   and rt.period <= :hiring_date))) fte
                       from hrm_robots p
                       join mrf_robots q
                         on q.company_Id = p.company_id
                        and q.filial_Id = p.filial_id
                        and q.robot_Id = p.robot_id
                      where p.company_Id = :company_id
                        and p.filial_Id = :filial_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'hiring_date',
                                 p.r_Date('hiring_date')));
  
    q.Number_Field('robot_id', 'division_id', 'org_unit_id', 'job_id', 'fte');
    q.Date_Field('opened_date', 'closed_date');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mhr_jobs q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = ''A''
                        and (q.c_divisions_exist = ''N''
                            or exists (select 1
                                  from mhr_job_divisions w
                                 where w.company_id = q.company_id
                                   and w.filial_id = q.filial_id
                                   and w.job_id = q.job_id
                                   and w.division_id = :division_id))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_id',
                                 p.o_Number('division_id')));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Ftes return Fazo_Query is
    q                 Fazo_Query;
    v_Params          Hashmap := Fazo.Zip_Map('company_id', Ui.Company_Id);
    v_Parttime_Enable varchar(1) := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Parttime_Enable;
  begin
    if v_Parttime_Enable = 'N' then
      v_Params.Put('fte_value', 1);
    end if;
  
    q := Fazo_Query('href_ftes', v_Params, true);
  
    q.Number_Field('fte_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select w.*
                       from htt_locations w
                      where w.company_id = :company_id
                        and w.state = ''A''
                        and exists (select 1
                               from htt_location_filials q
                              where q.company_id = w.company_id
                                and q.filial_id = :filial_id
                                and q.location_id = w.location_id)',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('location_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Types return Fazo_Query is
    q        Fazo_Query;
    v_Params Hashmap;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'operation_kind',
                             Mpr_Pref.c_Ok_Accrual,
                             'hourly',
                             Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly,
                             'daily',
                             Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily,
                             'monthly',
                             Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly,
                             'summarized',
                             Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized);
  
    v_Params.Put('weighted', Hpr_Pref.c_Pcode_Oper_Type_Weighted_Turnout);
  
    q := Fazo_Query('select q.oper_type_id,
                            q.short_name as name
                       from mpr_oper_types q
                      where q.company_id = :company_id
                        and q.state = ''A''
                        and q.pcode in (:hourly, :daily, :monthly, :summarized, :weighted)',
                    v_Params);
  
    q.Number_Field('oper_type_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Search(i_Search_Text varchar2) return Arraylist is
    v_Doc_Type_Id number;
    result        Matrix_Varchar2;
  begin
    case Href_Util.Verify_Person_Uniqueness_Column(Ui.Company_Id)
    --------------------------------------------------
      when Href_Pref.c_Vpu_Column_Name then
        select Array_Varchar2(p.Person_Id,
                              p.Name,
                              p.Gender,
                              (select t.Photo_Sha
                                 from Md_Persons t
                                where t.Company_Id = p.Company_Id
                                  and t.Person_Id = p.Person_Id),
                              case
                                when exists (select 1
                                        from Mhr_Employees k
                                       where k.Company_Id = p.Company_Id
                                         and k.Filial_Id = Ui.Filial_Id
                                         and k.Employee_Id = p.Person_Id) then
                                 'Y'
                                else
                                 'N'
                              end,
                              Uit_Href.Is_Blacklisted(i_Company_Id => p.Company_Id,
                                                      i_Person_Id  => p.Person_Id))
          bulk collect
          into result
          from Mr_Natural_Persons p
         where p.Company_Id = Ui.Company_Id
           and Lower(p.Name) like Lower('%' || i_Search_Text || '%')
         fetch first 5 Rows only;
      
    --------------------------------------------------
      when Href_Pref.c_Vpu_Column_Passport_Number then
        v_Doc_Type_Id := Href_Util.Doc_Type_Id(i_Company_Id => Ui.Company_Id,
                                               i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport);
        select Array_Varchar2(p.Person_Id,
                               p.Name,
                               p.Gender,
                               (select t.Photo_Sha
                                  from Md_Persons t
                                 where t.Company_Id = p.Company_Id
                                   and t.Person_Id = p.Person_Id),
                               case
                                 when exists (select 1
                                         from Mhr_Employees k
                                        where k.Company_Id = p.Company_Id
                                          and k.Filial_Id = Ui.Filial_Id
                                          and k.Employee_Id = p.Person_Id) then
                                  'Y'
                                 else
                                  'N'
                               end,
                               Uit_Href.Is_Blacklisted(i_Company_Id => p.Company_Id,
                                                       i_Person_Id  => p.Person_Id))
          bulk collect
          into result
          from (select q.*,
                       (select Upper(t.Doc_Series || t.Doc_Number)
                          from Href_Person_Documents t
                         where t.Company_Id = q.Company_Id
                           and t.Person_Id = q.Person_Id
                           and t.Doc_Type_Id = v_Doc_Type_Id
                         order by t.Begin_Date desc nulls last
                         fetch first 1 row only) Passport_Number
                  from Mr_Natural_Persons q
                 where q.Company_Id = Ui.Company_Id) p
         where p.Passport_Number = Upper(Regexp_Replace(i_Search_Text, ' ', ''));
      
    --------------------------------------------------
      when Href_Pref.c_Vpu_Column_Npin then
        select Array_Varchar2(p.Person_Id,
                              p.Name,
                              p.Gender,
                              (select t.Photo_Sha
                                 from Md_Persons t
                                where t.Company_Id = p.Company_Id
                                  and t.Person_Id = p.Person_Id),
                              case
                                when exists (select 1
                                        from Mhr_Employees k
                                       where k.Company_Id = p.Company_Id
                                         and k.Filial_Id = Ui.Filial_Id
                                         and k.Employee_Id = p.Person_Id) then
                                 'Y'
                                else
                                 'N'
                              end,
                              Uit_Href.Is_Blacklisted(i_Company_Id => p.Company_Id,
                                                      i_Person_Id  => p.Person_Id))
          bulk collect
          into result
          from Href_Person_Details d
          join Mr_Natural_Persons p
            on p.Company_Id = d.Company_Id
           and p.Person_Id = d.Person_Id
         where d.Company_Id = Ui.Company_Id
           and d.Npin = i_Search_Text;
    end case;
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Recommended_Logins(p Hashmap) return Hashmap is
    v_Logins     Array_Varchar2;
    v_First_Name varchar2(100) := p.o_Varchar2('first_name');
    v_Last_Name  varchar2(100) := p.o_Varchar2('last_name');
    result       Hashmap := Hashmap();
  begin
    v_Logins := Md_Util.Gen_Login(i_Company_Id => Ui.Company_Id,
                                  i_First_Name => v_First_Name,
                                  i_Last_Name  => v_Last_Name);
  
    for i in 1 .. v_Logins.Count
    loop
      v_Logins(i) := Md_Util.Login_Fixer(v_Logins(i));
    end loop;
  
    Result.Put('logins', v_Logins);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Login_Is_Valid(p Hashmap) return varchar2 is
    v_Login Md_Users.Login%type := Regexp_Replace(p.r_Varchar2('login'), '@', '');
    v_Dummy varchar2(1);
  begin
    select 'X'
      into v_Dummy
      from Md_Users u
     where u.Company_Id = Ui.Company_Id
       and u.Login = v_Login;
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Npin_Is_Valid(p Hashmap) return varchar2 is
  begin
    return Uit_Href.Npin_Is_Valid(i_Npin => p.r_Varchar2('npin'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Passport_Is_Valid(p Hashmap) return varchar2 is
    v_Passport_Series varchar2(50) := p.o_Varchar2('passport_series');
    v_Passport_Number varchar2(50) := p.o_Varchar2('passport_number');
    v_Dummy           varchar2(1);
    v_Doc_Type_Id     number := Href_Util.Doc_Type_Id(i_Company_Id => Ui.Company_Id,
                                                      i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport);
  begin
    select 'X'
      into v_Dummy
      from Href_Person_Documents q
     where q.Company_Id = Ui.Company_Id
       and q.Doc_Type_Id = v_Doc_Type_Id
       and q.Doc_Series = v_Passport_Series
       and q.Doc_Number = v_Passport_Number
       and Rownum = 1;
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Robot(p Hashmap) return Hashmap is
    r_Robot      Hrm_Robots%rowtype;
    r_Base_Robot Mrf_Robots%rowtype;
    result       Hashmap;
  begin
    r_Robot := z_Hrm_Robots.Load(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Robot_Id   => p.r_Number('robot_id'));
  
    r_Base_Robot := z_Mrf_Robots.Load(i_Company_Id => r_Robot.Company_Id,
                                      i_Filial_Id  => r_Robot.Filial_Id,
                                      i_Robot_Id   => r_Robot.Robot_Id);
  
    result := z_Hrm_Robots.To_Map(r_Robot, z.Robot_Id, z.Org_Unit_Id, z.Schedule_Id);
  
    Result.Put_All(z_Mrf_Robots.To_Map(r_Base_Robot, z.Division_Id, z.Job_Id));
  
    Result.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Base_Robot.Company_Id, i_Filial_Id => r_Base_Robot.Filial_Id, i_Division_Id => r_Base_Robot.Division_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Base_Robot.Company_Id, i_Filial_Id => r_Base_Robot.Filial_Id, i_Job_Id => r_Base_Robot.Job_Id).Name);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Robot.Company_Id, i_Filial_Id => r_Robot.Filial_Id, i_Schedule_Id => r_Robot.Schedule_Id).Name);
    Result.Put('access_salary_job',
               Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => r_Base_Robot.Job_Id));
    Result.Put_All(Uit_Href.Get_Fte(Coalesce(p.o_Number('fte'),
                                             Uit_Hrm.Robot_Fte(i_Robot_Id     => r_Robot.Robot_Id,
                                                               i_Period_Begin => p.r_Date('hiring_date')))));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hidden_Salary_Job(p Hashmap) return varchar2 is
  begin
    return Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => p.o_Number('job_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Passport_Info
  (
    p           Hashmap,
    i_Person_Id number
  ) is
    r_Data            Href_Person_Documents%rowtype;
    v_Shas            Array_Varchar2 := p.o_Array_Varchar2('shas');
    v_Passport_Series varchar2(50) := p.o_Varchar2('passport_series');
    v_Passport_Number varchar2(50) := p.o_Varchar2('passport_number');
  begin
    if Href_Util.Load_Col_Required_Settings(Ui.Company_Id)
     .Passport = 'Y' and v_Passport_Series is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Passport);
    elsif v_Passport_Series is null then
      return;
    end if;
  
    z_Href_Person_Documents.To_Row(r_Data,
                                   p,
                                   z.Issued_By,
                                   z.Issued_Date,
                                   z.Begin_Date,
                                   z.Expiry_Date,
                                   z.Note);
  
    r_Data.Company_Id  := Ui.Company_Id;
    r_Data.Document_Id := Href_Next.Person_Document_Id;
    r_Data.Person_Id   := i_Person_Id;
    r_Data.Doc_Series  := v_Passport_Series;
    r_Data.Doc_Number  := v_Passport_Number;
    r_Data.Doc_Type_Id := Href_Util.Doc_Type_Id(i_Company_Id => r_Data.Company_Id,
                                                i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport);
    r_Data.Is_Valid    := 'Y';
    r_Data.Status      := Href_Pref.c_Person_Document_Status_New;
  
    Href_Api.Person_Document_Save(r_Data);
  
    for i in 1 .. v_Shas.Count
    loop
      Href_Api.Person_Document_File_Save(i_Company_Id  => r_Data.Company_Id,
                                         i_Document_Id => r_Data.Document_Id,
                                         i_Sha         => v_Shas(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Phone_Is_Unique(p Hashmap) return varchar2 is
    v_Phone varchar2(25) := p.r_Varchar2('main_phone');
  begin
    return Href_Util.Check_Unique_Phone(i_Company_Id => Ui.Company_Id, i_Phone => v_Phone);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Email_Is_Unique(p Hashmap) return varchar2 is
    v_Email Md_Persons.Email%type := p.r_Varchar2('email');
  begin
    return Href_Util.Check_Unique(i_Company_Id   => Ui.Company_Id,
                                  i_Table        => Zt.Md_Persons,
                                  i_Column       => z.Email,
                                  i_Column_Value => v_Email);
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    r_Settings Hrm_Settings%rowtype;
    v_Matrix   Matrix_Varchar2;
    result     Hashmap := Hashmap();
  begin
    Result.Put('pg_female', Md_Pref.c_Pg_Female);
  
    select Array_Varchar2(t.Region_Id, t.Name, t.Parent_Id)
      bulk collect
      into v_Matrix
      from Md_Regions t
     where t.Company_Id = Ui.Company_Id
       and t.State = 'A'
     order by t.Name;
  
    Result.Put('regions', Fazo.Zip_Matrix(v_Matrix));
  
    r_Settings := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
    Result.Put('genders', Fazo.Zip_Matrix_Transposed(Md_Util.Person_Genders));
    Result.Put('crs', Uit_Href.Col_Required_Settings);
    Result.Put('sk_flexible', Htt_Pref.c_Schedule_Kind_Flexible);
    Result.Put('all_org_units', Fazo.Zip_Matrix(Uit_Hrm.Org_Units));
  
    Result.Put_All(z_Hrm_Settings.To_Map(r_Settings, --
                                         z.Position_Enable,
                                         z.Advanced_Org_Structure));
  
    -- verify person uniqueness modal
    Result.Put('vpu_column_name', Href_Pref.c_Vpu_Column_Name);
    Result.Put('vpu_column_passport_number', Href_Pref.c_Vpu_Column_Passport_Number);
    Result.Put('vpu_column_npin', Href_Pref.c_Vpu_Column_Npin);
  
    Result.Put('duplicate_prevention', Hface_Util.Duplicate_Prevention(Ui.Company_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    result := Fazo.Zip_Map('gender',
                           Md_Pref.c_Pg_Male,
                           'state',
                           'A',
                           'parttime_enable',
                           Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Parttime_Enable);
  
    Result.Put('company_code', '@' || z_Md_Companies.Load(Ui.Company_Id).Code);
    Result.Put('photo_as_face_rec', Htt_Util.Photo_As_Face_Rec(Ui.Company_Id));
  
    -- verify person uniqueness modal
    Result.Put('vpu_setting', Href_Util.Verify_Person_Uniqueness_Setting(Ui.Company_Id));
    Result.Put('vpu_column', Href_Util.Verify_Person_Uniqueness_Column(Ui.Company_Id));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_User
  (
    i_Person Mr_Natural_Persons%rowtype,
    p        Hashmap
  ) is
    r_Data     Md_Users%rowtype;
    v_Login    varchar2(200) := p.o_Varchar2('login');
    v_Password varchar2(40) := p.o_Varchar2('password');
    v_Role_Id  number;
  begin
    r_Data.Company_Id := i_Person.Company_Id;
    r_Data.User_Id    := i_Person.Person_Id;
    r_Data.User_Kind  := Md_Pref.c_Uk_Normal;
    r_Data.State      := 'A';
  
    if v_Login is not null then
      if v_Password is not null then
        r_Data.Password                 := Fazo.Hash_Sha1(v_Password);
        r_Data.Password_Changed_On      := sysdate;
        r_Data.Password_Change_Required := 'Y';
      else
        b.Raise_Error(t('password is required for new user'));
      end if;
    end if;
  
    r_Data.Name   := i_Person.Name;
    r_Data.Login  := v_Login;
    r_Data.Gender := i_Person.Gender;
  
    Md_Api.User_Save(r_Data);
  
    if i_Person.State = 'A' then
      Md_Api.User_Add_Filial(i_Company_Id => r_Data.Company_Id,
                             i_User_Id    => r_Data.User_Id,
                             i_Filial_Id  => Ui.Filial_Id);
    else
      Md_Api.User_Remove_Filial(i_Company_Id   => r_Data.Company_Id,
                                i_User_Id      => r_Data.User_Id,
                                i_Filial_Id    => Ui.Filial_Id,
                                i_Remove_Roles => false);
    end if;
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => Ui.Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    if v_Role_Id is not null then
      Md_Api.Role_Grant(i_Company_Id => Ui.Company_Id,
                        i_User_Id    => r_Data.User_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Journal
  (
    p             Hashmap,
    i_Employee_Id number
  ) is
    p_Journal        Hpd_Pref.Hiring_Journal_Rt;
    p_Robot          Hpd_Pref.Robot_Rt;
    p_Indicator      Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
    p_Oper_Type      Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    v_Salary_Type_Id number := p.o_Number('salary_type_id');
    v_Hiring_Date    date := p.o_Date('hiring_date');
    v_Robot_Id       number := p.o_Number('robot_id');
    v_Division_Id    number := p.o_Number('division_id');
    v_Job_Id         number := p.o_Number('job_id');
    v_Indicator_Id   number;
  begin
    if v_Division_Id is not null and v_Job_Id is not null and v_Hiring_Date is not null then
      Hpd_Util.Hiring_Journal_New(o_Journal         => p_Journal,
                                  i_Company_Id      => Ui.Company_Id,
                                  i_Filial_Id       => Ui.Filial_Id,
                                  i_Journal_Id      => Hpd_Next.Journal_Id,
                                  i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(Ui.Company_Id,
                                                                                Hpd_Pref.c_Pcode_Journal_Type_Hiring),
                                  i_Journal_Number  => null,
                                  i_Journal_Date    => v_Hiring_Date,
                                  i_Journal_Name    => null);
    
      if v_Robot_Id is null then
        v_Robot_Id := Mrf_Next.Robot_Id;
      end if;
    
      Hpd_Util.Robot_New(o_Robot           => p_Robot,
                         i_Robot_Id        => v_Robot_Id,
                         i_Division_Id     => v_Division_Id,
                         i_Job_Id          => v_Job_Id,
                         i_Org_Unit_Id     => p.o_Number('org_unit_id'),
                         i_Rank_Id         => null,
                         i_Wage_Scale_Id   => null,
                         i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                         i_Fte_Id          => p.o_Number('fte_id'),
                         i_Fte             => null);
    
      if v_Salary_Type_Id is not null then
        v_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                 i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
      
        Hpd_Util.Indicator_Add(p_Indicator       => p_Indicator,
                               i_Indicator_Id    => v_Indicator_Id,
                               i_Indicator_Value => p.r_Number('salary_amount'));
      
        Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Type,
                               i_Oper_Type_Id  => v_Salary_Type_Id,
                               i_Indicator_Ids => Array_Number(v_Indicator_Id));
      end if;
    
      Hpd_Util.Journal_Add_Hiring(p_Journal              => p_Journal,
                                  i_Page_Id              => Hpd_Next.Page_Id,
                                  i_Employee_Id          => i_Employee_Id,
                                  i_Staff_Number         => p.o_Varchar2('staff_number'),
                                  i_Hiring_Date          => v_Hiring_Date,
                                  i_Trial_Period         => 0,
                                  i_Employment_Source_Id => null,
                                  i_Schedule_Id          => p.o_Number('schedule_id'),
                                  i_Vacation_Days_Limit  => null,
                                  i_Is_Booked            => 'N',
                                  i_Robot                => p_Robot,
                                  i_Contract             => null,
                                  i_Indicators           => p_Indicator,
                                  i_Oper_Types           => p_Oper_Type);
    
      Hpd_Api.Hiring_Journal_Save(p_Journal);
    
      Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                           i_Filial_Id  => p_Journal.Filial_Id,
                           i_Journal_Id => p_Journal.Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    v_Employee          Href_Pref.Employee_Rt;
    v_Person            Href_Pref.Person_Rt;
    v_Person_Identity   Htt_Pref.Person_Rt;
    r_Person            Mr_Natural_Persons%rowtype;
    v_Photo_As_Face_Rec varchar2(1) := p.r_Varchar2('photo_as_face_rec');
    v_Location_Id       number := p.o_Number('location_id');
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    Href_Util.Person_New(o_Person               => v_Person,
                         i_Company_Id           => Ui.Company_Id,
                         i_Person_Id            => Md_Next.Person_Id,
                         i_First_Name           => p.r_Varchar2('first_name'),
                         i_Last_Name            => p.o_Varchar2('last_name'),
                         i_Middle_Name          => p.o_Varchar2('middle_name'),
                         i_Gender               => p.r_Varchar2('gender'),
                         i_Birthday             => p.o_Varchar2('birthday'),
                         i_Nationality_Id       => p.o_Number('nationality_id'),
                         i_Photo_Sha            => p.o_Varchar2('photo_sha'),
                         i_Tin                  => p.o_Varchar2('tin'),
                         i_Iapa                 => p.o_Varchar2('iapa'),
                         i_Npin                 => p.o_Varchar2('npin'),
                         i_Region_Id            => p.o_Varchar2('region_id'),
                         i_Main_Phone           => p.o_Varchar2('main_phone'),
                         i_Email                => p.o_Varchar2('email'),
                         i_Address              => p.o_Varchar2('address'),
                         i_Legal_Address        => p.o_Varchar2('legal_address'),
                         i_Key_Person           => Nvl(p.o_Varchar2('key_person'), 'N'),
                         i_Access_All_Employees => Nvl(p.o_Varchar2('access_all_employees'), 'N'),
                         i_Access_Hidden_Salary => Nvl(p.o_Varchar2('access_hidden_salary'), 'N'),
                         i_State                => p.r_Varchar2('state'),
                         i_Code                 => p.o_Varchar2('code'));
  
    v_Employee.Person    := v_Person;
    v_Employee.Filial_Id := Ui.Filial_Id;
    v_Employee.State     := v_Person.State;
  
    Href_Api.Employee_Save(v_Employee);
  
    Htt_Util.Person_New(o_Person     => v_Person_Identity,
                        i_Company_Id => v_Person.Company_Id,
                        i_Person_Id  => v_Person.Person_Id,
                        i_Pin        => null,
                        i_Pin_Code   => null,
                        i_Rfid_Code  => null,
                        i_Qr_Code    => Htt_Util.Qr_Code_Gen(v_Person.Person_Id));
  
    if Htt_Util.Pin_Autogenerate(v_Person.Company_Id) = 'Y' then
      v_Person_Identity.Pin := Htt_Core.Next_Pin(v_Person.Company_Id);
    end if;
  
    Htt_Api.Person_Save(v_Person_Identity);
  
    if v_Photo_As_Face_Rec = 'Y' then
      Htt_Api.Person_Photo_Update(i_Company_Id    => v_Person.Company_Id,
                                  i_Person_Id     => v_Person.Person_Id,
                                  i_Old_Photo_Sha => null,
                                  i_New_Photo_Sha => v_Person.Photo_Sha);
    end if;
  
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => v_Person.Company_Id,
                                          i_Person_Id  => v_Person.Person_Id);
  
    Save_User(r_Person, p);
  
    if v_Location_Id is not null then
      Htt_Api.Location_Add_Person(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Id,
                                  i_Person_Id   => v_Person.Person_Id);
    end if;
  
    Save_Journal(p, v_Person.Person_Id);
  
    Save_Passport_Info(p, v_Person.Person_Id);
  
    return Fazo.Zip_Map('employee_id', r_Person.Person_Id, 'name', r_Person.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Employee(p Hashmap) is
    r_Person   Mr_Natural_Persons%rowtype;
    r_Employee Mhr_Employees%rowtype;
    r_User     Md_Users%rowtype;
    v_Role_Id  number;
  begin
    r_Person := z_Mr_Natural_Persons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Person_Id  => p.r_Number('person_id'));
  
    Mrf_Api.Filial_Add_Person(i_Company_Id => Ui.Company_Id,
                              i_Filial_Id  => Ui.Filial_Id,
                              i_Person_Id  => r_Person.Person_Id,
                              i_State      => r_Person.State);
  
    if not z_Mhr_Employees.Exist(i_Company_Id  => Ui.Company_Id,
                                 i_Filial_Id   => Ui.Filial_Id,
                                 i_Employee_Id => r_Person.Person_Id) then
      r_Employee.Company_Id  := Ui.Company_Id;
      r_Employee.Filial_Id   := Ui.Filial_Id;
      r_Employee.Employee_Id := r_Person.Person_Id;
      r_Employee.State       := 'A';
    
      Mhr_Api.Employee_Save(i_Employee => r_Employee);
    end if;
  
    if not z_Md_Users.Exist(i_Company_Id => Ui.Company_Id,
                            i_User_Id    => r_Person.Person_Id,
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
  
    if not z_Md_User_Filials.Exist(i_Company_Id => Ui.Company_Id,
                                   i_User_Id    => r_Person.Person_Id,
                                   i_Filial_Id  => Ui.Filial_Id) then
      Md_Api.User_Add_Filial(i_Company_Id => Ui.Company_Id,
                             i_User_Id    => r_Person.Person_Id,
                             i_Filial_Id  => Ui.Filial_Id);
    end if;
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => Ui.Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    if not z_Md_User_Roles.Exist(i_Company_Id => Ui.Company_Id,
                                 i_User_Id    => r_Person.Person_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Role_Id    => v_Role_Id) then
      Md_Api.Role_Grant(i_Company_Id => Ui.Company_Id,
                        i_User_Id    => r_Person.Person_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector(p Hashmap) return Runtime_Service is
  begin
    return Uit_Hface.Calculate_Photo_Vector(i_Person_Id  => p.o_Number('person_id'),
                                            i_Photo_Shas => p.r_Array_Varchar2('photo_shas'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Upload_Images(p Hashmap) return Hashmap is
  begin
    return p;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id        = null,
           Job_Id            = null,
           Filial_Id         = null,
           name              = null,
           c_Divisions_Exist = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Job_Id      = null,
           Division_Id = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Href_Ftes
       set Company_Id = null,
           Fte_Id     = null,
           name       = null,
           Order_No   = null;
    update Href_Nationalities
       set Company_Id     = null,
           Nationality_Id = null,
           name           = null,
           State          = null;
    update Md_Roles
       set Company_Id = null,
           Role_Id    = null,
           name       = null,
           State      = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null,
           State       = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Mpr_Oper_Types
       set Company_Id   = null,
           Oper_Type_Id = null,
           Short_Name   = null,
           State        = null,
           Pcode        = null;
    update Hrm_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Org_Unit_Id = null,
           Opened_Date = null,
           Closed_Date = null;
    update Hrm_Robot_Turnover
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Period     = null,
           Fte        = null;
    update Mrf_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Division_Id = null,
           Job_Id      = null,
           name        = null;
  end;

end Ui_Vhr314;
/
