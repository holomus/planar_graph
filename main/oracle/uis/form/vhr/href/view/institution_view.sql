set define off
prompt PATH /vhr/href/view/institution_view
begin
uis.route('/vhr/href/view/institution_view:model','Ui_Vhr406.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/institution_view:table_audit','Ui_Vhr406.Query_Institution_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/institution_view','vhr406');
uis.form('/vhr/href/view/institution_view','/vhr/href/view/institution_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/institution_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/institution_view','audit_details','A','/vhr/href/view/institution_audit_details','S','O');
uis.action('/vhr/href/view/institution_view','edit','A','/vhr/href/institution+edit','S','O');


uis.ready('/vhr/href/view/institution_view','.audit.audit_details.edit.model.');

commit;
end;
/
