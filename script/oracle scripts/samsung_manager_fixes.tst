PL/SQL Developer Test script 3.0
49
-- Created on 10/19/2022 by ADHAM 
declare
  -- Local variables here
  i integer;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(940);
  --  hpd_core.Staff_Refresh_Cache(940);
  for r in (with Managers as
               (select q.*,
                      (select w.Name
                         from Md_Persons w
                        where w.Person_Id = q.Employee_Id) name,
                      k.Robot_Id
                 from Mhr_Employees q
                 join Href_Staffs k
                   on q.Filial_Id = k.Filial_Id
                  and q.Employee_Id = k.Employee_Id
                where q.Company_Id = 940
                  and q.Job_Id = 33955
                  and q.State = 'A'
                  and k.Dismissal_Date is null)
              select q.*,
                     w.Filial_Id,
                     w.Robot_Id,
                     (select Qe.Division_Id
                        from Hrm_Division_Managers Qe
                       where Qe.Company_Id = 940
                         and Qe.Employee_Id = q.Responsible_Person_Id) Division_Id
                from Mr_Natural_Persons q
                join Href_Staffs w
                  on w.Employee_Id = q.Person_Id
                 and w.Dismissal_Date is null
               where exists (select *
                        from Managers e
                       where e.Employee_Id = q.Responsible_Person_Id)
                 and q.State = 'A'
                 and w.State = 'A'
                 and w.Filial_Id = 42964)
  loop
    z_Mrf_Robots.Update_One(i_Company_Id  => 940,
                            i_Filial_Id   => r.Filial_Id,
                            i_Robot_Id    => r.Robot_Id,
                            i_Division_Id => Option_Number(r.Division_Id));
    null;
  end loop;
  Biruni_Route.Context_End;
end;
0
0
