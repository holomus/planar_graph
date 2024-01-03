set define off
prompt PATH /vhr/href/view/lang_level_view
begin
uis.route('/vhr/href/view/lang_level_view:model','Ui_Vhr373.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/lang_level_view:table_audit','Ui_Vhr373.Query_Lang_Level_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/lang_level_view','vhr373');
uis.form('/vhr/href/view/lang_level_view','/vhr/href/view/lang_level_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/lang_level_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/lang_level_view','audit_details','A','/vhr/href/view/lang_level_audit_details','S','O');
uis.action('/vhr/href/view/lang_level_view','edit','A','/vhr/href/lang_level+edit','S','O');


uis.ready('/vhr/href/view/lang_level_view','.audit.audit_details.edit.model.');

commit;
end;
/
