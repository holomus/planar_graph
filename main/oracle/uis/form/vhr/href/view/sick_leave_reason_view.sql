set define off
prompt PATH /vhr/href/view/sick_leave_reason_view
begin
uis.route('/vhr/href/view/sick_leave_reason_view:model','Ui_Vhr392.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/sick_leave_reason_view:table_audit','Ui_Vhr392.Query_Reason_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/sick_leave_reason_view','vhr392');
uis.form('/vhr/href/view/sick_leave_reason_view','/vhr/href/view/sick_leave_reason_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/sick_leave_reason_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/sick_leave_reason_view','audit_details','A','/vhr/href/view/sick_leave_reason_audit_details','S','O');
uis.action('/vhr/href/view/sick_leave_reason_view','edit','A','/vhr/href/sick_leave_reason+edit','S','O');


uis.ready('/vhr/href/view/sick_leave_reason_view','.audit.audit_details.edit.model.');

commit;
end;
/
