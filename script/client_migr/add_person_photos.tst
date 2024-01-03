PL/SQL Developer Test script 3.0
25
declare
  v_Company_Id number := -1;
  v_Filial_Id  number := -1;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

  Biruni_Route.Context_Begin;
  for r in (select *
              from Md_Persons p
             where p.Company_Id = v_Company_Id
               and p.Photo_Sha is not null
               and exists (select *
                      from Md_User_Filials q
                     where q.Company_Id = p.Company_Id
                       and q.User_Id = p.Person_Id
                       and q.Filial_Id = v_Filial_Id))
  loop
    Htt_Api.Person_Save_Photo(i_Company_Id => r.Company_Id,
                              i_Person_Id  => r.Person_Id,
                              i_Photo_Sha  => r.Photo_Sha,
                              i_Is_Main    => 'Y');
  end loop;

  Biruni_Route.Context_End;
end;
0
0
