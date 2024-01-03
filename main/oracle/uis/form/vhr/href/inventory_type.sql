set define off
prompt PATH /vhr/href/inventory_type
begin
uis.route('/vhr/href/inventory_type+add:model','Ui_Vhr466.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/inventory_type+add:name_is_unique','Ui_Vhr466.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/inventory_type+add:save','Ui_Vhr466.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/inventory_type+edit:model','Ui_Vhr466.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/inventory_type+edit:name_is_unique','Ui_Vhr466.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/inventory_type+edit:save','Ui_Vhr466.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/inventory_type','vhr466');
uis.form('/vhr/href/inventory_type+add','/vhr/href/inventory_type','A','A','F','H','M','N',null,null);
uis.form('/vhr/href/inventory_type+edit','/vhr/href/inventory_type','A','A','F','H','M','N',null,null);





uis.ready('/vhr/href/inventory_type+add','.model.');
uis.ready('/vhr/href/inventory_type+edit','.model.');

commit;
end;
/
