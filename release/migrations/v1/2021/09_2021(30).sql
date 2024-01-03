prompt migr 30.09.2021
----------------------------------------------------------------------------------------------------
prompt migr table changes
----------------------------------------------------------------------------------------------------
alter table htt_timesheet_facts drop constraint htt_timesheet_facts_c1;
alter table htt_timesheet_facts add constraint htt_timesheet_facts_c1 check (fact_value >= 0);
----------------------------------------------------------------------------------------------------
drop index href_person_details_u1;
alter table href_person_details modify iapa varchar2(20 char);
create unique index href_person_details_u1 on href_person_details(nvl2(iapa, company_id, null), iapa) tablespace GWS_INDEX;
----------------------------------------------------------------------------------------------------
drop index htt_locations_u2;
create unique index htt_locations_u2 on htt_locations(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt migr default role
----------------------------------------------------------------------------------------------------
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  v_Role_Id      number;
  v_Dummy        varchar2(1);
  --------------------------------------------------
  Procedure Default_Role
  (
    a varchar2,
    b varchar2,
    c number
  ) is
    v_Role_Id number;
  begin
    begin
      select Role_Id
        into v_Role_Id
        from Md_Roles
       where Company_Id = v_Company_Head
         and Pcode = b;
    exception
      when No_Data_Found then
        v_Role_Id := Md_Next.Role_Id;
    end;
  
    z_Md_Roles.Save_One(i_Company_Id  => v_Company_Head,
                        i_Role_Id     => v_Role_Id,
                        i_Name        => a,
                        i_State       => 'A',
                        i_Order_No    => c,
                        i_Pcode       => b);
  end;
begin
  Default_Role('HR-менеджер',Href_Pref.c_Pcode_Role_Hr, 1);
  Default_Role('Руководитель', Href_Pref.c_Pcode_Role_Supervisor, 2);
  Default_Role('Сотрудник', Href_Pref.c_Pcode_Role_Staff, 3);
  Default_Role('Бухгалтер', Href_Pref.c_Pcode_Role_Accountant, 4);
  
  for r in (select *
              from Md_Companies q
             where Md_Util.Any_Project(q.Company_Id) is not null
               and q.State = 'A'
               and q.Company_Id <> v_Company_Head)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    for r_Role in (select *
                     from Md_Roles q
                    where q.Company_Id = v_Company_Head
                      and q.State = 'A'
                      and q.Pcode in (Href_Pref.c_Pcode_Role_Hr,
                                      Href_Pref.c_Pcode_Role_Supervisor,
                                      Href_Pref.c_Pcode_Role_Staff,
                                      Href_Pref.c_Pcode_Role_Accountant))
    loop
      begin
        select Role_Id
          into v_Role_Id
          from Md_Roles
         where Company_Id = r.Company_Id
           and Pcode = r_Role.Pcode;
      exception
        when No_Data_Found then
          begin
            select 'X'
              into v_Dummy
              from Md_Roles q
             where q.Company_Id = r.Company_Id
               and Upper(q.Name) = Upper(r_Role.Name);
            continue;
          exception
            when No_Data_Found then
              v_Role_Id := Md_Next.Role_Id;
          end;
      end;
    
      z_Md_Roles.Save_One(i_Company_Id => r.Company_Id,
                          i_Role_Id    => v_Role_Id,
                          i_Name       => r_Role.Name,
                          i_State      => r_Role.State,
                          i_Order_No   => r_Role.Order_No,
                          i_Pcode      => r_Role.Pcode);
    
      for q in (select *
                  from Md_Role_Form_Actions f
                 where f.Company_Id = v_Company_Head
                   and f.Role_Id = r_Role.Role_Id)
      loop
        z_Md_Role_Form_Actions.Insert_Try(i_Company_Id => r.Company_Id,
                                          i_Role_Id    => v_Role_Id,
                                          i_Form       => q.Form,
                                          i_Action_Key => q.Action_Key);
      end loop;
    
      for q in (select *
                  from Md_Role_Grid_Columns g
                 where g.Company_Id = v_Company_Head
                   and g.Role_Id = r_Role.Role_Id)
      loop
        z_Md_Role_Grid_Columns.Insert_Try(i_Company_Id  => r.Company_Id,
                                          i_Role_Id     => v_Role_Id,
                                          i_Form        => q.Form,
                                          i_Grid        => q.Grid,
                                          i_Grid_Column => q.Grid_Column);
      end loop;
    
      for q in (select *
                  from Md_Role_Projects k
                 where k.Company_Id = v_Company_Head
                   and k.Role_Id = r_Role.Role_Id)
      loop
        z_Md_Role_Projects.Insert_Try(i_Company_Id   => r.Company_Id,
                                      i_Role_Id      => v_Role_Id,
                                      i_Project_Code => q.Project_Code);
      end loop;
    end loop;
  end loop;

  commit;
end;
/
