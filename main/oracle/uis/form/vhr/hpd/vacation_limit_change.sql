set define off
prompt PATH /vhr/hpd/vacation_limit_change
begin
uis.route('/vhr/hpd/vacation_limit_change+add:get_limit_day','Ui_Vhr269.Get_Limit_Day','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/vacation_limit_change+add:get_limit_days','Ui_Vhr269.Get_Limit_Days','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/vacation_limit_change+add:model','Ui_Vhr269.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/vacation_limit_change+add:save','Ui_Vhr269.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/vacation_limit_change+add:staffs','Ui_Vhr269.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/vacation_limit_change+edit:get_limit_day','Ui_Vhr269.Get_Limit_Day','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/vacation_limit_change+edit:get_limit_days','Ui_Vhr269.Get_Limit_Days','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/vacation_limit_change+edit:model','Ui_Vhr269.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/vacation_limit_change+edit:save','Ui_Vhr269.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/vacation_limit_change+edit:staffs','Ui_Vhr269.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/vacation_limit_change','vhr269');
uis.form('/vhr/hpd/vacation_limit_change+add','/vhr/hpd/vacation_limit_change','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpd/vacation_limit_change+edit','/vhr/hpd/vacation_limit_change','F','A','F','H','M','N',null,null);



uis.action('/vhr/hpd/vacation_limit_change+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/vacation_limit_change+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/vacation_limit_change+add','.model.select_staff.');
uis.ready('/vhr/hpd/vacation_limit_change+edit','.model.select_staff.');

commit;
end;
/
