prompt migr from 03.03.2023 v2.20.0 (2.after_start_dml)
----------------------------------------------------------------------------------------------------
prompt new indicators, oper_group and book_type_bind migr data
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id number;

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
begin
  for Cmp in (select *
                from Md_Companies q)
  loop
    v_Company_Id := Cmp.Company_Id;
  
    Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(v_Company_Id),
                         i_User_Id      => Md_Pref.User_System(v_Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    -- indicators
    Indicator('Штраф за неэффективность',
              'Штраф за неэффект.',
              'ШтрафЗаНеэффективность',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Perf_Penalty);
    Indicator('Дополнительный штраф за неэффективность',
              'Доп. штраф за неэффект.',
              'ДополнительныйШтрафЗаНеэффективность',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Perf_Extra_Penalty);
  
    -- operation group
    Operation_Group(Mpr_Pref.c_Ok_Deduction,
                    'Штраф за неэффективность',
                    Hpr_Pref.c_Estimation_Type_Formula,
                    'ШтрафЗаНеэффективность + ДополнительныйШтрафЗаНеэффективность',
                    Hpr_Pref.c_Pcode_Operation_Group_Perf_Penalty);
  
    Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Wage, Hpr_Pref.c_Pcode_Operation_Group_Perf_Penalty);
  end loop;

  commit;
end;
/


----------------------------------------------------------------------------------------------------
prompt set default variable 
----------------------------------------------------------------------------------------------------
update Hpr_Penalty_Policies q
   set q.Calc_After_From_Time = 'Y'
 where q.Penalty_Per_Time is not null
   and q.Penalty_Amount is not null;
commit;
