set define off
prompt PATH /vhr/href/view/relation_degree_audit_details
begin
uis.route('/vhr/href/view/relation_degree_audit_details:model','Ui_Vhr380.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/view/relation_degree_audit_details','vhr380');
uis.form('/vhr/href/view/relation_degree_audit_details','/vhr/href/view/relation_degree_audit_details','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/view/relation_degree_audit_details','.model.');

commit;
end;
/
