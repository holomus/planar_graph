prompt adding journal type
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
declare
  v_Query    varchar2(4000);
  v_Order_No number;
  v_Pcode    varchar2(10) := Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave;

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
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);

    -- Translate query
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpd_Journal_Types,
                                                i_Lang_Code => r.Lang_Code);

    -- Journal Type
    Journal_Type(i_Company_Id => r.Company_Id,
                 i_Name       => 'Больничный лист списком',
                 i_Order_No   => v_Order_No + 1,
                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave_Multiple);
  end loop;

  Biruni_Route.Context_End;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt adding easy report for sick leaves
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id number := Md_Pref.Company_Head;
  v_Filial_Head number := Md_Pref.Filial_Head(v_Company_Id);
  v_User_System number := Md_Pref.User_System(v_Company_Id);
begin
  Biruni_Route.Context_Begin;
  Ui_Context.Init(i_User_Id      => v_User_System,
                  i_Filial_Id    => v_Filial_Head,
                  i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);

  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Sick_Leave,
                              i_Name     => 'Больничный',
                              i_Order_No => 8,
                              i_Pcode    => 'vhr:hpd:8');
  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Sick_Leave_Multiple,
                              i_Name     => 'Больничный списком',
                              i_Order_No => 9,
                              i_Pcode    => 'vhr:hpd:9');
  Biruni_Route.Context_End;
  
  commit;
end;
/
