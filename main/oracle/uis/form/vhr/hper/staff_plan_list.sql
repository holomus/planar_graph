set define off
prompt PATH /vhr/hper/staff_plan_list
begin
uis.route('/vhr/hper/staff_plan_list$delete','Ui_Vhr134.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/staff_plan_list$set_completed','Ui_Vhr134.Set_Completed','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/staff_plan_list$set_draft','Ui_Vhr134.Set_Draft','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/staff_plan_list$set_new','Ui_Vhr134.Set_New','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/staff_plan_list$set_waiting','Ui_Vhr134.Set_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/staff_plan_list:model','Ui_Vhr134.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hper/staff_plan_list:table','Ui_Vhr134.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hper/staff_plan_list','vhr134');
uis.form('/vhr/hper/staff_plan_list','/vhr/hper/staff_plan_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hper/staff_plan_list','audit','F','/vhr/hper/audit/staff_plan_audit','S','O');
uis.action('/vhr/hper/staff_plan_list','delete','F',null,null,'A');
uis.action('/vhr/hper/staff_plan_list','set_completed','F',null,null,'A');
uis.action('/vhr/hper/staff_plan_list','set_draft','F',null,null,'A');
uis.action('/vhr/hper/staff_plan_list','set_new','F',null,null,'A');
uis.action('/vhr/hper/staff_plan_list','set_waiting','F',null,null,'A');
uis.action('/vhr/hper/staff_plan_list','view','F','/vhr/hper/staff_plan','S','O');



uis.ready('/vhr/hper/staff_plan_list','.audit.delete.model.set_completed.set_draft.set_new.set_waiting.view.');

commit;
end;
/
