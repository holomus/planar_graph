set define off
prompt PATH /vhr/hpd/start/overtime_add
begin
uis.route('/vhr/hpd/start/overtime_add:get_overtime_day','Ui_Vhr526.Get_Overtime_Day','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_add:get_overtimes','Ui_Vhr526.Get_Overtimes','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_add:jobs','Ui_Vhr526.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_add:load_blocked_staffs','Ui_Vhr526.Load_Blocked_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_add:model','Ui_Vhr526.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/start/overtime_add:save','Ui_Vhr526.Save','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/start/overtime_add:staffs','Ui_Vhr526.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/start/overtime_add','vhr526');
uis.form('/vhr/hpd/start/overtime_add','/vhr/hpd/start/overtime_add','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/start/overtime_add','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/start/overtime_add','.model.select_staff.');

commit;
end;
/
