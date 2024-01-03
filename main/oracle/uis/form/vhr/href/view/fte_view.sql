set define off
prompt PATH /vhr/href/view/fte_view
begin
uis.route('/vhr/href/view/fte_view:model','Ui_Vhr405.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/fte_view:table_audit','Ui_Vhr405.Query_Fte_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/fte_view','vhr405');
uis.form('/vhr/href/view/fte_view','/vhr/href/view/fte_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/fte_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/fte_view','audit_details','A','/vhr/href/view/fte_audit_details','S','O');
uis.action('/vhr/href/view/fte_view','edit','A','/vhr/href/fte+edit','S','O');


uis.ready('/vhr/href/view/fte_view','.audit.audit_details.edit.model.');

commit;
end;
/
