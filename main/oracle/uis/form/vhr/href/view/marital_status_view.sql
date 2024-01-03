set define off
prompt PATH /vhr/href/view/marital_status_view
begin
uis.route('/vhr/href/view/marital_status_view:model','Ui_Vhr383.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/marital_status_view:table_audit','Ui_Vhr383.Query_Marital_Status_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/marital_status_view','vhr383');
uis.form('/vhr/href/view/marital_status_view','/vhr/href/view/marital_status_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/marital_status_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/marital_status_view','audit_details','A','/vhr/href/view/marital_status_audit_details','S','O');
uis.action('/vhr/href/view/marital_status_view','edit','A','/vhr/href/marital_status+edit','S','O');


uis.ready('/vhr/href/view/marital_status_view','.audit.audit_details.edit.model.');

commit;
end;
/
