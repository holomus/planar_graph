PL/SQL Developer Test script 3.0
13
-- Created on 25.07.2022 by SANJAR 
declare
  -- Local variables here
  v_Company_Id number := -1;
begin
  -- Test statements here
  insert into Migr_Keys_Store_One
    (Company_Id, Key_Name, Old_Id, New_Id)
    select St.Company_Id, St.Key_Name, St.Old_Id, St.New_Id
      from Migr_Keys_Store_Two St
     where St.Company_Id = v_Company_Id
       and St.Key_Name in ('location_id', 'device_id');
end;
0
0
