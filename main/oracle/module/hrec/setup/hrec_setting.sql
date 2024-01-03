set define off
set serveroutput on
declare
  v_Company_Head number := Md_Pref.c_Company_Head;

  --------------------------------------------------
  Procedure Stage
  (
    i_Name     varchar2,
    i_Order_No number,
    i_Pcode    varchar2
  ) is
    v_Stage_Id number;
  begin
    begin
      select Stage_Id
        into v_Stage_Id
        from Hrec_Stages
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Stage_Id := Hrec_Next.Stage_Id;
    end;
  
    z_Hrec_Stages.Save_One(i_Company_Id => v_Company_Head,
                           i_Stage_Id   => v_Stage_Id,
                           i_Name       => i_Name,
                           i_State      => 'A',
                           i_Order_No   => i_Order_No,
                           i_Code       => '',
                           i_Pcode      => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Funnel
  (
    i_Name  varchar2,
    i_Pcode varchar2
  ) is
    v_Funnel_Id number;
  begin
    begin
      select Funnel_Id
        into v_Funnel_Id
        from Hrec_Funnels
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Funnel_Id := Hrec_Next.Funnel_Id;
    end;
  
    z_Hrec_Funnels.Save_One(i_Company_Id => v_Company_Head,
                            i_Funnel_Id  => v_Funnel_Id,
                            i_Name       => i_Name,
                            i_State      => 'A',
                            i_Code       => '',
                            i_Pcode      => i_Pcode);
  end;
  
  --------------------------------------------------  
  Procedure Vacancy_Group_Save
  (
    i_Name            varchar2,
    i_Order_No        number,
    i_Is_Required     varchar2,
    i_Multiple_Select varchar2,
    i_Pcode           varchar2
  ) is
    v_Vacancy_Group_Id number;
  begin
    begin
      select Vacancy_Group_Id
        into v_Vacancy_Group_Id
        from Hrec_Vacancy_Groups
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Vacancy_Group_Id := Hrec_Vacancy_Groups_Sq.Nextval;
    end;
  
    z_Hrec_Vacancy_Groups.Save_One(i_Company_Id       => v_Company_Head,
                                   i_Vacancy_Group_Id => v_Vacancy_Group_Id,
                                   i_Name             => i_Name,
                                   i_Order_No         => i_Order_No,
                                   i_Is_Required      => i_Is_Required,
                                   i_Multiple_Select  => i_Multiple_Select,
                                   i_Code             => null,
                                   i_Pcode            => i_Pcode,
                                   i_State            => 'A');
  end;

  --------------------------------------------------
  Procedure Vacancy_Type_Save
  (
    i_Name        varchar2,
    i_Group_Pcode varchar2,
    i_Pcode       varchar2
  ) is
    v_Vacancy_Type_Id number;
    v_Vacany_Group_Id number;
  begin
    begin
      select Vacancy_Type_Id
        into v_Vacancy_Type_Id
        from Hrec_Vacancy_Types
       where Company_Id = v_Company_Head
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Vacancy_Type_Id := Hrec_Vacancy_Types_Sq.Nextval;
    end;
  
    begin
      select Vacancy_Group_Id
        into v_Vacany_Group_Id
        from Hrec_Vacancy_Groups
       where Company_Id = v_Company_Head
         and Pcode = i_Group_Pcode;
    
      z_Hrec_Vacancy_Types.Save_One(i_Company_Id       => v_Company_Head,
                                    i_Vacancy_Type_Id  => v_Vacancy_Type_Id,
                                    i_Vacancy_Group_Id => v_Vacany_Group_Id,
                                    i_Name             => i_Name,
                                    i_Code             => null,
                                    i_Pcode            => i_Pcode,
                                    i_State            => 'A');
    exception
      when No_Data_Found then
        null;
    end;
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
  Procedure Save_Stage
  (
    i_Code varchar2,
    i_Name varchar2
  ) is
  begin
    z_Hrec_Head_Hunter_Stages.Save_One(i_Code => i_Code, i_Name => i_Name);
  end;
begin
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Stages ====');
  Stage('К выполнению', 1, Hrec_Pref.c_Pcode_Stage_Todo);
  Stage('Предложение принято', 98, Hrec_Pref.c_Pcode_Stage_Accepted);
  Stage('Отклонена', 99, Hrec_Pref.c_Pcode_Stage_Rejected);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Funnels ====');
  Funnel('Все этапы', Hrec_Pref.c_Pcode_Funnel_All);
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Head Hunter Stages ====');
  Save_Stage('response', 'Отклик');
  Save_Stage('consider', 'Подумать');
  Save_Stage('phone_interview', 'Тел. интервью');
  Save_Stage('assessment', 'Оценка');
  Save_Stage('interview', 'Интервью');
  Save_Stage('offer', 'Предложение о работе');
  Save_Stage('hired', 'Выход на работу');
  Save_Stage('discard_by_employer', 'Отказано');
  Save_Stage('response', 'Все неразобранные');
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Vacancy Groups ====');
  Vacancy_Group_Save('Опыт работа', 
                     1, 
                     'N', 
                     'N', 
                     Hrec_Pref.c_Pcode_Vacancy_Group_Experience);
  Vacancy_Group_Save('Тип занятости',
                     2,
                     'N',
                     'N',
                     Hrec_Pref.c_Pcode_Vacancy_Group_Employments);
  Vacancy_Group_Save('Водительские права',
                     3,
                     'N',
                     'Y',
                     Hrec_Pref.c_Pcode_Vacancy_Group_Driver_Licences);
  Vacancy_Group_Save('Ключевые навыки',
                     4,
                     'N',
                     'Y',
                     Hrec_Pref.c_Pcode_Vacancy_Group_Key_Skills);
----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Vacancy Types ====');
  Vacancy_Type_Save('Нет опыта',
                    Hrec_Pref.c_Pcode_Vacancy_Group_Experience,
                    Hrec_Pref.c_Pcode_Vacancy_Type_Experience_No_Experience);
  Vacancy_Type_Save('От 1 года до 3 лет',
                    Hrec_Pref.c_Pcode_Vacancy_Group_Experience,
                    Hrec_Pref.c_Pcode_Vacancy_Type_Experience_Between_1_And_3);
  Vacancy_Type_Save('От 3 до 6 лет',
                    Hrec_Pref.c_Pcode_Vacancy_Group_Experience,
                    Hrec_Pref.c_Pcode_Vacancy_Type_Experience_Between_3_And_6);
  Vacancy_Type_Save('Более 6 лет',
                    Hrec_Pref.c_Pcode_Vacancy_Group_Experience,
                    Hrec_Pref.c_Pcode_Vacancy_Type_Experience_More_Than_6);
  Vacancy_Type_Save('Полная занятость',
                    Hrec_Pref.c_Pcode_Vacancy_Group_Employments,
                    Hrec_Pref.c_Pcode_Vacancy_Type_Employment_Full);
  Vacancy_Type_Save('Частичная занятость',
                    Hrec_Pref.c_Pcode_Vacancy_Group_Employments,
                    Hrec_Pref.c_Pcode_Vacancy_Type_Employment_Part);
  Vacancy_Type_Save('A',
                    Hrec_Pref.c_Pcode_Vacancy_Group_Driver_Licences,
                    Hrec_Pref.c_Pcode_Vacancy_Type_Driver_Licence_a);
  Vacancy_Type_Save('B',
                    Hrec_Pref.c_Pcode_Vacancy_Group_Driver_Licences,
                    Hrec_Pref.c_Pcode_Vacancy_Type_Driver_Licence_b);
  Vacancy_Type_Save('C',
                    Hrec_Pref.c_Pcode_Vacancy_Group_Driver_Licences,
                    Hrec_Pref.c_Pcode_Vacancy_Type_Driver_Licence_c);
  Vacancy_Type_Save('Амбициозный человек',
                    Hrec_Pref.c_Pcode_Vacancy_Group_Key_Skills,
                    Hrec_Pref.c_Pcode_Vacancy_Type_Key_Skill_Ambitious);
  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translates ====');
  Table_Record_Setting('HREC_STAGES', 'NAME');
  Table_Record_Setting('HREC_FUNNELS', 'NAME');
  Table_Record_Setting('HREC_HEAD_HUNTER_STAGES', 'NAME');
  Table_Record_Setting('HREC_VACANCY_GROUPS', 'NAME');
  Table_Record_Setting('HREC_VACANCY_TYPES', 'NAME');
  commit;
end;
/
