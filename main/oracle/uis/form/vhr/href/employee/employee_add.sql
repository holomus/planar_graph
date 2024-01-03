set define off
prompt PATH /vhr/href/employee/employee_add
begin
uis.route('/vhr/href/employee/employee_add$attach_employee','Ui_Vhr314.Attach_Employee','M',null,'A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:calculate_photo_vector','Ui_Vhr314.Calculate_Photo_Vector','M','R','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:email_is_unique','Ui_Vhr314.Email_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:ftes','Ui_Vhr314.Query_Ftes',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:get_hidden_salary_job','Ui_Vhr314.Get_Hidden_Salary_Job','M','V','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:get_robot','Ui_Vhr314.Get_Robot','M','M','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:jobs','Ui_Vhr314.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:locations','Ui_Vhr314.Query_Locations',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:login_validate','Ui_Vhr314.Login_Is_Valid','M','V','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:model','Ui_Vhr314.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/employee/employee_add:nationalities','Ui_Vhr314.Query_Nationalities',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:npin_validate','Ui_Vhr314.Npin_Is_Valid','M','V','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:oper_types','Ui_Vhr314.Query_Oper_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:passport_valid','Ui_Vhr314.Passport_Is_Valid','M','V','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:phone_is_unique','Ui_Vhr314.Phone_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:recommended_logins','Ui_Vhr314.Recommended_Logins','M','M','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:robots','Ui_Vhr314.Query_Robots','M','Q','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:save','Ui_Vhr314.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:schedules','Ui_Vhr314.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:upload_images','Ui_Vhr314.Upload_Images','M','M','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_add:vpu_search','Ui_Vhr314.Verify_Person_Uniqueness_Search','V','L','A',null,null,null,null);

uis.path('/vhr/href/employee/employee_add','vhr314');
uis.form('/vhr/href/employee/employee_add','/vhr/href/employee/employee_add','F','A','F','H','M','N',null,'N');



uis.action('/vhr/href/employee/employee_add','add_fte','F','/vhr/href/fte+add','D','O');
uis.action('/vhr/href/employee/employee_add','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/href/employee/employee_add','add_location','F','/vhr/htt/location+add','D','O');
uis.action('/vhr/href/employee/employee_add','add_nationality','F','/vhr/href/nationality+add','D','O');
uis.action('/vhr/href/employee/employee_add','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/href/employee/employee_add','attach_employee','F',null,null,'A');
uis.action('/vhr/href/employee/employee_add','employee_edit','F','/vhr/href/employee/employee_edit','R','O');
uis.action('/vhr/href/employee/employee_add','hiring','F',null,null,'G');
uis.action('/vhr/href/employee/employee_add','person_edit','F','/vhr/href/person/person_edit','R','O');
uis.action('/vhr/href/employee/employee_add','select_fte','F','/vhr/href/fte_list','D','O');
uis.action('/vhr/href/employee/employee_add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/href/employee/employee_add','select_location','F','/vhr/htt/location_list','D','O');
uis.action('/vhr/href/employee/employee_add','select_nationality','F','/vhr/href/nationality_list','D','O');
uis.action('/vhr/href/employee/employee_add','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/href/employee/employee_add','select_schedule','F','/vhr/htt/schedule_list','D','O');


uis.ready('/vhr/href/employee/employee_add','.add_fte.add_job.add_location.add_nationality.add_schedule.attach_employee.employee_edit.hiring.model.person_edit.select_fte.select_job.select_location.select_nationality.select_robot.select_schedule.');

commit;
end;
/
