PL/SQL Developer Test script 3.0
26
-- Created on 7/19/2022 by ADHAM 
declare
  v_Company_Id number := 680;
  v_Filial_Id  number := 36879;

  v_Unnecessary_Divs Array_Number := Array_Number(5631, 5582, 5654);
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  v_Unnecessary_Divs := v_Unnecessary_Divs multiset union
                        Href_Util.Get_Child_Divisions(i_Company_Id => v_Company_Id,
                                                      i_Filial_Id  => v_Filial_Id,
                                                      i_Parents    => v_Unnecessary_Divs);

  for r in (select *
              from Htt_Location_Divisions Ld
             where Ld.Company_Id = v_Company_Id
               and Ld.Filial_Id = v_Filial_Id
               and Ld.Division_Id member of v_Unnecessary_Divs)
  loop
    Htt_Api.Location_Remove_Division(i_Company_Id  => r.Company_Id,
                                     i_Filial_Id   => r.Filial_Id,
                                     i_Location_Id => r.Location_Id,
                                     i_Division_Id => r.Division_Id);
  end loop;
end;
0
0
