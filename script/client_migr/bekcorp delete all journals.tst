PL/SQL Developer Test script 3.0
64
-- Created on 1/6/2023 by ADHAM 
declare
  -- Local variables here
  i            integer;
  v_Company_Id number := 580;
  --v_Filial_Id  number := 16176;
begin
  -- Test statements here

  --Biruni_Route.Context_Begin;
  --Ui_Auth.Logon_As_System(v_Company_Id);
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(v_Company_Id);
  for r in (with Dfs as
               (select (select max(w.Track_Date)
                         from Htt_Tracks w
                        where w.Person_Id = t.Person_Id) Max_Track_Date,
                      Row_Number() Over(partition by t.Name order by (select max(w.Track_Date)
                                                                        from Htt_Tracks w
                                                                       where w.Person_Id =
                                                                             t.Person_Id) desc nulls last, Person_Id) Rownumber,
                      t.*
                 from Mr_Natural_Persons_New t
                order by t.Name, 1 desc nulls last, Person_Id)
              select t.*
                from Dfs e
                join Mhr_Employees t
                  on e.Person_Id = t.Employee_Id
               where t.Employee_Id in (49809, 54321, 50036, 50001))
  loop
    for Doc in (select *
                  from Hpd_Journals w
                 where w.Company_Id = v_Company_Id
                   and w.Filial_Id = r.Filial_Id
                   and exists (select *
                          from Hpd_Journal_Employees k
                         where k.Company_Id = v_Company_Id
                           and k.Filial_Id = r.Filial_Id
                           and k.Journal_Id = w.Journal_Id
                           and k.Employee_Id = r.Employee_Id)
                 order by (select Jp.Staff_Id
                             from Hpd_Journal_Pages Jp
                            where Jp.Journal_Id = w.Journal_Id) desc,
                          w.Journal_Type_Id desc)
    loop
      Hpd_Api.Journal_Unpost(i_Company_Id => Doc.Company_Id,
                             i_Filial_Id  => Doc.Filial_Id,
                             i_Journal_Id => Doc.Journal_Id);
    
      Hpd_Api.Journal_Delete(i_Company_Id => Doc.Company_Id,
                             i_Filial_Id  => Doc.Filial_Id,
                             i_Journal_Id => Doc.Journal_Id);
    end loop;
  
    Href_Api.Employee_Delete(i_Company_Id  => v_Company_Id,
                             i_Filial_Id   => r.Filial_Id,
                             i_Employee_Id => r.Employee_Id);
  
  end loop;

  Biruni_Route.Context_End;

  --Biruni_Route.Context_End;
end;
0
0
