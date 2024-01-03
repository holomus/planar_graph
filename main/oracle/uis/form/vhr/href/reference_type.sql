set define off
prompt PATH /vhr/href/reference_type
begin
uis.route('/vhr/href/reference_type+add:code_is_unique','Ui_Vhr46.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/reference_type+add:model','Ui_Vhr46.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/reference_type+add:name_is_unique','Ui_Vhr46.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/reference_type+add:save','Ui_Vhr46.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/reference_type+edit:code_is_unique','Ui_Vhr46.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/reference_type+edit:model','Ui_Vhr46.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/reference_type+edit:name_is_unique','Ui_Vhr46.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/reference_type+edit:save','Ui_Vhr46.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/reference_type','vhr46');
uis.form('/vhr/href/reference_type+add','/vhr/href/reference_type','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/reference_type+edit','/vhr/href/reference_type','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/reference_type+add','.model.');
uis.ready('/vhr/href/reference_type+edit','.model.');

commit;
end;
/
