set define off
prompt PATH /vhr/hpd/application/application_list
begin
uis.route('/vhr/hpd/application/application_list$delete','Ui_Vhr534.Del','L',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/application_list+head$delete','Ui_Vhr534.Del','L',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/application_list+head:model','Ui_Vhr534.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/application_list+head:table','Ui_Vhr534.Query',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/application_list:model','Ui_Vhr534.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/application_list:table','Ui_Vhr534.Query',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/application_list:to_approved','Ui_Vhr534.To_Approved','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/application_list:to_canceled','Ui_Vhr534.To_Canceled','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/application_list:to_completed','Ui_Vhr534.To_Completed','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/application_list:to_in_progress','Ui_Vhr534.To_In_Progress','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/application_list:to_new','Ui_Vhr534.To_New','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/application_list:to_waiting','Ui_Vhr534.To_Waiting','M',null,'A',null,null,null,null);

uis.path('/vhr/hpd/application/application_list','vhr534');
uis.form('/vhr/hpd/application/application_list','/vhr/hpd/application/application_list','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/application/application_list+head','/vhr/hpd/application/application_list','H','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/application/application_list','create_robot_add','F','/vhr/hpd/application/create_robot+add','S','O');
uis.action('/vhr/hpd/application/application_list','create_robot_applicant','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','create_robot_edit','F','/vhr/hpd/application/create_robot+edit','S','O');
uis.action('/vhr/hpd/application/application_list','create_robot_hr','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','create_robot_manager','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','create_robot_view','F','/vhr/hpd/application/create_robot_view','S','O');
uis.action('/vhr/hpd/application/application_list','delete','F',null,null,'A');
uis.action('/vhr/hpd/application/application_list','dismissal_add','F','/vhr/hpd/application/dismissal+add','S','O');
uis.action('/vhr/hpd/application/application_list','dismissal_applicant','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','dismissal_edit','F','/vhr/hpd/application/dismissal+edit','S','O');
uis.action('/vhr/hpd/application/application_list','dismissal_hr','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','dismissal_manager','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','dismissal_view','F','/vhr/hpd/application/dismissal_view','S','O');
uis.action('/vhr/hpd/application/application_list','hiring_add','F','/vhr/hpd/application/hiring+add','S','O');
uis.action('/vhr/hpd/application/application_list','hiring_applicant','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','hiring_edit','F','/vhr/hpd/application/hiring+edit','S','O');
uis.action('/vhr/hpd/application/application_list','hiring_hr','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','hiring_manager','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','hiring_view','F','/vhr/hpd/application/hiring_view','S','O');
uis.action('/vhr/hpd/application/application_list','transfer_add','F','/vhr/hpd/application/transfer+add','S','O');
uis.action('/vhr/hpd/application/application_list','transfer_applicant','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','transfer_edit','F','/vhr/hpd/application/transfer+edit','S','O');
uis.action('/vhr/hpd/application/application_list','transfer_hr','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','transfer_manager','F',null,null,'G');
uis.action('/vhr/hpd/application/application_list','transfer_multiple_add','F','/vhr/hpd/application/transfer_multiple+add','S','O');
uis.action('/vhr/hpd/application/application_list','transfer_multiple_edit','F','/vhr/hpd/application/transfer_multiple+edit','S','O');
uis.action('/vhr/hpd/application/application_list','transfer_multiple_view','F','/vhr/hpd/application/transfer_multiple_view','S','O');
uis.action('/vhr/hpd/application/application_list','transfer_view','F','/vhr/hpd/application/transfer_view','S','O');
uis.action('/vhr/hpd/application/application_list+head','delete','H',null,null,'A');


uis.ready('/vhr/hpd/application/application_list','.create_robot_add.create_robot_applicant.create_robot_edit.create_robot_hr.create_robot_manager.create_robot_view.delete.dismissal_add.dismissal_applicant.dismissal_edit.dismissal_hr.dismissal_manager.dismissal_view.hiring_add.hiring_applicant.hiring_edit.hiring_hr.hiring_manager.hiring_view.model.transfer_add.transfer_applicant.transfer_edit.transfer_hr.transfer_manager.transfer_multiple_add.transfer_multiple_edit.transfer_multiple_view.transfer_view.');
uis.ready('/vhr/hpd/application/application_list+head','.delete.model.');

commit;
end;
/
