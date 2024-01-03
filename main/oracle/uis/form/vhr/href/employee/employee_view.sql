set define off
prompt PATH /vhr/href/employee/employee_view
begin
uis.route('/vhr/href/employee/employee_view:model','Ui_Vhr251.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/employee/employee_view','vhr251');
uis.form('/vhr/href/employee/employee_view','/vhr/href/employee/employee_view','F','A','F','H','M','N',null,'N');

uis.override_form('/anor/mhr/employee_view','vhr','/vhr/href/employee/employee_view');


uis.action('/vhr/href/employee/employee_view','edit','F','/vhr/href/employee/employee_edit','S','O');
uis.action('/vhr/href/employee/employee_view','employee_subordinate','F','/vhr/htt/staff_subordinate','S','O');
uis.action('/vhr/href/employee/employee_view','person_bank_account','F','/vhr/href/person/person_bank_account_view','S','O');
uis.action('/vhr/href/employee/employee_view','person_doc_history','F','/vhr/hpd/person_doc_history','S','O');
uis.action('/vhr/href/employee/employee_view','person_document','F','/vhr/href/person/person_document_view','S','O');
uis.action('/vhr/href/employee/employee_view','person_education','F','/vhr/href/person/person_education_view','S','O');
uis.action('/vhr/href/employee/employee_view','person_family','F','/vhr/href/person/person_family_view','S','O');
uis.action('/vhr/href/employee/employee_view','person_files','F','/vhr/href/person/person_files_view','S','O');
uis.action('/vhr/href/employee/employee_view','person_identification','F','/vhr/htt/person_identification_view','S','O');
uis.action('/vhr/href/employee/employee_view','person_references','F','/vhr/href/person/person_reference_view','S','O');
uis.action('/vhr/href/employee/employee_view','person_settings','F','/vhr/hes/person_setting_view','S','O');
uis.action('/vhr/href/employee/employee_view','person_trainings','F','/vhr/hln/person_trainings','S','O');
uis.action('/vhr/href/employee/employee_view','person_work','F','/vhr/href/person/person_work_view','S','O');
uis.action('/vhr/href/employee/employee_view','staff_calendar','F','/vhr/htt/staff_calendar','S','O');
uis.action('/vhr/href/employee/employee_view','staff_location','F','/vhr/htt/staff_location','S','O');


uis.ready('/vhr/href/employee/employee_view','.edit.employee_subordinate.model.person_bank_account.person_doc_history.person_document.person_education.person_family.person_files.person_identification.person_references.person_settings.person_trainings.person_work.staff_calendar.staff_location.');

commit;
end;
/
