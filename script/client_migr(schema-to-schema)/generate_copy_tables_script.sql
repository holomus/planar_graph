declare
  -- before running, increase buffer size to around 1000000
  -- enter '&company_id' for the value of company_id
  c_Verbose_Mode           boolean := true; -- true: prints all the dynamic queries to the output; false: prints table names only
  v_New_Schema_Name        varchar2(128) := 'VERIFIX_SARDOR'; -- NEW_SCHEMA_NAME
  v_Referential_Constraint varchar2(1) := 'R'; -- referential integrity (FK)
  v_Column_List            varchar2(4000);
begin
  Ui_Context.Init_Migr(i_Company_Id   => Md_Pref.Company_Head,
                       i_Filial_Id    => Md_Pref.Filial_Head(Md_Pref.Company_Head),
                       i_User_Id      => Md_Pref.User_System(Md_Pref.Company_Head),
                       i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);

  Dbms_Output.Put_Line('whenever sqlerror exit sql.sqlcode;');
  Dbms_Output.Put_Line('set define on;');
  Dbms_Output.Put_Line('set serveroutput on;');
  Dbms_Output.Put_Line('undefine company_id');
  Dbms_Output.Put_Line('define company_id=&company_id');
  Dbms_Output.New_Line;

  Dbms_Output.Put_Line('prompt copying table data from old schema to a new one for company_id: &company_id');

  ---------- 
  -- copy biruni_files that are related to the specified company_id
  Dbms_Output.Put_Line('prompt ==== ** BIRUNI_FILES ** ====');
  Dbms_Output.Put_Line('insert into BIRUNI_FILES (SHA, CREATED_ON, FILE_SIZE, FILE_NAME, CONTENT_TYPE) select SHA, CREATED_ON, FILE_SIZE, FILE_NAME, CONTENT_TYPE from OLD_BIRUNI_FILES t where exists (select 1 from OLD_MD_COMPANY_FILES k where k.Company_Id = &company_id and k.Sha = t.Sha);');
  Dbms_Output.Put_Line('commit;');

  ---------- 
  -- copy table data in hierarchical order based on referential constraints
  for r in (with Child_Parent_Relations as
              -- list all relations in following format: 'name of table A, name of table B referenced by table A' 
               (select c.Table_Name, c_Pk.Table_Name Referenced_Table_Name
                 from User_Constraints c
                 join User_Constraints c_Pk
                   on c.r_Owner = c_Pk.Owner
                  and c.r_Constraint_Name = c_Pk.Constraint_Name
                where c.Owner = v_New_Schema_Name
                  and c.Constraint_Type = v_Referential_Constraint),
              Raw_Hierarchical_Data as
               (select t.Table_Name,
                      level              Lvl, -- level in the hierarchy (the smaller the level, the higher is the position of a table)
                      Connect_By_Iscycle Is_Cyclic
                 from Child_Parent_Relations t
               connect by Nocycle prior t.Table_Name = t.Referenced_Table_Name),
              Hierarchy_With_Max_Levels as
               (select distinct t.Table_Name,
                               t.Is_Cyclic,
                               (select max(k.Lvl) -- max level of table in the hierarchy
                                  from Raw_Hierarchical_Data k
                                 where k.Table_Name = t.Table_Name) Max_Lvl
                 from Raw_Hierarchical_Data t)
              select t.Table_Name,
                     Is_Cyclic,
                     k.Max_Lvl,
                     Nvl((select 'Y'
                           from Dual
                          where exists (select 1 -- tables that have company_id column
                                   from User_Tab_Columns w
                                  where w.Table_Name = t.Table_Name
                                    and w.Column_Name = 'COMPANY_ID')),
                         'N') Table_Has_Company_Id_Col
                from User_Tables t
              -- left join used to also include tables that do not have any foreign keys (they are at the top of the hierarchy)
                left join Hierarchy_With_Max_Levels k
                  on t.Table_Name = k.Table_Name
               where t.Table_Name not like 'X_%'
                 and t.Table_Name not like 'BIRUNI_%'
                 and t.Table_Name not in -- system-wide tables with default values (not copied from OLD schema)
                     ('HREF_BADGE_TEMPLATES',
                      'HTT_DEVICE_TYPES',
                      'KL_LICENSING_SETTINGS',
                      'KTB_SETTINGS',
                      'MD_AUDIT_INFOS',
                      'MD_ACTUAL_AUDITS',
                      'MD_COMPANY_HEAD_FORMS',
                      'MD_FORM_SIBLINGS',
                      'MD_LANGS',
                      'MD_LICENSES',
                      'MD_MENU_FORMS',
                      'MD_MENUS',
                      'MD_MODULE_DEPENDENCIES',
                      'MD_MODULE_FORMS',
                      'MD_MODULES',
                      'MD_NON_SUBSCRIPTION_FORMS',
                      'MD_OVERRIDED_FORMS',
                      'MD_PATHS',
                      'MD_PROJECTS',
                      'MD_READY_FORMS',
                      'MD_RELEASE_FORMS',
                      'MD_SEARCH_SOURCES',
                      'MD_TABLE_INFOS',
                      'MD_TABLE_RECORD_TRANSLATES',
                      'MD_TABLE_RECORD_TRANSLATE_SETTINGS',
                      'MD_TIMEZONES',
                      'MKCS_COMPANY_BANK_TEMPLATES',
                      'MK_CURRENCY_TEMPLATES',
                      'MK_SETTINGS',
                      'MKU_INCOME_STATEMENT_GROUP_TEMPLATES',
                      'MRF_DATA_ACCESSES',
                      'HTT_TERMINAL_MODELS',
                      'MD_FORMS',
                      'MD_QUICKSTART_HEADINGS',
                      'MK_REF_TYPES',
                      'MT_TAPES',
                      'MT_TRANSLATE_CODES',
                      'MD_FORM_ACTIONS',
                      'MD_FORM_TYPE_BINDS',
                      'MD_QUICKSTART_STEPS',
                      'MK_COMPANY_COA_GROUP_TEMPLATES',
                      'MKR_REF_ORIGINS',
                      'MT_PROJECT_TAPES',
                      'MK_COMPANY_COA_TEMPLATES',
                      'MKCS_COMPANY_CASHFLOW_REASON_TEMPLATES',
                      'MKR_COMPANY_COA_DEFAULT_TEMPLATES',
                      'MKR_COMPANY_COA_REF_TYPE_TEMPLATES',
                      'MKU_COMPANY_COA_TWIN_TEMPLATES',
                      'MKU_INCOME_STATEMENT_COA_TEMPLATES',
                      'MKW_COMPANY_CORR_TEMPLATES',
                      'MKW_COMPANY_PURCHASE_CORR_TEMPLATES',
                      'MD_REGISTER_TABLES',
                      'MD_LOGS')
                 and t.Temporary = 'N'
                 and not exists (select 1
                        from User_Mviews s
                       where s.Owner = v_New_Schema_Name
                         and s.Mview_Name = t.Table_Name)
               order by Max_Lvl nulls first, -- nulls first to bring tables with no foreign keys to the top
                        t.Table_Name -- for readability
            )
  loop
    -- concate the names of columns of the table to v_Column_List string
    -- listagg threw ORA-01489 as the concatenated string was too long, that's why manual concatenation is implemented
    for Rj in (select t.Column_Name
                 from User_Tab_Cols t
                where t.Table_Name = r.Table_Name
                  and t.Virtual_Column = 'NO'
                  and t.User_Generated = 'YES'
                order by t.Column_Id)
    loop
      if v_Column_List is not null then
        -- not the first column
        v_Column_List := v_Column_List || ', ';
      end if;
    
      v_Column_List := v_Column_List || Rj.Column_Name;
    end loop;
  
    Dbms_Output.Put_Line('prompt ==== ** ' || r.Table_Name || ' ** ====');
  
    if r.Table_Has_Company_Id_Col = 'Y' then
      if c_Verbose_Mode then
        Dbms_Output.Put_Line('insert into ' || r.Table_Name || ' (' || v_Column_List ||
                             ') select ' || v_Column_List || ' from OLD_' || r.Table_Name ||
                             ' t where t.company_id = &company_id;');
        Dbms_Output.Put_Line('commit;');
      else
        Dbms_Output.Put_Line(r.Table_Name);
      end if;
    else
      if c_Verbose_Mode then
        Dbms_Output.Put_Line('insert into ' || r.Table_Name || ' (' || v_Column_List ||
                             ') select ' || v_Column_List || ' from OLD_' || r.Table_Name || ' t;');
        Dbms_Output.Put_Line('commit;');
      else
        Dbms_Output.Put_Line(r.Table_Name);
      end if;
    end if;
  
    v_Column_List := null;
  end loop;

  ---------- 
  -- copy X_% (audit) tables
  for r in (select t.Table_Name
              from User_Tables t
             where t.Table_Name like 'X_%'
               and t.Temporary = 'N')
  loop
    -- assertion: audit tables do not have virtual columns
    for Rj in (select t.Column_Name
                 from User_Tab_Cols t
                where t.Table_Name = r.Table_Name
                order by t.Column_Id)
    loop
      if v_Column_List is not null then
        -- not the first column
        v_Column_List := v_Column_List || ', ';
      end if;
    
      v_Column_List := v_Column_List || Rj.Column_Name;
    end loop;
  
    Dbms_Output.Put_Line('prompt ==== ** ' || r.Table_Name || ' ** ====');
  
    -- assertion: audit tables all have T_COMPANY_ID column
    if c_Verbose_Mode then
      Dbms_Output.Put_Line('insert into ' || r.Table_Name || ' (' || v_Column_List || ') select ' ||
                           v_Column_List || ' from OLD_' || r.Table_Name ||
                           ' t where t.t_company_id = &company_id;');
      Dbms_Output.Put_Line('commit;');
    else
      Dbms_Output.Put_Line(r.Table_Name);
    end if;
  
    v_Column_List := null;
  end loop;
end;
/
