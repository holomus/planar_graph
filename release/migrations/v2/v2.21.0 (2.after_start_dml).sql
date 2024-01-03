prompt migr from 25.03.2023 v2.21.0 (2.after_start_dml)
----------------------------------------------------------------------------------------------------
prompt new time kinds
----------------------------------------------------------------------------------------------------
declare
  v_Query varchar2(4000);
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
    r_Time_Kind Htt_Time_Kinds%rowtype;
    v_Parent_Id number;
  begin
    begin
      select *
        into r_Time_Kind
        from Htt_Time_Kinds
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        null;
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
  
    z_Htt_Time_Kinds.Init(p_Row            => r_Time_Kind,
                          i_Company_Id     => i_Company_Id,
                          i_Time_Kind_Id   => Coalesce(r_Time_Kind.Time_Kind_Id,
                                                       Htt_Next.Time_Kind_Id),
                          i_Name           => i_Name,
                          i_Letter_Code    => i_Letter_Code,
                          i_Digital_Code   => i_Digital_Code,
                          i_Parent_Id      => v_Parent_Id,
                          i_Plan_Load      => i_Plan_Load,
                          i_Requestable    => i_Requestable,
                          i_Bg_Color       => i_Bg_Color,
                          i_Color          => i_Color,
                          i_Timesheet_Coef => r_Time_Kind.Timesheet_Coef,
                          i_State          => 'A',
                          i_Pcode          => i_Pcode);
  
    execute immediate v_Query
      using in r_Time_Kind, out r_Time_Kind;
  
    z_Htt_Time_Kinds.Save_Row(r_Time_Kind);
  end;
begin
  Biruni_Route.Context_Begin;

  for r in (select q.Company_Id,
                   q.Lang_Code,
                   (select Q1.User_System
                      from Md_Company_Infos Q1
                     where Q1.Company_Id = q.Company_Id) as User_System,
                   (select Q1.Filial_Head
                      from Md_Company_Infos Q1
                     where Q1.Company_Id = q.Company_Id) as Filial_Head
              from Md_Companies q)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => r.Filial_Head,
                         i_User_Id      => r.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    -- Translate query
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Htt_Time_Kinds,
                                                i_Lang_Code => r.Lang_Code);
  
    -- Turnout time from Adjustment
    Time_Kind(i_Company_Id   => r.Company_Id,
              i_Name         => 'Явка из корректировки',
              i_Letter_Code  => 'ЯК',
              i_Digital_Code => null,
              i_Parent_Pcode => Htt_Pref.c_Pcode_Time_Kind_Turnout,
              i_Plan_Load    => Htt_Pref.c_Plan_Load_Extra,
              i_Requestable  => 'N',
              i_Bg_Color     => null,
              i_Color        => null,
              i_Pcode        => Htt_Pref.c_Pcode_Time_Kind_Turnout_Adjustment);
  
    -- Overtime time from Adjustment
    Time_Kind(i_Company_Id   => r.Company_Id,
              i_Name         => 'Сверхурочныe из корректировки',
              i_Letter_Code  => 'СК',
              i_Digital_Code => null,
              i_Parent_Pcode => Htt_Pref.c_Pcode_Time_Kind_Overtime,
              i_Plan_Load    => Htt_Pref.c_Plan_Load_Extra,
              i_Requestable  => 'N',
              i_Bg_Color     => null,
              i_Color        => null,
              i_Pcode        => Htt_Pref.c_Pcode_Time_Kind_Overtime_Adjustment);
  end loop;

  Biruni_Route.Context_End;
  
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt new journal type added
----------------------------------------------------------------------------------------------------
declare
  v_Query varchar2(4000);
  -------------------------------------------------- 
  Procedure Journal_Type
  (
    i_Company_Id number,
    i_Name       varchar2,
    i_Order_No   number,
    i_Pcode      varchar2
  ) is
    r_Journal_Type Hpd_Journal_Types%rowtype;
  begin
    begin
      select *
        into r_Journal_Type
        from Hpd_Journal_Types
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        null;
    end;
  
    z_Hpd_Journal_Types.Init(p_Row             => r_Journal_Type,
                             i_Company_Id      => i_Company_Id,
                             i_Journal_Type_Id => Coalesce(r_Journal_Type.Journal_Type_Id,
                                                           Hpd_Next.Journal_Type_Id),
                             i_Name            => i_Name,
                             i_Order_No        => i_Order_No,
                             i_Pcode           => i_Pcode);
  
    execute immediate v_Query
      using in r_Journal_Type, out r_Journal_Type;
  
    z_Hpd_Journal_Types.Save_Row(r_Journal_Type);
  end;
begin
  Biruni_Route.Context_Begin;

  for r in (select q.Company_Id,
                   q.Lang_Code,
                   (select Q1.User_System
                      from Md_Company_Infos Q1
                     where Q1.Company_Id = q.Company_Id) as User_System,
                   (select Q1.Filial_Head
                      from Md_Company_Infos Q1
                     where Q1.Company_Id = q.Company_Id) as Filial_Head
              from Md_Companies q)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => r.Filial_Head,
                         i_User_Id      => r.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    -- Translate query
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpd_Journal_Types,
                                                i_Lang_Code => r.Lang_Code);
  
    -- Journal Type
    Journal_Type(i_Company_Id => r.Company_Id,
                 i_Name       => 'Корректировка табеля',
                 i_Order_No   => 16,
                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment);
  end loop;

  Biruni_Route.Context_End;

  commit;
end;
/

