set define off
prompt PATH /vhr/href/experience_type
begin
uis.route('/vhr/href/experience_type+add:code_is_unique','Ui_Vhr26.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/experience_type+add:model','Ui_Vhr26.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/experience_type+add:name_is_unique','Ui_Vhr26.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/experience_type+add:save','Ui_Vhr26.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/experience_type+edit:code_is_unique','Ui_Vhr26.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/experience_type+edit:model','Ui_Vhr26.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/experience_type+edit:name_is_unique','Ui_Vhr26.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/experience_type+edit:save','Ui_Vhr26.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/experience_type','vhr26');
uis.form('/vhr/href/experience_type+add','/vhr/href/experience_type','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/experience_type+edit','/vhr/href/experience_type','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/experience_type+add','.model.');
uis.ready('/vhr/href/experience_type+edit','.model.');

commit;
end;
/
