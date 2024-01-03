set define off
prompt PATH /vhr/hpd/start/overtime_list
begin
uis.route('/vhr/hpd/start/overtime_list$delete','Ui_Vhr334.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_list$edit','Ui_Vhr334.Save','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_list:get_overtime','Ui_Vhr334.Get_Overtime','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_list:get_overtime_day','Ui_Vhr334.Get_Overtime_Day','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_list:get_overtimes','Ui_Vhr334.Get_Overtimes','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_list:load_blocked_staffs','Ui_Vhr334.Load_Blocked_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_list:model','Ui_Vhr334.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/start/overtime_list:save','Ui_Vhr334.Save','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_list:staffs','Ui_Vhr334.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_list:table','Ui_Vhr334.Query','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_list:table_user','Ui_Vhr334.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/start/overtime_list','vhr334');
uis.form('/vhr/hpd/start/overtime_list','/vhr/hpd/start/overtime_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/start/overtime_list','delete','F',null,null,'A');
uis.action('/vhr/hpd/start/overtime_list','edit','F',null,null,'A');
uis.action('/vhr/hpd/start/overtime_list','multiple_add','F','/vhr/hpd/start/overtime_add','S','O');
uis.action('/vhr/hpd/start/overtime_list','select_staff','F','/vhr/href/employee/employee_list','D','O');


uis.ready('/vhr/hpd/start/overtime_list','.delete.edit.model.multiple_add.select_staff.');

commit;
end;
/
