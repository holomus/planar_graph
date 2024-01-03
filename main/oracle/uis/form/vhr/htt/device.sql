set define off
prompt PATH /vhr/htt/device
begin
uis.route('/vhr/htt/device+add:admins','Ui_Vhr81.Query_Admins',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/device+add:languages','Ui_Vhr81.Query_Langs',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/device+add:location_name','Ui_Vhr81.Location_Name','M','M','A',null,null,null,null);
uis.route('/vhr/htt/device+add:locations','Ui_Vhr81.Query_Locations',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/device+add:model','Ui_Vhr81.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/device+add:save','Ui_Vhr81.Add','M','M','A',null,null,null,null);
uis.route('/vhr/htt/device+add:terminal_models','Ui_Vhr81.Query_Terminal_Models',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/device+edit:admins','Ui_Vhr81.Query_Admins',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/device+edit:languages','Ui_Vhr81.Query_Langs',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/device+edit:locations','Ui_Vhr81.Query_Locations',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/device+edit:model','Ui_Vhr81.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/device+edit:save','Ui_Vhr81.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/htt/device+edit:terminal_models','Ui_Vhr81.Query_Terminal_Models',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/device','vhr81');
uis.form('/vhr/htt/device+add','/vhr/htt/device','A','A','F','H','M','N',null,'N');
uis.form('/vhr/htt/device+edit','/vhr/htt/device','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/device+add','add_location','A','/vhr/htt/location+add','D','O');
uis.action('/vhr/htt/device+add','select_location','A','/vhr/htt/location_list','D','O');
uis.action('/vhr/htt/device+add','select_terminal_model','A','/vhr/htt/terminal_model_list','D','O');
uis.action('/vhr/htt/device+edit','add_location','A','/vhr/htt/location+add','D','O');
uis.action('/vhr/htt/device+edit','select_location','A','/vhr/htt/location_list','D','O');
uis.action('/vhr/htt/device+edit','select_terminal_model','A','/vhr/htt/terminal_model_list','D','O');


uis.ready('/vhr/htt/device+add','.add_location.model.select_location.select_terminal_model.');
uis.ready('/vhr/htt/device+edit','.add_location.model.select_location.select_terminal_model.');

commit;
end;
/
