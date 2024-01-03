PL/SQL Developer Test script 3.0
76
-- Created on 5/3/2023 by ADHAM.TOSHKANOV 
declare
  -- Local variables here
  i       integer;
  r_Robot Mrf_Robots%rowtype;
  p_Robot Hrm_Pref.Robot_Rt;
begin
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(700);
  for r in (select *
              from Mrf_Robots q
             where q.Robot_Id in (3065,
                                  33061,
                                  12226,
                                  3123,
                                  2987,
                                  24547,
                                  3027,
                                  2980,
                                  2978,
                                  34725,
                                  3068,
                                  20634,
                                  3018,
                                  12624,
                                  2979,
                                  2973,
                                  4691,
                                  3107,
                                  2996,
                                  24545,
                                  2977,
                                  3079,
                                  3108,
                                  2974,
                                  24546,
                                  8748,
                                  3026,
                                  24701,
                                  2975))
  loop
    r_Robot := z_Mrf_Robots.Load(i_Company_Id => r.Company_Id,
                                 i_Filial_Id  => r.Filial_Id,
                                 i_Robot_Id   => r.Robot_Id);
  
    Hrm_Util.Robot_New(o_Robot               => p_Robot,
                       i_Company_Id          => r_Robot.Company_Id,
                       i_Filial_Id           => r_Robot.Filial_Id,
                       i_Robot_Id            => r_Robot.Robot_Id,
                       i_Name                => r_Robot.Name,
                       i_Code                => r_Robot.Code,
                       i_Robot_Group_Id      => r_Robot.Robot_Group_Id,
                       i_Division_Id         => 3868,
                       i_Job_Id              => 6151,
                       i_State               => 'A',
                       i_Opened_Date         => to_date('01.01.2010', 'dd.mm.yyyy'),
                       i_Closed_Date         => null,
                       i_Schedule_Id         => null,
                       i_Vacation_Days_Limit => null,
                       i_Rank_Id             => null,
                       i_Labor_Function_Id   => null,
                       i_Description         => 'migration from trade',
                       i_Hiring_Condition    => null,
                       i_Wage_Scale_Id       => null,
                       i_Contractual_Wage    => 'Y');
  
    p_Robot.Robot.Person_Id  := r_Robot.Person_Id;
    p_Robot.Robot.Manager_Id := r_Robot.Manager_Id;
    p_Robot.Robot.Name       := r_Robot.Name;
    p_Robot.Robot.Code       := r_Robot.Code;
    p_Robot.Robot.State      := r_Robot.State;
  
    Hrm_Api.Robot_Save(p_Robot);
  end loop;
  Biruni_Route.Context_End;
end;
0
0
