set define off
prompt PATH /vhr/hes/person_settings
begin
uis.route('/vhr/hes/person_settings:job_groups','Ui_Vhr124.Query_Job_Groups',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hes/person_settings:login_validate','Ui_Vhr124.Login_Is_Valid','M','V','A',null,null,null,null,null);
uis.route('/vhr/hes/person_settings:model','Ui_Vhr124.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hes/person_settings:roles','Ui_Vhr124.Query_Roles',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hes/person_settings:save','Ui_Vhr124.Save','M','M','A',null,null,null,null,null);

uis.path('/vhr/hes/person_settings','vhr124');
uis.form('/vhr/hes/person_settings','/vhr/hes/person_settings','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hes/person_settings','add_role','F','/core/md/role+add','D','O');
uis.action('/vhr/hes/person_settings','licensing_plan','F',null,null,'G');
uis.action('/vhr/hes/person_settings','select_job_group','F','/anor/mhr/job_group_list','D','O');
uis.action('/vhr/hes/person_settings','select_role','F','/core/md/role_list','D','O');
uis.action('/vhr/hes/person_settings','view','F','/core/md/user_view','S','O');


uis.ready('/vhr/hes/person_settings','.add_role.licensing_plan.model.select_job_group.select_role.view.');

commit;
end;
/
