set define off
prompt PATH /vhr/hpr/start/wage_sheet
begin
uis.route('/vhr/hpr/start/wage_sheet+add:get_period_wages','Ui_Vhr308.Get_Period_Wages','M','L','A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+add:load_blocked_staffs','Ui_Vhr308.Load_Blocked_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+add:load_part_details','Ui_Vhr308.Load_Part_Details','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+add:model','Ui_Vhr308.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+add:save','Ui_Vhr308.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+add:staffs','Ui_Vhr308.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+edit:get_period_wages','Ui_Vhr308.Get_Period_Wages','M','L','A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+edit:load_blocked_staffs','Ui_Vhr308.Load_Blocked_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+edit:load_part_details','Ui_Vhr308.Load_Part_Details','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+edit:model','Ui_Vhr308.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+edit:save','Ui_Vhr308.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/start/wage_sheet+edit:staffs','Ui_Vhr308.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/hpr/start/wage_sheet','vhr308');
uis.form('/vhr/hpr/start/wage_sheet+add','/vhr/hpr/start/wage_sheet','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpr/start/wage_sheet+edit','/vhr/hpr/start/wage_sheet','F','A','F','H','M','N',null,null);



uis.action('/vhr/hpr/start/wage_sheet+add','select_staff','F','/vhr/href/employee/employee_list','D','O');
uis.action('/vhr/hpr/start/wage_sheet+edit','select_staff','F','/vhr/href/employee/employee_list','D','O');


uis.ready('/vhr/hpr/start/wage_sheet+add','.model.select_staff.');
uis.ready('/vhr/hpr/start/wage_sheet+edit','.model.select_staff.');

commit;
end;
/
