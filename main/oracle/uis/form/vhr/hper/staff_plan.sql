set define off
prompt PATH /vhr/hper/staff_plan
begin
uis.route('/vhr/hper/staff_plan$delete_plan_part','Ui_Vhr135.Delete_Plan_Part','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/staff_plan$save','Ui_Vhr135.Save','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/staff_plan$save_plan_part','Ui_Vhr135.Save_Plan_Part','M','M','A',null,null,null,null);
uis.route('/vhr/hper/staff_plan$set_completed','Ui_Vhr135.Set_Completed','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/staff_plan$set_new','Ui_Vhr135.Set_New','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/staff_plan$set_waiting','Ui_Vhr135.Set_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/staff_plan:load_plan_parts','Ui_Vhr135.Load_Plan_Parts','M','M','A',null,null,null,null);
uis.route('/vhr/hper/staff_plan:load_tasks','Ui_Vhr135.Load_Tasks','M','L','A',null,null,null,null);
uis.route('/vhr/hper/staff_plan:model','Ui_Vhr135.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hper/staff_plan:save_task','Ui_Vhr135.Save_Tasks','M',null,'A',null,null,null,null);

uis.path('/vhr/hper/staff_plan','vhr135');
uis.form('/vhr/hper/staff_plan','/vhr/hper/staff_plan','F','A','F','HM','M','N',null,'N');




uis.action('/vhr/hper/staff_plan','delete_plan_part','F',null,null,'A');
uis.action('/vhr/hper/staff_plan','save','F',null,null,'A');
uis.action('/vhr/hper/staff_plan','save_plan_part','F',null,null,'A');
uis.action('/vhr/hper/staff_plan','set_completed','F',null,null,'A');
uis.action('/vhr/hper/staff_plan','set_new','F',null,null,'A');
uis.action('/vhr/hper/staff_plan','set_waiting','F',null,null,'A');
uis.action('/vhr/hper/staff_plan','view_task','F','/core/ms/task+view','D','O');



uis.ready('/vhr/hper/staff_plan','.delete_plan_part.model.save.save_plan_part.set_completed.set_new.set_waiting.view_task.');

commit;
end;
/
