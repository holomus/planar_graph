prompt change payment user settings code
----------------------------------------------------------------------------------------------------  
declare
  v_Anor_Setting_Code varchar2(20) := 'ui_anor820';
  v_Vhr_Setting_Code  varchar2(20) := 'ui_vhr591';
begin
  for r in (select c.Company_Id,
                   (select Ci.User_System
                      from Md_Company_Infos Ci
                     where Ci.Company_Id = c.Company_Id) as User_System,
                   (select Ci.Filial_Head
                      from Md_Company_Infos Ci
                     where Ci.Company_Id = c.Company_Id) as Filial_Head
              from Md_Companies c)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => r.Filial_Head,
                         i_User_Id      => r.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    for s in (select q.*
                from Md_User_Settings q
               where q.Company_Id = r.Company_Id
                 and q.Setting_Code = v_Anor_Setting_Code)
    loop
      z_Md_User_Settings.Insert_One(i_Company_Id    => s.Company_Id,
                                    i_User_Id       => s.User_Id,
                                    i_Filial_Id     => s.Filial_Id,
                                    i_Setting_Code  => v_Vhr_Setting_Code,
                                    i_Setting_Value => s.Setting_Value);
    end loop;
  end loop;
  
  commit;
end;
/

---------------------------------------------------------------------------------------------------- 
prompt update phone numbers
---------------------------------------------------------------------------------------------------- 
declare
  v_Phone varchar2(100);
begin
  for Com in (select c.Company_Id,
                     (select Ci.User_System
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as User_System
                from Md_Companies c
                join Md_Company_Infos p
                  on p.Company_Id = c.Company_Id
                 and (p.Country_Code = 'UZ' or p.Country_Code is null))
  loop
    for Fil in (select *
                  from Md_Filials q
                 where q.Company_Id = Com.Company_Id)
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Fil.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => Com.User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      for Can in (select q.Company_Id,
                         q.Candidate_Id,
                         Pd.Main_Phone,
                         Regexp_Replace(Pd.Main_Phone, '[^0-9]', '') as Reg_Phone,
                         Length(Regexp_Replace(Pd.Main_Phone, '[^0-9]', '')) as Length,
                         (select p.Extra_Phone || ';'
                            from Href_Person_Details p
                           where p.Company_Id = q.Company_Id
                             and p.Person_Id = q.Candidate_Id) Extra_Phone
                    from Href_Candidates q
                    join Mr_Person_Details Pd
                      on Pd.Company_Id = q.Company_Id
                     and Pd.Person_Id = q.Candidate_Id
                     and Pd.Main_Phone is not null
                   where q.Company_Id = Fil.Company_Id
                     and q.Filial_Id = Fil.Filial_Id
                     and exists (select 1
                            from Md_Persons Pr
                           where Pr.Company_Id = Pd.Company_Id
                             and Pr.Person_Id = Pd.Person_Id
                             and Length(Pr.Phone) = 9))
      loop
        v_Phone := '998' || Can.Reg_Phone;
      
        -- unique index dan xato berishi mumkin shuning uchun exception yozildi
        begin
          z_Md_Persons.Update_One(i_Company_Id => Can.Company_Id,
                                  i_Person_Id  => Can.Candidate_Id,
                                  i_Phone      => Option_Varchar2(v_Phone));
        exception
          when others then
            null;
        end;
      
        z_Mr_Person_Details.Update_One(i_Company_Id => Can.Company_Id,
                                       i_Person_Id  => Can.Candidate_Id,
                                       i_Main_Phone => Option_Varchar2('+' || v_Phone));
      
        if z_Href_Person_Details.Exist(i_Company_Id => Can.Company_Id,
                                       i_Person_Id  => Can.Candidate_Id) then
          z_Href_Person_Details.Update_One(i_Company_Id  => Can.Company_Id,
                                           i_Person_Id   => Can.Candidate_Id,
                                           i_Extra_Phone => Option_Varchar2(Can.Extra_Phone ||
                                                                            Can.Main_Phone));
        else
          z_Href_Person_Details.Save_One(i_Company_Id           => Can.Company_Id,
                                         i_Person_Id            => Can.Candidate_Id,
                                         i_Key_Person           => 'N',
                                         i_Access_All_Employees => 'N',
                                         i_Extra_Phone          => Can.Extra_Phone || Can.Main_Phone,
                                         i_Access_Hidden_Salary => 'N');
        end if;
      end loop;
    end loop;
  end loop;

  commit;
end;
/
