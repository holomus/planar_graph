prompt adding new indicators
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
declare
  -------------------------------------------------- 
  Procedure Indicator
  (
    i_Company_Id            number,
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
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Indicator_Id := Href_Next.Indicator_Id;
    end;
  
    select Indicator_Group_Id
      into v_Indicator_Group_Id
      from Href_Indicator_Groups
     where Company_Id = i_Company_Id
       and Pcode = i_Indicator_Group_Pcode;
  
    z_Href_Indicators.Save_One(i_Company_Id         => i_Company_Id,
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

begin
  Table_Record_Setting('HREF_INDICATOR_GROUPS', 'NAME');

  for r in (select *
              from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Verifix_Settings.c_Pc_Verifix_Hr);
  
    Indicator(r.Company_Id,
              'Прохожение тренингов',
              'Прохожение тренингов',
              'ПрохожениеТренингов',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Trainings_Subjects,
              Href_Pref.c_Pcode_Indicator_Group_Experience);
    Indicator(r.Company_Id,
              'Результат Экзамена',
              'Результат Экзамена',
              'РезультатЭкзамена',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Exam_Results,
              Href_Pref.c_Pcode_Indicator_Group_Experience);
    Indicator(r.Company_Id,
              'Процент посещаемости',
              'Процент посещаемости',
              'ПроцентПосещаемости',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Average_Attendance_Percentage,
              Href_Pref.c_Pcode_Indicator_Group_Experience);
    Indicator(r.Company_Id,
              'Процент выполнения плана',
              'Процент выполнения плана',
              'ПроцентВыполненияПлана',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Average_Perfomance_Percentage,
              Href_Pref.c_Pcode_Indicator_Group_Experience);
  end loop;
  
  commit;
end;
/
