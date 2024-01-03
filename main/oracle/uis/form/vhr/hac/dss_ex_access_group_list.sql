set define off
prompt PATH /vhr/hac/dss_ex_access_group_list
begin
uis.route('/vhr/hac/dss_ex_access_group_list$delete','Ui_Vhr520.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_access_group_list$get_access_groups','Ui_Vhr520.Get_Access_Groups','M','R','A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_access_group_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/dss_ex_access_group_list:table','Ui_Vhr520.Query_Access_Groups','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/dss_ex_access_group_list','vhr520');
uis.form('/vhr/hac/dss_ex_access_group_list','/vhr/hac/dss_ex_access_group_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/dss_ex_access_group_list','delete','A',null,null,'A');
uis.action('/vhr/hac/dss_ex_access_group_list','get_access_groups','A',null,null,'A');


uis.ready('/vhr/hac/dss_ex_access_group_list','.delete.get_access_groups.model.');

commit;
end;
/
