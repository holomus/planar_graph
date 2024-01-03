set define off
prompt PATH /vhr/hper/plan
begin
uis.route('/vhr/hper/plan+add:jobs','Ui_Vhr136.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/hper/plan+add:journal_pages','Ui_Vhr136.Query_Journal_Pages','M','Q','A',null,null,null,null);
uis.route('/vhr/hper/plan+add:model','Ui_Vhr136.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hper/plan+add:plan_types','Ui_Vhr136.Query_Plan_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hper/plan+add:ranks','Ui_Vhr136.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/hper/plan+add:save','Ui_Vhr136.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/plan+edit:jobs','Ui_Vhr136.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/hper/plan+edit:journal_pages','Ui_Vhr136.Query_Journal_Pages','M','Q','A',null,null,null,null);
uis.route('/vhr/hper/plan+edit:model','Ui_Vhr136.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hper/plan+edit:plan_types','Ui_Vhr136.Query_Plan_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hper/plan+edit:ranks','Ui_Vhr136.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/hper/plan+edit:save','Ui_Vhr136.Edit','M',null,'A',null,null,null,null);

uis.path('/vhr/hper/plan','vhr136');
uis.form('/vhr/hper/plan+add','/vhr/hper/plan','F','A','F','H','M','N',null,null);
uis.form('/vhr/hper/plan+edit','/vhr/hper/plan','F','A','F','H','M','N',null,null);



uis.action('/vhr/hper/plan+add','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hper/plan+add','add_plan_type','F','/vhr/hper/plan_type+add','D','O');
uis.action('/vhr/hper/plan+add','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hper/plan+add','view_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hper/plan+add','view_plan_type','F','/vhr/hper/plan_type_list','D','O');
uis.action('/vhr/hper/plan+add','view_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hper/plan+edit','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hper/plan+edit','add_plan_type','F','/vhr/hper/plan_type+add','D','O');
uis.action('/vhr/hper/plan+edit','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hper/plan+edit','view_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hper/plan+edit','view_plan_type','F','/vhr/hper/plan_type_list','D','O');
uis.action('/vhr/hper/plan+edit','view_rank','F','/anor/mhr/rank_list','D','O');



uis.ready('/vhr/hper/plan+add','.add_job.add_plan_type.add_rank.model.view_job.view_plan_type.view_rank.');
uis.ready('/vhr/hper/plan+edit','.add_job.add_plan_type.add_rank.model.view_job.view_plan_type.view_rank.');

commit;
end;
/
