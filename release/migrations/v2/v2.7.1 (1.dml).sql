prompt migr from 28.09.2022 - v2.7.1 (1.dml)
----------------------------------------------------------------------------------------------------
declare
  r_Leg_Person Mr_Legal_Persons%rowtype;
  r_Details    Mr_Person_Details%rowtype;
begin
  for Cmp in (select c.Company_Id,
                     (select C1.User_System
                        from Md_Company_Infos C1
                       where C1.Company_Id = c.Company_Id) as User_System,
                     (select C1.Filial_Head
                        from Md_Company_Infos C1
                       where C1.Company_Id = c.Company_Id) as Filial_Head,
                     (select k.Currency_Id
                        from Mk_Currencies k
                       where k.Company_Id = c.Company_Id
                         and k.Pcode = 'ANOR:1') as Base_Currency_Id
                from Md_Companies c)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                         i_Filial_Id    => Cmp.Filial_Head,
                         i_User_Id      => Cmp.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    for Fil in (select *
                  from Md_Filials f
                 where f.Company_Id = Cmp.Company_Id
                   and f.Filial_Id <> Cmp.Filial_Head
                   and not exists (select 1
                          from Mr_Legal_Persons Lp
                         where Lp.Company_Id = Cmp.Company_Id
                           and Lp.Person_Id = f.Filial_Id))
    loop
      -- legal person
      z_Mr_Legal_Persons.Init(p_Row        => r_Leg_Person,
                              i_Company_Id => Fil.Company_Id,
                              i_Person_Id  => Fil.Filial_Id,
                              i_Name       => Fil.Name,
                              i_Short_Name => Fil.Name,
                              i_State      => 'A');
    
      Mr_Api.Legal_Person_Save(r_Leg_Person);
    
      -- legal person details
      r_Details.Company_Id     := Fil.Company_Id;
      r_Details.Person_Id      := Fil.Filial_Id;
      r_Details.Is_Budgetarian := 'N';
    
      Mr_Api.Person_Detail_Save(r_Details);
    
      -- filial data
      if not
          z_Mk_Base_Currencies.Exist(i_Company_Id => Fil.Company_Id, i_Filial_Id => Fil.Filial_Id) then
        Mk_Api.Base_Currency_Save(i_Company_Id  => Fil.Company_Id,
                                  i_Filial_Id   => Fil.Filial_Id,
                                  i_Currency_Id => Cmp.Base_Currency_Id);
      end if;
    
      Mrf_Api.Filial_Add_Person(i_Company_Id => Fil.Company_Id,
                                i_Filial_Id  => Fil.Filial_Id,
                                i_Person_Id  => Fil.Filial_Id,
                                i_State      => 'A');
    
      Md_Api.Preference_Save(i_Company_Id => Fil.Company_Id,
                             i_Filial_Id  => Fil.Filial_Id,
                             i_Code       => Mrf_Pref.c_Pref_Vat_Enabled,
                             i_Value      => 'N');
    
      Md_Api.Preference_Save(i_Company_Id => Fil.Company_Id,
                             i_Filial_Id  => Fil.Filial_Id,
                             i_Code       => Mrf_Pref.c_Pref_Excise_Enabled,
                             i_Value      => 'N');
    end loop;
  
    commit;
  end loop;
end;
/
