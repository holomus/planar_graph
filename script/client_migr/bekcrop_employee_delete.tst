PL/SQL Developer Test script 3.0
37
-- Created on 2/7/2023 by ADHAM 
declare
  -- Local variables here
  i integer;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(580);
  for r in (select (select max(w.Track_Date)
                      from Htt_Tracks w
                     where w.Person_Id = t.Person_Id) Max_Track_Date,
                   t.*
              from Mr_Natural_Persons_New t
             where not exists (select *
                      from Mhr_Employees k
                     where k.Employee_Id = t.Person_Id)
             order by t.Name)
  loop
    delete Htt_Location_Persons w
     where w.Company_Id = r.Company_Id
       and w.Person_Id = r.Person_Id;
  
    delete Htt_Tracks q
     where q.Company_Id = r.Company_Id
       and q.Person_Id = r.Person_Id;
  
    delete Htt_Trash_Tracks q
     where q.Company_Id = r.Company_Id
       and q.Person_Id = r.Person_Id;
  
    Md_Api.User_Delete(i_Company_Id => r.Company_Id, i_User_Id => r.Person_Id);
    Href_Api.Person_Delete(i_Company_Id => r.Company_Id, i_Person_Id => r.Person_Id);
    Mr_Api.Natural_Person_Delete(i_Company_Id => r.Company_Id, i_Person_Id => r.Person_Id);
    delete mr_natural_persons_new q where q.person_id = r.person_id;
  end loop;
  Biruni_Route.Context_End;
end;
0
0
