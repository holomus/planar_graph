set define off
prompt PATH /vhr/htt/change
begin
uis.route('/vhr/htt/change+add:load_interval_dates','Ui_Vhr218.Load_Interval_Dates',null,null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change+add:load_monthly_limit','Ui_Vhr218.Load_Monthly_Limit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/change+add:load_timesheet','Ui_Vhr218.Load_Timesheet','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/change+add:model','Ui_Vhr218.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/htt/change+add:save','Ui_Vhr218.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change+add:staffs','Ui_Vhr218.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/change+add_personal:load_interval_dates','Ui_Vhr218.Load_Interval_Dates','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/change+add_personal:load_timesheet','Ui_Vhr218.Load_Timesheet','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/change+add_personal:model','Ui_Vhr218.Add_Model_Personal',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/htt/change+add_personal:save','Ui_Vhr218.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change+add_personal:staffs','Ui_Vhr218.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/change+edit:load_interval_dates','Ui_Vhr218.Load_Interval_Dates',null,null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change+edit:load_monthly_limit','Ui_Vhr218.Load_Monthly_Limit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/change+edit:load_timesheet','Ui_Vhr218.Load_Timesheet','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/change+edit:model','Ui_Vhr218.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/change+edit:save','Ui_Vhr218.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change+edit_personal:load_interval_dates','Ui_Vhr218.Load_Interval_Dates','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/change+edit_personal:load_timesheet','Ui_Vhr218.Load_Timesheet','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/change+edit_personal:model','Ui_Vhr218.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/change+edit_personal:save','Ui_Vhr218.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change+edit_personal:staffs','Ui_Vhr218.Query_Staffs',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/htt/change','vhr218');
uis.form('/vhr/htt/change+add','/vhr/htt/change','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/htt/change+add_personal','/vhr/htt/change','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/htt/change+edit','/vhr/htt/change','A','A','F','H','M','N',null,null,null);
uis.form('/vhr/htt/change+edit_personal','/vhr/htt/change','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/htt/change+add','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/htt/change+add','.model.select_staff.');
uis.ready('/vhr/htt/change+add_personal','.model.');
uis.ready('/vhr/htt/change+edit','.model.');
uis.ready('/vhr/htt/change+edit_personal','.model.');

commit;
end;
/
