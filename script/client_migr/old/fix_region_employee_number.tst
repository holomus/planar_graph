PL/SQL Developer Test script 3.0
74
-- Created on 27.09.2022 by SANJAR 
declare
  v_Old_Company_Id number := -1;
  v_New_Company_Id number := -1;
  v_Filial_Id      number := -1;
begin
  Ui_Auth.Logon_As_System(v_New_Company_Id);

  update Mr_Person_Details Pd
     set Pd.Region_Id =
         (select Rg.New_Id
            from Migr_Keys_Store_One St
            join Old_Vx_Org_Persons p
              on p.Company_Id = v_Old_Company_Id
             and p.Person_Id = St.Old_Id
            left join Migr_Keys_Store_One Rg
              on Rg.Company_Id = v_New_Company_Id
             and Rg.Key_Name = 'region_id'
             and Rg.Old_Id = p.Region_Id
           where St.Company_Id = Pd.Company_Id
             and St.Key_Name = 'person_id'
             and St.New_Id = Pd.Person_Id)
   where Pd.Company_Id = v_New_Company_Id
     and exists (select 1
            from Migr_Keys_Store_One St
            join Old_Vx_Org_Persons p
              on p.Company_Id = v_Old_Company_Id
             and p.Person_Id = St.Old_Id
           where St.Company_Id = Pd.Company_Id
             and St.Key_Name = 'person_id'
             and St.New_Id = Pd.Person_Id);

  update Href_Staffs q
     set q.Staff_Number =
         (select p.Employee_Number
            from Migr_Keys_Store_One St
            join Old_Vx_Hr_Employees p
              on p.Company_Id = v_Old_Company_Id
             and p.Employee_Id = St.Old_Id
           where St.Company_Id = q.Company_Id
             and St.Key_Name = 'person_id'
             and St.New_Id = q.Employee_Id)
   where q.Company_Id = v_New_Company_Id
     and q.Filial_Id = v_Filial_Id
     and exists (select 1
            from Migr_Keys_Store_One St
            join Old_Vx_Hr_Employees p
              on p.Company_Id = v_Old_Company_Id
             and p.Employee_Id = St.Old_Id
           where St.Company_Id = q.Company_Id
             and St.Key_Name = 'person_id'
             and St.New_Id = q.Employee_Id);

  update Mhr_Employees q
     set q.Employee_Number =
         (select p.Employee_Number
            from Migr_Keys_Store_One St
            join Old_Vx_Hr_Employees p
              on p.Company_Id = v_Old_Company_Id
             and p.Employee_Id = St.Old_Id
           where St.Company_Id = q.Company_Id
             and St.Key_Name = 'person_id'
             and St.New_Id = q.Employee_Id)
   where q.Company_Id = v_New_Company_Id
     and q.Filial_Id = v_Filial_Id
     and exists (select 1
            from Migr_Keys_Store_One St
            join Old_Vx_Hr_Employees p
              on p.Company_Id = v_Old_Company_Id
             and p.Employee_Id = St.Old_Id
           where St.Company_Id = q.Company_Id
             and St.Key_Name = 'person_id'
             and St.New_Id = q.Employee_Id);
end;
0
0
