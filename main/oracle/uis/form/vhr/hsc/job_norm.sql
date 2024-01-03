set define off
prompt PATH /vhr/hsc/job_norm
begin
uis.route('/vhr/hsc/job_norm+add:division_objects','Ui_Vhr553.Query_Objects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm+add:jobs','Ui_Vhr553.Query_Jobs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm+add:model','Ui_Vhr553.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/job_norm+add:save','Ui_Vhr553.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm+edit:division_objects','Ui_Vhr553.Query_Objects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm+edit:jobs','Ui_Vhr553.Query_Jobs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm+edit:model','Ui_Vhr553.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/job_norm+edit:save','Ui_Vhr553.Edit','M',null,'A',null,null,null,null,null);

uis.path('/vhr/hsc/job_norm','vhr553');
uis.form('/vhr/hsc/job_norm+add','/vhr/hsc/job_norm','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hsc/job_norm+edit','/vhr/hsc/job_norm','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hsc/job_norm+add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hsc/job_norm+edit','select_job','F','/anor/mhr/job_list','D','O');


uis.ready('/vhr/hsc/job_norm+add','.model.select_job.');
uis.ready('/vhr/hsc/job_norm+edit','.model.select_job.');

commit;
end;
/
