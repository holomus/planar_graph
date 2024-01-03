prompt new nighttime indicator added
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
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
  end;
begin
  -- Translate
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Additional_Nighttime, 'NAME',       'ru', 'Дополнительное Ночное Время');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Additional_Nighttime, 'SHORT_NAME', 'ru', 'Дополнительное Ночное Время');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Additional_Nighttime, 'IDENTIFIER', 'ru', 'ДополнительноеНочноеВремя');

  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Additional_Nighttime, 'NAME',       'en', 'Additional Night Time');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Additional_Nighttime, 'SHORT_NAME', 'en', 'Additional Night Time');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Additional_Nighttime, 'IDENTIFIER', 'en', 'AdditionalNightTime');

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
              i_Name       => 'Дополнительное Ночное Время',
              i_Short_Name => 'Дополнительное Ночное Время',
              i_Identifier => 'ДополнительноеНочноеВремя',
              i_Used       => Href_Pref.c_Indicator_Used_Automatically,
              i_Pcode      => Href_Pref.c_Pcode_Indicator_Additional_Nighttime);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt new weighted turnout indicator added
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
  end;
begin
  -- Translate
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Weighted_Turnout, 'NAME',       'ru', 'Взвешенная Явка');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Weighted_Turnout, 'SHORT_NAME', 'ru', 'Взвешенная Явка');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Weighted_Turnout, 'IDENTIFIER', 'ru', 'ВзвешеннаяЯвка');

  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Weighted_Turnout, 'NAME',       'en', 'Weighted Turnout');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Weighted_Turnout, 'SHORT_NAME', 'en', 'Weighted Turnout');
  Uis.Table_Record_Translate('HREF_INDICATORS', Href_Pref.c_Pcode_Indicator_Weighted_Turnout, 'IDENTIFIER', 'en', 'WeightedTurnout');

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
              i_Name       => 'Взвешенное время в часах',
              i_Short_Name => 'Взвешенное время в часах',
              i_Identifier => 'ВзвешенноеВремяВЧасах',
              i_Used       => Href_Pref.c_Indicator_Used_Automatically,
              i_Pcode      => Href_Pref.c_Pcode_Indicator_Weighted_Turnout);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt nighttime and weighted turnout opertype added
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id         number;
  v_Estimation_Formula varchar2(300 char);

  --------------------------------------------------
  Procedure Oper_Type
  (
    i_Name               varchar2,
    i_Short_Name         varchar2,
    i_Oper_Group_Pcode   varchar2,
    i_Estimation_Type    varchar2,
    i_Estimation_Formula varchar2,
    i_Operation_Kind     varchar2,
    i_Oper_Type_Pcode    varchar2
  ) is
    v_Oper_Type     Hpr_Pref.Oper_Type_Rt;
    v_Oper_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    begin
      select Oper_Type_Id
        into v_Oper_Type_Id
        from Mpr_Oper_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Oper_Type_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Type_Id := Mpr_Next.Oper_Type_Id;
    end;
  
    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = v_Company_Id
       and Pcode = i_Oper_Group_Pcode;
  
    Hpr_Util.Oper_Type_New(o_Oper_Type              => v_Oper_Type,
                           i_Company_Id             => v_Company_Id,
                           i_Oper_Type_Id           => v_Oper_Type_Id,
                           i_Oper_Group_Id          => v_Oper_Group_Id,
                           i_Estimation_Type        => i_Estimation_Type,
                           i_Estimation_Formula     => i_Estimation_Formula,
                           i_Operation_Kind         => i_Operation_Kind,
                           i_Name                   => i_Name,
                           i_Short_Name             => i_Short_Name,
                           i_Accounting_Type        => Mpr_Pref.c_At_Employee,
                           i_Corr_Coa_Id            => null,
                           i_Corr_Ref_Set           => null,
                           i_Income_Tax_Exists      => 'N',
                           i_Income_Tax_Rate        => null,
                           i_Pension_Payment_Exists => 'N',
                           i_Pension_Payment_Rate   => null,
                           i_Social_Payment_Exists  => 'N',
                           i_Social_Payment_Rate    => null,
                           i_Note                   => null,
                           i_State                  => 'A',
                           i_Code                   => null);
  
    Hpr_Api.Oper_Type_Save(v_Oper_Type);
  
    update Mpr_Oper_Types q
       set q.Pcode = i_Oper_Type_Pcode
     where q.Company_Id = v_Company_Id
       and q.Oper_Type_Id = v_Oper_Type_Id;
  end;

  --------------------------------------------------
  Function Identifier(i_Pcode varchar2) return varchar2 is
    result Href_Indicators.Identifier%type;
  begin
    select Identifier
      into result
      from Href_Indicators
     where Company_Id = v_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

