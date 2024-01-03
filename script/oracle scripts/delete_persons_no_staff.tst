PL/SQL Developer Test script 3.0
40
-- Created on 7/19/2022 by ADHAM 
declare
  v_Company_Id number := 680;

  v_Employee_Ids Array_Number;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  select p.Person_Id
    bulk collect
    into v_Employee_Ids
    from Mr_Natural_Persons p
   where p.Company_Id = v_Company_Id
     and not exists (select *
            from Href_Staffs q
           where q.Company_Id = p.Company_Id
             and q.Employee_Id = p.Person_Id);

  v_Employee_Ids := set(v_Employee_Ids);

  delete Mrf_Persons p
   where p.Company_Id = v_Company_Id
     and p.Person_Id member of v_Employee_Ids;

  delete Htt_Location_Persons p
   where p.Company_Id = v_Company_Id
     and p.Person_Id member of v_Employee_Ids;

  delete Mr_Natural_Persons p
   where p.Company_Id = v_Company_Id
     and p.Person_Id member of v_Employee_Ids;

  delete Md_Users p
   where p.Company_Id = v_Company_Id
     and p.User_Id member of v_Employee_Ids;

  delete Md_Persons p
   where p.Company_Id = v_Company_Id
     and p.Person_Id member of v_Employee_Ids;
end;
0
0
