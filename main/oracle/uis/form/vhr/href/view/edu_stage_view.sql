set define off
prompt PATH /vhr/href/view/edu_stage_view
begin
uis.route('/vhr/href/view/edu_stage_view:model','Ui_Vhr358.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/edu_stage_view:table_audit','Ui_Vhr358.Query_Edu_Stage_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/edu_stage_view','vhr358');
uis.form('/vhr/href/view/edu_stage_view','/vhr/href/view/edu_stage_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/edu_stage_view','audit','A',null,null,'A');
uis.action('/vhr/href/view/edu_stage_view','audit_details','A','/vhr/href/view/edu_stage_audit_details','S','O');
uis.action('/vhr/href/view/edu_stage_view','edit','A','/vhr/href/edu_stage+edit','S','O');


uis.ready('/vhr/href/view/edu_stage_view','.audit.audit_details.edit.model.');

commit;
end;
/
