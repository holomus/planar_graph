set define off
prompt PATH /vhr/hac/hik_ex_organization_list
begin
uis.route('/vhr/hac/hik_ex_organization_list$delete','Ui_Vhr515.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_organization_list:get_organizations','Ui_Vhr515.Get_Organizations','M','R','A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_organization_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/hik_ex_organization_list:table','Ui_Vhr515.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/hik_ex_organization_list','vhr515');
uis.form('/vhr/hac/hik_ex_organization_list','/vhr/hac/hik_ex_organization_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/hik_ex_organization_list','delete','A',null,null,'A');


uis.ready('/vhr/hac/hik_ex_organization_list','.delete.model.');

commit;
end;
/
