PL/SQL Developer Test script 3.0
53
declare
  v_Company_Id          number := -1;
  v_Filial_Id           number := -1;
  v_Vacation_Days_Limit number := 21;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);
  Biruni_Route.Context_Begin;

  for r in (select q.Journal_Id, --
                   p.Page_Id,
                   q.Posted,
                   Rb.Robot_Id,
                   Rownum Rn
              from Hpd_Journals q
              join Hpd_Journal_Pages p
                on p.Company_Id = q.Company_Id
               and p.Filial_Id = q.Filial_Id
               and p.Journal_Id = q.Journal_Id
              join Hpd_Page_Robots Rb
                on Rb.Company_Id = p.Company_Id
               and Rb.Filial_Id = p.Filial_Id
               and Rb.Page_Id = p.Page_Id
             where q.Company_Id = v_Company_Id
               and q.Filial_Id = v_Filial_Id)
  loop
    Dbms_Application_Info.Set_Module('migr progress', r.Rn || '/867');
  
    if r.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => v_Company_Id,
                             i_Filial_Id  => v_Filial_Id,
                             i_Journal_Id => r.Journal_Id,
                             i_Repost     => true);
    end if;
  
    z_Hrm_Robot_Vacation_Limits.Save_One(i_Company_Id => v_Company_Id,
                                         i_Filial_Id  => v_Filial_Id,
                                         i_Robot_Id   => r.Robot_Id,
                                         i_Days_Limit => v_Vacation_Days_Limit);
  
    z_Hpd_Page_Vacation_Limits.Save_One(i_Company_Id => v_Company_Id,
                                        i_Filial_Id  => v_Filial_Id,
                                        i_Page_Id    => r.Page_Id,
                                        i_Days_Limit => v_Vacation_Days_Limit);
  
    if r.Posted = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Journal_Id => r.Journal_Id);
    end if;
  end loop;

  Biruni_Route.Context_End;
end;
0
0
