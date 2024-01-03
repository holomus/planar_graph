-- MCG_DISCOUNT_CARD_CODE_SQ -- just iterate sequence to max(old, new) value
-- MD_AUDIT_ID_SQ, BIRUNI_CONTEXT_SQ, BIRUNI_MODIFIED_SQ, BIRUNI_JOB_SQ -- reitreate in new schema based on new vals
-- MK_TRANS_NO_SQ - rename MK_TRANS_NO_SQ to MK_TRANSACTIONS_SQ, rename MK_TRANSACTIONS.trans_no to transaction_id ?? (Adham aka)
-- MFG_SPECIFICATION_ITEMS_SQ - propose to anor project owners to restructure sequences as follows: MFG_SPECIFICATION_INPUT_ITEMS_SQ, MFG_SPECIFICATION_OUTPUT_ITEMS_SQ
-- BIRUNI_JOB_SQ -- do not migrate

declare
  v_Global_Max_Audit_Id              number := 0;
  v_Global_Max_Context_Id            number := 0;
  v_Global_Max_Modified_Id           number := 0;
  v_Global_Max_Manufacture_Item_Id   number := 0;
  v_Global_Max_Specification_Item_Id number := 0;

  -------------------------------------------------- 
  -- returns column name in the table related to either its unique constraint #1 or its primary key
  -- throws error if the given table_name has neither of these two. in that case the table should be added to exceptions
  Function Get_Column_Name(i_Table_Name varchar2) return varchar2 is
    v_Unique_Key_Name  varchar2(128) := i_Table_Name || '_U1';
    v_Primary_Key_Name varchar2(128) := i_Table_Name || '_PK';
    v_Column_Name      varchar2(4000);
  begin
    -- get column name used by the unique key 1 of a table (works only if the unique key 1 has only one column)
    begin
      select t.Column_Name
        into v_Column_Name
        from User_Cons_Columns t
       where t.Constraint_Name = v_Unique_Key_Name
         and t.Table_Name = i_Table_Name;
    exception
      when others then
        -- as of 08.02.2023, 6 tables have primary key with single column that satisfies the script logic: 
        -- HTT_SCHEDULE_TEMPLATES_SQ, MD_COMPANY_TEMPLATES_SQ, MD_COMPANY_TEMPLATE_GROUPS_SQ, MD_FEEDBACKS_SQ, MD_QUICKSTART_HEADINGS_SQ, MD_QUICKSTART_STEPS_SQ
        select t.Column_Name
          into v_Column_Name
          from User_Cons_Columns t
         where t.Constraint_Name = v_Primary_Key_Name
           and t.Table_Name = i_Table_Name;
    end;
  
    return v_Column_Name;
  end;

  --------------------------------------------------
  -- returns max value for the given column of the given table
  Function Get_Column_Max
  (
    i_Table_Name  varchar2,
    i_Column_Name varchar2
  ) return number is
    v_Column_Max number;
  begin
    execute immediate 'select nvl(max(t.' || i_Column_Name || ') + 1, 1)
                         from ' || i_Table_Name || ' t'
      into v_Column_Max;
    return v_Column_Max;
  end;

  -------------------------------------------------- 
  -- 
  Procedure Iterate_Sequence
  (
    i_Sequence_Name varchar2,
    i_Table_Name    varchar2 := null,
    i_Column_Name   varchar2 := null,
    i_Column_Max    number := null
  ) is
    v_Table_Name  varchar2(128) := Nvl(i_Table_Name,
                                       Substr(i_Sequence_Name, 0, Length(i_Sequence_Name) - 3));
    v_Column_Max  number;
    v_Column_Name varchar2(4000);
    v_Next_Value  number;
    v_Difference  number;
  begin
    Dbms_Output.Put_Line(i_Sequence_Name);
  
    if i_Column_Max is not null then
      v_Column_Max := i_Column_Max;
    else
      if i_Column_Name is not null then
        v_Column_Name := i_Column_Name;
      else
        v_Column_Name := Get_Column_Name(v_Table_Name);
      end if;
    
      v_Column_Max := Get_Column_Max(v_Table_Name, v_Column_Name);
    end if;
  
    -- next value of the sequence
    execute immediate 'select ' || i_Sequence_Name || '.nextval from dual'
      into v_Next_Value;
  
    -- by how much should the sequence be iterated
    v_Difference := v_Column_Max - v_Next_Value;
  
    if v_Difference > 0 then
      -- iterate sequence
      -- increments it by the needed number and then sets 'increment by' parameter back to 1
      execute immediate 'alter sequence  ' || i_Sequence_Name || ' increment by ' ||
                        to_char(v_Difference);
      execute immediate 'select ' || i_Sequence_Name || '.nextval from dual'
        into v_Next_Value;
      execute immediate 'alter sequence  ' || i_Sequence_Name || ' increment by 1';
    end if;
  end;
