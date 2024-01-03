prompt migr from 01.12.2022 (1.after_start_dml)
----------------------------------------------------------------------------------------------------
prompt move pcode of hpr_oper_types to mpr_oper_types
----------------------------------------------------------------------------------------------------
declare
begin
  for Cmp in (select c.Company_Id,
                     c.Lang_Code,
                     (select Ci.Filial_Head
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as Filial_Head,
                     (select Ci.User_System
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as User_System
                from Md_Companies c)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                         i_Filial_Id    => Cmp.Filial_Head,
                         i_User_Id      => Cmp.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);

    update Mpr_Oper_Types q
       set q.Pcode =
           (select o.Pcode
              from Hpr_Oper_Types o
             where o.Company_Id = Cmp.Company_Id
               and o.Oper_Type_Id = q.Oper_Type_Id)
     where q.Company_Id = Cmp.Company_Id
       and q.Oper_Type_Id in (select o.Oper_Type_Id
                                from Hpr_Oper_Types o
                               where o.Company_Id = Cmp.Company_Id
                                 and o.Pcode is not null);
  end loop;

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt update Md_Table_Record_Translate_Settings for HREF_INDICATORS
----------------------------------------------------------------------------------------------------
declare
begin
  z_Md_Table_Record_Translate_Settings.Save_One(i_Table_Name => 'HREF_INDICATORS',
                                                i_Column_Set => 'NAME,SHORT_NAME,IDENTIFIER');

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt update system data names
----------------------------------------------------------------------------------------------------
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  v_Pcode_Like   varchar2(10) := Upper(Href_Pref.c_Pc_Verifix_Hr) || '%';
  v_Query        varchar2(32767);
  v_Tables       Array_Varchar2;
  v_Column_Names Array_Varchar2;
  v_With_Filial  Array_Varchar2;

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

      Href_Api.Indicator_Save(r_Data);
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
  v_Tables := Array_Varchar2(Zt.Hpd_Journal_Types.Name,
                             Zt.Ms_Task_Groups.Name,
                             Zt.Hpr_Oper_Groups.Name,
                             Zt.Hpr_Book_Types.Name,
                             Zt.Md_Roles.Name,
                             Zt.Href_Document_Types.Name,
                             Zt.Href_Ftes.Name,
                             Zt.Htt_Calendars.Name,
                             Zt.Htt_Request_Kinds.Name,
                             Zt.Htt_Schedules.Name);

  v_Column_Names := Array_Varchar2(z.Journal_Type_Id,
                                   z.Task_Group_Id,
                                   z.Oper_Group_Id,
                                   z.Book_Type_Id,
                                   z.Role_Id,
                                   z.Doc_Type_Id,
                                   z.Fte_Id,
                                   z.Calendar_Id,
                                   z.Request_Kind_Id,
                                   z.Schedule_Id);

  v_With_Filial := Array_Varchar2('N', 'N', 'N', 'N', 'N', 'N', 'N', 'Y', 'N', 'Y');

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

    for i in 1 .. v_Tables.Count
    loop
      v_Query := 'declare' || Chr(10) || --
                 '  v_query varchar2(32767);' || Chr(10) || --
                 '  r_data ' || v_Tables(i) || '%rowtype;' || Chr(10) || --
                 'begin' || Chr(10) || --
                 '  v_query := md_util.translate_rows_statement(i_table => zt.' || v_Tables(i) ||
                 ', i_lang_code => ''' || Cmp.Lang_Code || ''');' || Chr(10) || --
                 '' || Chr(10) || --
                 '  for r in (select *' || Chr(10) || --
                 '              from ' || v_Tables(i) || ' t' || Chr(10) || --
                 '             where t.company_id = ' || Cmp.Company_Id || Chr(10) || --
                 '               and t.pcode like ''' || v_Pcode_Like || ''')' || Chr(10) || --
                 '  loop' || Chr(10) || --
                 '    r_data := r;' || Chr(10) || --
                 '' || Chr(10) || --
                 '    execute immediate v_query' || Chr(10) || --
                 '     using in r_data, out r_data;' || Chr(10) || --
                 '' || Chr(10) || --
                 '    z_' || v_Tables(i) || '.update_one(i_company_id => r_data.company_id,' ||
                 Chr(10);

      if v_With_Filial(i) = 'Y' then
        v_Query := v_Query || --
                   '                        i_filial_id => r_data.filial_id,' || Chr(10);
      end if;

      v_Query := v_Query || --
                 '                           i_' || v_Column_Names(i) || ' => r_data.' ||
                 v_Column_Names(i) || ',' || Chr(10) || --
                 '                           i_name => option_varchar2(r_data.name));' || Chr(10) || --
                 '  end loop;' || Chr(10) || --
                 'end;';

      begin
        execute immediate v_Query;
      exception
        when others then
          b.Raise_Error(Fazo.Trimmed_Sqlerrm || Chr(10) || v_Tables(i));
      end;
    end loop;

    Indicators(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
    Oper_Types(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
    Time_Kinds(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
  end loop;

  Biruni_Route.Context_End;

  commit;
end;
/
