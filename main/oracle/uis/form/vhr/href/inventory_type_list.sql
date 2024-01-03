set define off
prompt PATH /vhr/href/inventory_type_list
begin
uis.route('/vhr/href/inventory_type_list$delete','Ui_Vhr465.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/inventory_type_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/inventory_type_list:table','Ui_Vhr465.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/inventory_type_list','vhr465');
uis.form('/vhr/href/inventory_type_list','/vhr/href/inventory_type_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/inventory_type_list','add','A','/vhr/href/inventory_type+add','S','O');
uis.action('/vhr/href/inventory_type_list','delete','A',null,null,'A');
uis.action('/vhr/href/inventory_type_list','edit','A','/vhr/href/inventory_type+edit','S','O');


uis.ready('/vhr/href/inventory_type_list','.add.delete.edit.model.');

commit;
end;
/
