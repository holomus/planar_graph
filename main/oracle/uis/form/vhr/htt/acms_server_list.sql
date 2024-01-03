set define off
prompt PATH /vhr/htt/acms_server_list
begin
uis.route('/vhr/htt/acms_server_list$delete','Ui_Vhr473.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/acms_server_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/acms_server_list:table','Ui_Vhr473.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/acms_server_list','vhr473');
uis.form('/vhr/htt/acms_server_list','/vhr/htt/acms_server_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/acms_server_list','add','A','/vhr/htt/acms_server+add','S','O');
uis.action('/vhr/htt/acms_server_list','delete','A',null,null,'A');
uis.action('/vhr/htt/acms_server_list','edit','A','/vhr/htt/acms_server+edit','S','O');
uis.action('/vhr/htt/acms_server_list','view','A','/vhr/htt/acms_server_view','S','O');


uis.ready('/vhr/htt/acms_server_list','.add.delete.edit.model.view.');

commit;
end;
/
