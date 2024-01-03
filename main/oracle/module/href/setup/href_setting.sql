set define off
set serveroutput on
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
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
  
  --------------------------------------------------
  Procedure Document_Type
  (
    a varchar2,
    b varchar2
  ) is
    v_Document_Type_Id number;
  begin
    begin
      select Doc_Type_Id
        into v_Document_Type_Id
        from Href_Document_Types
       where Company_Id = v_Company_Head
         and Pcode = b;
    exception
      when No_Data_Found then
        v_Document_Type_Id := Href_Next.Document_Type_Id;
    end;
  
    z_Href_Document_Types.Save_One(i_Company_Id  => v_Company_Head,
                                   i_Doc_Type_Id => v_Document_Type_Id,
                                   i_Name        => a,
                                   i_Is_Required => 'N',
                                   i_State       => 'A',
                                   i_Pcode       => b);
  end;
  
  --------------------------------------------------
  Procedure Indicator_Group
  (
    i_Name  varchar2,
    i_Pcode varchar2
  ) is
    v_Indicator_Group_Id number;
  begin
    begin
      select q.Indicator_Group_Id
        into v_Indicator_Group_Id
        from Href_Indicator_Groups q
       where q.Company_Id = v_Company_Head
         and q.Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Indicator_Group_Id := Href_Next.Indicator_Group_Id;
    end;
  
    z_Href_Indicator_Groups.Save_One(i_Company_Id         => v_Company_Head,
                                     i_Indicator_Group_Id => v_Indicator_Group_Id,
                                     i_Name               => i_Name,
                                     i_Pcode              => i_Pcode);
  end;
  
  --------------------------------------------------
  Procedure Indicator
  (
    i_Name                  varchar2,
    i_Short_Name            varchar2,
    i_Identifier            varchar2,
    i_Used                  varchar2,
    i_Pcode                 varchar2,
    i_Indicator_Group_Pcode varchar2
  ) is
    v_Indicator_Id       number;
    v_Indicator_Group_Id number;
  begin
    begin
      select Indicator_Id
        into v_Indicator_Id
        from Href_Indicators
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Indicator_Id := Href_Next.Indicator_Id;
    end;
    
    select Indicator_Group_Id
      into v_Indicator_Group_Id
      from Href_Indicator_Groups
     where Company_Id = v_Company_Head
       and Pcode = i_Indicator_Group_Pcode;
  
    z_Href_Indicators.Save_One(i_Company_Id         => v_Company_Head,
                               i_Indicator_Id       => v_Indicator_Id,
                               i_Indicator_Group_Id => v_Indicator_Group_Id,
                               i_Name               => i_Name,
                               i_Short_Name         => i_Short_Name,
                               i_Identifier         => i_Identifier,
                               i_Used               => i_Used,
                               i_State              => 'A',
                               i_Pcode              => i_Pcode);
  end;
  
  --------------------------------------------------
  Procedure Fte
  (
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
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Fte_Id := Href_Next.Fte_Id;
    end;
  
    z_Href_Ftes.Save_One(i_Company_Id => v_Company_Head,
                        i_Fte_Id     => v_Fte_Id,
                        i_Name       => i_Name,
                        i_Fte_Value  => i_Fte_Value,
                        i_Order_No   => i_Order_No,
                        i_Pcode      => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Table_Record_Setting
  (
    a varchar2,
    b varchar2,
    c varchar2 := null
  ) is
  begin
    z_Md_Table_Record_Translate_Settings.Insert_Try(i_Table_Name  => a,
                                                    i_Column_Set  => b,
                                                    i_Extra_Where => c);
  end;

  -------------------------------------------------- 
  Procedure Add_Default_Badge_Template is
  begin
    insert into Href_Badge_Templates
      (Badge_Template_Id, name, Html_Value, State)
    values
      (Href_Next.Badge_Template_Id,
       'Бейдж сотрудника(по умолчанию)',
       '<div style="display: flex; align-items: stretch; padding: 10px; border: 1px solid #ccc;">
           <div style="width: 50%; text-align: center;">
             <h2 style="font-weight: 600;">{{ company_name }}</h2>
             <img src="{{ filial_logo }}" style="margin: 5px auto; width: 200px;"/>
             <h5 style="font-weight: 600;">{{ employee_name }}</h5>
             <h6>{{ employee_job }}</h6>
             <h6>{{ employee_number }}</h6>
           </div>
           <div style="width: 50%; display: flex; justify-content: center; align-items: center;">
             <img src="{{ qrcode }}" style="width: 200px;"/>
           </div>
         </div>',
       'A');
  exception
    when Dup_Val_On_Index then
      Dbms_Output.Put_Line('*already inserted default badge template');
  end;
begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Default Roles ====');
  Default_Role('HR-менеджер',Href_Pref.c_Pcode_Role_Hr, 1);
  Default_Role('Руководитель', Href_Pref.c_Pcode_Role_Supervisor, 2);
  Default_Role('Сотрудник', Href_Pref.c_Pcode_Role_Staff, 3);
  Default_Role('Бухгалтер', Href_Pref.c_Pcode_Role_Accountant, 4);
  Default_Role('Timepad', Href_Pref.c_Pcode_Role_Timepad, 5);
  Default_Role('Рекрутер', Href_Pref.c_Pcode_Role_Recruiter, 6);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Document Types ====');
  Document_Type('Паспорт (по умолчанию)', Href_Pref.c_Pcode_Document_Type_Default_Passport);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Indicator Groups ====');
  Indicator_Group('Показатели расчета зарплаты', Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator_Group('Показатели расчета опыта', Href_Pref.c_Pcode_Indicator_Group_Experience);
  ---------------------------------------------------------------------------------------------------- 
  Dbms_Output.Put_Line('==== Indicators ====');
  Indicator('Оклад', 'Оклад', 'Оклад', Href_Pref.c_Indicator_Used_Constantly, Href_Pref.c_Pcode_Indicator_Wage, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Доля неполного рабочего времени', 'Доля неполн. времени', 'ДоляНеполногоРабочегоВремени', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Rate, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Норма дней', 'Норма (дн.)', 'НормаДней', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Plan_Days, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Время в днях', 'Время в днях', 'ВремяВДнях', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Fact_Days, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Норма часов', 'Норма (часов)', 'НормаЧасов', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Plan_Hours, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Время в часах', 'Время в часах', 'ВремяВЧасах', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Fact_Hours, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Бонус за эффективность', 'Бонус за эффект.', 'БонусЗаЭффективность', Href_Pref.c_Indicator_Used_Constantly, Href_Pref.c_Pcode_Indicator_Perf_Bonus, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Дополнительный бонус за эффективность', 'Доп. бонус за эффект.', 'ДополнительныйБонусЗаЭффективность', Href_Pref.c_Indicator_Used_Constantly, Href_Pref.c_Pcode_Indicator_Perf_Extra_Bonus, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Рабочее время в днях', 'Рабочие дни', 'РабочиеДни', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Working_Days, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Рабочее время в часах', 'Рабочее время', 'РабочееВремя', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Working_Hours, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Коэффициент больничных листов', 'Коэффициент (Больничный лист)', 'КоэффициентБольничныхЛистов', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Sick_Leave_Coefficient, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Количество командировочных дней', 'Кол-во ком. дней', 'КоличествоДней', Href_pref.c_Indicator_Used_Automatically, Href_pref.c_Pcode_Indicator_Business_Trip_Days, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Количество отпускных дней', 'Кол-во от. дней', 'КоличествоДнейОтпуска', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Vacation_Days, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Среднемесячное количество рабочих дней', 'Среднемес. кол-во раб. дней', 'СреднемесячноеКоличествоРабочихДней', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Mean_Working_Days, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Количество больничных дней', 'Кол-во больн. дней', 'КоличествоБольничныхДней', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Sick_Leave_Days, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Средний часовой оклад', 'Сред. час. оклад', 'СреднеЧасовойОклад', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Hourly_Wage, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Cверхурочные часы', 'Сверх. часы', 'СверхурочныеЧасы', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Overtime_Hours, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Коэффициент сверхурочного времени', 'Коэф. сверх. времени', 'КоэффициентСверхурочногоВремени', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Overtime_Coef, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Штраф за опоздание', 'Штраф за опоздание', 'ШтрафЗаОпоздание', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Penalty_For_Late, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Штраф за ранний уход', 'Штраф за ранний уход', 'ШтрафЗаРаннийУход', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Penalty_For_Early_Output, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Штраф за отсутствие', 'Штраф за отсутствие', 'ШтрафЗаОтсутствие', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Penalty_For_Absence, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Штраф за пропуск дня', 'Штраф за пропуск дня', 'ШтрафЗаПропускДня', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Penalty_For_Day_Skip, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Штраф за неэффективность', 'Штраф за неэффект.', 'ШтрафЗаНеэффективность', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Perf_Penalty, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Дополнительный Штраф за неэффективность', 'Доп. Штраф за неэффект.', 'ДополнительныйШтрафЗаНеэффективность', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Perf_Extra_Penalty, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Штраф за пропуск отметки', 'Штраф за пропуск отметки', 'ШтрафЗаПропускОтметки', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Penalty_For_Mark_Skip, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Дополнительное Ночное Время', 'Дополнительное Ночное Время', 'ДополнительноеНочноеВремя', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Additional_Nighttime, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Взвешенное время в часах', 'Взвешенное время в часах', 'ВзвешенноеВремяВЧасах', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Weighted_Turnout, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Среднемесячный бонус за эффективность', 'Сред. бонус за эффект.', 'СреднемесячныйБонусЗаЭффективность', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Average_Perf_Bonus, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Среднемесячный дополнительный бонус за эффективность', 'Сред. доп. бонус за эффект.', 'СреднемесячныйДополнительныйБонусЗаЭффективность', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Average_Perf_Extra_Bonus, Href_Pref.c_Pcode_Indicator_Group_Wage);
  Indicator('Прохожение тренингов', 'Прохожение тренингов', 'ПрохожениеТренингов', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Trainings_Subjects, Href_Pref.c_Pcode_Indicator_Group_Experience);
  Indicator('Результат Экзамена', 'Результат Экзамена', 'РезультатЭкзамена', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Exam_Results, Href_Pref.c_Pcode_Indicator_Group_Experience);
  Indicator('Процент посещаемости', 'Процент посещаемости', 'ПроцентПосещаемости', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Average_Attendance_Percentage, Href_Pref.c_Pcode_Indicator_Group_Experience);
  Indicator('Процент выполнения плана', 'Процент выполнения плана', 'ПроцентВыполненияПлана', Href_Pref.c_Indicator_Used_Automatically, Href_Pref.c_Pcode_Indicator_Average_Perfomance_Percentage, Href_Pref.c_Pcode_Indicator_Group_Experience);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Ftes ====');
  ----------------------------------------------------------------------------------------------------
  Fte('Full time', 1, 1, Href_Pref.c_Pcode_Fte_Full_Time);
  Fte('Part time', 0.5, 2, Href_Pref.c_Pcode_Fte_Part_Time);
  Fte('Quarter time', 0.25, 3, Href_Pref.c_Pcode_Fte_Quarter_Time);
  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translate ====');
  Table_Record_Setting('HREF_DOCUMENT_TYPES', 'NAME');
  Table_Record_Setting('HREF_INDICATOR_GROUPS', 'NAME');
  Table_Record_Setting('HREF_INDICATORS', 'NAME,SHORT_NAME,IDENTIFIER');
  Table_Record_Setting('HREF_FTES', 'NAME', 'PCODE IS NOT NULL');
  commit;
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Default Badge ====');
  Add_Default_Badge_Template;
  commit;
end;
/
