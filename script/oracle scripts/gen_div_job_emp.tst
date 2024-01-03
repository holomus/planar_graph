PL/SQL Developer Test script 3.0
259
declare
  v_Company_Id  number := 0;
  v_Filial_Id   number := 120;
  v_Schedule_Id number := null;
  v_Role_Id     number := Md_Util.Role_Id(i_Company_Id => v_Company_Id,
                                          i_Pcode      => Href_Pref.c_Pcode_Role_Staff);

  v_Division_Cnt number := 100;
  v_Job_Cnt      number := 100;
  v_Employee_Cnt number := 1000;

  v_Division_Date date := to_date('01.01.2016', 'dd.mm.yyyy');
  v_Hiring_Date   date := to_date('01.01.2022', 'dd.mm.yyyy');

  v_Division_Ids Array_Number := Array_Number();
  v_Job_Ids      Array_Number := Array_Number();

  --------------------------------------------------
  Procedure Division_Create is
    r_Division Mhr_Divisions%rowtype;
  begin
    -- division create
    v_Division_Ids.Extend(v_Division_Cnt);
  
    r_Division.Company_Id  := v_Company_Id;
    r_Division.Filial_Id   := v_Filial_Id;
    r_Division.Opened_Date := v_Division_Date;
    r_Division.State       := 'A';
  
    for i in 1 .. v_Division_Cnt
    loop
      r_Division.Division_Id := Mhr_Next.Division_Id;
      r_Division.Name        := 'Sample division (' || r_Division.Division_Id || ')';
    
      Mhr_Api.Division_Save(r_Division);
      Hrm_Api.Division_Schedule_Save(i_Company_Id  => r_Division.Company_Id,
                                     i_Filial_Id   => r_Division.Filial_Id,
                                     i_Division_Id => r_Division.Division_Id,
                                     i_Schedule_Id => v_Schedule_Id);
    
      v_Division_Ids(i) := r_Division.Division_Id;
    end loop;
  end;

  --------------------------------------------------
  Procedure Job_Create is
    r_Job Mhr_Jobs%rowtype;
  begin
    -- job create
    v_Job_Ids.Extend(v_Job_Cnt);
  
    r_Job.Company_Id        := v_Company_Id;
    r_Job.Filial_Id         := v_Filial_Id;
    r_Job.State             := 'A';
    r_Job.c_Divisions_Exist := 'N';
  
    for i in 1 .. v_Job_Cnt
    loop
      r_Job.Job_Id := Mhr_Next.Job_Id;
      r_Job.Name   := 'Sample job (' || r_Job.Job_Id || ')';
    
      Mhr_Api.Job_Save(r_Job);
    
      v_Job_Ids(i) := r_Job.Job_Id;
    end loop;
  end;

  --------------------------------------------------
  Procedure Save_User(i_Person Mr_Natural_Persons%rowtype) is
    r_Data Md_Users%rowtype;
  begin
    r_Data.Company_Id := i_Person.Company_Id;
    r_Data.User_Id    := i_Person.Person_Id;
    r_Data.User_Kind  := Md_Pref.c_Uk_Normal;
    r_Data.State      := i_Person.State;
  
    r_Data.Name   := i_Person.Name;
    r_Data.Gender := i_Person.Gender;
  
    Md_Api.User_Save(r_Data);
  
    Md_Api.User_Add_Filial(i_Company_Id => r_Data.Company_Id,
                           i_User_Id    => r_Data.User_Id,
                           i_Filial_Id  => v_Filial_Id);
  
    if v_Role_Id is not null then
      Md_Api.Role_Grant(i_Company_Id => v_Company_Id,
                        i_User_Id    => r_Data.User_Id,
                        i_Filial_Id  => v_Filial_Id,
                        i_Role_Id    => v_Role_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Journal(i_Employee_Id number) is
    p_Journal     Hpd_Pref.Hiring_Journal_Rt;
    p_Robot       Hpd_Pref.Robot_Rt;
    p_Indicator   Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
    p_Oper_Type   Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    v_Division_Id number := v_Division_Ids(Href_Util.Random_Integer(1, v_Division_Cnt));
    v_Job_Id      number := v_Job_Ids(Href_Util.Random_Integer(1, v_Job_Cnt));
  begin
    Hpd_Util.Hiring_Journal_New(o_Journal         => p_Journal,
                                i_Company_Id      => v_Company_Id,
                                i_Filial_Id       => v_Filial_Id,
                                i_Journal_Id      => Hpd_Next.Journal_Id,
                                i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(v_Company_Id,
                                                                              Hpd_Pref.c_Pcode_Journal_Type_Hiring),
                                i_Journal_Number  => null,
                                i_Journal_Date    => v_Hiring_Date,
                                i_Journal_Name    => null);
  
    Hpd_Util.Robot_New(o_Robot           => p_Robot,
                       i_Robot_Id        => Mrf_Next.Robot_Id,
                       i_Division_Id     => v_Division_Id,
                       i_Job_Id          => v_Job_Id,
                       i_Rank_Id         => null,
                       i_Wage_Scale_Id   => null,
                       i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                       i_Fte_Id          => null,
                       i_Fte             => null);
  
    Hpd_Util.Journal_Add_Hiring(p_Journal              => p_Journal,
                                i_Page_Id              => Hpd_Next.Page_Id,
                                i_Employee_Id          => i_Employee_Id,
                                i_Staff_Number         => null,
                                i_Hiring_Date          => v_Hiring_Date,
                                i_Trial_Period         => 0,
                                i_Employment_Source_Id => null,
                                i_Schedule_Id          => v_Schedule_Id,
                                i_Vacation_Days_Limit  => null,
                                i_Robot                => p_Robot,
                                i_Contract             => null,
                                i_Indicators           => p_Indicator,
                                i_Oper_Types           => p_Oper_Type);
  
    Hpd_Api.Hiring_Journal_Save(p_Journal);
  
    Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                         i_Filial_Id  => p_Journal.Filial_Id,
                         i_Journal_Id => p_Journal.Journal_Id);
  end;

  --------------------------------------------------
  Procedure Save_Passport_Info(i_Person_Id number) is
    r_Data Href_Person_Documents%rowtype;
  begin
    r_Data.Company_Id  := v_Company_Id;
    r_Data.Document_Id := Href_Next.Person_Document_Id;
    r_Data.Person_Id   := i_Person_Id;
    r_Data.Doc_Type_Id := Href_Util.Doc_Type_Id(i_Company_Id => r_Data.Company_Id,
                                                i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport);
    r_Data.Doc_Series  := Dbms_Random.String('U', 2);
    r_Data.Doc_Number  := Substr(Abs(Dbms_Random.Normal), 3, 12);
    r_Data.Issued_Date := to_date('16.11.2016', 'dd.mm.yyyy') + Floor(Dbms_Random.Normal * 100);
    r_Data.Begin_Date  := to_date('16.11.2016', 'dd.mm.yyyy') + Floor(Dbms_Random.Normal * 100);
  
    r_Data.Is_Valid := 'N';
    r_Data.Status := 'N';
  
    Href_Api.Person_Document_Save(r_Data);
  end;

  --------------------------------------------------
  Procedure Employee_Create is
    v_Employee        Href_Pref.Employee_Rt;
    v_Person          Href_Pref.Person_Rt;
    v_Person_Identity Htt_Pref.Person_Rt;
    r_Person          Mr_Natural_Persons%rowtype;
  begin
    for i in 1 .. v_Employee_Cnt
    loop
      Href_Util.Person_New(o_Person               => v_Person,
                           i_Company_Id           => v_Company_Id,
                           i_Person_Id            => Md_Next.Person_Id,
                           i_First_Name           => 'Employee',
                           i_Last_Name            => 'Sample',
                           i_Middle_Name          => null,
                           i_Gender               => 'M',
                           i_Birthday             => null,
                           i_Nationality_Id       => null,
                           i_Photo_Sha            => null,
                           i_Tin                  => null,
                           i_Iapa                 => null,
                           i_Npin                 => null,
                           i_Region_Id            => null,
                           i_Main_Phone           => null,
                           i_Email                => null,
                           i_Address              => null,
                           i_Legal_Address        => null,
                           i_Key_Person           => 'N',
                           i_Access_All_Employees => 'N',
                           i_State                => 'A',
                           i_Code                 => null);
    
      v_Person.First_Name  := v_Person.First_Name || '(' || v_Person.Person_Id || ')';
      v_Employee.Person    := v_Person;
      v_Employee.Filial_Id := v_Filial_Id;
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
    
      r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => v_Person.Company_Id,
                                            i_Person_Id  => v_Person.Person_Id);
    
      Save_User(r_Person);
    
      Save_Passport_Info(r_Person.Person_Id);
      --Save_Passport_Info(r_Person.Person_Id);
      --Save_Passport_Info(r_Person.Person_Id);
    
      Save_Journal(v_Person.Person_Id);
    end loop;
  end;
begin
  Biruni_Route.Context_Begin;
  Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                       i_Filial_Id    => v_Filial_Id,
                       i_User_Id      => Md_Pref.User_Admin(v_Company_Id),
                       i_Project_Code => Verifix.Project_Code);

  Division_Create;
  Job_Create;

  /*select q.Division_Id
    bulk collect
    into v_Division_Ids
    from Mhr_Divisions q
   where q.Company_Id = v_Company_Id
     and q.Filial_Id = v_Filial_Id;
  
  select q.Job_Id
    bulk collect
    into v_Job_Ids
    from Mhr_Jobs q
   where q.Company_Id = v_Company_Id
     and q.Filial_Id = v_Filial_Id;
  
  v_Division_Cnt := v_Division_Ids.Count;
  v_Job_Cnt      := v_Job_Ids.Count;*/

  Employee_Create;

  Biruni_Route.Context_End;
end;
0
0
