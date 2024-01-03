set define off
prompt PATH /vhr/href/view/science_branch_view
begin
uis.route('/vhr/href/view/science_branch_view:model','Ui_Vhr360.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/science_branch_view:table_audit','Ui_Vhr360.Query_Science_Branche_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/science_branch_view','vhr360');
uis.form('/vhr/href/view/science_branch_view','/vhr/href/view/science_branch_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/science_branch_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/science_branch_view','audit_details','A','/vhr/href/view/science_branch_audit_details','S','O');
uis.action('/vhr/href/view/science_branch_view','edit','A','/vhr/href/science_branch+edit','S','O');


uis.ready('/vhr/href/view/science_branch_view','.audit.audit_details.edit.model.');

commit;
end;
/
