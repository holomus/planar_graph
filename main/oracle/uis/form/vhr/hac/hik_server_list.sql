set define off
prompt PATH /vhr/hac/hik_server_list
begin
uis.route('/vhr/hac/hik_server_list$delete','Ui_Vhr516.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_server_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/hik_server_list:table','Ui_Vhr516.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hac/hik_server_list','vhr516');
uis.form('/vhr/hac/hik_server_list','/vhr/hac/hik_server_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/hik_server_list','add','A','/vhr/hac/hik_server+add','S','O');
uis.action('/vhr/hac/hik_server_list','delete','A',null,null,'A');
uis.action('/vhr/hac/hik_server_list','edit','A','/vhr/hac/hik_server+edit','S','O');
uis.action('/vhr/hac/hik_server_list','view','A','/vhr/hac/hik_server_view','S','O');


uis.ready('/vhr/hac/hik_server_list','.add.delete.edit.model.view.');

commit;
end;
/
