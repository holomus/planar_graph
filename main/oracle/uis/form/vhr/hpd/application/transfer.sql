set define off
prompt PATH /vhr/hpd/application/transfer
begin
uis.route('/vhr/hpd/application/transfer+add:model','Ui_Vhr542.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/transfer+add:robots','Ui_Vhr542.Query_Robots','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer+add:save','Ui_Vhr542.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer+add:staffs','Ui_Vhr542.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer+edit:model','Ui_Vhr542.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/transfer+edit:robots','Ui_Vhr542.Query_Robots','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer+edit:save','Ui_Vhr542.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer+edit:staffs','Ui_Vhr542.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/application/transfer','vhr542');
uis.form('/vhr/hpd/application/transfer+add','/vhr/hpd/application/transfer','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/application/transfer+edit','/vhr/hpd/application/transfer','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/application/transfer+add','add_robot','F','/vhr/hrm/robot+add','D','O');
uis.action('/vhr/hpd/application/transfer+add','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/hpd/application/transfer+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/application/transfer+edit','add_robot','F','/vhr/hrm/robot+add','D','O');
uis.action('/vhr/hpd/application/transfer+edit','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/hpd/application/transfer+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/application/transfer+add','.add_robot.model.select_robot.select_staff.');
uis.ready('/vhr/hpd/application/transfer+edit','.add_robot.model.select_robot.select_staff.');

commit;
end;
/
