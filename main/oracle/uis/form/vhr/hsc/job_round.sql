set define off
prompt PATH /vhr/hsc/job_round
begin
uis.route('/vhr/hsc/job_round+add:division_objects','Ui_Vhr645.Query_Objects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_round+add:jobs','Ui_Vhr645.Query_Jobs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_round+add:model','Ui_Vhr645.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/job_round+add:save','Ui_Vhr645.Add','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hsc/job_round+edit:division_objects','Ui_Vhr645.Query_Objects',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hsc/job_round+edit:jobs','Ui_Vhr645.Query_Jobs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_round+edit:model','Ui_Vhr645.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/job_round+edit:save','Ui_Vhr645.Edit','M',null,'A',null,null,null,null,null);

uis.path('/vhr/hsc/job_round','vhr645');
uis.form('/vhr/hsc/job_round+add','/vhr/hsc/job_round','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hsc/job_round+edit','/vhr/hsc/job_round','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hsc/job_round+add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hsc/job_round+edit','select_job','F','/anor/mhr/job_list','D','O');


uis.ready('/vhr/hsc/job_round+add','.model.select_job.');
uis.ready('/vhr/hsc/job_round+edit','.model.select_job.');

commit;
end;
/
