PL/SQL Developer Test script 3.0
53
-- Created on 9/12/2022 by ADHAM 
declare
  -- Local variables here
  i integer;
begin
  -- Test statements here

  for r in (select *
              from Hpd_Journals q
             where q.Company_Id = 560
               and q.Filial_Id = 15689
               and q.Journal_Type_Id in (641, 642))
  loop
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(560);
  
    Hpd_Api.Journal_Unpost(i_Company_Id => r.Company_Id,
                           i_Filial_Id  => r.Filial_Id,
                           i_Journal_Id => r.Journal_Id,
                           i_Repost     => true);
  
    update Hpd_Page_Schedules q
       set q.Schedule_Id = Nvl((select (select t.Schedule_Id
                                         from Hrm_Division_Schedules t
                                        where t.Company_Id = r.Company_Id
                                          and t.Filial_Id = r.Filial_Id
                                          and t.Division_Id = k.Division_Id)
                                 from Hpd_Page_Robots k
                                 join Hpd_Journal_Pages e
                                   on k.Company_Id = e.Company_Id
                                  and k.Filial_Id = e.Filial_Id
                                  and k.Page_Id = e.Page_Id
                                where k.Company_Id = r.Company_Id
                                  and k.Filial_Id = r.Filial_Id
                                  and k.Page_Id = q.Page_Id
                                  and e.Journal_Id = r.Journal_Id),
                               q.Schedule_Id)
     where q.Company_Id = r.Company_Id
       and q.Filial_Id = r.Filial_Id
       and exists (select 1
              from Hpd_Journal_Pages w
             where w.Company_Id = r.Company_Id
               and w.Filial_Id = r.Filial_Id
               and w.Journal_Id = r.Journal_Id
               and w.Page_Id = q.Page_Id);
  
    Hpd_Api.Journal_Post(i_Company_Id => r.Company_Id,
                         i_Filial_Id  => r.Filial_Id,
                         i_Journal_Id => r.Journal_Id);
  
    Biruni_Route.Context_End;
  end loop;
end;
0
0
