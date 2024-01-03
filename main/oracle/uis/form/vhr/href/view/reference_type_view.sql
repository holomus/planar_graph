set define off
prompt PATH /vhr/href/view/reference_type_view
begin
uis.route('/vhr/href/view/reference_type_view:model','Ui_Vhr377.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/reference_type_view:table_audit','Ui_Vhr377.Query_Reference_Type_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/reference_type_view','vhr377');
uis.form('/vhr/href/view/reference_type_view','/vhr/href/view/reference_type_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/reference_type_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/reference_type_view','audit_details','A','/vhr/href/view/reference_type_audit_details','S','O');
uis.action('/vhr/href/view/reference_type_view','edit','A','/vhr/href/reference_type+edit','S','O');


uis.ready('/vhr/href/view/reference_type_view','.audit.audit_details.edit.model.');

commit;
end;
/
