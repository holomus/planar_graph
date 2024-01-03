set define off
prompt PATH /vhr/hrm/job
begin
uis.route('/vhr/hrm/job+add:coa_info','Ui_Vhr659.Coa_Info','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+add:job_coa','Ui_Vhr659.Query_Coa',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+add:job_group','Ui_Vhr659.Query_Job_Groups',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+add:model','Ui_Vhr659.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hrm/job+add:origins','Ui_Vhr659.Query_Origins','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+add:ref_name','Ui_Vhr659.Ref_Name','M','V','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+add:roles','Ui_Vhr659.Query_Roles',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+add:save','Ui_Vhr659.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+edit:coa_info','Ui_Vhr659.Coa_Info','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+edit:job_coa','Ui_Vhr659.Query_Coa',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+edit:job_group','Ui_Vhr659.Query_Job_Groups',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+edit:model','Ui_Vhr659.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hrm/job+edit:origins','Ui_Vhr659.Query_Origins','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+edit:ref_name','Ui_Vhr659.Ref_Name','M','V','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+edit:roles','Ui_Vhr659.Query_Roles',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/job+edit:save','Ui_Vhr659.Edit','M','M','A',null,null,null,null,null);

uis.path('/vhr/hrm/job','vhr659');
uis.form('/vhr/hrm/job+add','/vhr/hrm/job','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hrm/job+edit','/vhr/hrm/job','F','A','F','H','M','N',null,'N',null);

uis.override_form('/anor/mhr/job+add','vhr','/vhr/hrm/job+add');
uis.override_form('/anor/mhr/job+edit','vhr','/vhr/hrm/job+edit');


uis.action('/vhr/hrm/job+add','add_expense_coa','F','/anor/mk/coa+add','D','O');
uis.action('/vhr/hrm/job+add','add_job_group','F','/anor/mhr/job_group+add','D','O');
uis.action('/vhr/hrm/job+add','select_expense_coa','F','/anor/mk/coa_list','D','O');
uis.action('/vhr/hrm/job+add','select_job_group','F','/anor/mhr/job_group_list','D','O');
uis.action('/vhr/hrm/job+add','select_role','F','/core/md/role_list','D','O');
uis.action('/vhr/hrm/job+edit','add_expense_coa','F','/anor/mk/coa+add','D','O');
uis.action('/vhr/hrm/job+edit','add_job_group','F','/anor/mhr/job_group+add','D','O');
uis.action('/vhr/hrm/job+edit','select_expense_coa','F','/anor/mk/coa_list','D','O');
uis.action('/vhr/hrm/job+edit','select_job_group','F','/anor/mhr/job_group_list','D','O');
uis.action('/vhr/hrm/job+edit','select_role','F','/core/md/role_list','D','O');


uis.ready('/vhr/hrm/job+add','.add_expense_coa.add_job_group.model.select_expense_coa.select_job_group.select_role.');
uis.ready('/vhr/hrm/job+edit','.add_expense_coa.add_job_group.model.select_expense_coa.select_job_group.select_role.');

commit;
end;
/
