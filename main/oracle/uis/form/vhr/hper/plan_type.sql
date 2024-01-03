set define off
prompt PATH /vhr/hper/plan_type
begin
uis.route('/vhr/hper/plan_type+add:model','Ui_Vhr133.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hper/plan_type+add:plan_groups','Ui_Vhr133.Query_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hper/plan_type+add:save','Ui_Vhr133.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hper/plan_type+add:task_types','Ui_Vhr133.Query_Task_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/hper/plan_type+edit:model','Ui_Vhr133.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hper/plan_type+edit:plan_groups','Ui_Vhr133.Query_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hper/plan_type+edit:save','Ui_Vhr133.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hper/plan_type+edit:task_types','Ui_Vhr133.Query_Task_Types',null,'Q','A',null,null,null,null);

uis.path('/vhr/hper/plan_type','vhr133');
uis.form('/vhr/hper/plan_type+add','/vhr/hper/plan_type','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hper/plan_type+edit','/vhr/hper/plan_type','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hper/plan_type+add','add_plan_group','F','/vhr/hper/plan_group+add','D','O');
uis.action('/vhr/hper/plan_type+add','add_task_type','F','/core/ms/task_type+add','D','O');
uis.action('/vhr/hper/plan_type+add','view_plan_group','F','/vhr/hper/plan_group_list','D','O');
uis.action('/vhr/hper/plan_type+add','view_task_type','F','/core/ms/task_type_list','D','O');
uis.action('/vhr/hper/plan_type+edit','add_plan_group','F','/vhr/hper/plan_group+add','D','O');
uis.action('/vhr/hper/plan_type+edit','add_task_type','F','/core/ms/task_type+add','D','O');
uis.action('/vhr/hper/plan_type+edit','view_plan_group','F','/vhr/hper/plan_group_list','D','O');
uis.action('/vhr/hper/plan_type+edit','view_task_type','F','/core/ms/task_type_list','D','O');


uis.ready('/vhr/hper/plan_type+add','.add_plan_group.add_task_type.model.view_plan_group.view_task_type.');
uis.ready('/vhr/hper/plan_type+edit','.add_plan_group.add_task_type.model.view_plan_group.view_task_type.');

commit;
end;
/
