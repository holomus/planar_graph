PL/SQL Developer Test script 3.0
45
-- Created on 7/19/2022 by ADHAM 
declare
  v_Company_Id number := 580;
  v_Filial_Id  number := 48905;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  delete Href_Staffs p
   where p.Company_Id = v_Company_Id
     and p.Filial_Id = v_Filial_Id
     and not exists (select *
            from Hpd_Journal_Pages Jp
           where Jp.Company_Id = p.Company_Id
             and Jp.Filial_Id = p.Filial_Id
             and Jp.Staff_Id = p.Staff_Id);

  delete Mhr_Employees p
   where p.Company_Id = v_Company_Id
     and p.Filial_Id = v_Filial_Id
     and not exists (select *
            from Href_Staffs q
           where q.Company_Id = p.Company_Id
             and q.Filial_Id = p.Filial_Id
             and q.Employee_Id = p.Employee_Id);

  delete Htt_Location_Persons p
   where p.Company_Id = v_Company_Id
     and p.Filial_Id = v_Filial_Id
     and not exists (select *
            from Href_Staffs q
           where q.Company_Id = p.Company_Id
             and q.Filial_Id = p.Filial_Id
             and q.Employee_Id = p.Person_Id);

  update Mrf_Persons p
     set p.State = 'P'
   where p.Company_Id = v_Company_Id
     and p.Filial_Id = v_Filial_Id
     and p.State = 'A'
     and not exists (select *
            from Href_Staffs q
           where q.Company_Id = p.Company_Id
             and q.Filial_Id = p.Filial_Id
             and q.Employee_Id = p.Person_Id);
end;
0
0
