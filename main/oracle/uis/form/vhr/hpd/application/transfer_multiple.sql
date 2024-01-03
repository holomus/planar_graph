set define off
prompt PATH /vhr/hpd/application/transfer_multiple
begin
uis.route('/vhr/hpd/application/transfer_multiple+add:get_robot','Ui_Vhr619.Get_Robot','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+add:get_staff','Ui_Vhr619.Get_Staff','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+add:model','Ui_Vhr619.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+add:robots','Ui_Vhr619.Query_Robots','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+add:save','Ui_Vhr619.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+add:staffs','Ui_Vhr619.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+edit:get_robot','Ui_Vhr619.Get_Robot','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+edit:get_staff','Ui_Vhr619.Get_Staff','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+edit:model','Ui_Vhr619.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+edit:robots','Ui_Vhr619.Query_Robots','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+edit:save','Ui_Vhr619.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_multiple+edit:staffs','Ui_Vhr619.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/application/transfer_multiple','vhr619');
uis.form('/vhr/hpd/application/transfer_multiple+add','/vhr/hpd/application/transfer_multiple','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/application/transfer_multiple+edit','/vhr/hpd/application/transfer_multiple','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/application/transfer_multiple+add','add_robot','F','/vhr/hrm/robot+add','S','O');
uis.action('/vhr/hpd/application/transfer_multiple+add','select_robot','F','/vhr/hrm/robot_list','S','O');
uis.action('/vhr/hpd/application/transfer_multiple+add','select_staff','F','/vhr/href/staff/staff_list','S','O');
uis.action('/vhr/hpd/application/transfer_multiple+edit','add_robot','F','/vhr/hrm/robot+add','S','O');
uis.action('/vhr/hpd/application/transfer_multiple+edit','select_robot','F','/vhr/hrm/robot_list','S','O');
uis.action('/vhr/hpd/application/transfer_multiple+edit','select_staff','F','/vhr/href/staff/staff_list','S','O');


uis.ready('/vhr/hpd/application/transfer_multiple+add','.add_robot.model.select_robot.select_staff.');
uis.ready('/vhr/hpd/application/transfer_multiple+edit','.add_robot.model.select_robot.select_staff.');

commit;
end;
/
