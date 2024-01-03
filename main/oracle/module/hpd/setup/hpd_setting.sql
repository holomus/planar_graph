set define off
set serveroutput on
declare
  v_Company_Head number := Md_Pref.c_Company_Head;

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
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    end;

    z_Hpd_Journal_Types.Save_One(i_Company_Id      => v_Company_Head,
                                 i_Journal_Type_Id => v_Journal_Type_Id,
                                 i_Name            => i_Name,
                                 i_Order_No        => i_Order_No,
                                 i_Pcode           => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Application_Type
  (
    i_Name     varchar2,
    i_Order_No number,
    i_Pcode    varchar2
  ) is
    v_Application_Type_Id number;
  begin
    begin
      select Application_Type_Id
        into v_Application_Type_Id
        from Hpd_Application_Types
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Application_Type_Id := Hpd_Next.Application_Type_Id;
    end;

    z_Hpd_Application_Types.Save_One(i_Company_Id          => v_Company_Head,
                                     i_Application_Type_Id => v_Application_Type_Id,
                                     i_Name                => i_Name,
                                     i_Order_No            => i_Order_No,
                                     i_Pcode               => i_Pcode);
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
  
  --------------------------------------------------
  Procedure Save_Process
  (
    i_Name     varchar2,
    i_Order_No number,
    i_State    varchar2,
    i_Pcode    varchar2
  ) is
    v_Process_Id number;
  begin
    begin
      select Process_Id
        into v_Process_Id
        from Mdf_Sign_Processes
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Process_Id := Mdf_Next.Process_Id;
    end;
  
    z_Mdf_Sign_Processes.Save_One(i_Company_Id   => v_Company_Head,
                                  i_Process_Id   => v_Process_Id,
                                  i_Project_Code => Verifix.Project_Code,
                                  i_Source_Table => Zt.Hpd_Journals.Name,
                                  i_Name         => i_Name,
                                  i_Order_No     => i_Order_No,
                                  i_State        => i_State,
                                  i_Pcode        => i_Pcode);
  end;
begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Journal Types ====');
  Journal_Type('Прием на работу', 1, Hpd_Pref.c_Pcode_Journal_Type_Hiring);
  Journal_Type('Прием на работу списком', 2, Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple);
  Journal_Type('Прием на договор ГПХ', 3, Hpd_Pref.c_Pcode_Journal_Type_Hiring_Contractor);
  Journal_Type('Кадровый перевод', 4, Hpd_Pref.c_Pcode_Journal_Type_Transfer);
  Journal_Type('Кадровый перевод списком', 5, Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple);
  Journal_Type('Увольнение', 6, Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
  Journal_Type('Увольнение списком', 7, Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple);
  Journal_Type('Изменение оплаты труда', 8, Hpd_Pref.c_Pcode_Journal_Type_Wage_Change);
  Journal_Type('Изменение оплаты труда списком', 9, Hpd_pref.c_Pcode_Journal_Type_Wage_Change_Multiple);
  Journal_Type('Изменение квалификации', 10, Hpd_Pref.c_Pcode_Journal_Type_Rank_Change);
  Journal_Type('Изменение квалификации списком', 11, Hpd_Pref.c_Pcode_Journal_Type_Rank_Change_Multiple);
  Journal_Type('Изменение графика работы списком', 12, Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change);
  Journal_Type('Изменение количества отпускных дней', 13, Hpd_Pref.c_Pcode_Journal_Type_Limit_Change);
  Journal_Type('Больничный лист', 14, Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave);
  Journal_Type('Больничный лист списком', 15, Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave_Multiple);
  Journal_Type('Командировка', 16, Hpd_Pref.c_Pcode_Journal_Type_Business_Trip);
  Journal_Type('Командировка списком', 17, Hpd_Pref.c_Pcode_Journal_Type_Business_Trip_Multiple);
  Journal_Type('Отпуск', 18, Hpd_Pref.c_Pcode_Journal_Type_Vacation);
  Journal_Type('Отпуск списком', 19, Hpd_Pref.c_Pcode_Journal_Type_Vacation_Multiple);
  Journal_Type('Сверхурочная работа', 20, Hpd_Pref.c_Pcode_Journal_Type_Overtime);
  Journal_Type('Корректировка табеля', 21, Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Application Types ====');
  Application_Type('Открытие позиции', 1, Hpd_Pref.c_Pcode_Application_Type_Create_Robot);
  Application_Type('Прием на работу', 2, Hpd_Pref.c_Pcode_Application_Type_Hiring);
  Application_Type('Кадровый перевод', 3, Hpd_Pref.c_Pcode_Application_Type_Transfer);
  Application_Type('Кадровый перевод списком', 4, Hpd_Pref.c_Pcode_Application_Type_Transfer_Multiple);
  Application_Type('Увольнение', 5, Hpd_Pref.c_Pcode_Application_Type_Dismissal);  
  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translates ====');
  Table_Record_Setting('HPD_JOURNAL_TYPES', 'NAME');
  Table_Record_Setting('HPD_APPLICATION_TYPES', 'NAME');
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Easy report templates ====');

  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Hiring,
                              i_Name     => 'Приказ о приеме на работу',
                              i_Order_No => 1,
                              i_Pcode    => 'vhr:hpd:1');
  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Hiring_Multiple,
                              i_Name     => 'Приказ о приеме на работу списком',
                              i_Order_No => 2,
                              i_Pcode    => 'vhr:hpd:2');
  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Transfer,
                              i_Name     => 'Приказ о кадровом переводе',
                              i_Order_No => 3,
                              i_Pcode    => 'vhr:hpd:3');
  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Transfer_Multiple,
                              i_Name     => 'Приказ о кадровом переводе списком',
                              i_Order_No => 4,
                              i_Pcode    => 'vhr:hpd:4');
  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Dismissal,
                              i_Name     => 'Приказ об увольнении',
                              i_Order_No => 5,
                              i_Pcode    => 'vhr:hpd:5');
  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Dismissal_Multiple,
                              i_Name     => 'Приказ об увольнении списком',
                              i_Order_No => 6,
                              i_Pcode    => 'vhr:hpd:6');
  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Labor_Contract,
                              i_Name     => 'Трудовой договор',
                              i_Order_No => 7,
                              i_Pcode    => 'vhr:hpd:7');
  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Sick_Leave,
                              i_Name     => 'Больничный',
                              i_Order_No => 8,
                              i_Pcode    => 'vhr:hpd:8');
  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Sick_Leave_Multiple,
                              i_Name     => 'Больничный списком',
                              i_Order_No => 9,
                              i_Pcode    => 'vhr:hpd:9');
  ----------------------------------------------------------------------------------------------------  
  Dbms_Output.Put_Line('==== Save Journal Process ====');   
  Save_Process('ЭДО для кадровых документов',
               1,
               'A',
               Hpd_Pref.c_Pcode_Journal_Sign_Processes);
               
  commit;
end;
/
