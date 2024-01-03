set define off
prompt PATH /vhr/href/view/indicator_view
begin
uis.route('/vhr/href/view/indicator_view:model','Ui_Vhr402.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/indicator_view:table_audit','Ui_Vhr402.Query_Indicator_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/indicator_view','vhr402');
uis.form('/vhr/href/view/indicator_view','/vhr/href/view/indicator_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/indicator_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/indicator_view','audit_details','A','/vhr/href/view/indicator_audit_details','S','O');
uis.action('/vhr/href/view/indicator_view','edit','A','/vhr/href/indicator+edit','S','O');


uis.ready('/vhr/href/view/indicator_view','.audit.audit_details.edit.model.');

commit;
end;
/
