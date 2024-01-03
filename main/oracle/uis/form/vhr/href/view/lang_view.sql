set define off
prompt PATH /vhr/href/view/lang_view
begin
uis.route('/vhr/href/view/lang_view:model','Ui_Vhr371.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/lang_view:table_audit','Ui_Vhr371.Query_Lang_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/lang_view','vhr371');
uis.form('/vhr/href/view/lang_view','/vhr/href/view/lang_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/lang_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/lang_view','audit_details','A','/vhr/href/view/lang_audit_details','S','O');
uis.action('/vhr/href/view/lang_view','edit','A','/vhr/href/lang+edit','S','O');


uis.ready('/vhr/href/view/lang_view','.audit.audit_details.edit.model.');

commit;
end;
/
