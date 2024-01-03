set define off
prompt PATH /vhr/hpd/overtime
begin
uis.route('/vhr/hpd/overtime+add:get_overtime_day','Ui_Vhr280.Get_Overtime_Day','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/overtime+add:get_overtimes','Ui_Vhr280.Get_Overtimes','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/overtime+add:get_overtimes_all','Ui_Vhr280.Get_Overtimes_All','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/overtime+add:load_blocked_staffs','Ui_Vhr280.Load_Blocked_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/overtime+add:model','Ui_Vhr280.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/overtime+add:save','Ui_Vhr280.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/overtime+add:staff','Ui_Vhr280.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/overtime+add:staffs','Ui_Vhr280.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/overtime+edit:get_overtime_day','Ui_Vhr280.Get_Overtime_Day','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/overtime+edit:get_overtimes','Ui_Vhr280.Get_Overtimes','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/overtime+edit:get_overtimes_all','Ui_Vhr280.Get_Overtimes_All','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/overtime+edit:load_blocked_staffs','Ui_Vhr280.Load_Blocked_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/overtime+edit:model','Ui_Vhr280.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/overtime+edit:save','Ui_Vhr280.Edit','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/overtime+edit:staffs','Ui_Vhr280.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/overtime','vhr280');
uis.form('/vhr/hpd/overtime+add','/vhr/hpd/overtime','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/overtime+edit','/vhr/hpd/overtime','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/overtime+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/overtime+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/overtime+add','.model.select_staff.');
uis.ready('/vhr/hpd/overtime+edit','.model.select_staff.');

commit;
end;
/
