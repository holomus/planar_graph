set define off
prompt PATH /vhr/href/view/wage_view
begin
uis.route('/vhr/href/view/wage_view:model','Ui_Vhr397.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/wage_view:table_audit','Ui_Vhr397.Query_Wage_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/wage_view','vhr397');
uis.form('/vhr/href/view/wage_view','/vhr/href/view/wage_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/wage_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/wage_view','audit_details','A','/vhr/href/view/wage_audit_details','S','O');
uis.action('/vhr/href/view/wage_view','edit','A','/vhr/href/wage+edit','S','O');


uis.ready('/vhr/href/view/wage_view','.audit.audit_details.edit.model.');

commit;
end;
/
