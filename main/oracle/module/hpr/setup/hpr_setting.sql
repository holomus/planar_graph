set define off
set serveroutput on
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
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
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Group_Id := Hpr_Next.Oper_Group_Id;
    end;
  
    z_Hpr_Oper_Groups.Save_One(i_Company_Id         => v_Company_Head,
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
        from Mpr_Oper_Types
       where Company_Id = v_Company_Head
         and Pcode = i_Oper_Type_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Type_Id := Mpr_Next.Oper_Type_Id;
    end;
  
    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = v_Company_Head
       and Pcode = i_Oper_Group_Pcode;
  
    Hpr_Util.Oper_Type_New(o_Oper_Type              => v_Oper_Type,
                           i_Company_Id             => v_Company_Head,
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
     where q.Company_Id = v_Company_Head
       and q.Oper_Type_Id = v_Oper_Type_Id;
  end;

  --------------------------------------------------
  Procedure Book_Type
  (
    i_Name     varchar2,
    i_Pcode    varchar2,
    i_Order_No number
  ) is
    v_Book_Type_Id number;
  begin
    begin
      select Book_Type_Id
        into v_Book_Type_Id
        from Hpr_Book_Types
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Book_Type_Id := Hpr_Next.Book_Type_Id;
    end;
  
    z_Hpr_Book_Types.Save_One(i_Company_Id   => v_Company_Head,
                              i_Book_Type_Id => v_Book_Type_Id,
                              i_Name         => i_Name,
                              i_Order_No     => i_Order_No,
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
     where Company_Id = v_Company_Head
       and Pcode = i_Book_Type_Pcode;

    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = v_Company_Head
       and Pcode = i_Oper_Group_Pcode;
  
    z_Hpr_Book_Type_Binds.Insert_Try(i_Company_Id    => v_Company_Head,
                                     i_Book_Type_Id  => v_Book_Type_Id,
                                     i_Oper_Group_Id => v_Oper_Group_Id);
  end;

  --------------------------------------------------
  Procedure Table_Record_Setting
  (
    i_Table_Name  varchar2,
    i_Column_Set  varchar2,
    i_Extra_Where varchar2 := null
  ) is
  begin
    z_Md_Table_Record_Translate_Settings.Insert_Try(i_Table_Name  => i_Table_Name,
                                                    i_Column_Set  => i_Column_Set,
                                                    i_Extra_Where => i_Extra_Where);
  end;
begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Operation groups ====');
  Operation_Group(Mpr_Pref.c_Ok_Accrual, 'Повременная оплата труда и надбавки', Hpr_Pref.c_Estimation_Type_Formula, 'Оклад * ДоляНеполногоРабочегоВремени * ВремяВДнях / НормаДней', Hpr_Pref.c_Pcode_Operation_Group_Wage);
  Operation_Group(Mpr_Pref.c_Ok_Accrual, 'Бонус за эффективность', Hpr_Pref.c_Estimation_Type_Formula, 'БонусЗаЭффективность + ДополнительныйБонусЗаЭффективность', Hpr_Pref.c_Pcode_Operation_Group_Perf);
  Operation_Group(Mpr_Pref.c_Ok_Accrual, 'Больничные', Hpr_Pref.c_Estimation_Type_Formula, '(Оклад / НормаДней) * КоличествоБольничныхДней * КоэффициентБольничныхЛистов', Hpr_Pref.c_Pcode_Operation_Group_Sick_Leave);
  Operation_Group(Mpr_pref.c_Ok_Accrual, 'Командировочные', Hpr_pref.c_Estimation_Type_Formula, '(Оклад / НормаДней) * КоличествоДней', Hpr_pref.c_Pcode_Operation_Group_Business_Trip);
  Operation_Group(Mpr_pref.c_Ok_Accrual, 'Отпускные', Hpr_pref.c_Estimation_Type_Formula, '(Оклад / СреднемесячноеКоличествоРабочихДней) * КоличествоДнейОтпуска', Hpr_Pref.c_Pcode_Operation_Group_Vacation);
  Operation_Group(Mpr_pref.c_Ok_Accrual, 'Сверхурочная оплата труда', Hpr_pref.c_Estimation_Type_Formula, 'СреднеЧасовойОклад * КоэффициентСверхурочногоВремени * СверхурочныеЧасы', Hpr_Pref.c_Pcode_Operation_Group_Overtime);
  Operation_Group(Mpr_pref.c_Ok_Deduction, 'Штрафы за нарушение дисциплины', Hpr_pref.c_Estimation_Type_Formula, 'ШтрафЗаОпоздание + ШтрафЗаРаннийУход + ШтрафЗаОтсутствие + ШтрафЗаПропускДня + ШтрафЗаПропускОтметки', Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline);
  Operation_Group(Mpr_Pref.c_Ok_Deduction, 'Штраф за неэффективность', Hpr_Pref.c_Estimation_Type_Formula, 'ШтрафЗаНеэффективность + ДополнительныйШтрафЗаНеэффективность', Hpr_Pref.c_Pcode_Operation_Group_Perf_Penalty);
  Operation_Group(Mpr_Pref.c_Ok_Accrual, 'Повременная оплата труда и надбавки (без штрафов)', Hpr_Pref.c_Estimation_Type_Formula, 'Оклад', Hpr_Pref.c_Pcode_Operation_Group_Wage_No_Deduction);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Oper Types ====');
  Oper_Type('Больничные',
            'Больничные',
            Hpr_Pref.c_Pcode_Operation_Group_Sick_Leave,
            Hpr_Pref.c_Estimation_Type_Formula,
            '(Оклад / НормаДней) * КоличествоБольничныхДней * КоэффициентБольничныхЛистов',
            Mpr_Pref.c_Ok_Accrual,
            Hpr_Pref.c_Pcode_Oper_Type_Sick_Leave);
  Oper_Type('Командировочные',
            'Командировочные',
            Hpr_Pref.c_Pcode_Operation_Group_Business_Trip,
            Hpr_Pref.c_Estimation_Type_Formula,
            '(Оклад / НормаДней) * КоличествоДней',
            Mpr_Pref.c_Ok_Accrual,
            Hpr_Pref.c_Pcode_Oper_Type_Business_Trip);
  Oper_Type('Отпускные',
            'Отпускные',
            Hpr_Pref.c_Pcode_Operation_Group_Vacation,
            Hpr_Pref.c_Estimation_Type_Formula,
            '(Оклад / СреднемесячноеКоличествоРабочихДней) * КоличествоДнейОтпуска',
            Mpr_Pref.c_Ok_Accrual,
            Hpr_Pref.c_Pcode_Oper_Type_Vacation);
  Oper_Type('Почасовая оплата труда',
            'Почасовая',
            Hpr_Pref.c_Pcode_Operation_Group_Wage,
            Hpr_Pref.c_Estimation_Type_Formula,
            'Оклад * ДоляНеполногоРабочегоВремени * ВремяВЧасах',
            Mpr_Pref.c_Ok_Accrual,
            Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly);
  Oper_Type('Поденная оплата труда',
            'Поденная',
            Hpr_Pref.c_Pcode_Operation_Group_Wage,
            Hpr_Pref.c_Estimation_Type_Formula,
            'Оклад * ДоляНеполногоРабочегоВремени * ВремяВДнях',
            Mpr_Pref.c_Ok_Accrual,
            Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily);          
  Oper_Type('Помесячная оплата труда',
            'Помесячная',
            Hpr_Pref.c_Pcode_Operation_Group_Wage,
            Hpr_Pref.c_Estimation_Type_Formula,
            'Оклад * ДоляНеполногоРабочегоВремени * ВремяВДнях / НормаДней',
            Mpr_Pref.c_Ok_Accrual,
            Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly);
  Oper_Type('Сверхурочная оплата труда',
            'Сверхурочные',
            Hpr_Pref.c_Pcode_Operation_Group_Overtime,
            Hpr_Pref.c_Estimation_Type_Formula,
            'СреднеЧасовойОклад * КоэффициентСверхурочногоВремени * СверхурочныеЧасы',
            Mpr_Pref.c_Ok_Accrual,
            Hpr_Pref.c_Pcode_Oper_Type_Overtime);
  Oper_Type('Дополнительная оплата труда в ночное время',
            'Ночная',
            Hpr_Pref.c_Pcode_Operation_Group_Overtime,
            Hpr_Pref.c_Estimation_Type_Formula,
            'СреднеЧасовойОклад * ДополнительноеНочноеВремя',
            Mpr_Pref.c_Ok_Accrual,
            Hpr_Pref.c_Pcode_Oper_Type_Nighttime);
  Oper_Type('Помесячная оплата труда (за отработанные часы)', 
            'Помесячная (за отработанные часы)', 
            Hpr_Pref.c_Pcode_Operation_Group_Wage,
            Hpr_Pref.c_Estimation_Type_Formula,
            'Оклад * ДоляНеполногоРабочегоВремени * ВремяВЧасах / НормаЧасов',
            Mpr_Pref.c_Ok_Accrual,
            Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized); 
  Oper_Type('Взвешенная оплата труда (за отработанные часы)',
            'Взвешенная помесячная (за отработанные часы)',
            Hpr_Pref.c_Pcode_Operation_Group_Wage,
            Hpr_Pref.c_Estimation_Type_Formula,
            'Оклад * ДоляНеполногоРабочегоВремени * ВзвешенноеВремяВЧасах / НормаЧасов',
            Mpr_Pref.c_Ok_Accrual,
            Hpr_Pref.c_Pcode_Oper_Type_Weighted_Turnout);        
  Oper_Type('Штрафы за нарушение дисциплины',
            'Штрафы за нарушение дисциплины',
            Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline,
            Hpr_Pref.c_Estimation_Type_Formula,
            'ШтрафЗаОпоздание + ШтрафЗаРаннийУход + ШтрафЗаОтсутствие + ШтрафЗаПропускДня + ШтрафЗаПропускОтметки',
            Mpr_Pref.c_Ok_Deduction,
            Hpr_Pref.c_Pcode_Oper_Type_Penalty_For_Discipline);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Book types ====');
  Book_Type('Начисление зарплаты и взносов', Hpr_Pref.c_Pcode_Book_Type_Wage, 1);
  Book_Type('Начисление больничных', Hpr_Pref.c_Pcode_Book_Type_Sick_Leave, 2);
  Book_Type('Начисление командировочных', Hpr_Pref.c_Pcode_Book_Type_Business_Trip, 3);
  Book_Type('Начисление отпускных', Hpr_Pref.c_Pcode_Book_Type_Vacation, 4);
  Book_Type('Начисление всех видов', Hpr_Pref.c_Pcode_Book_Type_All, 5);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Book type binds ====');
  Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Wage, Hpr_Pref.c_Pcode_Operation_Group_Wage);
  Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Wage, Hpr_Pref.c_Pcode_Operation_Group_Perf);
  Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Wage, Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline);
  Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Wage, Hpr_Pref.c_Pcode_Operation_Group_Perf_Penalty);
  Book_Type_Bind(Hpr_pref.c_Pcode_Book_Type_Wage, hpr_Pref.c_Pcode_Operation_Group_Wage_No_Deduction);
  Book_Type_Bind(Hpr_pref.c_Pcode_Book_Type_Wage, hpr_Pref.c_Pcode_Operation_Group_Overtime);
  Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Sick_Leave, Hpr_Pref.c_Pcode_Operation_Group_Sick_Leave);
  Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Business_Trip, Hpr_Pref.c_Pcode_Operation_Group_Business_Trip);
  Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Vacation, Hpr_Pref.c_Pcode_Operation_Group_Vacation);
  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translates ====');
  Table_Record_Setting('HPR_OPER_GROUPS', 'NAME');
  Table_Record_Setting('HPR_BOOK_TYPES', 'NAME');
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Easy report templates ====');
  Ker_Core.Head_Template_Save(i_Form     => Hpr_Pref.c_Easy_Report_Form_Timebook,
                              i_Name     => 'Табель',
                              i_Order_No => 1,
                              i_Pcode    => 'vhr:hpr:1');
  Ker_Core.Head_Template_Save(i_Form     => Hpr_Pref.c_Easy_Report_Form_Payroll_Book,
                              i_Name     => 'Книга начисления заработной платы',
                              i_Order_No => 2,
                              i_Pcode    => 'vhr:hpr:2');
  Ker_Core.Head_Template_Save(i_Form     => Hpr_Pref.c_Easy_Report_Form_Charge_Document,
                              i_Name     => 'Разовые начисление',
                              i_Order_No => 3,
                              i_Pcode    => 'vhr:hpr:3');
  commit;
end;
/
