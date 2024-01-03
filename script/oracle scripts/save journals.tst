PL/SQL Developer Test script 3.0
75
-- Created on 12.04.23 by SANJAR.AXMEDOV 
declare
  v_Company_Id number := 1500;
  v_Filial_Id  number := 61533;

  Procedure Save_Journal(i_Employee_Id number) is
    p_Journal     Hpd_Pref.Hiring_Journal_Rt;
    p_Robot       Hpd_Pref.Robot_Rt;
    p_Indicator   Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
    p_Oper_Type   Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    v_Division_Id number := 13502;
    v_Job_Id      number := 57498;
    v_Schedule_Id number := 28491;
    v_Hiring_Date date := Trunc(sysdate, 'yyyy');
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

begin
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(v_Company_Id);

  for r in (select *
              from Mhr_Employees q
             where q.Company_Id = v_Company_Id
               and q.Filial_Id = v_Filial_Id
               and not exists (select *
                      from Href_Staffs p
                     where p.Company_Id = q.Company_Id
                       and p.Filial_Id = q.Filial_Id
                       and p.Employee_Id = q.Employee_Id))
  loop
    Save_Journal(r.Employee_Id);
  end loop;

  Biruni_Route.Context_End;
end;
0
0
