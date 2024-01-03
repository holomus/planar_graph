set define off
prompt PATH /vhr/hpr/start/onetime_sheet
begin
uis.route('/vhr/hpr/start/onetime_sheet+add:get_period_info','Ui_Vhr438.Get_Period_Info','M','L','A',null,null,null,null);
uis.route('/vhr/hpr/start/onetime_sheet+add:load_blocked_staffs','Ui_Vhr438.Load_Blocked_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/start/onetime_sheet+add:model','Ui_Vhr438.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/start/onetime_sheet+add:save','Ui_Vhr438.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/start/onetime_sheet+add:staffs','Ui_Vhr438.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/start/onetime_sheet+edit:get_period_info','Ui_Vhr438.Get_Period_Info','M','L','A',null,null,null,null);
uis.route('/vhr/hpr/start/onetime_sheet+edit:load_blocked_staffs','Ui_Vhr438.Load_Blocked_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/start/onetime_sheet+edit:model','Ui_Vhr438.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/start/onetime_sheet+edit:save','Ui_Vhr438.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/start/onetime_sheet+edit:staffs','Ui_Vhr438.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/hpr/start/onetime_sheet','vhr438');
uis.form('/vhr/hpr/start/onetime_sheet+add','/vhr/hpr/start/onetime_sheet','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpr/start/onetime_sheet+edit','/vhr/hpr/start/onetime_sheet','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpr/start/onetime_sheet+add','select_staff','F','/vhr/href/employee/employee_list','D','O');
uis.action('/vhr/hpr/start/onetime_sheet+edit','select_staff','F','/vhr/href/employee/employee_list','D','O');


uis.ready('/vhr/hpr/start/onetime_sheet+add','.model.select_staff.');
uis.ready('/vhr/hpr/start/onetime_sheet+edit','.model.select_staff.');

commit;
end;
/
