set define off
prompt PATH /vhr/href/staff/staff_view
begin
uis.route('/vhr/href/staff/staff_view:model','Ui_Vhr158.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/staff/staff_view','vhr158');
uis.form('/vhr/href/staff/staff_view','/vhr/href/staff/staff_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/staff/staff_view','person_bank_account','A','/vhr/href/person/person_bank_account_view','S','O');
uis.action('/vhr/href/staff/staff_view','person_document','A','/vhr/href/person/person_document_view','S','O');
uis.action('/vhr/href/staff/staff_view','person_education','A','/vhr/href/person/person_education_view','S','O');
uis.action('/vhr/href/staff/staff_view','person_family','A','/vhr/href/person/person_family_view','S','O');
uis.action('/vhr/href/staff/staff_view','person_files','A','/vhr/href/person/person_files_view','S','O');
uis.action('/vhr/href/staff/staff_view','person_identification','A','/vhr/htt/person_identification_view','S','O');
uis.action('/vhr/href/staff/staff_view','person_references','A','/vhr/href/person/person_reference_view','S','O');
uis.action('/vhr/href/staff/staff_view','person_settings','A','/vhr/hes/person_setting_view','S','O');
uis.action('/vhr/href/staff/staff_view','person_trainings','A','/vhr/hln/person_trainings','S','O');
uis.action('/vhr/href/staff/staff_view','person_work','A','/vhr/href/person/person_work_view','S','O');
uis.action('/vhr/href/staff/staff_view','staff_calendar','A','/vhr/htt/staff_calendar','S','O');
uis.action('/vhr/href/staff/staff_view','staff_location','A','/vhr/htt/staff_location','S','O');
uis.action('/vhr/href/staff/staff_view','staff_subordinate','A','/vhr/htt/staff_subordinate','S','O');
uis.action('/vhr/href/staff/staff_view','view_employee','F','/vhr/href/employee/employee_edit','S','O');


uis.ready('/vhr/href/staff/staff_view','.model.person_bank_account.person_document.person_education.person_family.person_files.person_identification.person_references.person_settings.person_trainings.person_work.staff_calendar.staff_location.staff_subordinate.view_employee.');

commit;
end;
/
