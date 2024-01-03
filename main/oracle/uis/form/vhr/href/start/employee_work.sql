set define off
prompt PATH /vhr/href/start/employee_work
begin
uis.route('/vhr/href/start/employee_work$delete','Ui_Vhr312.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/start/employee_work$delete_dismissal','Ui_Vhr312.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/start/employee_work$delete_hiring','Ui_Vhr312.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/start/employee_work$save_dismissal','Ui_Vhr312.Save_Dismissal','M','M','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work$save_hiring','Ui_Vhr312.Save_Hiring','M','M','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work$save_salary','Ui_Vhr312.Save_Salary','M','M','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work$save_schedule','Ui_Vhr312.Save_Schedule','M','M','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work$save_transfer','Ui_Vhr312.Save_Transfer','M','M','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work:ftes','Ui_Vhr312.Query_Ftes',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work:get_hidden_salary_job','Ui_Vhr312.Get_Hidden_Salary_Job','M','V','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work:get_influences','Ui_Vhr312.Get_Influences','M','M','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work:jobs','Ui_Vhr312.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work:load_last_staff','Ui_Vhr312.Load_Last_Staff','M','M','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work:model','Ui_Vhr312.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/start/employee_work:reasons','Ui_Vhr312.Query_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work:salary_types','Ui_Vhr312.Query_Oper_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/start/employee_work:schedules','Ui_Vhr312.Query_Schedules',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/start/employee_work','vhr312');
uis.form('/vhr/href/start/employee_work','/vhr/href/start/employee_work','F','A','F','H','M','N',null,'N');



uis.action('/vhr/href/start/employee_work','add_fte','F','/vhr/href/fte+add','D','O');
uis.action('/vhr/href/start/employee_work','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/href/start/employee_work','add_reason','F','/vhr/href/dismissal_reason+add','D','O');
uis.action('/vhr/href/start/employee_work','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/href/start/employee_work','audit_schedule','F','/vhr/hpd/audit/schedule_change_audit','D','O');
uis.action('/vhr/href/start/employee_work','delete','F',null,null,'A');
uis.action('/vhr/href/start/employee_work','delete_dismissal','F',null,null,'A');
uis.action('/vhr/href/start/employee_work','delete_hiring','F',null,null,'A');
uis.action('/vhr/href/start/employee_work','save_dismissal','F',null,null,'A');
uis.action('/vhr/href/start/employee_work','save_hiring','F',null,null,'A');
uis.action('/vhr/href/start/employee_work','save_salary','F',null,null,'A');
uis.action('/vhr/href/start/employee_work','save_schedule','F',null,null,'A');
uis.action('/vhr/href/start/employee_work','save_transfer','F',null,null,'A');
uis.action('/vhr/href/start/employee_work','select_fte','F','/vhr/href/fte_list','D','O');
uis.action('/vhr/href/start/employee_work','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/href/start/employee_work','select_reason','F','/vhr/href/dismissal_reason_list','D','O');
uis.action('/vhr/href/start/employee_work','select_schedule','F','/vhr/htt/schedule_list','D','O');


uis.ready('/vhr/href/start/employee_work','.add_fte.add_job.add_reason.add_schedule.audit_schedule.delete.delete_dismissal.delete_hiring.model.save_dismissal.save_hiring.save_salary.save_schedule.save_transfer.select_fte.select_job.select_reason.select_schedule.');

commit;
end;
/
