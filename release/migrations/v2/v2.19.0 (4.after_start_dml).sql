prompt incrementing htt_acms_tracks_sq
---------------------------------------------------------------------------------------------------- 
declare
  v_Max_Acms_Track_Id number;
  v_Buffer_Value      number;
begin
  select Nvl(max(t.Track_Id), 1)
    into v_Max_Acms_Track_Id
    from Htt_Acms_Tracks t;

  execute immediate 'alter sequence htt_acms_tracks_sq increment by ' || v_Max_Acms_Track_Id;

  select Htt_Acms_Tracks_Sq.Nextval
    into v_Buffer_Value
    from Dual;

  execute immediate 'alter sequence htt_acms_tracks_sq increment by 1';
end;
/

---------------------------------------------------------------------------------------------------- 
prompt adding new time kinds
---------------------------------------------------------------------------------------------------- 
declare
  -------------------------------------------------- 
  Procedure Time_Kind
  (
    i_Company_Id   number,
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
    v_Time_Kind_Id number;
    v_Parent_Id    number;
  begin
    begin
      select Time_Kind_Id
        into v_Time_Kind_Id
        from Htt_Time_Kinds
       where Company_Id = i_Company_Id
         and (Pcode = i_Pcode or --
             name = i_Name or -- 
             Letter_Code = i_Letter_Code);
    exception
      when No_Data_Found then
        v_Time_Kind_Id := Htt_Next.Time_Kind_Id;
    end;
  
    begin
      select Time_Kind_Id
        into v_Parent_Id
        from Htt_Time_Kinds
       where Company_Id = i_Company_Id
         and Pcode = i_Parent_Pcode;
    exception
      when No_Data_Found then
        v_Parent_Id := null;
    end;
  
    z_Htt_Time_Kinds.Save_One(i_Company_Id   => i_Company_Id,
                              i_Time_Kind_Id => v_Time_Kind_Id,
                              i_Name         => i_Name,
                              i_Letter_Code  => i_Letter_Code,
                              i_Digital_Code => i_Digital_Code,
                              i_Parent_Id    => v_Parent_Id,
                              i_Plan_Load    => i_Plan_Load,
                              i_Requestable  => i_Requestable,
                              i_Bg_Color     => i_Bg_Color,
                              i_Color        => i_Color,
                              i_State        => 'A',
                              i_Pcode        => i_Pcode);
  end;

begin
  for r in (select *
              from Md_Companies q
             where Md_Util.Any_Project(q.Company_Id) is not null
               and q.State = 'A')
  loop
    Ui_Auth.Logon_As_System(i_Company_Id => r.Company_Id);

    Time_Kind(r.Company_Id, 'Дорабочее Время', 'ДВ', null, Htt_Pref.c_Pcode_Time_Kind_Free, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Before_Work);
    Time_Kind(r.Company_Id, 'Послерабочее Время', 'ПУ', null, Htt_Pref.c_Pcode_Time_Kind_Free, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_After_Work);
    Time_Kind(r.Company_Id, 'Обеденное время', 'ОВ', null, Htt_Pref.c_Pcode_Time_Kind_Free, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Lunchtime);
    Time_Kind(r.Company_Id, 'Плановое свободное время', 'ПСВ', null, Htt_Pref.c_Pcode_Time_Kind_Free, 'P', 'N', null, null, Htt_Pref.c_Pcode_Time_Kind_Free_Inside);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt add new oper group, oper types and Indicators
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
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Company_Id := Cmp.Company_Id;
  
    Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(v_Company_Id),
                         i_User_Id      => Md_Pref.User_System(v_Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Indicator('Штраф за опоздание',
              'Штраф за опоздание',
              'ШтрафЗаОпоздание',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Penalty_For_Late);
    Indicator('Штраф за ранний уход',
              'Штраф за ранний уход',
              'ШтрафЗаРаннийУход',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Penalty_For_Early_Output);
    Indicator('Штраф за отсутствие',
              'Штраф за отсутствие',
              'ШтрафЗаОтсутствие',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Penalty_For_Absence);
    Indicator('Штраф за пропуск дня',
              'Штраф за пропуск дня',
              'ШтрафЗаПропускДня',
              Href_Pref.c_Indicator_Used_Automatically,
              Href_Pref.c_Pcode_Indicator_Penalty_For_Day_Skip);
  
    Operation_Group(Mpr_Pref.c_Ok_Deduction,
                    'Штрафы за нарушение дисциплины',
                    Hpr_Pref.c_Estimation_Type_Formula,
                    'ШтрафЗаОпоздание + ШтрафЗаРаннийУход + ШтрафЗаОтсутствие + ШтрафЗаПропускДня',
                    Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline);
  
    Oper_Type('Штрафы за нарушение дисциплины',
              'Штрафы за нарушение дисциплины',
              Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline,
              Hpr_Pref.c_Estimation_Type_Formula,
              'ШтрафЗаОпоздание + ШтрафЗаРаннийУход + ШтрафЗаОтсутствие + ШтрафЗаПропускДня',
              Mpr_Pref.c_Ok_Deduction,
              Hpr_Pref.c_Pcode_Oper_Type_Penalty_For_Discipline);
  
    Book_Type_Bind(Hpr_Pref.c_Pcode_Book_Type_Wage,
                   Hpr_Pref.c_Pcode_Operation_Group_Penalty_For_Discipline);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt change some names oper gorups, oper types and book types
----------------------------------------------------------------------------------------------------
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  v_Pcode_Like   varchar2(10) := Upper(Href_Pref.c_Pc_Verifix_Hr) || '%';
  v_Query        varchar2(32767);

  --------------------------------------------------
  Procedure Indicators
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    r_Data Href_Indicators%rowtype;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Href_Indicators,
                                                i_Lang_Code => i_Lang_Code);
  
    for r in (select *
                from Href_Indicators t
               where t.Company_Id = i_Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Data := r;
    
      execute immediate v_Query
        using in r_Data, out r_Data;
    
      z_Href_Indicators.Update_One(i_Company_Id    => r_Data.Company_Id,
                                   i_Indicator_Id  => r_Data.Indicator_Id,
                                   i_Name          => Option_Varchar2(r_Data.Name),
                                   i_Short_Name    => Option_varchar2(r_Data.Short_Name));
    end loop;
  end;
  
  --------------------------------------------------
  Procedure Oper_Groups
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    r_Data Hpr_Oper_Groups%rowtype;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpr_Oper_Groups,
                                                i_Lang_Code => i_Lang_Code);
  
    for r in (select *
                from Hpr_Oper_Groups t
               where t.Company_Id = i_Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Data := r;
    
      execute immediate v_Query
        using in r_Data, out r_Data;
    
      z_Hpr_Oper_Groups.Update_One(i_Company_Id    => r_Data.Company_Id,
                                   i_Oper_Group_Id => r_Data.Oper_Group_Id,
                                   i_Name          => Option_Varchar2(r_Data.Name));
    end loop;
  end;

  --------------------------------------------------
  Procedure Oper_Types
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    r_Data Mpr_Oper_Types%rowtype;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Mpr_Oper_Types,
                                                i_Lang_Code => i_Lang_Code);
  
    for r in (select *
                from Mpr_Oper_Types t
               where t.Company_Id = i_Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Data := r;
    
      execute immediate v_Query
        using in r_Data, out r_Data;
    
      z_Mpr_Oper_Types.Update_One(i_Company_Id   => r_Data.Company_Id,
                                  i_Oper_Type_Id => r_Data.Oper_Type_Id,
                                  i_Name         => Option_Varchar2(r_Data.Name),
                                  i_Short_Name   => Option_Varchar2(r_Data.Short_Name));
    end loop;
  end;

  --------------------------------------------------
  Procedure Book_Types
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    r_Data Hpr_Book_Types%rowtype;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpr_Book_Types,
                                                i_Lang_Code => i_Lang_Code);
  
    for r in (select *
                from Hpr_Book_Types t
               where t.Company_Id = i_Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Data := r;
    
      execute immediate v_Query
        using in r_Data, out r_Data;
    
      z_Hpr_Book_Types.Update_One(i_Company_Id   => r_Data.Company_Id,
                                  i_Book_Type_Id => r_Data.Book_Type_Id,
                                  i_Name         => Option_Varchar2(r_Data.Name));
    end loop;
  end;
  
  --------------------------------------------------
  Procedure Time_Kinds
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    r_Data Htt_Time_Kinds%rowtype;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Htt_Time_Kinds,
                                                i_Lang_Code => i_Lang_Code);
  
    for r in (select *
                from Htt_Time_Kinds t
               where t.Company_Id = i_Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Data := r;
    
      execute immediate v_Query
        using in r_Data, out r_Data;
    
      z_Htt_Time_Kinds.Update_One(i_Company_Id   => r_Data.Company_Id,
                                  i_Time_Kind_Id => r_Data.Time_Kind_Id,
                                  i_Name         => Option_Varchar2(r_Data.Name),
                                  i_Letter_Code  => Option_Varchar2(r_Data.Letter_Code));
    end loop;
  end;
begin
  Biruni_Route.Context_Begin;   

  for Cmp in (select c.Company_Id,
                     c.Lang_Code,
                     (select Ci.Filial_Head
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as Filial_Head,
                     (select Ci.User_System
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as User_System
                from Md_Companies c
               where c.Company_Id <> v_Company_Head)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                         i_Filial_Id    => Cmp.Filial_Head,
                         i_User_Id      => Cmp.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Indicators(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
    Oper_Groups(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
    Oper_Types(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
    Book_Types(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
    Time_Kinds(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
  end loop;

  Biruni_Route.Context_End;

  commit;
end;
/


