set define off
prompt PATH /vhr/rep/href/staff
begin
uis.route('/vhr/rep/href/staff:division_groups','Ui_Vhr583.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/href/staff:edu_stages','Ui_Vhr583.Query_Edu_Stages',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/href/staff:jobs','Ui_Vhr583.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/href/staff:model','Ui_Vhr583.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/href/staff:run','Ui_Vhr583.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/href/staff:schedules','Ui_Vhr583.Query_Schedule',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/href/staff:staffs','Ui_Vhr583.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/rep/href/staff','vhr583');
uis.form('/vhr/rep/href/staff','/vhr/rep/href/staff','F','A','R','H','M','N',null,'N');



uis.action('/vhr/rep/href/staff','select_division_group','F','/anor/mhr/division_group_list','D','O');
uis.action('/vhr/rep/href/staff','select_edu_stage','F','/vhr/href/edu_stage_list','D','O');
uis.action('/vhr/rep/href/staff','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/rep/href/staff','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/rep/href/staff','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/rep/href/staff','.model.select_division_group.select_edu_stage.select_job.select_schedule.select_staff.');

commit;
end;
/
