set define off
prompt PATH /vhr/href/view/employment_source_view
begin
uis.route('/vhr/href/view/employment_source_view:model','Ui_Vhr400.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/employment_source_view:table_audit','Ui_Vhr400.Query_Source_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/employment_source_view','vhr400');
uis.form('/vhr/href/view/employment_source_view','/vhr/href/view/employment_source_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/employment_source_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/employment_source_view','audit_details','A','/vhr/href/view/employment_source_audit_details','S','O');
uis.action('/vhr/href/view/employment_source_view','edit','A','/vhr/href/employment_source+edit','S','O');


uis.ready('/vhr/href/view/employment_source_view','.audit.audit_details.edit.model.');

commit;
end;
/
