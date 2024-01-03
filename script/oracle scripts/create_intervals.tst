PL/SQL Developer Test script 3.0
30
-- Created on 30.08.2022 by SANJAR 
declare
  -- Local variables here
  v_Company_Id number := 200;
  v_Staff_Ids  Array_Number;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  Biruni_Route.Context_Begin;

  for r in (select q.Filial_Id
              from Href_Staffs q
             where q.Company_Id = v_Company_Id
             group by q.Filial_Id)
  loop
    select p.Staff_Id
      bulk collect
      into v_Staff_Ids
      from Href_Staffs p
     where p.Company_Id = v_Company_Id
       and p.Filial_Id = r.Filial_Id;
  
    Hlic_Core.Revise_License_By_Dirty_Staffs(i_Company_Id => v_Company_Id,
                                             i_Filial_Id  => r.Filial_Id,
                                             i_Staff_Ids  => v_Staff_Ids);
  end loop;

  Biruni_Route.Context_End;
  commit;
end;
0
0
