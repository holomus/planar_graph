set define off
prompt PATH /vhr/hpd/sick_leave
begin
uis.route('/vhr/hpd/sick_leave+add:calc_sick_days','Ui_Vhr171.Calc_Sick_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+add:model','Ui_Vhr171.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/sick_leave+add:reasons','Ui_Vhr171.Query_Sick_Leave_Reasons',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+add:save','Ui_Vhr171.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+add:staffs','Ui_Vhr171.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+edit:calc_sick_days','Ui_Vhr171.Calc_Sick_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+edit:model','Ui_Vhr171.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/sick_leave+edit:reasons','Ui_Vhr171.Query_Sick_Leave_Reasons',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+edit:save','Ui_Vhr171.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+edit:staffs','Ui_Vhr171.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+multiple_add:calc_sick_days','Ui_Vhr171.Calc_Sick_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+multiple_add:model','Ui_Vhr171.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/sick_leave+multiple_add:reasons','Ui_Vhr171.Query_Sick_Leave_Reasons',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+multiple_add:save','Ui_Vhr171.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+multiple_add:staffs','Ui_Vhr171.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+multiple_edit:calc_sick_days','Ui_Vhr171.Calc_Sick_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+multiple_edit:model','Ui_Vhr171.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/sick_leave+multiple_edit:reasons','Ui_Vhr171.Query_Sick_Leave_Reasons',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+multiple_edit:save','Ui_Vhr171.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/sick_leave+multiple_edit:staffs','Ui_Vhr171.Query_Staffs',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/sick_leave','vhr171');
uis.form('/vhr/hpd/sick_leave+add','/vhr/hpd/sick_leave','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpd/sick_leave+edit','/vhr/hpd/sick_leave','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpd/sick_leave+multiple_add','/vhr/hpd/sick_leave','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hpd/sick_leave+multiple_edit','/vhr/hpd/sick_leave','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hpd/sick_leave+add','add_reason','F','/vhr/href/sick_leave_reason+add','D','O');
uis.action('/vhr/hpd/sick_leave+add','select_reason','F','/vhr/href/sick_leave_reason_list','D','O');
uis.action('/vhr/hpd/sick_leave+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/sick_leave+edit','add_reason','F','/vhr/href/sick_leave_reason+add','D','O');
uis.action('/vhr/hpd/sick_leave+edit','select_reason','F','/vhr/href/sick_leave_reason_list','D','O');
uis.action('/vhr/hpd/sick_leave+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/sick_leave+multiple_add','add_reason','F','/vhr/href/sick_leave_reason+add','D','O');
uis.action('/vhr/hpd/sick_leave+multiple_add','select_reason','F','/vhr/href/sick_leave_reason_list','D','O');
uis.action('/vhr/hpd/sick_leave+multiple_add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/sick_leave+multiple_edit','add_reason','F','/vhr/href/sick_leave_reason+add','D','O');
uis.action('/vhr/hpd/sick_leave+multiple_edit','select_reason','F','/vhr/href/sick_leave_reason_list','D','O');
uis.action('/vhr/hpd/sick_leave+multiple_edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/sick_leave+multiple_edit','.add_reason.model.select_reason.select_staff.');
uis.ready('/vhr/hpd/sick_leave+multiple_add','.add_reason.model.select_reason.select_staff.');
uis.ready('/vhr/hpd/sick_leave+add','.add_reason.model.select_reason.select_staff.');
uis.ready('/vhr/hpd/sick_leave+edit','.add_reason.model.select_reason.select_staff.');

commit;
end;
/
