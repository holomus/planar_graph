prompt migr from 20.05.2023 v2.25.0 (2.dml)
----------------------------------------------------------------------------------------------------
prompt new mark skip indicator added
----------------------------------------------------------------------------------------------------
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  v_Query        varchar2(4000);

  --------------------------------------------------
  Procedure Indicator
  (
    i_Company_Id number,
    i_Lang_Code  varchar2,
    i_Name       varchar2,
    i_Short_Name varchar2,
    i_Identifier varchar2,
    i_Used       varchar2,
    i_Pcode      varchar2
  ) is
    r_Indicator Href_Indicators%rowtype;
  begin
    begin
      select q.*
        into r_Indicator
        from Href_Indicators q
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        r_Indicator.Indicator_Id := Href_Next.Indicator_Id;
        r_Indicator.State        := 'A';
    end;
  
    r_Indicator.Company_Id := i_Company_Id;
    r_Indicator.Name       := i_Name;
    r_Indicator.Short_Name := i_Short_Name;
    r_Indicator.Identifier := i_Identifier;
    r_Indicator.Used       := i_Used;
    r_Indicator.Pcode      := i_Pcode;
  
    if i_Company_Id <> v_Company_Head then
      v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Href_Indicators,
                                                  i_Lang_Code => i_Lang_Code);
    
      execute immediate v_Query
        using in r_Indicator, out r_Indicator;
    end if;
  
    z_Href_Indicators.Save_Row(r_Indicator);
  
    for r in (select *
                from Hpr_Oper_Groups q
               where q.Company_Id = i_Company_Id
                 and q.Pcode = Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline)
    loop
      z_Hpr_Oper_Groups.Update_One(i_Company_Id         => r.Company_Id,
                                   i_Oper_Group_Id      => r.Oper_Group_Id,
                                   i_Estimation_Formula => Option_Varchar2(r.Estimation_Formula ||
                                                                           ' + ' ||
                                                                           r_Indicator.Identifier));
    
      for Oper in (select *
                     from Hpr_Oper_Types q
                    where q.Company_Id = i_Company_Id
                      and q.Oper_Group_Id = r.Oper_Group_Id
                      and q.Estimation_Type = Hpr_Pref.c_Estimation_Type_Formula)
      loop
        z_Hpr_Oper_Types.Update_One(i_Company_Id         => Oper.Company_Id,
                                    i_Oper_Type_Id       => Oper.Oper_Type_Id,
                                    i_Estimation_Formula => Option_Varchar2(Oper.Estimation_Formula ||
                                                                            ' + ' ||
                                                                            r_Indicator.Identifier));
      end loop;
    end loop;
  end;
