set define off
prompt PATH /vhr/hrm/robot_audit_details
begin
uis.route('/vhr/hrm/robot_audit_details:model','Ui_Vhr664.Model','M','M','A','Y',null,null,null,'S');

uis.path('/vhr/hrm/robot_audit_details','vhr664');
uis.form('/vhr/hrm/robot_audit_details','/vhr/hrm/robot_audit_details','F','A','F','H','M','N',null,'N','S');





uis.ready('/vhr/hrm/robot_audit_details','.model.');

commit;
end;
/
