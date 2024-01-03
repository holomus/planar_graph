prompt migr from 22.03.2022

----------------------------------------------------------------------------------------------------
-- indicator and formulas
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
    r_Oper_Type     Mpr_Oper_Types%rowtype;
    v_Oper_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    begin
      select Oper_Type_Id
        into v_Oper_Type_Id
        from Hpr_Oper_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Oper_Type_Pcode;
    
      r_Oper_Type := z_Mpr_Oper_Types.Load(i_Company_Id   => v_Company_Id,
                                           i_Oper_Type_Id => v_Oper_Type_Id);
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
                           i_Corr_Coa_Id            => r_Oper_Type.Corr_Coa_Id,
                           i_Corr_Ref_Set           => r_Oper_Type.Corr_Ref_Set,
                           i_Income_Tax_Exists      => Nvl(r_Oper_Type.Income_Tax_Exists, 'N'),
                           i_Income_Tax_Rate        => r_Oper_Type.Income_Tax_Rate,
                           i_Pension_Payment_Exists => Nvl(r_Oper_Type.Pension_Payment_Exists, 'N'),
                           i_Pension_Payment_Rate   => r_Oper_Type.Pension_Payment_Rate,
                           i_Social_Payment_Exists  => Nvl(r_Oper_Type.Social_Payment_Exists, 'N'),
                           i_Social_Payment_Rate    => r_Oper_Type.Social_Payment_Rate,
                           i_Note                   => r_Oper_Type.Note,
                           i_State                  => Nvl(r_Oper_Type.State, 'A'),
                           i_Code                   => r_Oper_Type.Code);
  
    Hpr_Api.Oper_Type_Save(v_Oper_Type);
  
    update Hpr_Oper_Types q
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
  
    -- indicators
    Indicator('Количество больничных дней',
              'Кол-во больн. дней',
              'КоличествоБольничныхДней',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Sick_Leave_Days);
  
    -- Estimation Formula
    -- '(Оклад / НормаДней) * КоличествоБольничныхДней * КоэффициентБольничныхЛистов'
    v_Estimation_Formula := '(' || Identifier(Href_Pref.c_Pcode_Indicator_Wage) || ' / ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Plan_Days) || ') * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Sick_Leave_Days) || ' * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Sick_Leave_Coefficient);
  
    -- Operation group
    Operation_Group(Mpr_Pref.c_Ok_Accrual,
                    'Больничный',
                    Hpr_Pref.c_Estimation_Type_Formula,
                    v_Estimation_Formula,
                    Hpr_Pref.c_Pcode_Operation_Group_Sick_Leave);
  
    -- Oper type
    Oper_Type('Больничный (Sick Leave)',
              'Больничный (Sick Leave)',
              Hpr_Pref.c_Pcode_Operation_Group_Sick_Leave,
              Hpr_Pref.c_Estimation_Type_Formula,
              v_Estimation_Formula,
              Mpr_Pref.c_Ok_Accrual,
              Hpr_Pref.c_Pcode_Oper_Type_Sick_Leave);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