begin
  -- Translate
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip, 'NAME',       'ru', 'Штраф за пропуск отметки');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip, 'SHORT_NAME', 'ru', 'Штраф за пропуск отметки');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip, 'IDENTIFIER', 'ru', 'ШтрафЗаПропускОтметки');
  
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip, 'NAME',       'en', 'Fine for Mark skip');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip, 'SHORT_NAME', 'en', 'Fine for Mark skip');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip, 'IDENTIFIER', 'en', 'FineForMarkSkip');
  
  -- insert indicator
  for r in (select c.Company_Id,
                   c.Lang_Code,
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
  
    Indicator(i_Company_Id => r.Company_Id,
              i_Lang_Code  => r.Lang_Code,
              i_Name       => 'Штраф за пропуск отметки',
              i_Short_Name => 'Штраф за пропуск отметки',
              i_Identifier => 'ШтрафЗаПропускОтметки',
              i_Used       => Href_Pref.c_Indicator_Used_Automatically,
              i_Pcode      => Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt insert data into Hpd_Journal_Staffs
----------------------------------------------------------------------------------------------------
insert into Hpd_Journal_Staffs
  (Company_Id, Filial_Id, Journal_Id, Staff_Id)
  select q.Company_Id, q.Filial_Id, q.Journal_Id, q.Staff_Id
    from Hpd_Journal_Pages q
   where not exists (select *
            from Hpd_Journal_Staffs s
           where s.Company_Id = q.Company_Id
             and s.Filial_Id = q.Filial_Id
             and s.Journal_Id = q.Journal_Id
             and s.Staff_Id = q.Staff_Id);
commit;

insert into Hpd_Journal_Staffs
  (Company_Id, Filial_Id, Journal_Id, Staff_Id)
  select q.Company_Id, q.Filial_Id, q.Journal_Id, q.Staff_Id
    from Hpd_Journal_Timeoffs q
   where not exists (select *
            from Hpd_Journal_Staffs s
           where s.Company_Id = q.Company_Id
             and s.Filial_Id = q.Filial_Id
             and s.Journal_Id = q.Journal_Id
             and s.Staff_Id = q.Staff_Id);
commit;

insert into Hpd_Journal_Staffs
  (Company_Id, Filial_Id, Journal_Id, Staff_Id)
  select q.Company_Id, q.Filial_Id, q.Journal_Id, q.Staff_Id
    from Hpd_Journal_Overtimes q
   where not exists (select *
            from Hpd_Journal_Staffs s
           where s.Company_Id = q.Company_Id
             and s.Filial_Id = q.Filial_Id
             and s.Journal_Id = q.Journal_Id
             and s.Staff_Id = q.Staff_Id);
commit;

----------------------------------------------------------------------------------------------------
prompt giving robots roles
----------------------------------------------------------------------------------------------------
declare
  v_Staff_Role_Id number;
begin
  for r in (select c.Company_Id,
                   c.Lang_Code,
                   (select Ci.User_System
                      from Md_Company_Infos Ci
                     where Ci.Company_Id = c.Company_Id) as User_System
              from Md_Companies c
             where c.State = 'A'
               and Md_Util.Any_Project(c.Company_Id) is not null)
  loop
    v_Staff_Role_Id := Md_Util.Role_Id(i_Company_Id => r.Company_Id,
                                       i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    continue when v_Staff_Role_Id is null;
  
    for Fl in (select *
                 from Md_Filials p
                where p.Company_Id = r.Company_Id
                  and p.State = 'A'
                  and exists (select *
                         from Hrm_Settings St
                        where St.Company_Id = p.Company_Id
                          and St.Filial_Id = p.Filial_Id
                          and St.Position_Enable = 'Y'))
    loop
      Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                           i_Filial_Id    => Fl.Filial_Id,
                           i_User_Id      => r.User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      insert into Mrf_Robot_Roles
        (Company_Id, Robot_Id, Filial_Id, Role_Id, Created_By, Created_On)
        select Rb.Company_Id,
               Rb.Robot_Id,
               Rb.Filial_Id,
               v_Staff_Role_Id,
               r.User_System,
               Current_Timestamp
          from Hrm_Robots Rb
         where Rb.Company_Id = r.Company_Id
           and Rb.Filial_Id = Fl.Filial_Id
           and not exists (select *
                  from Mrf_Robot_Persons Rp
                 where Rp.Company_Id = Rb.Company_Id
                   and Rp.Filial_Id = Rb.Filial_Id
                   and Rp.Robot_Id = Rb.Robot_Id)
           and not exists (select *
                  from Mrf_Robot_Roles Rl
                 where Rl.Company_Id = Rb.Company_Id
                   and Rl.Filial_Id = Rb.Filial_Id
                   and Rl.Robot_Id = Rb.Robot_Id
                   and Rl.Role_Id = v_Staff_Role_Id);
    
      insert into Mrf_Robot_Roles
        (Company_Id, Robot_Id, Filial_Id, Role_Id, Created_By, Created_On)
        select Rb.Company_Id,
               Rb.Robot_Id,
               Rb.Filial_Id,
               Ur.Role_Id,
               r.User_System,
               Current_Timestamp
          from Hrm_Robots Rb
          join Mrf_Robot_Persons Rp
            on Rp.Company_Id = Rb.Company_Id
           and Rp.Filial_Id = Rb.Filial_Id
           and Rp.Robot_Id = Rb.Robot_Id
          join Md_User_Roles Ur
            on Ur.Company_Id = Rp.Company_Id
           and Ur.Filial_Id = Rp.Filial_Id
           and Ur.User_Id = Rp.Person_Id
         where Rb.Company_Id = r.Company_Id
           and Rb.Filial_Id = Fl.Filial_Id
           and not exists (select *
                  from Mrf_Robot_Roles Rl
                 where Rl.Company_Id = Rb.Company_Id
                   and Rl.Filial_Id = Rb.Filial_Id
                   and Rl.Robot_Id = Rb.Robot_Id
                   and Rl.Role_Id = Ur.Role_Id)
         group by Rb.Company_Id, Rb.Filial_Id, Rb.Robot_Id, Ur.Role_Id;
    end loop;
  end loop;

  commit;
end;
/
