set define off
prompt PATH /vhr/href/wage
begin
uis.route('/vhr/href/wage+add:jobs','Ui_Vhr144.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/wage+add:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/wage+add:ranks','Ui_Vhr144.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/wage+add:save','Ui_Vhr144.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/wage+edit:jobs','Ui_Vhr144.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/wage+edit:model','Ui_Vhr144.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/wage+edit:ranks','Ui_Vhr144.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/wage+edit:save','Ui_Vhr144.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/wage','vhr144');
uis.form('/vhr/href/wage+add','/vhr/href/wage','F','A','F','H','M','N',null,null);
uis.form('/vhr/href/wage+edit','/vhr/href/wage','F','A','F','H','M','N',null,null);



uis.action('/vhr/href/wage+add','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/href/wage+add','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/href/wage+add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/href/wage+add','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/href/wage+edit','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/href/wage+edit','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/href/wage+edit','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/href/wage+edit','select_rank','F','/anor/mhr/rank_list','D','O');



uis.ready('/vhr/href/wage+add','.add_job.add_rank.model.select_job.select_rank.');
uis.ready('/vhr/href/wage+edit','.add_job.add_rank.model.select_job.select_rank.');

commit;
end;
/
