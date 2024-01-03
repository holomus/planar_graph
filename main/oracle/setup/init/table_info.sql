prompt core table info
declare
  v_project_code varchar2(10) := Verifix.Project_Code;
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
delete md_table_infos t
 where t.project_code = v_project_code;
----------------------------------------------------------------------------------------------------
-- table_name, field_id, field_name, translate_procedure, uri, uri_procedure, view_kind
dbms_output.put_line('==== Table info ====');
table_info('HTT_REQUESTS','REQUEST_ID',null,'HTT_UTIL.TNAME_REQUEST','/vhr/htt/request_view',null,'O');
table_info('HTT_PLAN_CHANGES','CHANGE_ID',null,'HTT_UTIL.TNAME_CHANGE','/vhr/htt/change_view',null,'O');
table_info('HTT_LOCATION_TYPES','LOCATION_TYPE_ID','NAME',null,'vhr/href/view/location_type_view',null,'A');
table_info('HTT_LOCATIONS','LOCATION_ID','NAME',null,'vhr/href/view/location_view',null,'A');
table_info('HTT_TIME_KINDS','TIME_KIND_ID','NAME',null,'vhr/href/view/time_kind_view',null,'A');
table_info('HTT_REQUEST_KINDS','REQUEST_KIND_ID','NAME',null,'vhr/href/view/request_kind_view',null,'A');
table_info('HTT_TRACKS','TRACK_ID',null,'HTT_UTIL.TNAME_TRACK','/vhr/htt/track_view',null,'A');
table_info('HLN_QUESTION_GROUPS','QUESTION_GROUP_ID','NAME',null,'vhr/hln/view/question_group_view',null,'O');
table_info('HLN_QUESTION_TYPES','QUESTION_TYPE_ID','NAME',null,'vhr/hln/view/question_type_view',null,'O');
table_info('HLN_TRAINING_SUBJECTS','SUBJECT_ID','NAME',null,'vhr/hln/view/training_subject_view',null,'O');
table_info('HPD_JOURNALS','JOURNAL_ID','JOURNAL_NAME',null,null,'HPD_UTIL.TABLE_URI_JOURNAL','O'); 
table_info('HPD_JOURNAL_PAGES','PAGE_ID',null,'HPD_UTIL.TNAME_PAGE',null,'HPD_UTIL.TABLE_URI_PAGE','O');
table_info('HPD_JOURNAL_TIMEOFFS','TIMEOFF_ID',null,'HPD_UTIL.TNAME_TIMEOFFS',null,'HPD_UTIL.TABLE_URI_TIMEOFF','O');
table_info('HPD_JOURNAL_OVERTIMES','OVERTIME_ID',null,'HPD_UTIL.TNAME_OVERTIME',null,'HPD_UTIL.TABLE_URI_OVERTIME','O');
table_info('HPD_APPLICATIONS','APPLICATION_ID','APPLICATION_NUMBER',null,null,null,'O');
table_info('HPD_APPLICATION_CREATE_ROBOTS','APPLICATION_ID',null,null,null,null,'O');
table_info('HPER_STAFF_PLANS','STAFF_PLAN_ID','HPER_UTIL.TNAME_STAFF_PLANS',null,'vhr/hper/audit/staff_plan_audit',null,'O');
table_info('HPER_PLAN_GROUPS','PLAN_GROUP_ID','NAME',null,'VHR/HPER/VIEW/PLAN_GROUP_VIEW',null,'O');
table_info('HPER_PLAN_TYPES','PLAN_TYPE_ID','NAME',null,'VHR/HPER/VIEW/PLAN_TYPE_VIEW',null,'O');
table_info('HREF_EDU_STAGES','EDU_STAGE_ID','NAME',null,'vhr/href/view/edu_stage_view',null,'A');
table_info('HREF_SCIENCE_BRANCHES','SCIENCE_BRANCH_ID','NAME',null,'vhr/href/view/science_branch_view',null,'A');
table_info('HREF_INSTITUTIONS','INSTITUTION_ID','NAME',null,'vhr/href/view/institution_view',null,'A');
table_info('HREF_SPECIALTIES','SPECIALTY_ID','NAME',null,'vhr/href/view/specialty_view',null,'A');
table_info('HREF_LANGS','LANG_ID','NAME',null,'vhr/href/view/lang_view',null,'A');
table_info('HREF_LANG_LEVELS','LANG_LEVEL_ID','NAME',null,'vhr/href/view/lang_level_view',null,'A');
table_info('HREF_DOCUMENT_TYPES','DOC_TYPE_ID','NAME',null,'vhr/href/view/document_type_view',null,'A');
table_info('HREF_REFERENCE_TYPES','REFERENCE_TYPE_ID','NAME',null,'vhr/href/view/reference_type_view',null,'A');
table_info('HREF_RELATION_DEGREES','RELATION_DEGREE_ID','NAME',null,'vhr/href/view/relation_degree_view',null,'A');
table_info('HREF_MARITAL_STATUSES','MARITAL_STATUS_ID','NAME',null,'vhr/href/view/marital_status_view',null,'A');
table_info('HREF_EXPERIENCE_TYPES','EXPERIENCE_TYPE_ID','NAME',null,'vhr/href/view/experience_type_view',null,'A');
table_info('HREF_AWARDS','AWARD_ID','NAME',null,'vhr/href/view/award_view',null,'A');
table_info('HREF_LABOR_FUNCTIONS','LABOR_FUNCTION_ID','NAME',null,'vhr/href/view/labor_function_view',null,'A');
table_info('HREF_SICK_LEAVE_REASONS','REASON_ID','NAME',null,'vhr/href/view/sick_leave_reason_view',null,'O');
table_info('HREF_BUSINESS_TRIP_REASONS','REASON_ID','NAME',null,'vhr/href/view/business_trip_reason_view',null,'O');
table_info('HREF_DISMISSAL_REASONS','DISMISSAL_REASON_ID','NAME',null,'vhr/href/view/dismissal_reason_view',null,'A');
table_info('HREF_WAGES','WAGE_ID','NAME',null,'vhr/href/view/wage_view',null,'O');
table_info('HREF_EMPLOYMENT_SOURCES','SOURCE_ID','NAME',null,'vhr/href/view/employment_source_view',null,'A');
table_info('HREF_INDICATORS','INDICATOR_ID','NAME',null,'vhr/href/view/indicator_view',null,'A');
table_info('HREF_FTES','FTE_ID','NAME',null,'vhr/href/view/fte_view',null,'A');
table_info('HREF_PERSON_DETAILS','PERSON_ID',null,null,'/vhr/href/employee/employee',null,'A');
table_info('HRM_ROBOTS', 'ROBOT_ID', null, null, '/vhr/hrm/robot_view', null, 'O');
table_info('HPR_CREDITS', 'CREDIT_ID', null, null, '/vhr/hpr/credit_view', null, 'O');

commit;
end;
/
