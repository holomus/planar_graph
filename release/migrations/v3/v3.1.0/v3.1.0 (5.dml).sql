prompt adding new journal type
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
declare
  v_Query    varchar2(4000);
  v_Order_No number;
  v_Pcode    varchar2(10) := Hpd_Pref.c_Pcode_Journal_Type_Vacation;

  --------------------------------------------------
  Procedure Get_Order_No(i_Compnay_Id number) is
  begin
    select q.Order_No
      into v_Order_No
      from Hpd_Journal_Types q
     where q.Company_Id = i_Compnay_Id
       and q.Pcode = v_Pcode;
  end;

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
    Get_Order_No(r.Company_Id);

    update Hpd_Journal_Types q
       set q.Order_No = q.Order_No + 1
     where q.Company_Id = r.Company_Id
       and q.Order_No > v_Order_No;

    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => r.Filial_Head,
                         i_User_Id      => r.User_System,
                         i_Project_Code => Verifix_Settings.c_Pc_Verifix_Hr);

    -- Translate query
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpd_Journal_Types,
                                                i_Lang_Code => r.Lang_Code);

    -- Journal Type
    Journal_Type(i_Company_Id => r.Company_Id,
                 i_Name       => 'Отпуск списком',
                 i_Order_No   => v_Order_No + 1,
                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Vacation_Multiple);
  end loop;

  Biruni_Route.Context_End;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt adding easy report template
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id number := Md_Pref.Company_Head;
  v_Filial_Head number := Md_Pref.Filial_Head(v_Company_Id);
  v_User_System number := Md_Pref.User_System(v_Company_Id);
begin
  Biruni_Route.Context_Begin;
  Ui_Context.Init(i_User_Id      => v_User_System,
                  i_Filial_Id    => v_Filial_Head,
                  i_Project_Code => Verifix_Settings.c_Pc_Verifix_Hr);
                  
  Ker_Core.Head_Template_Save(i_Form     => Hpr_Pref.c_Easy_Report_Form_Charge_Document,
                              i_Name     => 'Разовые начисление',
                              i_Order_No => 3,
                              i_Pcode    => 'vhr:hpr:3');
  Biruni_Route.Context_End;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt adding table info
----------------------------------------------------------------------------------------------------
declare
  v_Project_Code varchar2(10) := Verifix_Settings.c_Pc_Verifix_Hr;
  -------------------------------
  Procedure Table_Info
  (
    a varchar2,
    b varchar2,
    c varchar2,
    d varchar2,
    e varchar2,
    f varchar2,
    g varchar2
  ) is
  begin
    z_Md_Table_Infos.Insert_One(i_Table_Name          => a,
                                i_Project_Code        => v_Project_Code,
                                i_Field_Id            => b,
                                i_Field_Name          => c,
                                i_Translate_Procedure => d,
                                i_Uri                 => e,
                                i_Uri_Procedure       => f,
                                i_View_Kind           => g);
  end;
begin
  Table_Info('HPR_CREDITS', 'CREDIT_ID', null, null, '/vhr/hpr/credit_view', null, 'O');

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt adding audit info
----------------------------------------------------------------------------------------------------
declare
  -------------------------------
  Procedure Audit_Info
  (
    a varchar2,
    b varchar2,
    c varchar2,
    d varchar2,
    e varchar2,
    f varchar2
  ) is
  begin
    z_Md_Audit_Infos.Insert_One(i_Table_Name      => a,
                                i_Readonly        => b,
                                i_Parent_Name     => c,
                                i_Start_Procedure => d,
                                i_Stop_Procedure  => e,
                                i_Uri             => f);
  end;
begin
  Audit_Info('HPR_CREDITS',
             'N',
             null,
             'hpr_audit.credit_audit_start',
             'hpr_audit.credit_audit_stop',
             '/vhr/hpr/credit_audit_details');

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt credit audit start
----------------------------------------------------------------------------------------------------
declare
begin
  for r in (select *
              from Md_Companies q
             where q.State = 'A')
  loop
    Ui_Auth.Logon_As_System(r.Company_Id);
    Hpr_Audit.Credit_Audit_Start(r.Company_Id);
  end loop;
  commit;
  Fazo_z.Run('x_hpr_credits');
end;
/
