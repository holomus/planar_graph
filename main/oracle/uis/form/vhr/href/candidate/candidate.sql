set define off
prompt PATH /vhr/href/candidate/candidate
begin
uis.route('/vhr/href/candidate/candidate+add$attach_person','Ui_Vhr301.Attach_Person','V',null,'A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+add:jobs','Ui_Vhr301.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+add:load_person','Ui_Vhr301.Load_Data','V','JO','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+add:model','Ui_Vhr301.Add_Model',null,'JO','A','Y',null,null,null);
uis.route('/vhr/href/candidate/candidate+add:person_types','Ui_Vhr301.Query_Person_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+add:phone_is_unique','Ui_Vhr301.Phone_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+add:save','Ui_Vhr301.Add','JO','JO','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+add:sources','Ui_Vhr301.Query_Sources',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+add:table_persons','Ui_Vhr301.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+edit:jobs','Ui_Vhr301.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+edit:model','Ui_Vhr301.Edit_Model','JO','JO','A','Y',null,null,null);
uis.route('/vhr/href/candidate/candidate+edit:person_types','Ui_Vhr301.Query_Person_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+edit:phone_is_unique','Ui_Vhr301.Phone_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+edit:save','Ui_Vhr301.Edit','JO','JO','A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate+edit:sources','Ui_Vhr301.Query_Sources',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/candidate/candidate','vhr301');
uis.form('/vhr/href/candidate/candidate+add','/vhr/href/candidate/candidate','F','A','F','H','M','N',null,'N');
uis.form('/vhr/href/candidate/candidate+edit','/vhr/href/candidate/candidate','F','A','F','H','M','N',null,null);



uis.action('/vhr/href/candidate/candidate+add','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/href/candidate/candidate+add','add_source','F','/vhr/href/employment_source+add','D','O');
uis.action('/vhr/href/candidate/candidate+add','attach_person','F',null,null,'A');
uis.action('/vhr/href/candidate/candidate+add','edit','F','/vhr/href/candidate/candidate+edit','S','O');
uis.action('/vhr/href/candidate/candidate+add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/href/candidate/candidate+add','select_source','F','/vhr/href/employment_source_list','D','O');
uis.action('/vhr/href/candidate/candidate+edit','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/href/candidate/candidate+edit','add_source','F','/vhr/href/employment_source+add','D','O');
uis.action('/vhr/href/candidate/candidate+edit','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/href/candidate/candidate+edit','select_source','F','/vhr/href/employment_source_list','D','O');


uis.ready('/vhr/href/candidate/candidate+add','.add_job.add_source.attach_person.edit.model.select_job.select_source.');
uis.ready('/vhr/href/candidate/candidate+edit','.add_job.add_source.model.select_job.select_source.');

commit;
end;
/
