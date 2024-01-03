set define off
prompt PATH /vhr/hper/view/plan_type_view
begin
uis.route('/vhr/hper/view/plan_type_view:model','Ui_Vhr436.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hper/view/plan_type_view:table_audit','Ui_Vhr436.Query_Plan_Type_Audit','M','Q','A',null,null,null,null);
uis.route('/vhr/hper/view/plan_type_view:table_division','Ui_Vhr436.Query_Division_Audit','M','Q','A',null,null,null,null);
uis.route('/vhr/hper/view/plan_type_view:table_task_type','Ui_Vhr436.Query_Task_Type','M','Q','A',null,null,null,null);

uis.path('/vhr/hper/view/plan_type_view','vhr436');
uis.form('/vhr/hper/view/plan_type_view','/vhr/hper/view/plan_type_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hper/view/plan_type_view','audit','F',null,null,'G');
uis.action('/vhr/hper/view/plan_type_view','audit_details','F','/vhr/hper/view/plan_type_audit_details','S','O');
uis.action('/vhr/hper/view/plan_type_view','edit','F','/vhr/hper/plan_type+edit','S','O');


uis.ready('/vhr/hper/view/plan_type_view','.audit.audit_details.edit.model.');

commit;
end;
/
