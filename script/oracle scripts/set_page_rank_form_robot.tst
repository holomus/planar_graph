PL/SQL Developer Test script 3.0
23
-- Created on 05.08.2022 by SANJAR 
declare
  v_Company_Id number := -1;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  update Hpd_Page_Robots p
     set p.Rank_Id =
         (select r.Rank_Id
            from Hrm_Robots r
           where r.Company_Id = p.Company_Id
             and r.Filial_Id = p.Filial_Id
             and r.Robot_Id = p.Robot_Id)
   where p.Company_Id = v_Company_Id
     and p.Rank_Id is null
     and exists (select 1
            from Hrm_Robots q
           where q.Company_Id = p.Company_Id
             and q.Filial_Id = p.Filial_Id
             and q.Robot_Id = p.Robot_Id
             and q.Rank_Id is not null);
  commit;
end;
0
0
