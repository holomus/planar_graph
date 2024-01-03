PL/SQL Developer Test script 3.0
41
declare
  v_Company_Id number := 100;
  v_Filial_Id  number := 144;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);
  Biruni_Route.Context_Begin;

  for r in (select t.Schedule_Id, p.Employee_Id, p.Staff_Id, j.Journal_Id, j.Page_Id, q.*, Rownum Rn
              from Migr_Schedule_Employees q
              join Htt_Schedules t
                on t.Name = q.Schedule_Name
              join Href_Staffs p
                on p.Staff_Number = q.Employee_Number
              join Hpd_Journal_Pages j
                on j.Company_Id = p.Company_Id
               and j.Filial_Id = p.Filial_Id
               and j.Staff_Id = p.Staff_Id
             where t.Company_Id = v_Company_Id
               and t.Filial_Id = v_Filial_Id
               and p.Company_Id = v_Company_Id
               and p.Filial_Id = v_Filial_Id)
  loop
    Dbms_Application_Info.Set_Module('migr progress', r.Rn || '/867');
  
    Hpd_Api.Journal_Unpost(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Journal_Id => r.Journal_Id,
                           i_Repost     => true);
  
    z_Hpd_Page_Schedules.Update_One(i_Company_Id  => v_Company_Id,
                                    i_Filial_Id   => v_Filial_Id,
                                    i_Page_Id     => r.Page_Id,
                                    i_Schedule_Id => Option_Number(r.Schedule_Id));
  
    Hpd_Api.Journal_Post(i_Company_Id => v_Company_Id,
                         i_Filial_Id  => v_Filial_Id,
                         i_Journal_Id => r.Journal_Id);
  end loop;

  Biruni_Route.Context_End;
end;
0
0
