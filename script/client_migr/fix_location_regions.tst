PL/SQL Developer Test script 3.0
81
-- Created on 27.09.2022 by SANJAR 
declare
  v_Old_Company_Id number := 960;
  v_New_Company_Id number := 680;
begin
  Ui_Auth.Logon_As_System(v_New_Company_Id);

  insert into Migr_Used_Keys
    (Key_Name, Old_Id, Company_Id)
    select 'region_id', q.Region_Id, v_New_Company_Id
      from Md_Regions p
      join Old_Md_Regions q
        on q.Company_Id = v_Old_Company_Id
       and Upper(q.Name) = Upper(p.Name)
     where p.Company_Id = v_New_Company_Id
       and p.Pcode is null;

  insert into Migr_Keys_Store_One
    (Company_Id, Key_Name, Old_Id, New_Id)
    select v_New_Company_Id, 'region_id', q.Region_Id, p.Region_Id
      from Md_Regions p
      join Old_Md_Regions q
        on q.Company_Id = v_Old_Company_Id
       and Upper(q.Name) = Upper(p.Name)
     where p.Company_Id = v_New_Company_Id
       and p.Pcode is null;

  Biruni_Route.Context_Begin;

  Client_Migr.Migr_Regions(v_Old_Company_Id, v_New_Company_Id);

  Biruni_Route.Context_End;

  update Htt_Locations p
     set p.Region_Id =
         (select Rg.New_Id
            from Migr_Keys_Store_One St
            join Old_Vx_Org_Locations Lc
              on Lc.Company_Id = v_Old_Company_Id
             and Lc.Location_Id = St.Old_Id
            left join Migr_Keys_Store_One Rg
              on Rg.Company_Id = v_New_Company_Id
             and Rg.Key_Name = 'region_id'
             and Rg.Old_Id = Lc.Region_Id
           where St.Company_Id = p.Company_Id
             and St.Key_Name = 'location_id'
             and St.New_Id = p.Location_Id)
   where p.Company_Id = v_New_Company_Id
     and exists (select 1
            from Migr_Keys_Store_One St
            join Old_Vx_Org_Locations Lc
              on Lc.Company_Id = v_Old_Company_Id
             and Lc.Location_Id = St.Old_Id
           where St.Company_Id = p.Company_Id
             and St.Key_Name = 'location_id'
             and St.New_Id = p.Location_Id);

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
end;
0
0
