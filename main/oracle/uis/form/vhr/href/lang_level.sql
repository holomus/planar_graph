set define off
prompt PATH /vhr/href/lang_level
begin
uis.route('/vhr/href/lang_level+add:code_is_unique','Ui_Vhr20.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/lang_level+add:model','Ui_Vhr20.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/lang_level+add:name_is_unique','Ui_Vhr20.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/lang_level+add:save','Ui_Vhr20.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/lang_level+edit:code_is_unique','Ui_Vhr20.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/lang_level+edit:model','Ui_Vhr20.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/lang_level+edit:name_is_unique','Ui_Vhr20.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/lang_level+edit:save','Ui_Vhr20.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/lang_level','vhr20');
uis.form('/vhr/href/lang_level+add','/vhr/href/lang_level','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/lang_level+edit','/vhr/href/lang_level','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/lang_level+add','.model.');
uis.ready('/vhr/href/lang_level+edit','.model.');

commit;
end;
/
