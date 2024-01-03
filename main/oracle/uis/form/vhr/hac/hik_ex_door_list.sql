set define off
prompt PATH /vhr/hac/hik_ex_door_list
begin
uis.route('/vhr/hac/hik_ex_door_list$delete','Ui_Vhr513.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_door_list:get_doors','Ui_Vhr513.Get_Doors','M','R','A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_door_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/hik_ex_door_list:servers','Ui_Vhr513.Query_Servers',null,null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_door_list:table','Ui_Vhr513.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/hik_ex_door_list','vhr513');
uis.form('/vhr/hac/hik_ex_door_list','/vhr/hac/hik_ex_door_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/hik_ex_door_list','delete','A',null,null,'A');


uis.ready('/vhr/hac/hik_ex_door_list','.delete.model.');

commit;
end;
/
