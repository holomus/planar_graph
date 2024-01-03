set define off
prompt PATH /vhr/hes/staff
begin
uis.route('/vhr/hes/staff:available_changes','Ui_Vhr95.Query_Available_Changes',null,'Q','S',null,null,null,null);
uis.route('/vhr/hes/staff:available_changes_by_param','Ui_Vhr95.Query_Available_Changes_By_Param','M','Q','S',null,null,null,null);
uis.route('/vhr/hes/staff:available_requests','Ui_Vhr95.Query_Available_Requests',null,'Q','S',null,null,null,null);
uis.route('/vhr/hes/staff:available_requests_by_param','Ui_Vhr95.Query_Available_Requests_By_Param','M','Q','S',null,null,null,null);
uis.route('/vhr/hes/staff:change_approve','Ui_Vhr95.Change_Approve','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:change_complete','Ui_Vhr95.Change_Complete','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:change_delete','Ui_Vhr95.Change_Delete','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:change_deny','Ui_Vhr95.Change_Deny','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:change_model','Ui_Vhr95.Change_Model','M','M','S',null,null,null,null);
uis.route('/vhr/hes/staff:change_reset','Ui_Vhr95.Change_Reset','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:change_save','Ui_Vhr95.Change_Save','L',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:download_person_document_files','Ui_Vhr95.Download_Person_Document_Files','M','F','S',null,null,null,null);
uis.route('/vhr/hes/staff:employee_details','Ui_Vhr95.Employee_Details','M','M','S',null,null,null,null);
uis.route('/vhr/hes/staff:get_accessible_action_keys','Ui_Vhr95.Get_Accessible_Action_Keys',null,'V','S',null,null,null,null);
uis.route('/vhr/hes/staff:get_notifications','Ui_Vhr95.Query_Notifications',null,'Q','S',null,null,null,null);
uis.route('/vhr/hes/staff:get_payroll','Ui_Vhr95.Get_Payroll','M','M','S',null,null,null,null);
uis.route('/vhr/hes/staff:gps_track_data_save','Ui_Vhr95.Gps_Track_Data_Save','A','M','S',null,null,null,null);
uis.route('/vhr/hes/staff:gps_track_save','Ui_Vhr95.Gps_Track_Save','A','M','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_attendance','Ui_Vhr95.Load_Attendance','M','L','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_birthdays','Ui_Vhr95.Load_Birthdays','V','L','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_dashboard_plans','Ui_Vhr95.Load_Dashboard_Plans','M','M','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_gps_track_settings','Ui_Vhr95.Load_Gps_Track_Settings',null,'M','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_gps_tracks','Ui_Vhr95.Load_Gps_Tracks','M','JO','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_marks','Ui_Vhr95.Load_Marks','M','L','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_notify_settings','Ui_Vhr95.Load_Notify_Settings',null,'M','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_person_documents','Ui_Vhr95.Get_Person_Documents','M','L','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_plan_info','Ui_Vhr95.Load_Plan_Info','M','L','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_request_limits','Ui_Vhr95.Load_Request_Limits','M','L','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_settings','Ui_Vhr95.Load_Settings',null,'M','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_staff_monthly_attendance','Ui_Vhr95.Load_Staff_Monthly_Attendance','M','M','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_staff_plans','Ui_Vhr95.Load_Staff_Plans','M','L','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_task_statuses','Ui_Vhr95.Load_Task_Statuses',null,'L','S',null,null,null,null);
uis.route('/vhr/hes/staff:load_users','Ui_Vhr95.Load_Users',null,'L','S',null,null,null,null);
uis.route('/vhr/hes/staff:notify_setting_save','Ui_Vhr95.Notify_Setting_Save','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:person_save_photo','Ui_Vhr95.Person_Save_Photo','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:personal_changes','Ui_Vhr95.Query_Personal_Changes',null,'Q','S',null,null,null,null);
uis.route('/vhr/hes/staff:personal_requests','Ui_Vhr95.Query_Personal_Requests',null,'Q','S',null,null,null,null);
uis.route('/vhr/hes/staff:request_approve','Ui_Vhr95.Request_Approve','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:request_complete','Ui_Vhr95.Request_Complete','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:request_delete','Ui_Vhr95.Request_Delete','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:request_deny','Ui_Vhr95.Request_Deny','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:request_model','Ui_Vhr95.Request_Model','M','M','S',null,null,null,null);
uis.route('/vhr/hes/staff:request_reset','Ui_Vhr95.Request_Reset','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:request_save','Ui_Vhr95.Request_Save','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:set_invalid','Ui_Vhr95.Set_Invalid','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:set_valid','Ui_Vhr95.Set_Valid','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/staff:staff_plan_edit','Ui_Vhr95.Staff_Plan_Edit','M','M','S',null,null,null,null);
uis.route('/vhr/hes/staff:subordinates','Ui_Vhr95.Query_Subordinates','M','Q','S',null,null,null,null);
uis.route('/vhr/hes/staff:timesheets','Ui_Vhr95.Load_Timesheets','M','L','S',null,null,null,null);
uis.route('/vhr/hes/staff:track_model','Ui_Vhr95.Track_Model',null,'M','S',null,null,null,null);
uis.route('/vhr/hes/staff:track_offline_save','Ui_Vhr95.Track_Offline_Save','M','V','S',null,null,null,null);
uis.route('/vhr/hes/staff:track_save','Ui_Vhr95.Track_Save','M','V','S',null,null,null,null);
uis.route('/vhr/hes/staff:tracks','Ui_Vhr95.Query_Tracks',null,'Q','S',null,null,null,null);
uis.route('/vhr/hes/staff:get_divisions','Ui_Vhr95.Get_Divisions',null,'L','S',null,null,null,null);

uis.path('/vhr/hes/staff','vhr95');
uis.form('/vhr/hes/staff','/vhr/hes/staff','F','S','E','Z','M','N',null,'N');



uis.action('/vhr/hes/staff','change_approve','F',null,null,'G');
uis.action('/vhr/hes/staff','change_complete','F',null,null,'G');
uis.action('/vhr/hes/staff','change_delete','F',null,null,'G');
uis.action('/vhr/hes/staff','change_deny','F',null,null,'G');
uis.action('/vhr/hes/staff','change_reset','F',null,null,'G');
uis.action('/vhr/hes/staff','change_save_for_subordinate','F',null,null,'G');
uis.action('/vhr/hes/staff','day_statistics','F',null,null,'G');
uis.action('/vhr/hes/staff','hide_salary','F',null,null,'G');
uis.action('/vhr/hes/staff','request_approve','F',null,null,'G');
uis.action('/vhr/hes/staff','request_complete','F',null,null,'G');
uis.action('/vhr/hes/staff','request_delete','F',null,null,'G');
uis.action('/vhr/hes/staff','request_deny','F',null,null,'G');
uis.action('/vhr/hes/staff','request_reset','F',null,null,'G');
uis.action('/vhr/hes/staff','set_invalid','F',null,null,'G');
uis.action('/vhr/hes/staff','set_valid','F',null,null,'G');


uis.ready('/vhr/hes/staff','.change_approve.change_complete.change_delete.change_deny.change_reset.change_save_for_subordinate.day_statistics.hide_salary.model.request_approve.request_complete.request_delete.request_deny.request_reset.set_invalid.set_valid.');

commit;
end;
/
