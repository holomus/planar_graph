PL/SQL Developer Test script 3.0
11
-- Created on 10/19/2022 by ADHAM 
declare
  v_Company_Id number := -1;
  v_Filial_Id  number := -1;
begin
  Client_Migr.Create_Subordinated_Divisions_V1(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Filial_Id);

  Client_Migr.Fix_Robot_Divisions_V1(i_Company_Id => v_Company_Id, --
                                     i_Filial_Id  => v_Filial_Id);
end;
0
0
