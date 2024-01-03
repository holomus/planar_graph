PL/SQL Developer Test script 3.0
166
declare
  v_Company_Id  number := 0;
  v_Filial_Id   number := 1921;
  v_Schedule_Id number := null;

  v_Division_Cnt   number := 150;
  v_Job_Cnt        number := 100;
  v_Staff_Cnt      number := 1000;
  v_Transfer_Count number := 10;

  v_Division_Date  date := to_date('01.01.2016', 'dd.mm.yyyy');
  v_Transfer_Start date := to_date('01.02.2023', 'dd.mm.yyyy');
  v_Days           number := 28;

  v_Division_Ids Array_Number := Array_Number();
  v_Job_Ids      Array_Number := Array_Number();
  v_Staff_Ids    Array_Number := Array_Number();

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

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Journal(i_Staff_Id number) is
    p_Journal     Hpd_Pref.Transfer_Journal_Rt;
    p_Robot       Hpd_Pref.Robot_Rt;
    p_Indicator   Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
    p_Oper_Type   Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    v_Division_Id number := v_Division_Ids(Href_Util.Random_Integer(1, v_Division_Cnt));
    v_Job_Id      number := v_Job_Ids(Href_Util.Random_Integer(1, v_Job_Cnt));
  begin
    Hpd_Util.Transfer_Journal_New(o_Journal         => p_Journal,
                                  i_Company_Id      => v_Company_Id,
                                  i_Filial_Id       => v_Filial_Id,
                                  i_Journal_Id      => Hpd_Next.Journal_Id,
                                  i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(v_Company_Id,
                                                                                Hpd_Pref.c_Pcode_Journal_Type_Transfer),
                                  i_Journal_Number  => null,
                                  i_Journal_Date    => v_Transfer_Start +
                                                       Href_Util.Random_Integer(1, v_Days),
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
  
    Hpd_Util.Journal_Add_Transfer(p_Journal             => p_Journal,
                                  i_Page_Id             => Hpd_Next.Page_Id,
                                  i_Transfer_Begin      => p_Journal.Journal_Date,
                                  i_Transfer_End        => null,
                                  i_Staff_Id            => i_Staff_Id,
                                  i_Schedule_Id         => v_Schedule_Id,
                                  i_Vacation_Days_Limit => null,
                                  i_Transfer_Reason     => null,
                                  i_Transfer_Base       => null,
                                  i_Robot               => p_Robot,
                                  i_Contract            => null,
                                  i_Indicators          => p_Indicator,
                                  i_Oper_Types          => p_Oper_Type);
  
    Hpd_Api.Transfer_Journal_Save(p_Journal);
  
    /* Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
    i_Filial_Id  => p_Journal.Filial_Id,
    i_Journal_Id => p_Journal.Journal_Id);*/
  end;
begin
  Biruni_Route.Context_Begin;
  Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                       i_Filial_Id    => v_Filial_Id,
                       i_User_Id      => Md_Pref.User_Admin(v_Company_Id),
                       i_Project_Code => Verifix.Project_Code);

  /*Division_Create;
  Job_Create;*/

  select q.Division_Id
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

  select s.Staff_Id
    bulk collect
    into v_Staff_Ids
    from Href_Staffs s
   where s.Company_Id = v_Company_Id
     and s.Filial_Id = v_Filial_Id
     and s.State = 'A'
     and s.Hiring_Date <= v_Transfer_Start
     and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Transfer_Start + v_Days)
   fetch first v_Staff_Cnt Rows only;

  v_Division_Cnt := v_Division_Ids.Count;
  v_Job_Cnt      := v_Job_Ids.Count;

  for i in 1 .. v_Staff_Ids.Count
  loop
    for j in 1 .. v_Transfer_Count
    loop
      Save_Journal(v_Staff_Ids(i));
    end loop;
  end loop;

  Biruni_Route.Context_End;
end;
0
0
