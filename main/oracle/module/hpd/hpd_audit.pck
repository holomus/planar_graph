create or replace package Hpd_Audit is
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Start(i_Company_Id number);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Application_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
end Hpd_Audit;
/
create or replace package body Hpd_Audit is
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Start(i_Company_Id number) is
  begin
    -- journal
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_JOURNALS',
                           i_Column_List => 'JOURNAL_ID,JOURNAL_TYPE_ID,JOURNAL_NUMBER,JOURNAL_DATE,JOURNAL_NAME,POSTED');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_JOURNALS_I1',
                              i_Table_Name  => 'HPD_JOURNALS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,JOURNAL_ID,T_CONTEXT_ID');
    -- journal_pages
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_JOURNAL_PAGES',
                           i_Column_List => 'JOURNAL_ID,PAGE_ID,EMPLOYEE_ID,STAFF_ID',
                           i_Parent_Name => 'HPD_JOURNALS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_JOURNAL_PAGES_I1',
                              i_Table_Name  => 'HPD_JOURNAL_PAGES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,JOURNAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_JOURNAL_PAGES_I2',
                              i_Table_Name  => 'HPD_JOURNAL_PAGES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,JOURNAL_ID,PAGE_ID,T_CONTEXT_ID');
    -- page_robots
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_PAGE_ROBOTS',
                           i_Column_List => 'PAGE_ID,ROBOT_ID,RANK_ID,EMPLOYMENT_TYPE,FTE',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_ROBOTS_I1',
                              i_Table_Name  => 'HPD_PAGE_ROBOTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_ROBOTS_I2',
                              i_Table_Name  => 'HPD_PAGE_ROBOTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');
    -- page_contract
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_PAGE_CONTRACTS',
                           i_Column_List => 'PAGE_ID,CONTRACT_NUMBER,CONTRACT_DATE,FIXED_TERM,EXPIRY_DATE,FIXED_TERM_BASE_ID,CONCLUDING_TERM,HIRING_CONDITIONS,OTHER_CONDITIONS,WORKPLACE_EQUIPMENT,REPRESENTATIVE_BASIS',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_CONTRACTS_I1',
                              i_Table_Name  => 'HPD_PAGE_CONTRACTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_CONTRACTS_I2',
                              i_Table_Name  => 'HPD_PAGE_CONTRACTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');
    -- page_schedules
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_PAGE_SCHEDULES',
                           i_Column_List => 'PAGE_ID,SCHEDULE_ID',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_SCHEDULES_I1',
                              i_Table_Name  => 'HPD_PAGE_SCHEDULES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_SCHEDULES_I2',
                              i_Table_Name  => 'HPD_PAGE_SCHEDULES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');
    -- page_oper_types
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_PAGE_OPER_TYPES',
                           i_Column_List => 'PAGE_ID,OPER_TYPE_ID',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_OPER_TYPES_I1',
                              i_Table_Name  => 'HPD_PAGE_OPER_TYPES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_OPER_TYPES_I2',
                              i_Table_Name  => 'HPD_PAGE_OPER_TYPES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,OPER_TYPE_ID,T_TIMESTAMP');
    -- oper_type_indicators
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_OPER_TYPE_INDICATORS',
                           i_Column_List => 'PAGE_ID,OPER_TYPE_ID,INDICATOR_ID',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_OPER_TYPE_INDICATORS_I1',
                              i_Table_Name  => 'HPD_OPER_TYPE_INDICATORS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,OPER_TYPE_ID,T_CONTEXT_ID');
    -- page_indicators
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_PAGE_INDICATORS',
                           i_Column_List => 'PAGE_ID,INDICATOR_ID,INDICATOR_VALUE',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_INDICATORS_I1',
                              i_Table_Name  => 'HPD_PAGE_INDICATORS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_INDICATORS_I2',
                              i_Table_Name  => 'HPD_PAGE_INDICATORS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,INDICATOR_ID,T_TIMESTAMP');
    -- page currecnies
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_PAGE_CURRENCIES',
                           i_Column_List => 'PAGE_ID,CURRENCY_ID',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_CURRENCIES_I1',
                              i_Table_Name  => 'HPD_PAGE_CURRENCIES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_CURRENCIES_I2',
                              i_Table_Name  => 'HPD_PAGE_CURRENCIES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');
  
    -- hirings
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_HIRINGS',
                           i_Column_List => 'PAGE_ID,HIRING_DATE,TRIAL_PERIOD,EMPLOYMENT_SOURCE_ID',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_HIRINGS_I1',
                              i_Table_Name  => 'HPD_HIRINGS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_HIRINGS_I2',
                              i_Table_Name  => 'HPD_HIRINGS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');
    -- transfers
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_TRANSFERS',
                           i_Column_List => 'PAGE_ID,TRANSFER_BEGIN,TRANSFER_END,TRANSFER_REASON,TRANSFER_BASE',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_TRANSFERS_I1',
                              i_Table_Name  => 'HPD_TRANSFERS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_TRANSFERS_I2',
                              i_Table_Name  => 'HPD_TRANSFERS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');
    -- dismissal
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_DISMISSALS',
                           i_Column_List => 'PAGE_ID,DISMISSAL_DATE,DISMISSAL_REASON_ID,EMPLOYMENT_SOURCE_ID,BASED_ON_DOC,NOTE',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_DISMISSALS_I1',
                              i_Table_Name  => 'HPD_DISMISSALS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_DISMISSALS_I2',
                              i_Table_Name  => 'HPD_DISMISSALS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');
    -- wage_changes
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_WAGE_CHANGES',
                           i_Column_List => 'PAGE_ID,CHANGE_DATE',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_WAGE_CHANGES_I1',
                              i_Table_Name  => 'HPD_WAGE_CHANGES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_WAGE_CHANGES_I2',
                              i_Table_Name  => 'HPD_WAGE_CHANGES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');
    -- rank_changes
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_RANK_CHANGES',
                           i_Column_List => 'PAGE_ID,CHANGE_DATE,RANK_ID',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_RANK_CHANGES_I1',
                              i_Table_Name  => 'HPD_RANK_CHANGES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_RANK_CHANGES_I2',
                              i_Table_Name  => 'HPD_RANK_CHANGES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');
    -- schedule_changes
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_SCHEDULE_CHANGES',
                           i_Column_List => 'JOURNAL_ID,DIVISION_ID,BEGIN_DATE,END_DATE',
                           i_Parent_Name => 'HPD_JOURNALS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_SCHEDULE_CHANGES_I1',
                              i_Table_Name  => 'HPD_SCHEDULE_CHANGES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,JOURNAL_ID,T_CONTEXT_ID');
    -- vacations
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_VACATIONS',
                           i_Column_List => 'TIMEOFF_ID,TIME_KIND_ID',
                           i_Parent_Name => 'HPD_JOURNAL_TIMEOFFS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_VACATIONS_I1',
                              i_Table_Name  => 'HPD_VACATIONS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_VACATIONS_I2',
                              i_Table_Name  => 'HPD_VACATIONS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,TIMEOFF_ID,T_CONTEXT_ID');
    -- vacation_limit_changes
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_VACATION_LIMIT_CHANGES',
                           i_Column_List => 'JOURNAL_ID,DIVISION_ID,CHANGE_DATE,DAYS_LIMIT',
                           i_Parent_Name => 'HPD_JOURNALS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_VACATION_LIMIT_CHANGES_I1',
                              i_Table_Name  => 'HPD_VACATION_LIMIT_CHANGES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,JOURNAL_ID,T_CONTEXT_ID');
    -- journal_timeoffs
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_JOURNAL_TIMEOFFS',
                           i_Column_List => 'TIMEOFF_ID,JOURNAL_ID,EMPLOYEE_ID,STAFF_ID,BEGIN_DATE,END_DATE',
                           i_Parent_Name => 'HPD_JOURNALS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_JOURNAL_TIMEOFFS_I1',
                              i_Table_Name  => 'HPD_JOURNAL_TIMEOFFS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,JOURNAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_JOURNAL_TIMEOFFS_I2',
                              i_Table_Name  => 'HPD_JOURNAL_TIMEOFFS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,JOURNAL_ID,TIMEOFF_ID,T_TIMESTAMP');
    -- sick_leaves
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_SICK_LEAVES',
                           i_Column_List => 'TIMEOFF_ID,REASON_ID,COEFFICIENT,SICK_LEAVE_NUMBER',
                           i_Parent_Name => 'HPD_JOURNAL_TIMEOFFS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_SICK_LEAVES_I1',
                              i_Table_Name  => 'HPD_SICK_LEAVES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_SICK_LEAVES_I2',
                              i_Table_Name  => 'HPD_SICK_LEAVES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,TIMEOFF_ID,T_TIMESTAMP');
    -- businnes_trips
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_BUSINESS_TRIPS',
                           i_Column_List => 'TIMEOFF_ID,PERSON_ID,REASON_ID,NOTE',
                           i_Parent_Name => 'HPD_JOURNAL_TIMEOFFS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_BUSINESS_TRIPS_I1',
                              i_Table_Name  => 'HPD_BUSINESS_TRIPS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_BUSINESS_TRIPS_I2',
                              i_Table_Name  => 'HPD_BUSINESS_TRIPS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,TIMEOFF_ID,T_TIMESTAMP');
    -- business_trip_regions
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_BUSINESS_TRIP_REGIONS',
                           i_Column_List => 'TIMEOFF_ID,REGION_ID,ORDER_NO',
                           i_Parent_Name => 'HPD_JOURNAL_TIMEOFFS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_BUSINESS_TRIP_REGIONS_I1',
                              i_Table_Name  => 'HPD_BUSINESS_TRIP_REGIONS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_BUSINESS_TRIP_REGIONS_I2',
                              i_Table_Name  => 'HPD_BUSINESS_TRIP_REGIONS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,TIMEOFF_ID,REGION_ID,ORDER_NO,T_TIMESTAMP');
  
    -- overtimes
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_JOURNAL_OVERTIMES',
                           i_Column_List => 'OVERTIME_ID,JOURNAL_ID,EMPLOYEE_ID,STAFF_ID,BEGIN_DATE,END_DATE',
                           i_Parent_Name => 'HPD_JOURNALS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_JOURNAL_OVERTIMES_I1',
                              i_Table_Name  => 'HPD_JOURNAL_OVERTIMES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_JOURNAL_OVERTIMES_I2',
                              i_Table_Name  => 'HPD_JOURNAL_OVERTIMES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,JOURNAL_ID,OVERTIME_ID');
  
    -- overtime_days
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_OVERTIME_DAYS',
                           i_Column_List => 'STAFF_ID,OVERTIME_DATE,OVERTIME_SECONDS,OVERTIME_ID',
                           i_Parent_Name => 'HPD_JOURNAL_OVERTIMES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_OVERTIME_DAYS_I1',
                              i_Table_Name  => 'HPD_OVERTIME_DAYS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_OVERTIME_DAYS_I2',
                              i_Table_Name  => 'HPD_OVERTIME_DAYS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,OVERTIME_ID,OVERTIME_DATE');
  
    -- timebook_adjustment
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_PAGE_ADJUSTMENTS',
                           i_Column_List => 'PAGE_ID,FREE_TIME,OVERTIME,TURNOUT_TIME',
                           i_Parent_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_ADJUSTMENTS_I1',
                              i_Table_Name  => 'HPD_PAGE_ADJUSTMENTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_PAGE_ADJUSTMENTS_I2',
                              i_Table_Name  => 'HPD_PAGE_ADJUSTMENTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PAGE_ID,T_TIMESTAMP');
  
    -- timeoff_files
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_TIMEOFF_FILES',
                           i_Column_List => 'TIMEOFF_ID,SHA',
                           i_Parent_Name => 'HPD_JOURNAL_TIMEOFFS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_TIMEOFF_FILES_I1',
                              i_Table_Name  => 'HPD_TIMEOFF_FILES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_TIMEOFF_FILES_I2',
                              i_Table_Name  => 'HPD_TIMEOFF_FILES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,TIMEOFF_ID,SHA,T_TIMESTAMP');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Journal_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_JOURNALS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_JOURNAL_PAGES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_PAGE_ROBOTS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_PAGE_CONTRACTS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_PAGE_SCHEDULES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_PAGE_OPER_TYPES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_OPER_TYPE_INDICATORS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_PAGE_INDICATORS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_HIRINGS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_TRANSFERS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_DISMISSALS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_WAGE_CHANGES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_RANK_CHANGES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_SCHEDULE_CHANGES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id,
                          i_Table_Name => 'HPD_VACATION_LIMIT_CHANGES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_JOURNAL_TIMEOFFS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_SICK_LEAVES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_BUSINESS_TRIPS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_JOURNAL_OVERTIMES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_OVERTIME_DAYS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_PAGE_ADJUSTMENTS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_TIMEOFF_FILES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Start(i_Company_Id number) is
  begin
    -- Application
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_APPLICATIONS',
                           i_Column_List => 'APPLICATION_ID,APPLICATION_TYPE_ID,APPLICATION_NUMBER,APPLICATION_DATE,STATUS,CLOSING_NOTE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_APPLICATIONS_I1',
                              i_Table_Name  => 'HPD_APPLICATIONS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,APPLICATION_ID,T_CONTEXT_ID');
    -- Create Robot
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_APPLICATION_CREATE_ROBOTS',
                           i_Column_List => 'APPLICATION_ID,NAME,OPENED_DATE,DIVISION_ID,JOB_ID,QUANTITY,NOTE',
                           i_Parent_Name => 'HPD_APPLICATIONS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_APPLICATION_CREATE_ROBOTS_I1',
                              i_Table_Name  => 'HPD_APPLICATION_CREATE_ROBOTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,APPLICATION_ID,T_CONTEXT_ID');
    -- Hiring
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_APPLICATION_HIRINGS',
                           i_Column_List => 'APPLICATION_ID,EMPLOYEE_ID,HIRING_DATE,ROBOT_ID,NOTE,FIRST_NAME,LAST_NAME,MIDDLE_NAME,BIRTHDAY,GENDER,PHONE,EMAIL,PHOTO_SHA,ADDRESS,LEGAL_ADDRESS,REGION_ID,PASSPORT_SERIES,PASSPORT_NUMBER,NPIN,IAPA,EMPLOYMENT_TYPE',
                           i_Parent_Name => 'HPD_APPLICATIONS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_APPLICATION_HIRINGS_I1',
                              i_Table_Name  => 'HPD_APPLICATION_HIRINGS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,APPLICATION_ID,T_CONTEXT_ID');
    -- Transfer
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_APPLICATION_TRANSFERS',
                           i_Column_List => 'APPLICATION_ID,STAFF_ID,TRANSFER_BEGIN,ROBOT_ID,NOTE',
                           i_Parent_Name => 'HPD_APPLICATIONS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_APPLICATION_TRANSFERS_I1',
                              i_Table_Name  => 'HPD_APPLICATION_TRANSFERS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,APPLICATION_ID,T_CONTEXT_ID');
    -- Dismissal
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_APPLICATION_DISMISSALS',
                           i_Column_List => 'APPLICATION_ID,STAFF_ID,DISMISSAL_DATE,DISMISSAL_REASON_ID,NOTE',
                           i_Parent_Name => 'HPD_APPLICATIONS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_APPLICATION_DISMISSALS_I1',
                              i_Table_Name  => 'HPD_APPLICATION_DISMISSALS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,APPLICATION_ID,T_CONTEXT_ID');
    -- Created Robot
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_APPLICATION_ROBOTS',
                           i_Column_List => 'APPLICATION_ID,ROBOT_ID,CREATED_BY,CREATED_ON',
                           i_Parent_Name => 'HPD_APPLICATION_CREATE_ROBOTS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_APPLICATION_ROBOTS_I1',
                              i_Table_Name  => 'HPD_APPLICATION_ROBOTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,APPLICATION_ID,T_CONTEXT_ID');
    -- journal
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPD_APPLICATION_JOURNALS',
                           i_Column_List => 'APPLICATION_ID,JOURNAL_ID,CREATED_BY,CREATED_ON,MODIFIED_BY,MODIFIED_ON',
                           i_Parent_Name => 'HPD_APPLICATIONS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPD_APPLICATION_JOURNALS_I1',
                              i_Table_Name  => 'HPD_APPLICATION_JOURNALS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,APPLICATION_ID,T_CONTEXT_ID');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Application_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_APPLICATIONS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id,
                          i_Table_Name => 'HPD_APPLICATION_CREATE_ROBOTS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_APPLICATION_HIRINGS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id,
                          i_Table_Name => 'HPD_APPLICATION_TRANSFERS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id,
                          i_Table_Name => 'HPD_APPLICATION_DISMISSALS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_APPLICATION_ROBOTS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPD_APPLICATION_JOURNALS');
  end;

end Hpd_Audit;
/
