set define off
prompt PATH /vhr/href/view/labor_function_view
begin
uis.route('/vhr/href/view/labor_function_view:model','Ui_Vhr389.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/labor_function_view:table_audit','Ui_Vhr389.Query_Labor_Function_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/labor_function_view','vhr389');
uis.form('/vhr/href/view/labor_function_view','/vhr/href/view/labor_function_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/labor_function_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/labor_function_view','audit_details','A','/vhr/href/view/labor_function_audit_details','S','O');
uis.action('/vhr/href/view/labor_function_view','edit','A','/vhr/href/labor_function+edit','S','O');


uis.ready('/vhr/href/view/labor_function_view','.audit.audit_details.edit.model.');

commit;
end;
/
