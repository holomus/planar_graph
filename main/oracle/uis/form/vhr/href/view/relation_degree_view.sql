set define off
prompt PATH /vhr/href/view/relation_degree_view
begin
uis.route('/vhr/href/view/relation_degree_view:model','Ui_Vhr381.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/relation_degree_view:table_audit','Ui_Vhr381.Query_Relation_Degree_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/relation_degree_view','vhr381');
uis.form('/vhr/href/view/relation_degree_view','/vhr/href/view/relation_degree_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/relation_degree_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/relation_degree_view','audit_details','A','/vhr/href/view/relation_degree_audit_details','S','O');
uis.action('/vhr/href/view/relation_degree_view','edit','A','/vhr/href/relation_degree+edit','S','O');


uis.ready('/vhr/href/view/relation_degree_view','.audit.audit_details.edit.model.');

commit;
end;
/
