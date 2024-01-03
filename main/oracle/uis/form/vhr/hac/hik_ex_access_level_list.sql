set define off
prompt PATH /vhr/hac/hik_ex_access_level_list
begin
uis.route('/vhr/hac/hik_ex_access_level_list$delete','Ui_Vhr514.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_access_level_list:get_access_levels','Ui_Vhr514.Get_Access_Levels','M','R','A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_access_level_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/hik_ex_access_level_list:table','Ui_Vhr514.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/hik_ex_access_level_list','vhr514');
uis.form('/vhr/hac/hik_ex_access_level_list','/vhr/hac/hik_ex_access_level_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/hik_ex_access_level_list','delete','A',null,null,'A');


uis.ready('/vhr/hac/hik_ex_access_level_list','.delete.model.');

commit;
end;
/
