set define off
prompt PATH /vhr/hpd/application/hiring
begin
uis.route('/vhr/hpd/application/hiring+add:model','Ui_Vhr541.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/hiring+add:robots','Ui_Vhr541.Query_Robots','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/hiring+add:save','Ui_Vhr541.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/hiring+edit:model','Ui_Vhr541.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/hiring+edit:robots','Ui_Vhr541.Query_Robots','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/hiring+edit:save','Ui_Vhr541.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hpd/application/hiring','vhr541');
uis.form('/vhr/hpd/application/hiring+add','/vhr/hpd/application/hiring','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/application/hiring+edit','/vhr/hpd/application/hiring','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/application/hiring+add','add_robot','F','/vhr/hrm/robot+add','D','O');
uis.action('/vhr/hpd/application/hiring+add','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/hpd/application/hiring+edit','add_robot','F','/vhr/hrm/robot+add','D','O');
uis.action('/vhr/hpd/application/hiring+edit','select_robot','F','/vhr/hrm/robot_list','D','O');


uis.ready('/vhr/hpd/application/hiring+add','.add_robot.model.select_robot.');
uis.ready('/vhr/hpd/application/hiring+edit','.add_robot.model.select_robot.');

commit;
end;
/
