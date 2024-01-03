set define off
prompt PATH /vhr/hrm/division_view
begin
uis.route('/vhr/hrm/division_view:model','Ui_Vhr277.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrm/division_view:table_audit','Ui_Vhr277.Query_Division_Audits','M','Q','A',null,null,null,null);

uis.path('/vhr/hrm/division_view','vhr277');
uis.form('/vhr/hrm/division_view','/vhr/hrm/division_view','F','A','F','H','M','N',null,'N');

uis.override_form('/anor/mhr/division_view','vhr','/vhr/hrm/division_view');


uis.action('/vhr/hrm/division_view','audit','F',null,null,'A');
uis.action('/vhr/hrm/division_view','audit_details','F','/anor/mhr/division_audit_details','S','O');
uis.action('/vhr/hrm/division_view','edit','F','/vhr/hrm/division+edit','S','O');
uis.action('/vhr/hrm/division_view','robots','F','/vhr/hrm/robot_list','S','O');


uis.ready('/vhr/hrm/division_view','.audit.audit_details.edit.model.robots.');

commit;
end;
/
