set define off
prompt PATH /vhr/hpd/application/create_robot_view
begin
uis.route('/vhr/hpd/application/create_robot_view:approved_to_in_progress','Ui_Vhr544.Change_Status_To_In_Progress','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:approved_to_waiting','Ui_Vhr544.Change_Status_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:bind_robot','Ui_Vhr544.Application_Bind_Robot','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:canceled_to_waiting','Ui_Vhr544.Change_Status_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:completed_to_in_progress','Ui_Vhr544.Change_Status_To_In_Progress','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:in_progress_to_approved','Ui_Vhr544.Change_Status_From_In_Progress_To_Approved','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:in_progress_to_completed','Ui_Vhr544.Change_Status_To_Completed','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:model','Ui_Vhr544.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:new_to_waiting','Ui_Vhr544.Change_Status_From_New_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:waiting_to_approved','Ui_Vhr544.Change_Status_From_Waiting_To_Approved','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:waiting_to_canceled','Ui_Vhr544.Change_Status_To_Canceled','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot_view:waiting_to_new','Ui_Vhr544.Change_Status_To_New','M',null,'A',null,null,null,null);

uis.path('/vhr/hpd/application/create_robot_view','vhr544');
uis.form('/vhr/hpd/application/create_robot_view','/vhr/hpd/application/create_robot_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/application/create_robot_view','add_robot','F','/vhr/hrm/robot+add','D','O');
uis.action('/vhr/hpd/application/create_robot_view','edit','F','/vhr/hpd/application/create_robot+edit','S','O');
uis.action('/vhr/hpd/application/create_robot_view','view_robots','F','/anor/mrf/robot_list','S','O');


uis.ready('/vhr/hpd/application/create_robot_view','.add_robot.edit.model.view_robots.');

commit;
end;
/