begin

  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Company_Id := Cmp.Company_Id;
  
    Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(v_Company_Id),
                         i_User_Id      => Md_Pref.User_System(v_Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    -- nighttime oper type
    v_Estimation_Formula := Identifier(Href_Pref.c_Pcode_Indicator_Hourly_Wage) || ' * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Additional_Nighttime);
  
    Oper_Type('Дополнительная оплата труда в ночное время',
              'Ночная',
              Hpr_Pref.c_Pcode_Operation_Group_Overtime,
              Hpr_Pref.c_Estimation_Type_Formula,
              v_Estimation_Formula,
              Mpr_Pref.c_Ok_Accrual,
              Hpr_Pref.c_Pcode_Oper_Type_Nighttime);
  
    -- weighted turnout oper type
    v_Estimation_Formula := Identifier(Href_Pref.c_Pcode_Indicator_Wage) || ' * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Rate) || ' * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Weighted_Turnout) || ' / ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Plan_Hours);
  
    Oper_Type('Взвешенная оплата труда (за отработанные часы)',
              'Взвешенная помесячная (за отработанные часы)',
              Hpr_Pref.c_Pcode_Operation_Group_Wage,
              Hpr_Pref.c_Estimation_Type_Formula,
              v_Estimation_Formula,
              Mpr_Pref.c_Ok_Accrual,
              Hpr_Pref.c_Pcode_Oper_Type_Weighted_Turnout);
  
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------  
prompt add default Sign Process
----------------------------------------------------------------------------------------------------                                  
declare
  Procedure Save_Process
  (
    i_Company_Id number,
    i_Name       varchar2,
    i_Order_No   number,
    i_State      varchar2,
    i_Pcode      varchar2
  ) is
    v_Process_Id number;
  begin
    begin
      select Process_Id
        into v_Process_Id
        from Mdf_Sign_Processes
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Process_Id := Mdf_Next.Process_Id;
    end;
  
    z_Mdf_Sign_Processes.Save_One(i_Company_Id   => i_Company_Id,
                                  i_Process_Id   => v_Process_Id,
                                  i_Project_Code => Href_Pref.c_Pc_Verifix_Hr,
                                  i_Source_Table => Zt.Hpd_Journals.Name,
                                  i_Name         => i_Name,
                                  i_Order_No     => i_Order_No,
                                  i_State        => i_State,
                                  i_Pcode        => i_Pcode);
  end;