begin
  ---------- 
  for r in (select *
              from User_Sequences t
             where t.Sequence_Name not in ( -- 4 sequences below are not iterated
                                           'BIRUNI_LOG_SQ',
                                           'BIRUNI_FINAL_SERVICE_LOG_SQ',
                                           'BIRUNI_APP_SERVER_JOB_LOGS_SQ',
                                           'BIRUNI_JOB_SQ',
                                           -- 6 sequences below exist but not used anywhere, so are not iterated
                                           'MD_LICENSES_SQ',
                                           'MD_TELEGRAM_BOT_MENUS_SQ',
                                           'MKW_PRICES_SQ',
                                           'MK_COA_GROUP_TEMPLATES_SQ',
                                           'MK_COA_TEMPLATES_SQ',
                                           'MS_KANBANS_SQ',
                                           -- the rest of the sequences below are iterated via separate calls to iterate_sequence (they do not fit the main script logic)
                                           -- reiterate 4 below
                                           'BIRUNI_CONTEXT_SQ',
                                           'BIRUNI_MODIFIED_SQ',
                                           'MD_AUDIT_ID_SQ',
                                           'MCG_DISCOUNT_CARD_CODE_SQ', -- mcg_util.generate_discount_code : used to generate a random code, should migr?
                                           
                                           'HLIC_REQUIRED_INTERVALS_SQ',
                                           'HTT_ACMS_COMMANDS_SQ',
                                           'MCG_OVERLOAD_RULE_LOADS_SQ',
                                           'MFK_LOGS_SQ', -- not migrated
                                           'MKCS_REQUEST_PAYMENTS_SQ',
                                           'HREF_BADGE_TEMPLATES_SQ',
                                           'HTT_DEVICE_TYPES_SQ',
                                           'HTT_TERMINAL_MODELS_SQ',
                                           'MD_COMPANIES_SQ',
                                           'MFG_MANUFACTURE_ITEMS_SQ',
                                           'MFG_SPECIFICATION_ITEMS_SQ',
                                           'MKU_INCOME_STATEMENT_GROUPS_SQ',
                                           'MKU_REVALUATIONS_SQ',
                                           'MKW_PURCHASE_REASONS_SQ',
                                           'MK_COA_TWIN_REF_TYPES_SQ',
                                           'MK_TRANS_NO_SQ',
                                           'MQZ_RESULT_QUIZ_PHOTOS_SQ',
                                           'MRF_DATA_ACCESSES_SQ',
                                           'MR_PRODUCERS_SQ'))
  loop
    Iterate_Sequence(r.Sequence_Name);
  end loop;

  ---------- 
  -- sequences that do not fit the main script logic
  Iterate_Sequence(i_Sequence_Name => 'HLIC_REQUIRED_INTERVALS_SQ',
                   i_Table_Name    => 'HLIC_REQUIRED_INTERVALS',
                   i_Column_Name   => 'INTERVAL_ID');
  Iterate_Sequence(i_Sequence_Name => 'HTT_ACMS_COMMANDS_SQ',
                   i_Table_Name    => 'HTT_ACMS_COMMANDS',
                   i_Column_Name   => 'COMMAND_ID');
  Iterate_Sequence(i_Sequence_Name => 'MCG_OVERLOAD_RULE_LOADS_SQ',
                   i_Table_Name    => 'MCG_OVERLOAD_RULE_LOADS',
                   i_Column_Name   => 'LOAD_ID');
  Iterate_Sequence(i_Sequence_Name => 'MFK_LOGS_SQ',
                   i_Table_Name    => 'MFK_LOGS',
                   i_Column_Name   => 'LOG_ID');
  Iterate_Sequence(i_Sequence_Name => 'MKCS_REQUEST_PAYMENTS_SQ',
                   i_Table_Name    => 'MKCS_REQUEST_PAYMENTS',
                   i_Column_Name   => 'REQUEST_PAYMENT_ID');
  Iterate_Sequence(i_Sequence_Name => 'MD_COMPANIES_SQ',
                   i_Table_Name    => 'MD_COMPANIES',
                   i_Column_Name   => 'COMPANY_ID');
  Iterate_Sequence(i_Sequence_Name => 'MKU_INCOME_STATEMENT_GROUPS_SQ',
                   i_Table_Name    => 'MKU_INCOME_STATEMENT_GROUPS',
                   i_Column_Name   => 'GROUP_ID');
  Iterate_Sequence(i_Sequence_Name => 'MKU_REVALUATIONS_SQ',
                   i_Table_Name    => 'MKU_REVALUATIONS',
                   i_Column_Name   => 'REVAL_ID');
  Iterate_Sequence(i_Sequence_Name => 'MKW_PURCHASE_REASONS_SQ',
                   i_Table_Name    => 'MKW_PURCHASE_REQUEST_REASONS',
                   i_Column_Name   => 'REASON_ID');
  Iterate_Sequence(i_Sequence_Name => 'MK_COA_TWIN_REF_TYPES_SQ',
                   i_Table_Name    => 'MKU_COA_TWIN_REF_TYPES',
                   i_Column_Name   => 'REF_TYPE_UNIT_ID');
  Iterate_Sequence(i_Sequence_Name => 'MK_TRANS_NO_SQ',
                   i_Table_Name    => 'MK_TRANSACTIONS',
                   i_Column_Name   => 'TRANS_NO');
  Iterate_Sequence(i_Sequence_Name => 'MQZ_RESULT_QUIZ_PHOTOS_SQ',
                   i_Table_Name    => 'MQZ_RESULT_QUIZ_PHOTOS',
                   i_Column_Name   => 'RESULT_PHOTO_ID');
  Iterate_Sequence(i_Sequence_Name => 'MR_PRODUCERS_SQ',
                   i_Table_Name    => 'MR_PRODUCERS',
                   i_Column_Name   => 'PRODUCER_ID');

  -- 4 tables + sequences below are not iterated during the migr
  -- TODO: remove function calls
  Iterate_Sequence(i_Sequence_Name => 'HREF_BADGE_TEMPLATES_SQ',
                   i_Table_Name    => 'HREF_BADGE_TEMPLATES',
                   i_Column_Name   => 'BADGE_TEMPLATE_ID');
  Iterate_Sequence(i_Sequence_Name => 'HTT_DEVICE_TYPES_SQ',
                   i_Table_Name    => 'HTT_DEVICE_TYPES',
                   i_Column_Name   => 'DEVICE_TYPE_ID');
  Iterate_Sequence(i_Sequence_Name => 'HTT_TERMINAL_MODELS_SQ',
                   i_Table_Name    => 'HTT_TERMINAL_MODELS',
                   i_Column_Name   => 'MODEL_ID');
  Iterate_Sequence(i_Sequence_Name => 'MRF_DATA_ACCESSES_SQ',
                   i_Table_Name    => 'MRF_DATA_ACCESSES',
                   i_Column_Name   => 'DATA_ACCESS_ID');

  ---------- 
  -- MD_AUDIT_ID_SQ, BIRUNI_CONTEXT_SQ: get max t_audit_id and t_context_id from all audit tables
  -- assertion: all X_ tables have t_audit_id and t_context_id column
  for r in (select t.Table_Name
              from User_Tables t
             where t.Table_Name like 'X_%')
  loop
    v_Global_Max_Audit_Id   := Greatest(v_Global_Max_Audit_Id,
                                        Get_Column_Max(r.Table_Name, 'T_AUDIT_ID'));
    v_Global_Max_Context_Id := Greatest(v_Global_Max_Context_Id,
                                        Get_Column_Max(r.Table_Name, 'T_CONTEXT_ID'));
  end loop;

  Iterate_Sequence(i_Sequence_Name => 'MD_AUDIT_ID_SQ', i_Column_Max => v_Global_Max_Audit_Id);
  Iterate_Sequence(i_Sequence_Name => 'BIRUNI_CONTEXT_SQ', i_Column_Max => v_Global_Max_Context_Id);

  ---------- 
  -- BIRUNI_MODIFIED_SQ: get max t_context_id from all audit tables
  -- assertion: all X_ tables have t_context_id column
  for r in (select *
              from User_Tables t
             where exists (select 1
                      from User_Tab_Cols k
                     where k.Table_Name = t.Table_Name
                       and k.Column_Name = 'MODIFIED_ID'))
  loop
    v_Global_Max_Modified_Id := Greatest(v_Global_Max_Modified_Id,
                                         Get_Column_Max(r.Table_Name, 'MODIFIED_ID'));
  end loop;

  Iterate_Sequence(i_Sequence_Name => 'BIRUNI_MODIFIED_SQ',
                   i_Column_Max    => v_Global_Max_Modified_Id);

  ---------- 
  -- MFG_MANUFACTURE_ITEMS_SQ: get max .._item_id from tables MFG_MANUFACTURE_INPUTS and MFG_MANUFACTURE_OUTPUTS
  v_Global_Max_Manufacture_Item_Id := Greatest(Get_Column_Max('MFG_MANUFACTURE_INPUTS',
                                                              'INPUT_ITEM_ID'),
                                               Get_Column_Max('MFG_MANUFACTURE_OUTPUTS',
                                                              'OUTPUT_ITEM_ID'));
  Iterate_Sequence(i_Sequence_Name => 'MFG_MANUFACTURE_ITEMS_SQ',
                   i_Column_Max    => v_Global_Max_Manufacture_Item_Id);

  ---------- 
  -- MFG_SPECIFICATION_ITEMS_SQ: get max .._item_id from tables MFG_SPECIFICATION_INPUTS and MFG_SPECIFICATION_OUTPUTS
  v_Global_Max_Specification_Item_Id := Greatest(Get_Column_Max('MFG_SPECIFICATION_INPUTS',
                                                                'INPUT_ITEM_ID'),
                                                 Get_Column_Max('MFG_SPECIFICATION_OUTPUTS',
                                                                'OUTPUT_ITEM_ID'));
  Iterate_Sequence(i_Sequence_Name => 'MFG_SPECIFICATION_ITEMS_SQ',
                   i_Column_Max    => v_Global_Max_Specification_Item_Id);
end;