-- time kinds
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id  number;
  v_Leave_Id    number;
  v_Sick_Id     number;
  v_Trip_Id     number;
  v_Vacation_Id number;

  -------------------------------------------------- 
  Procedure Time_Kind
  (
    i_Name         varchar2,
    i_Letter_Code  varchar2,
    i_Digital_Code varchar2 := null,
    i_Parent_Pcode varchar2 := null,
    i_Plan_Load    varchar2,
    i_Requestable  varchar2,
    i_Bg_Color     varchar2 := null,
    i_Color        varchar2 := null,
    i_Pcode        varchar2
  ) is
    r_Time_Kind    Htt_Time_Kinds%rowtype;
    v_Time_Kind_Id number;
    v_Parent_Id    number;
  begin
    begin
      select *
        into r_Time_Kind
        from Htt_Time_Kinds
       where Company_Id = v_Company_Id
         and Pcode = i_Pcode;
    
      v_Time_Kind_Id := r_Time_Kind.Time_Kind_Id;
    exception
      when No_Data_Found then
        v_Time_Kind_Id := Htt_Next.Time_Kind_Id;
    end;
  
    begin
      select Time_Kind_Id
        into v_Parent_Id
        from Htt_Time_Kinds
       where Company_Id = v_Company_Id
         and Pcode = i_Parent_Pcode;
    exception
      when No_Data_Found then
        v_Parent_Id := null;
    end;
  
    z_Htt_Time_Kinds.Save_One(i_Company_Id   => v_Company_Id,
                              i_Time_Kind_Id => v_Time_Kind_Id,
                              i_Name         => Nvl(r_Time_Kind.Name, i_Name),
                              i_Letter_Code  => Nvl(r_Time_Kind.Letter_Code, i_Letter_Code),
                              i_Digital_Code => Nvl(r_Time_Kind.Digital_Code, i_Digital_Code),
                              i_Parent_Id    => v_Parent_Id,
                              i_Plan_Load    => i_Plan_Load,
                              i_Requestable  => i_Requestable,
                              i_Bg_Color     => Nvl(r_Time_Kind.Bg_Color, i_Bg_Color),
                              i_Color        => Nvl(r_Time_Kind.Color, i_Color),
                              i_State        => 'A',
                              i_Pcode        => i_Pcode);
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
    -- time kinds
    Time_Kind('Больничный',
              'Б',
              null,
              null,
              'P',
              'N',
              '#26C281',
              '#fff',
              Htt_Pref.c_Pcode_Time_Kind_Sick);
    Time_Kind('Командировка',
              'К',
              null,
              null,
              'P',
              'N',
              '#BCAAA4',
              '#000',
              Htt_Pref.c_Pcode_Time_Kind_Trip);
    Time_Kind('Отпуск',
              'ОТ',
              null,
              null,
              'P',
              'N',
              '#FF9800',
              '#fff',
              Htt_Pref.c_Pcode_Time_Kind_Vacation);
  
    v_Leave_Id    := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Leave);
    v_Sick_Id     := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Sick);
    v_Trip_Id     := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Trip);
    v_Vacation_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Vacation);
  
    update Htt_Time_Kinds Tk
       set Tk.Parent_Id = v_Leave_Id
     where Tk.Company_Id = v_Company_Id
       and Tk.Parent_Id in (v_Sick_Id, v_Trip_Id, v_Vacation_Id);
  
    update Htt_Request_Kinds Rk
       set Rk.Time_Kind_Id = v_Leave_Id
     where Rk.Company_Id = v_Company_Id
       and Rk.Time_Kind_Id in (v_Sick_Id, v_Trip_Id, v_Vacation_Id);
  
    update Htt_Timesheet_Facts Tf
       set Tf.Time_Kind_Id = v_Leave_Id
     where Tf.Company_Id = v_Company_Id
       and Tf.Time_Kind_Id in (v_Sick_Id, v_Trip_Id, v_Vacation_Id);
  
    for r in (select distinct Tf.Filial_Id, Tf.Timebook_Id, Tf.Staff_Id
                from Hpr_Timebook_Facts Tf
               where Tf.Company_Id = v_Company_Id
                 and Tf.Time_Kind_Id in (v_Sick_Id, v_Trip_Id, v_Vacation_Id))
    loop
      Hpr_Core.Regen_Timebook_Facts(i_Company_Id  => v_Company_Id,
                                    i_Filial_Id   => r.Filial_Id,
                                    i_Timebook_Id => r.Timebook_Id,
                                    i_Staff_Id    => r.Staff_Id);
    end loop;
  
    commit;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
-- timeoff facts insert
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id  number;
  v_Filial_Id   number;
  v_Filial_Head number;
  v_User_System number;

begin
  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Company_Id  := Cmp.Company_Id;
    v_Filial_Head := Md_Pref.Filial_Head(Cmp.Company_Id);
    v_User_System := Md_Pref.User_System(Cmp.Company_Id);
  
    for Fil in (select p.Filial_Id
                  from Md_Filials p
                 where p.Company_Id = Cmp.Company_Id
                   and p.Filial_Id <> v_Filial_Head
                   and p.State = 'A')
    loop
      v_Filial_Id := Fil.Filial_Id;
    
      Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                           i_Filial_Id    => v_Filial_Id,
                           i_User_Id      => v_User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      Biruni_Route.Context_Begin;
      for Tm in (select Jt.*, p.Journal_Type_Id
                   from Hpd_Journal_Timeoffs Jt
                   join Hpd_Journals p
                     on p.Company_Id = Jt.Company_Id
                    and p.Filial_Id = Jt.Filial_Id
                    and p.Journal_Id = Jt.Journal_Id
                    and p.Posted = 'Y'
                  where Jt.Company_Id = v_Company_Id
                    and Jt.Filial_Id = v_Filial_Id)
      loop
        Hpd_Core.Insert_Timeoff_Days(i_Company_Id      => Tm.Company_Id,
                                     i_Filial_Id       => Tm.Filial_Id,
                                     i_Journal_Type_Id => Tm.Journal_Type_Id,
                                     i_Timeoff_Id      => Tm.Timeoff_Id,
                                     i_Staff_Id        => Tm.Staff_Id,
                                     i_Begin_Date      => Tm.Begin_Date,
                                     i_End_Date        => Tm.End_Date);
      end loop;
      Biruni_Route.Context_End;
    
      commit;
    end loop;
  end loop;
end;
/
