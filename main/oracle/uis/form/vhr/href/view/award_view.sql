set define off
prompt PATH /vhr/href/view/award_view
begin
uis.route('/vhr/href/view/award_view:model','Ui_Vhr387.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/award_view:table_audit','Ui_Vhr387.Query_Award_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/award_view','vhr387');
uis.form('/vhr/href/view/award_view','/vhr/href/view/award_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/award_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/award_view','audit_details','A','/vhr/href/view/award_audit_details','S','O');
uis.action('/vhr/href/view/award_view','edit','A','/vhr/href/award+edit','S','O');


uis.ready('/vhr/href/view/award_view','.audit.audit_details.edit.model.');

commit;
end;
/
