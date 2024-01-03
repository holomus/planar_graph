prompt request audit info
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
  delete Md_Audit_Infos t
   where Regexp_Like(t.Table_Name, '^(HTT|HLN|HPD|HPER|HREF|HRM|HPR)_');

  Audit_Info('HTT_REQUESTS', 'N', null, 'htt_audit.request_start', 'htt_audit.request_stop', '/vhr/htt/request_audit_details');
  Audit_Info('HTT_PLAN_CHANGES', 'N', null, 'htt_audit.change_start', 'htt_audit.change_stop', '/vhr/htt/change_audit_details');
  Audit_Info('HTT_LOCATION_TYPES', 'N', null, 'htt_audit.location_type_start', 'htt_audit.location_type_stop', '/vhr/htt/view/location_type_audit_details');
  Audit_Info('HTT_LOCATIONS', 'N', null, 'htt_audit.location_start', 'htt_audit.location_stop', '/vhr/htt/view/location_audit_details');
  Audit_Info('HTT_TIME_KINDS', 'N', null, 'htt_audit.time_kind_start', 'htt_audit.time_kind_stop', '/vhr/htt/view/time_kind_audit_details');
  Audit_Info('HTT_REQUEST_KINDS', 'N', null, 'htt_audit.request_kind_start', 'htt_audit.request_kind_stop', '/vhr/htt/view/request_kind_audit_details');
  Audit_Info('HTT_TRACKS', 'N', null, 'htt_audit.track_start', 'htt_audit.track_stop', '/vhr/htt/view/track_audit_details');
  Audit_Info('HLN_QUESTION_GROUPS', 'N', null, 'hln_audit.question_group_start', 'hln_audit.question_group_stop', '/vhr/hln/view/question_group_audit_details');
  Audit_Info('HLN_QUESTION_TYPES', 'N', null, 'hln_audit.question_type_start', 'hln_audit.question_type_stop', '/vhr/hln/view/question_type_audit_details');
  Audit_Info('HLN_TRAINING_SUBJECTS', 'N', null, 'hln_audit.training_subject_start', 'hln_audit.training_subject_stop', '/vhr/hln/view/training_subject_audit_details');
  Audit_Info('HPD_JOURNALS', 'N', null, 'hpd_audit.journal_start', 'hpd_audit.journal_stop', '/vhr/hpd/audit/journal_audit_details');
  Audit_Info('HPD_APPLICATIONS', 'N', null, 'hpd_audit.application_start', 'hpd_audit.application_stop', '/vhr/hpd/application/application_audit_details');
  Audit_Info('HPER_STAFF_PLANS', 'N', null, 'hper_audit.staff_plan_audit_start', 'hper_audit.staff_plan_audit_stop', '/vhr/hper/audit/staff_plan_audit_details');
  Audit_Info('HPER_PLAN_GROUPS', 'N', null, 'hper_audit.plan_group_start', 'hper_audit.plan_group_stop', '/vhr/hper/audit/plan_group_audit_details');
  Audit_Info('HPER_PLAN_TYPES', 'N', null, 'hper_audit.plan_type_start', 'hper_audit.plan_type_stop', '/vhr/hper/audit/plan_type_audit_details');
  Audit_info('HREF_EDU_STAGES', 'N', null, 'href_audit.edu_stage_start', 'href_audit.edu_stage_stop', '/vhr/href/view/edu_stage_audit_details');
  Audit_info('HREF_SCIENCE_BRANCHES', 'N', null, 'href_audit.science_branch_start', 'href_audit.science_branch_stop', '/vhr/href/view/science_branche_audit_details');  
  Audit_info('HREF_INSTITUTIONS', 'N', null, 'href_audit.institution_start', 'href_audit.institution_stop', '/vhr/href/view/institution_audit_details');
  Audit_info('HREF_SPECIALTIES', 'N', null, 'href_audit.specialty_start', 'href_audit.specialty_stop', '/vhr/href/view/specialty_audit_details');
  Audit_info('HREF_LANGS', 'N', null, 'href_audit.lang_start', 'href_audit.lang_stop', '/vhr/href/view/lang_audit_details');
  Audit_info('HREF_LANG_LEVELS', 'N', null, 'href_audit.lang_level_start', 'href_audit.lang_level_stop', '/vhr/href/view/lang_level_audit_details');
  Audit_info('HREF_DOCUMENT_TYPES', 'N', null, 'href_audit.document_type_start', 'href_audit.document_type_stop', '/vhr/href/view/document_type_audit_details');
  Audit_info('HREF_REFERENCE_TYPES', 'N', null, 'href_audit.reference_type_start', 'href_audit.reference_type_stop', '/vhr/href/view/reference_type_audit_details');
  Audit_info('HREF_RELATION_DEGREES', 'N', null, 'href_audit.relation_degree_start', 'href_audit.relation_degree_stop', '/vhr/href/view/relation_degree_audit_details');
  Audit_info('HREF_MARITAL_STATUSES', 'N', null, 'href_audit.marital_status_start', 'href_audit.marital_status_stop', '/vhr/href/view/marital_status_audit_details');
  Audit_info('HREF_EXPERIENCE_TYPES', 'N', null, 'href_audit.experience_type_start', 'href_audit.experience_type_stop', '/vhr/href/view/experience_type_audit_details');
  Audit_info('HREF_AWARDS', 'N', null, 'href_audit.award_start', 'href_audit.award_stop', '/vhr/href/view/award_audit_details');
  Audit_info('HREF_LABOR_FUNCTIONS', 'N', null, 'href_audit.labor_function_start', 'href_audit.labor_function_stop', '/vhr/href/view/labor_function_audit_details');
  Audit_info('HREF_SICK_LEAVE_REASONS', 'N', null, 'href_audit.sick_leave_reason_start', 'href_audit.sick_leave_reason_stop', '/vhr/href/view/sick_leave_reason_audit_details');
  Audit_info('HREF_BUSINESS_TRIP_REASONS', 'N', null, 'href_audit.business_trip_reason_start', 'href_audit.business_trip_reason_stop', '/vhr/href/view/business_trip_reason_audit_details');
  Audit_info('HREF_DISMISSAL_REASONS', 'N', null, 'href_audit.dismissal_reason_start', 'href_audit.dismissal_reason_stop', '/vhr/href/view/dismissal_reason_audit_details');
  Audit_info('HREF_WAGES', 'N', null, 'href_audit.wage_start', 'href_audit.wage_stop', '/vhr/href/view/wage_audit_details');
  Audit_info('HREF_EMPLOYMENT_SOURCES', 'N', null, 'href_audit.employment_source_start', 'href_audit.employment_source_stop', '/vhr/href/view/employment_source_audit_details');
  Audit_info('HREF_INDICATORS', 'N', null, 'href_audit.indicator_start', 'href_audit.indicator_stop', '/vhr/href/view/indicator_audit_details');
  Audit_info('HREF_FTES', 'N', null, 'href_audit.fte_start', 'href_audit.fte_stop', '/vhr/href/view/fte_audit_details');
  Audit_info('HREF_PERSON_DETAILS', 'N', null, 'href_audit.person_detail_start', 'href_audit.person_detail_stop', '/vhr/href/view/employee_audit_details');
  Audit_Info('HRM_ROBOTS', 'N', null, 'hrm_audit.robot_audit_start', 'hrm_audit.robot_audit_stop', '/vhr/hrm/robot_audit_details');
  Audit_Info('HPR_CREDITS', 'N', null, 'hpr_audit.credit_audit_start', 'hpr_audit.credit_audit_stop', '/vhr/hpr/credit_audit_details');
   
  commit;
end; 
/
