set define off
prompt PATH /vhr/rep/href/candidate
begin
uis.route('/vhr/rep/href/candidate:jobs','Ui_Vhr580.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/href/candidate:model','Ui_Vhr580.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/href/candidate:person_types','Ui_Vhr580.Query_Person_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/href/candidate:run','Ui_Vhr580.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/href/candidate:sources','Ui_Vhr580.Query_Sources',null,'Q','A',null,null,null,null);

uis.path('/vhr/rep/href/candidate','vhr580');
uis.form('/vhr/rep/href/candidate','/vhr/rep/href/candidate','F','A','R','H','M','N',null,'N');



uis.action('/vhr/rep/href/candidate','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/rep/href/candidate','select_source','F','/vhr/href/employment_source_list','D','O');


uis.ready('/vhr/rep/href/candidate','.model.select_job.select_source.');

commit;
end;
/
