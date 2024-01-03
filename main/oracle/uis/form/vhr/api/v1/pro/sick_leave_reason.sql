set define off
prompt PATH /vhr/api/v1/pro/sick_leave_reason
begin
uis.route('/vhr/api/v1/pro/sick_leave_reason$create','Ui_Vhr421.Create_Sick_Leave_Reason','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/sick_leave_reason$delete','Ui_Vhr421.Delete_Sick_Leave_Reason','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/pro/sick_leave_reason$list','Ui_Vhr421.List_Sick_Leave_Reasons','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/sick_leave_reason$update','Ui_Vhr421.Update_Sick_Leave_Reason','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/pro/sick_leave_reason','vhr421');
uis.form('/vhr/api/v1/pro/sick_leave_reason','/vhr/api/v1/pro/sick_leave_reason','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/sick_leave_reason','create','F',null,null,'A');
uis.action('/vhr/api/v1/pro/sick_leave_reason','delete','F',null,null,'A');
uis.action('/vhr/api/v1/pro/sick_leave_reason','list','F',null,null,'A');
uis.action('/vhr/api/v1/pro/sick_leave_reason','update','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/sick_leave_reason','.create.delete.list.model.update.');

commit;
end;
/
