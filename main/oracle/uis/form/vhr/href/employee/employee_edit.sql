set define off
prompt PATH /vhr/href/employee/employee_edit
begin
uis.route('/vhr/href/employee/employee_edit$block_employee_tracking','Ui_Vhr324.Block_Employee_Tracking','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit$delete_employee','Ui_Vhr324.Delete_Employee','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit$dismiss_employee','Ui_Vhr324.Dismiss_Employee','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit$save_photo','Ui_Vhr324.Save_Photo','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit$toggle_access_all','Ui_Vhr324.Toggle_Access_All','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit$toggle_employee_state','Ui_Vhr324.Toggle_Employee_State','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit$toggle_user_state','Ui_Vhr324.Toggle_User_State','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit$unblock_employee_tracking','Ui_Vhr324.Unblock_Employee_Tracking','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit:calculate_photo_vector','Ui_Vhr324.Calculate_Photo_Vector','M','R','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit:dismissal_reasons','Ui_Vhr324.Query_Reasons',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit:get_influences','Ui_Vhr324.Get_Influences','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit:load_location','Ui_Vhr324.Load_Location','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit:load_person','Ui_Vhr324.Load_Person','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit:load_staff','Ui_Vhr324.Load_Staff','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit:load_user','Ui_Vhr324.Load_User','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit:model','Ui_Vhr324.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/href/employee/employee_edit:save_tab_config','Ui_Vhr324.Save_Tab_Config','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_edit:upload_images','Ui_Vhr324.Upload_Images','M','M','A',null,null,null,null,null);

uis.path('/vhr/href/employee/employee_edit','vhr324');
uis.form('/vhr/href/employee/employee_edit','/vhr/href/employee/employee_edit','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/href/employee/employee_edit','add_dismissal_reason','F','/vhr/href/dismissal_reason+add','D','O');
uis.action('/vhr/href/employee/employee_edit','block_employee_tracking','F',null,null,'A');
uis.action('/vhr/href/employee/employee_edit','delete_employee','F',null,null,'A');
uis.action('/vhr/href/employee/employee_edit','dismiss_employee','F',null,null,'A');
uis.action('/vhr/href/employee/employee_edit','employee_main','F','/vhr/href/employee/employee','S','O');
uis.action('/vhr/href/employee/employee_edit','employee_salary','F','/vhr/href/employee/employee_salary','S','O');
uis.action('/vhr/href/employee/employee_edit','employee_work','F','/vhr/href/start/employee_work','S','O');
uis.action('/vhr/href/employee/employee_edit','person_bank_account','F','/vhr/href/person/person_bank_account','S','O');
uis.action('/vhr/href/employee/employee_edit','person_doc_history','F','/vhr/hpd/person_doc_history','S','O');
uis.action('/vhr/href/employee/employee_edit','person_document','F','/vhr/href/person/person_document','S','O');
uis.action('/vhr/href/employee/employee_edit','person_education','F','/vhr/href/person/person_education','S','O');
uis.action('/vhr/href/employee/employee_edit','person_family','F','/vhr/href/person/person_family','S','O');
uis.action('/vhr/href/employee/employee_edit','person_files','F','/vhr/href/person/person_files','S','O');
uis.action('/vhr/href/employee/employee_edit','person_identification','F','/vhr/htt/person_identification','S','O');
uis.action('/vhr/href/employee/employee_edit','person_inventories','F','/vhr/href/person/person_inventories','S','O');
uis.action('/vhr/href/employee/employee_edit','person_overtime','F','/vhr/hpd/start/overtime_list','S','O');
uis.action('/vhr/href/employee/employee_edit','person_reference','F','/vhr/href/person/person_references','S','O');
uis.action('/vhr/href/employee/employee_edit','person_settings','F','/vhr/hes/person_settings','S','O');
uis.action('/vhr/href/employee/employee_edit','person_subordinate','F','/vhr/htt/staff_subordinate','S','O');
uis.action('/vhr/href/employee/employee_edit','person_trainings','F','/vhr/hln/person_trainings','S','O');
uis.action('/vhr/href/employee/employee_edit','person_work','F','/vhr/href/person/person_work','S','O');
uis.action('/vhr/href/employee/employee_edit','save_photo','F',null,null,'A');
uis.action('/vhr/href/employee/employee_edit','select_dismissal_reason','F','/vhr/href/dismissal_reason_list','D','O');
uis.action('/vhr/href/employee/employee_edit','staff_calendar','F','/vhr/htt/staff_calendar','S','O');
uis.action('/vhr/href/employee/employee_edit','staff_changes','F','/vhr/htt/staff_changes','S','O');
uis.action('/vhr/href/employee/employee_edit','staff_location','F','/vhr/htt/staff_location','S','O');
uis.action('/vhr/href/employee/employee_edit','staff_performance','F','/vhr/hper/staff_performance','S','O');
uis.action('/vhr/href/employee/employee_edit','staff_requests','F','/vhr/htt/staff_requests','S','O');
uis.action('/vhr/href/employee/employee_edit','toggle_employee_state','F',null,null,'A');
uis.action('/vhr/href/employee/employee_edit','toggle_user_state','F',null,null,'A');
uis.action('/vhr/href/employee/employee_edit','unblock_employee_tracking','F',null,null,'A');


uis.ready('/vhr/href/employee/employee_edit','.add_dismissal_reason.block_employee_tracking.delete_employee.dismiss_employee.employee_main.employee_salary.employee_work.model.person_bank_account.person_doc_history.person_document.person_education.person_family.person_files.person_identification.person_inventories.person_overtime.person_reference.person_settings.person_subordinate.person_trainings.person_work.save_photo.select_dismissal_reason.staff_calendar.staff_changes.staff_location.staff_performance.staff_requests.toggle_employee_state.toggle_user_state.unblock_employee_tracking.');

commit;
end;
/