begin
  for r in (select *
              from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Save_Process(r.Company_Id,
                 'ЭДО для кадровых документов',
                 1,
                 'A',
                 Hpd_Pref.c_Pcode_Journal_Sign_Processes);
  end loop;
  
  commit;
end;
/

---------------------------------------------------------------------------------------------------- 
prompt add default value
---------------------------------------------------------------------------------------------------- 
declare
  v_Base_Currency_Id number;
begin
  for Com in (select *
                from Md_Companies)
  loop
    for Fil in (select *
                  from Md_Filials q
                 where q.Company_Id = Com.Company_Id)
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Fil.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => Md_Pref.User_System(Fil.Company_Id),
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      v_Base_Currency_Id := z_Mk_Base_Currencies.Take(i_Company_Id => Fil.Company_Id, i_Filial_Id => Fil.Filial_Id).Currency_Id;
    
      if v_Base_Currency_Id is not null then
        update Hrm_Robots q
           set q.Currency_Id = v_Base_Currency_Id
         where q.Company_Id = Fil.Company_Id
           and q.Filial_Id = Fil.Filial_Id
           and exists (select 1
                  from Hrm_Robot_Oper_Types w
                 where w.Company_Id = Fil.Company_Id
                   and w.Filial_Id = Fil.Filial_Id
                   and w.Robot_Id = q.Robot_Id);
      end if;
    end loop;
  end loop;
  
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt adding job forms to HR Role
----------------------------------------------------------------------------------------------------
declare
  v_Hr_Role_Pcode varchar2(100) := Href_Pref.c_Pcode_Role_Hr;
  v_Hr_Role_Id    number;
  v_Form_Job_Add  varchar2(200) := '/vhr/hrm/job+add';
  v_Form_Job_Edit varchar2(200) := '/vhr/hrm/job+edit';
  v_Form_Job_List varchar2(200) := '/vhr/hrm/job_list';
  v_Form_Job_View varchar2(200) := '/vhr/hrm/job_view';
begin
  for r in (select *
              from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Biruni_Route.Context_Begin;
  
    v_Hr_Role_Id := Md_Util.Role_Id(i_Company_Id => r.Company_Id, i_Pcode => v_Hr_Role_Pcode);
  
    --------------------------------------------------
    -- job+add
    --------------------------------------------------
    Md_Api.Form_Grant(i_Company_Id => r.Company_Id,
                      i_Role_Id    => v_Hr_Role_Id,
                      i_Form       => v_Form_Job_Add);
  
    for a in (select *
                from Md_Form_Actions t
               where t.Form = v_Form_Job_Add
                 and t.Action_Kind = 'A')
    loop
      Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                               i_Role_Id    => v_Hr_Role_Id,
                               i_Form       => v_Form_Job_Add,
                               i_Action_Key => a.Action_Key);
    end loop;
  
    --------------------------------------------------
    -- job+edit
    --------------------------------------------------
    Md_Api.Form_Grant(i_Company_Id => r.Company_Id,
                      i_Role_Id    => v_Hr_Role_Id,
                      i_Form       => v_Form_Job_Edit);
  
    for a in (select *
                from Md_Form_Actions t
               where t.Form = v_Form_Job_Edit
                 and t.Action_Kind = 'A')
    loop
      Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                               i_Role_Id    => v_Hr_Role_Id,
                               i_Form       => v_Form_Job_Edit,
                               i_Action_Key => a.Action_Key);
    end loop;
  
    --------------------------------------------------
    -- job_list
    --------------------------------------------------
    Md_Api.Form_Grant(i_Company_Id => r.Company_Id,
                      i_Role_Id    => v_Hr_Role_Id,
                      i_Form       => v_Form_Job_List);
  
    for a in (select *
                from Md_Form_Actions t
               where t.Form = v_Form_Job_List
                 and t.Action_Kind = 'A')
    loop
      Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                               i_Role_Id    => v_Hr_Role_Id,
                               i_Form       => v_Form_Job_List,
                               i_Action_Key => a.Action_Key);
    end loop;
  
    --------------------------------------------------
    -- job_view
    -------------------------------------------------- 
    Md_Api.Form_Grant(i_Company_Id => r.Company_Id,
                      i_Role_Id    => v_Hr_Role_Id,
                      i_Form       => v_Form_Job_View);
  
    for a in (select *
                from Md_Form_Actions t
               where t.Form = v_Form_Job_View
                 and t.Action_Kind = 'A')
    loop
      Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                               i_Role_Id    => v_Hr_Role_Id,
                               i_Form       => v_Form_Job_View,
                               i_Action_Key => a.Action_Key);
    end loop;
  
    Biruni_Route.Context_End;
  end loop;
  
  commit;
end;
/

----------------------------------------------------------------------------------------------------
drop package Ui_Vhr621;

