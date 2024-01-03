set define off
prompt PATH /vhr/href/edu_stage
begin
uis.route('/vhr/href/edu_stage+add:code_is_unique','Ui_Vhr4.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/edu_stage+add:model','Ui_Vhr4.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/edu_stage+add:name_is_unique','Ui_Vhr4.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/edu_stage+add:save','Ui_Vhr4.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/edu_stage+edit:code_is_unique','Ui_Vhr4.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/edu_stage+edit:model','Ui_Vhr4.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/edu_stage+edit:name_is_unique','Ui_Vhr4.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/edu_stage+edit:save','Ui_Vhr4.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/edu_stage','vhr4');
uis.form('/vhr/href/edu_stage+add','/vhr/href/edu_stage','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/edu_stage+edit','/vhr/href/edu_stage','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/edu_stage+add','.model.');
uis.ready('/vhr/href/edu_stage+edit','.model.');

commit;
end;
/
