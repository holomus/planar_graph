set define off
prompt PATH /vhr/hrec/application
begin
uis.route('/vhr/hrec/application+add:jobs','Ui_Vhr586.Query_Job',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/application+add:model','Ui_Vhr586.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrec/application+add:save','Ui_Vhr586.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/application+edit:jobs','Ui_Vhr586.Query_Job',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/application+edit:model','Ui_Vhr586.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrec/application+edit:save','Ui_Vhr586.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hrec/application','vhr586');
uis.form('/vhr/hrec/application+add','/vhr/hrec/application','F','A','F','H','M','N',null,null);
uis.form('/vhr/hrec/application+edit','/vhr/hrec/application','F','A','F','H','M','N',null,null);



uis.action('/vhr/hrec/application+add','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hrec/application+add','select_job','F','/anor/mhr/job_list','D','O');


uis.ready('/vhr/hrec/application+add','.add_job.model.select_job.');
uis.ready('/vhr/hrec/application+edit','.model.');

commit;
end;
/
