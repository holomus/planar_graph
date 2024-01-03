PL/SQL Developer Test script 3.0
49
-- Created on 27.09.2022 by SANJAR 
declare
  v_Old_Company_Id   number := -1;
  v_New_Company_Id   number := -1;
  v_Undesired_Filial number := -1;
begin
  Ui_Auth.Logon_As_System(v_New_Company_Id);

  update Md_Users p
     set (p.Name, p.Timezone_Code) =
         (select Ou.Name, Ou.Timezone_Code
            from Migr_Keys_Store_One St
            join Old_Md_Users Ou
              on Ou.Company_Id = v_Old_Company_Id
             and Ou.User_Id = St.Old_Id
           where St.Company_Id = p.Company_Id
             and St.Key_Name = 'person_id'
             and St.New_Id = p.User_Id)
   where p.Company_Id = v_New_Company_Id
     and exists (select 1
            from Migr_Keys_Store_One St
            join Old_Md_Users Ou
              on Ou.Company_Id = v_Old_Company_Id
             and Ou.User_Id = St.Old_Id
           where St.Company_Id = p.Company_Id
             and St.Key_Name = 'person_id'
             and St.New_Id = p.User_Id);

  Biruni_Route.Context_Begin;
  
  for r in (select *
              from Md_Users p
             where p.Company_Id = v_New_Company_Id
               and exists (select 1
                      from Migr_Keys_Store_One St
                      join Old_Md_Users Ou
                        on Ou.Company_Id = v_Old_Company_Id
                       and Ou.User_Id = St.Old_Id
                     where St.Company_Id = p.Company_Id
                       and St.Key_Name = 'person_id'
                       and St.New_Id = p.User_Id))
  loop
    Md_Api.User_Remove_Filial(i_Company_Id => r.Company_Id,
                              i_User_Id    => r.User_Id,
                              i_Filial_Id  => v_Undesired_Filial);
  end loop;

  Biruni_Route.Context_End;
end;
0
0
