set define off
prompt PATH /vhr/href/view/specialty_view
begin
uis.route('/vhr/href/view/specialty_view:model','Ui_Vhr367.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/specialty_view:table_audit','Ui_Vhr367.Query_Specialty_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/specialty_view','vhr367');
uis.form('/vhr/href/view/specialty_view','/vhr/href/view/specialty_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/specialty_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/specialty_view','audit_details','A','/vhr/href/view/specialty_audit_details','S','O');
uis.action('/vhr/href/view/specialty_view','edit','A','/vhr/href/specialty+edit','S','O');


uis.ready('/vhr/href/view/specialty_view','.audit.audit_details.edit.model.');

commit;
end;
/
