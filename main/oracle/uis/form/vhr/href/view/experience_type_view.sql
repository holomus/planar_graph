set define off
prompt PATH /vhr/href/view/experience_type_view
begin
uis.route('/vhr/href/view/experience_type_view:model','Ui_Vhr385.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/experience_type_view:table_audit','Ui_Vhr385.Query_Experience_Type_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/experience_type_view','vhr385');
uis.form('/vhr/href/view/experience_type_view','/vhr/href/view/experience_type_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/experience_type_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/experience_type_view','audit_details','A','/vhr/href/view/experience_type_audit_details','S','O');
uis.action('/vhr/href/view/experience_type_view','edit','A','/vhr/href/experience_type+edit','S','O');


uis.ready('/vhr/href/view/experience_type_view','.audit.audit_details.edit.model.');

commit;
end;
/
