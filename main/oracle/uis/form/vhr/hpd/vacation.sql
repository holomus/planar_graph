set define off
prompt PATH /vhr/hpd/vacation
begin
uis.route('/vhr/hpd/vacation+add:calc_vacation_days','Ui_Vhr187.Calc_Vacation_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+add:get_vacation_payment','Ui_Vhr187.Get_Vacation_Payment','M','M','A',null,null,null,null,'S');
uis.route('/vhr/hpd/vacation+add:model','Ui_Vhr187.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/vacation+add:save','Ui_Vhr187.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+add:staffs','Ui_Vhr187.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+add:time_kinds','Ui_Vhr187.Query_Time_Kinds',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+edit:calc_vacation_days','Ui_Vhr187.Calc_Vacation_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+edit:get_vacation_payment','Ui_Vhr187.Get_Vacation_Payment','M','M','A',null,null,null,null,'S');
uis.route('/vhr/hpd/vacation+edit:model','Ui_Vhr187.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/vacation+edit:save','Ui_Vhr187.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+edit:staffs','Ui_Vhr187.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+edit:time_kinds','Ui_Vhr187.Query_Time_Kinds',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_add:calc_vacation_days','Ui_Vhr187.Calc_Vacation_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_add:get_vacation_payment','Ui_Vhr187.Get_Vacation_Payment','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_add:model','Ui_Vhr187.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_add:save','Ui_Vhr187.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_add:staffs','Ui_Vhr187.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_add:time_kinds','Ui_Vhr187.Query_Time_Kinds',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_edit:calc_vacation_days','Ui_Vhr187.Calc_Vacation_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_edit:get_vacation_payment','Ui_Vhr187.Get_Vacation_Payment','M','M','A',null,null,null,null,'S');
uis.route('/vhr/hpd/vacation+multiple_edit:model','Ui_Vhr187.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_edit:save','Ui_Vhr187.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_edit:staffs','Ui_Vhr187.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/vacation+multiple_edit:time_kinds','Ui_Vhr187.Query_Time_Kinds',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/vacation','vhr187');
uis.form('/vhr/hpd/vacation+add','/vhr/hpd/vacation','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpd/vacation+edit','/vhr/hpd/vacation','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpd/vacation+multiple_add','/vhr/hpd/vacation','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hpd/vacation+multiple_edit','/vhr/hpd/vacation','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hpd/vacation+add','add_time_kind','F','/vhr/htt/time_kind+add','D','O');
uis.action('/vhr/hpd/vacation+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/vacation+add','select_time_kind','F','/vhr/htt/time_kind_list','D','O');
uis.action('/vhr/hpd/vacation+edit','add_time_kind','F','/vhr/htt/time_kind+add','D','O');
uis.action('/vhr/hpd/vacation+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/vacation+edit','select_time_kind','F','/vhr/htt/time_kind_list','D','O');
uis.action('/vhr/hpd/vacation+multiple_add','add_time_kind','F','/vhr/htt/time_kind+add','D','O');
uis.action('/vhr/hpd/vacation+multiple_add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/vacation+multiple_add','select_time_kind','F','/vhr/htt/time_kind_list','D','O');
uis.action('/vhr/hpd/vacation+multiple_edit','add_time_kind','F','/vhr/htt/time_kind+add','D','O');
uis.action('/vhr/hpd/vacation+multiple_edit','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/vacation+multiple_edit','select_time_kind','F','/vhr/htt/time_kind_list','D','O');


uis.ready('/vhr/hpd/vacation+add','.add_time_kind.model.select_staff.select_time_kind.');
uis.ready('/vhr/hpd/vacation+edit','.add_time_kind.model.select_staff.select_time_kind.');
uis.ready('/vhr/hpd/vacation+multiple_add','.add_time_kind.model.select_staff.select_time_kind.');
uis.ready('/vhr/hpd/vacation+multiple_edit','.add_time_kind.model.select_staff.select_time_kind.');

commit;
end;
/
