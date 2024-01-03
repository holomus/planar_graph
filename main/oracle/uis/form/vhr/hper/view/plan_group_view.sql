set define off
prompt PATH /vhr/hper/view/plan_group_view
begin
uis.route('/vhr/hper/view/plan_group_view:model','Ui_Vhr434.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hper/view/plan_group_view:table_audit','Ui_Vhr434.Query_Plan_Group_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/hper/view/plan_group_view','vhr434');
uis.form('/vhr/hper/view/plan_group_view','/vhr/hper/view/plan_group_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hper/view/plan_group_view','audit','F',null,null,'G');
uis.action('/vhr/hper/view/plan_group_view','audit_details','F','/vhr/hper/view/plan_group_audit_details','S','O');
uis.action('/vhr/hper/view/plan_group_view','edit','F','/vhr/hper/plan_group+edit','S','O');


uis.ready('/vhr/hper/view/plan_group_view','.audit.audit_details.edit.model.');

commit;
end;
/
