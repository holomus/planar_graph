prompt migr from 01.05.2023 v2.23.1 (2.dml_after_start)
----------------------------------------------------------------------------------------------------
prompt new Device Types
----------------------------------------------------------------------------------------------------
set define off
set serveroutput on
declare
  --------------------------------------------------
  Procedure Device_Type
  (
    i_Name  varchar2,
    i_Pcode varchar2
  ) is
    v_Device_Type_Id number;
  begin
    begin
      select Device_Type_Id
        into v_Device_Type_Id
        from Hac_Device_Types
       where Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Device_Type_Id := Hac_Next.Device_Type_Id;
    end;
  
    z_Hac_Device_Types.Save_One(i_Device_Type_Id => v_Device_Type_Id,
                                i_Name           => i_Name,
                                i_Pcode          => i_Pcode);
  end;
begin
  ----------------------------------------------------------------------------------------------------
  Dbms_Output.Put_Line('==== Device Types ====');
  Device_Type('Verifix Hikvision', Hac_Pref.c_Pcode_Device_Type_Hikvision);
  Device_Type('Verifix Dahua', Hac_Pref.c_Pcode_Device_Type_Dahua);
end;
/

----------------------------------------------------------------------------------------------------
prompt delete 'href:restricted_employee_search' Preferences
----------------------------------------------------------------------------------------------------
declare
  c_Pref_Restricted_Employee_Search constant varchar2(50) := 'href:restricted_employee_search';
begin
  delete from Md_Preferences t
   where t.Pref_Code = c_Pref_Restricted_Employee_Search;
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt new Application_Types
----------------------------------------------------------------------------------------------------
declare
  v_Company_Head     number := Md_Pref.c_Company_Head;
  v_Pcode_Like       varchar2(10) := Upper(Href_Pref.c_Pc_Verifix_Hr) || '%';
  v_Query            varchar2(4000);
  r_Application_Type Hpd_Application_Types%rowtype;

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
begin
  ----------------------------------------------------------------------------------------------------
  -- Fill Application types
  ----------------------------------------------------------------------------------------------------
  Ui_Auth.Logon_As_System(i_Company_Id => v_Company_Head);

  --------------------------------------------------
  Dbms_Output.Put_Line('==== Application Types ====');
  Application_Type('Открытие позиции', 1, Hpd_Pref.c_Pcode_Application_Type_Create_Robot);
  Application_Type('Прием на работу', 2, Hpd_Pref.c_Pcode_Application_Type_Hiring);
  Application_Type('Кадровый перевод', 3, Hpd_Pref.c_Pcode_Application_Type_Transfer);
  Application_Type('Увольнение', 4, Hpd_Pref.c_Pcode_Application_Type_Dismissal);

  --------------------------------------------------
  Dbms_Output.Put_Line('==== Table record translates ====');
  Table_Record_Setting('HPD_APPLICATION_TYPES', 'NAME');

  ----------------------------------------------------------------------------------------------------
  -- Translates
  ----------------------------------------------------------------------------------------------------
  -- RU
  Uis.Table_Record_Translate('HPD_APPLICATION_TYPES', 'VHR:HPD:1', 'NAME', 'ru', 'Открытие позиции');
  Uis.Table_Record_Translate('HPD_APPLICATION_TYPES', 'VHR:HPD:2', 'NAME', 'ru', 'Прием на работу');
  Uis.Table_Record_Translate('HPD_APPLICATION_TYPES', 'VHR:HPD:3', 'NAME', 'ru', 'Кадровый перевод');
  Uis.Table_Record_Translate('HPD_APPLICATION_TYPES', 'VHR:HPD:4', 'NAME', 'ru', 'Увольнение');
  -- EN
  Uis.Table_Record_Translate('HPD_APPLICATION_TYPES', 'VHR:HPD:1', 'NAME', 'en', 'Creating position');
  Uis.Table_Record_Translate('HPD_APPLICATION_TYPES', 'VHR:HPD:2', 'NAME', 'en', 'Hiring');
  Uis.Table_Record_Translate('HPD_APPLICATION_TYPES', 'VHR:HPD:3', 'NAME', 'en', 'HR Transfer');
  Uis.Table_Record_Translate('HPD_APPLICATION_TYPES', 'VHR:HPD:4', 'NAME', 'en', 'Dismissal');

  ----------------------------------------------------------------------------------------------------
  -- add default application types
  ----------------------------------------------------------------------------------------------------
  for c in (select *
              from Md_Companies t
             where t.Company_Id <> v_Company_Head)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => c.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(c.Company_Id),
                         i_User_Id      => Md_Pref.User_System(c.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpd_Application_Types,
                                                i_Lang_Code => c.Lang_Code);

    for r in (select *
                from Hpd_Application_Types t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Order_No)
    loop
      r_Application_Type                     := r;
      r_Application_Type.Company_Id          := c.Company_Id;
      r_Application_Type.Application_Type_Id := Hpd_Next.Application_Type_Id;

      execute immediate v_Query
        using in r_Application_Type, out r_Application_Type;

      z_Hpd_Application_Types.Save_Row(r_Application_Type);
    end loop;
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt application audit start all
----------------------------------------------------------------------------------------------------
declare
  v_Project_Code varchar2(10) := Href_Pref.c_Pc_Verifix_Hr;
begin
  for r in (select *
              from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => v_Project_Code);
  
    Hpd_Audit.Application_Start(r.Company_Id);
  end loop;
end;
/
