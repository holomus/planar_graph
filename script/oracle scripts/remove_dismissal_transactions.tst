PL/SQL Developer Test script 3.0
35
-- Created on 8/30/2022 by ADHAM 
declare
  -- Local variables here
  i integer;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(100);

  for r in (select *
              from Hpd_Transactions q
             where q.Tag = 'dismissal')
  loop
    z_Hpd_Transactions.Update_One(i_Company_Id => r.Company_Id,
                                  i_Filial_Id  => r.Filial_Id,
                                  i_Trans_Id   => r.Trans_Id,
                                  i_Event      => Option_Varchar2(Hpd_Pref.c_Transaction_Event_To_Be_Deleted));
    for w in (select q.Trans_Type
                from Hpd_Transactions q
               where q.Company_Id = r.Company_Id
                 and q.Filial_Id = r.Filial_Id
                 and q.Staff_Id = r.Staff_Id
               group by q.Trans_Type)
    loop
      Hpd_Core.Agreement_Dirty(i_Company_Id => r.Company_Id,
                               i_Filial_Id  => r.Filial_Id,
                               i_Staff_Id   => r.Staff_Id,
                               i_Trans_Type => w.Trans_Type);
    end loop;
  end loop;

  Hpd_Core.Agreements_Evaluate(100);
  Hrm_Core.Dirty_Robots_Revise;
  Biruni_Route.Context_End;
end;
0
0
