set define off
prompt PATH /vhr/href/person/person_inventories
begin
uis.route('/vhr/href/person/person_inventories$delete_person_inventory','Ui_Vhr467.Delete_Person_Inventory','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_inventories$save_person_inventory','Ui_Vhr467.Save_Person_Inventory','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_inventories:inventory_types','Ui_Vhr467.Query_Inventory_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_inventories:model','Ui_Vhr467.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/person/person_inventories','vhr467');
uis.form('/vhr/href/person/person_inventories','/vhr/href/person/person_inventories','F','A','F','H','M','N',null,'N');



uis.action('/vhr/href/person/person_inventories','add_inventory_type','F','/vhr/href/inventory_type+add','D','O');
uis.action('/vhr/href/person/person_inventories','delete_person_inventory','F',null,null,'A');
uis.action('/vhr/href/person/person_inventories','save_person_inventory','F',null,null,'A');
uis.action('/vhr/href/person/person_inventories','select_inventory_type','F','/vhr/href/inventory_type_list','D','O');


uis.ready('/vhr/href/person/person_inventories','.add_inventory_type.delete_person_inventory.model.save_person_inventory.select_inventory_type.');

commit;
end;
/
