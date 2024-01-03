set define off
prompt PATH /vhr/hes/settings
begin
uis.route('/vhr/hes/settings$activate_timepad_user','Ui_Vhr98.Activate_Timepad_User',null,null,'A',null,null,null,null);
uis.route('/vhr/hes/settings:badge_templates','Ui_Vhr98.Query_Badge_Templates',null,'Q','A',null,null,null,null);
uis.route('/vhr/hes/settings:get_exceeded_employees_from_fte_limit','Ui_Vhr98.Get_Exceeded_Employees_From_Fte_Limit','M','M','A',null,null,null,null);
uis.route('/vhr/hes/settings:job_groups','Ui_Vhr98.Query_Job_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hes/settings:languages','Ui_Vhr98.Query_Langs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hes/settings:model','Ui_Vhr98.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hes/settings:save','Ui_Vhr98.Save','M',null,'A',null,null,null,null);

uis.path('/vhr/hes/settings','vhr98');
uis.form('/vhr/hes/settings','/vhr/hes/settings','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hes/settings','activate_timepad_user','A',null,null,'A');
uis.action('/vhr/hes/settings','col_required_settings','A',null,null,'G');
uis.action('/vhr/hes/settings','general_settings','A',null,null,'G');
uis.action('/vhr/hes/settings','select_job_group','A','/anor/mhr/job_group_list','D','O');
uis.action('/vhr/hes/settings','staff_settings','F',null,null,'G');
uis.action('/vhr/hes/settings','timepad_settings','A',null,null,'G');


uis.ready('/vhr/hes/settings','.activate_timepad_user.col_required_settings.general_settings.model.select_job_group.staff_settings.timepad_settings.');

commit;
end;
/
