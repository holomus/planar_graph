prompt adding contractor journal type
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Journal_Type
  (
    i_Company_Id number,
    i_Name       varchar2,
    i_Order_No   number,
    i_Pcode      varchar2
  ) is
    v_Journal_Type_Id number;
  begin
    begin
      select Journal_Type_Id
        into v_Journal_Type_Id
        from Hpd_Journal_Types
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    end;
  
    z_Hpd_Journal_Types.Save_One(i_Company_Id      => i_Company_Id,
                                 i_Journal_Type_Id => v_Journal_Type_Id,
                                 i_Name            => i_Name,
                                 i_Order_No        => i_Order_No,
                                 i_Pcode           => i_Pcode);
  end;
begin
  update Hpd_Journal_Types q
     set q.Order_No = q.Order_No + 1
   where q.Pcode in (Hpd_Pref.c_Pcode_Journal_Type_Transfer,
                     Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple,
                     Hpd_Pref.c_Pcode_Journal_Type_Dismissal,
                     Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple,
                     Hpd_Pref.c_Pcode_Journal_Type_Wage_Change,
                     Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change,
                     Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave,
                     Hpd_Pref.c_Pcode_Journal_Type_Business_Trip,
                     Hpd_Pref.c_Pcode_Journal_Type_Vacation,
                     Hpd_Pref.c_Pcode_Journal_Type_Rank_Change,
                     Hpd_Pref.c_Pcode_Journal_Type_Limit_Change,
                     Hpd_Pref.c_Pcode_Journal_Type_Overtime,
                     Hpd_Pref.c_Pcode_Journal_Type_Wage_Change_Multiple,
                     Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment,
                     Hpd_Pref.c_Pcode_Journal_Type_Rank_Change_Multiple,
                     Hpd_Pref.c_Pcode_Journal_Type_Business_Trip_Multiple);

  for r in (select *
              from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Journal_Type(r.Company_Id,
                 'Прием на договор ГПХ',
                 3,
                 Hpd_Pref.c_Pcode_Journal_Type_Hiring_Contractor);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt add Default values for Vacancy Groups and Vacancy Types
----------------------------------------------------------------------------------------------------   
declare
  --------------------------------------------------  
  Procedure Vacancy_Group_Save
  (
    i_Company_Id      number,
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
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Vacancy_Group_Id := Hrec_Vacancy_Groups_Sq.Nextval;
    end;
  
    z_Hrec_Vacancy_Groups.Save_One(i_Company_Id       => i_Company_Id,
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
    i_Company_Id  number,
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
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Vacancy_Type_Id := Hrec_Vacancy_Types_Sq.Nextval;
    end;
  
    begin
      select Vacancy_Group_Id
        into v_Vacany_Group_Id
        from Hrec_Vacancy_Groups
       where Company_Id = i_Company_Id
         and Pcode = i_Group_Pcode;
    
      z_Hrec_Vacancy_Types.Save_One(i_Company_Id       => i_Company_Id,
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
begin
  for r in (select *
              from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    ----------------------------------------------------------------------------------------------------
    Dbms_Output.Put_Line('==== Vacancy Groups ====');
    Vacancy_Group_Save(r.Company_Id,
                       'Опыт работа',
                       1,
                       'N',
                       'N',
                       Hrec_Pref.c_Pcode_Vacancy_Group_Experience);
    Vacancy_Group_Save(r.Company_Id,
                       'Тип занятости',
                       2,
                       'N',
                       'N',
                       Hrec_Pref.c_Pcode_Vacancy_Group_Employments);
    Vacancy_Group_Save(r.Company_Id,
                       'Водительские права',
                       3,
                       'N',
                       'Y',
                       Hrec_Pref.c_Pcode_Vacancy_Group_Driver_Licences);
    Vacancy_Group_Save(r.Company_Id,
                       'Ключевые навыки',
                       4,
                       'N',
                       'Y',
                       Hrec_Pref.c_Pcode_Vacancy_Group_Key_Skills);
    ----------------------------------------------------------------------------------------------------
    Dbms_Output.Put_Line('==== Vacancy Types ====');
    Vacancy_Type_Save(r.Company_Id,
                      'Нет опыта',
                      Hrec_Pref.c_Pcode_Vacancy_Group_Experience,
                      Hrec_Pref.c_Pcode_Vacancy_Type_Experience_No_Experience);
    Vacancy_Type_Save(r.Company_Id,
                      'От 1 года до 3 лет',
                      Hrec_Pref.c_Pcode_Vacancy_Group_Experience,
                      Hrec_Pref.c_Pcode_Vacancy_Type_Experience_Between_1_And_3);
    Vacancy_Type_Save(r.Company_Id,
                      'От 3 до 6 лет',
                      Hrec_Pref.c_Pcode_Vacancy_Group_Experience,
                      Hrec_Pref.c_Pcode_Vacancy_Type_Experience_Between_3_And_6);
    Vacancy_Type_Save(r.Company_Id,
                      'Более 6 лет',
                      Hrec_Pref.c_Pcode_Vacancy_Group_Experience,
                      Hrec_Pref.c_Pcode_Vacancy_Type_Experience_More_Than_6);
    Vacancy_Type_Save(r.Company_Id,
                      'Полная занятость',
                      Hrec_Pref.c_Pcode_Vacancy_Group_Employments,
                      Hrec_Pref.c_Pcode_Vacancy_Type_Employment_Full);
    Vacancy_Type_Save(r.Company_Id,
                      'Частичная занятость',
                      Hrec_Pref.c_Pcode_Vacancy_Group_Employments,
                      Hrec_Pref.c_Pcode_Vacancy_Type_Employment_Part);
    Vacancy_Type_Save(r.Company_Id,
                      'A',
                      Hrec_Pref.c_Pcode_Vacancy_Group_Driver_Licences,
                      Hrec_Pref.c_Pcode_Vacancy_Type_Driver_Licence_a);
    Vacancy_Type_Save(r.Company_Id,
                      'B',
                      Hrec_Pref.c_Pcode_Vacancy_Group_Driver_Licences,
                      Hrec_Pref.c_Pcode_Vacancy_Type_Driver_Licence_b);
    Vacancy_Type_Save(r.Company_Id,
                      'C',
                      Hrec_Pref.c_Pcode_Vacancy_Group_Driver_Licences,
                      Hrec_Pref.c_Pcode_Vacancy_Type_Driver_Licence_c);
    Vacancy_Type_Save(r.Company_Id,
                      'Амбициозный человек',
                      Hrec_Pref.c_Pcode_Vacancy_Group_Key_Skills,
                      Hrec_Pref.c_Pcode_Vacancy_Type_Key_Skill_Ambitious);
  end loop;
  
  ---------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translates ====');
  Table_Record_Setting('HREC_VACANCY_GROUPS', 'NAME');
  Table_Record_Setting('HREC_VACANCY_TYPES', 'NAME');

  commit;
end;
/
