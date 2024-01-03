prompt migr from 23.08.2022 after start dml
----------------------------------------------------------------------------------------------------
prompt removing empty transactions
----------------------------------------------------------------------------------------------------
declare
begin
  delete Hpd_Agreements p
   where p.Trans_Type = Hpd_Pref.c_Transaction_Type_Operation
     and not exists (select 1
            from Hpd_Trans_Oper_Types Ot
           where Ot.Company_Id = p.Company_Id
             and Ot.Filial_Id = p.Filial_Id
             and Ot.Trans_Id = p.Trans_Id);

  delete Hpd_Transactions p
   where p.Trans_Type = Hpd_Pref.c_Transaction_Type_Operation
     and not exists (select 1
            from Hpd_Trans_Oper_Types Ot
           where Ot.Company_Id = p.Company_Id
             and Ot.Filial_Id = p.Filial_Id
             and Ot.Trans_Id = p.Trans_Id);

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt adding default request kinds
----------------------------------------------------------------------------------------------------
declare
  -------------------------------------------------- 
  Procedure Request_Kind
  (
    i_Company_Id               number,
    i_Name                     varchar2,
    i_Time_Kind_Pcode          varchar2,
    i_Annually_Limited         varchar2,
    i_Day_Count_Type           varchar2,
    i_Annual_Day_Limit         number := null,
    i_User_Permitted           varchar2,
    i_Allow_Unused_Time        varchar2,
    i_Request_Restriction_Days number := null,
    i_Pcode                    varchar2
  ) is
    v_Request_Kind_Id number;
    v_Time_Kind_Id    number;
  begin
    begin
      select q.Request_Kind_Id
        into v_Request_Kind_Id
        from Htt_Request_Kinds q
       where q.Company_Id = i_Company_Id
         and q.Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Request_Kind_Id := Htt_Next.Request_Kind_Id;
    end;
  
    select q.Time_Kind_Id
      into v_Time_Kind_Id
      from Htt_Time_Kinds q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Time_Kind_Pcode;
  
    z_Htt_Request_Kinds.Save_One(i_Company_Id               => i_Company_Id,
                                 i_Request_Kind_Id          => v_Request_Kind_Id,
                                 i_Name                     => i_Name,
                                 i_Time_Kind_Id             => v_Time_Kind_Id,
                                 i_Annually_Limited         => i_Annually_Limited,
                                 i_Day_Count_Type           => i_Day_Count_Type,
                                 i_Annual_Day_Limit         => i_Annual_Day_Limit,
                                 i_User_Permitted           => i_User_Permitted,
                                 i_Allow_Unused_Time        => i_Allow_Unused_Time,
                                 i_Request_Restriction_Days => i_Request_Restriction_Days,
                                 i_State                    => 'A',
                                 i_Pcode                    => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Table_Record_Setting
  (
    i_Table_Name  varchar2,
    i_Column_Set  varchar2,
    i_Extra_Where varchar2 := null
  ) is
  begin
    z_Md_Table_Record_Translate_Settings.Save_One(i_Table_Name  => i_Table_Name,
                                                  i_Column_Set  => i_Column_Set,
                                                  i_Extra_Where => i_Extra_Where);
  end;
begin
  for r in (select p.Company_Id
              from Md_Companies p)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    -- adding request kinds
    Request_Kind(r.Company_Id,
                 'Больничный',
                 Htt_Pref.c_Pcode_Time_Kind_Sick,
                 'N',
                 Htt_Pref.c_Day_Count_Type_Work_Days,
                 null,
                 'Y',
                 'N',
                 null,
                 Htt_Pref.c_Pcode_Request_Kind_Sick_Leave);
    Request_Kind(r.Company_Id,
                 'Отпуск',
                 Htt_Pref.c_Pcode_Time_Kind_Vacation,
                 'N',
                 Htt_Pref.c_Day_Count_Type_Production_Days,
                 null,
                 'Y',
                 'N',
                 null,
                 Htt_Pref.c_Pcode_Request_Kind_Vacation);
    Request_Kind(r.Company_Id,
                 'Командировка',
                 Htt_Pref.c_Pcode_Time_Kind_Trip,
                 'N',
                 Htt_Pref.c_Day_Count_Type_Calendar_Days,
                 null,
                 'Y',
                 'N',
                 null,
                 Htt_Pref.c_Pcode_Request_Kind_Trip);
    Request_Kind(r.Company_Id,
                 'Отгул',
                 Htt_Pref.c_Pcode_Time_Kind_Leave,
                 'N',
                 Htt_Pref.c_Day_Count_Type_Work_Days,
                 null,
                 'Y',
                 'N',
                 null,
                 Htt_Pref.c_Pcode_Request_Kind_Leave);
    Request_Kind(r.Company_Id,
                 'Рабочая Встреча',
                 Htt_Pref.c_Pcode_Time_Kind_Meeting,
                 'N',
                 Htt_Pref.c_Day_Count_Type_Work_Days,
                 null,
                 'Y',
                 'N',
                 null,
                 Htt_Pref.c_Pcode_Request_Kind_Meeting);
  end loop;
  
  -- table translates             
  Table_Record_Setting('HTT_TIME_KINDS', 'NAME,LETTER_CODE', 'PCODE IS NOT NULL');
  Table_Record_Setting('HTT_REQUEST_KINDS', 'NAME', 'PCODE IS NOT NULL');

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt migr created user for employees and attached to filials
----------------------------------------------------------------------------------------------------
declare
  v_User_Ids Array_Number;
begin
  Biruni_Route.Clear_Globals;

  for Cmp in (select c.Company_Id,
                     (select Ci.Filial_Head
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as Filial_Head,
                     (select Ci.User_System
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as User_System
                from Md_Companies c
               where exists (select 1
                        from Md_Company_Projects p
                       where p.Company_Id = c.Company_Id
                         and p.Project_Code = Href_Pref.c_Pc_Verifix_Hr))
  loop
    Ui_Context.Init(i_User_Id      => Cmp.User_System,
                    i_Project_Code => Href_Pref.c_Pc_Verifix_Hr,
                    i_Filial_Id    => Cmp.Filial_Head);
  
    select e.Employee_Id
      bulk collect
      into v_User_Ids
      from Mhr_Employees e
     where e.Company_Id = Cmp.Company_Id
       and not exists (select 1
              from Md_Users u
             where u.Company_Id = Cmp.Company_Id
               and u.User_Id = e.Employee_Id)
     group by e.Employee_Id;
  
    insert into Md_Users
      (Company_Id,
       User_Id,
       name,
       State,
       User_Kind,
       Gender,
       Created_By,
       Created_On,
       Modified_By,
       Modified_On)
      select Np.Company_Id,
             Np.Person_Id as User_Id,
             Np.Name,
             'A' as State,
             Md_Pref.c_Uk_Normal as User_Kind,
             Np.Gender,
             Cmp.User_System as Created_By,
             Current_Timestamp as Created_On,
             Cmp.User_System as Modified_By,
             Current_Timestamp as Modified_On
        from Mr_Natural_Persons Np
       where Np.Company_Id = Cmp.Company_Id
         and Np.Person_Id in (select *
                                from table(v_User_Ids));
  
    insert into Md_User_Filials
      (Company_Id, User_Id, Filial_Id)
      select e.Company_Id, e.Employee_Id as User_Id, e.Filial_Id
        from Mhr_Employees e
       where e.Company_Id = Cmp.Company_Id
         and not exists (select 1
                from Md_User_Filials Uf
               where Uf.Company_Id = Cmp.Company_Id
                 and Uf.Filial_Id = e.Filial_Id
                 and Uf.User_Id = e.Employee_Id);
  
    commit;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
declare
  Procedure Fte
  (
    i_Company_Id number,
    i_Name       varchar2,
    i_Fte_Value  number,
    i_Order_No   number,
    i_Pcode      varchar2
  ) is
    v_Fte_Id number;
  begin
    begin
      select Fte_Id
        into v_Fte_Id
        from Href_Ftes
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Fte_Id := Href_Next.Fte_Id;
    end;
  
    z_Href_Ftes.Save_One(i_Company_Id => i_Company_Id,
                        i_Fte_Id     => v_Fte_Id,
                        i_Name       => i_Name,
                        i_Fte_Value  => i_Fte_Value,
                        i_Order_No   => i_Order_No,
                        i_Pcode      => i_Pcode);
  end;

begin
  for x in (select q.Company_Id
              from Md_Companies q)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => x.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(x.Company_Id),
                         i_User_Id      => Md_Pref.User_System(x.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Fte(x.Company_Id, 'Full time', 1, 1, Href_Pref.c_Pcode_Fte_Full_Time);
    Fte(x.Company_Id, 'Part time', 0.5, 2, Href_Pref.c_Pcode_Fte_Part_Time);
    Fte(x.Company_Id, 'Quarter time', 0.25, 3, Href_Pref.c_Pcode_Fte_Quarter_Time);
  end loop;

  z_Md_Table_Record_Translate_Settings.Insert_Try(i_Table_Name  => 'HREF_FTES',
                                                  i_Column_Set  => 'NAME',
                                                  i_Extra_Where => 'PCODE IS NOT NULL');

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt adding overtime oper type
---------------------------------------------------------------------------------------------------- 
declare
  v_Company_Id         number;
  v_Estimation_Formula varchar2(300 char);
  v_Identifier         Href_Indicators.Identifier%type;

  --------------------------------------------------
  Procedure Indicator
  (
    i_Name       varchar2,
    i_Short_Name varchar2,
    i_Identifier varchar2,
    i_Used       varchar2,
    i_Pcode      varchar2
  ) is
    v_Indicator_Id number;
  begin
    begin
      select Indicator_Id
        into v_Indicator_Id
        from Href_Indicators
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Indicator_Id := Href_Next.Indicator_Id;
    end;
  
    z_Href_Indicators.Save_One(i_Company_Id   => v_Company_Id,
                               i_Indicator_Id => v_Indicator_Id,
                               i_Name         => i_Name,
                               i_Short_Name   => i_Short_Name,
                               i_Identifier   => i_Identifier,
                               i_Used         => i_Used,
                               i_State        => 'A',
                               i_Pcode        => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Operation_Group
  (
    i_Operation_Kind     varchar2,
    i_Name               varchar2,
    i_Estimation_Type    varchar2,
    i_Estimation_Formula varchar2,
    i_Pcode              varchar2
  ) is
    v_Oper_Group_Id number;
  begin
    begin
      select Oper_Group_Id
        into v_Oper_Group_Id
        from Hpr_Oper_Groups
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Group_Id := Hpr_Next.Oper_Group_Id;
    end;
  
    z_Hpr_Oper_Groups.Save_One(i_Company_Id         => v_Company_Id,
                               i_Oper_Group_Id      => v_Oper_Group_Id,
                               i_Operation_Kind     => i_Operation_Kind,
                               i_Name               => i_Name,
                               i_Estimation_Type    => i_Estimation_Type,
                               i_Estimation_Formula => i_Estimation_Formula,
                               i_Pcode              => i_Pcode);
  end;

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
        from Hpr_Oper_Types
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
  
    update Hpr_Oper_Types q
       set q.Pcode = i_Oper_Type_Pcode
     where q.Company_Id = v_Company_Id
       and q.Oper_Type_Id = v_Oper_Type_Id;
  end;

  --------------------------------------------------
  Procedure Book_Type
  (
    i_Name  varchar2,
    i_Pcode varchar2
  ) is
    v_Book_Type_Id number;
  begin
    begin
      select Book_Type_Id
        into v_Book_Type_Id
        from Hpr_Book_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Book_Type_Id := Hpr_Next.Book_Type_Id;
    end;
  
    z_Hpr_Book_Types.Save_One(i_Company_Id   => v_Company_Id,
                              i_Book_Type_Id => v_Book_Type_Id,
                              i_Name         => i_Name,
                              i_Pcode        => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Book_Type_Bind
  (
    i_Book_Type_Pcode  varchar2,
    i_Oper_Group_Pcode varchar2
  ) is
    v_Book_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    select Book_Type_Id
      into v_Book_Type_Id
      from Hpr_Book_Types
     where Company_Id = v_Company_Id
       and Pcode = i_Book_Type_Pcode;
  
    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = v_Company_Id
       and Pcode = i_Oper_Group_Pcode;
  
    z_Hpr_Book_Type_Binds.Insert_Try(i_Company_Id    => v_Company_Id,
                                     i_Book_Type_Id  => v_Book_Type_Id,
                                     i_Oper_Group_Id => v_Oper_Group_Id);
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

  --------------------------------------------------
  Procedure Journal_Type
  (
    i_Name     varchar2,
    i_Order_No number,
    i_Pcode    varchar2
  ) is
    v_Journal_Type_Id number;
  begin
    begin
      select Journal_Type_Id
        into v_Journal_Type_Id
        from Hpd_Journal_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    end;
  
    z_Hpd_Journal_Types.Save_One(i_Company_Id      => v_Company_Id,
                                 i_Journal_Type_Id => v_Journal_Type_Id,
                                 i_Name            => i_Name,
                                 i_Order_No        => i_Order_No,
                                 i_Pcode           => i_Pcode);
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
  
    -- indicators
    Indicator('Средний часовой оклад',
              'Сред. час. оклад',
              'СреднеЧасовойОклад',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Hourly_Wage);
    Indicator('Коэффициент сверхурочного времени',
              'Коэф. сверх. времени',
              'КоэффициентСверхурочногоВремени',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Overtime_Coef);
    Indicator('Cверхурочные часы',
              'Сверх. часы',
              'СверхурочныеЧасы',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Overtime_Hours);
  
    -- Estimation Formula
    -- 'СреднеЧасовойОклад * КоэффициентСверхурочногоВремени * СверхурочныеЧасы'
    v_Estimation_Formula := Identifier(Href_Pref.c_Pcode_Indicator_Hourly_Wage) || ' * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Overtime_Coef) || ' * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Overtime_Hours);
  
    -- Operation group
    Operation_Group(Mpr_Pref.c_Ok_Accrual,
                    'Сверхурочная оплата труда',
                    Hpr_Pref.c_Estimation_Type_Formula,
                    v_Estimation_Formula,
                    Hpr_Pref.c_Pcode_Operation_Group_Overtime);
  
    -- Oper type
    Oper_Type('Сверхурочная оплата труда',
              'Сверхурочные',
              Hpr_Pref.c_Pcode_Operation_Group_Overtime,
              Hpr_Pref.c_Estimation_Type_Formula,
              v_Estimation_Formula,
              Mpr_Pref.c_Ok_Accrual,
              Hpr_Pref.c_Pcode_Oper_Type_Overtime);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
update Hpd_Page_Robots r
   set r.Fte_Id =
       (select f.Fte_Id
          from Href_Ftes f
         where f.Company_Id = r.Company_Id
           and f.Fte_Value = r.Fte
           and Rownum = 1);
commit;

update Hpd_Trans_Robots p
   set p.Fte_Id =
       (select w.Fte_Id
          from Hpd_Transactions q
          join Hpd_Page_Robots w
            on w.Company_Id = q.Company_Id
           and w.Filial_Id = q.Filial_Id
           and w.Page_Id = q.Page_Id
         where q.Company_Id = p.Company_Id
           and q.Filial_Id = p.Filial_Id
           and q.Trans_Id = p.Trans_Id);
commit;
