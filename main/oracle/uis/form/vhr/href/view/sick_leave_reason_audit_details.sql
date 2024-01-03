set define off
prompt PATH /vhr/href/view/sick_leave_reason_audit_details
begin
uis.route('/vhr/href/view/sick_leave_reason_audit_details:model','Ui_Vhr393.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/view/sick_leave_reason_audit_details','vhr393');
uis.form('/vhr/href/view/sick_leave_reason_audit_details','/vhr/href/view/sick_leave_reason_audit_details','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/view/sick_leave_reason_audit_details','.model.');

commit;
end;
/
