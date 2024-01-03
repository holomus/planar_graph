set define off
prompt PATH /vhr/href/science_branch
begin
uis.route('/vhr/href/science_branch+add:code_is_unique','Ui_Vhr3.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/science_branch+add:model','Ui_Vhr3.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/science_branch+add:name_is_unique','Ui_Vhr3.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/science_branch+add:save','Ui_Vhr3.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/science_branch+edit:code_is_unique','Ui_Vhr3.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/science_branch+edit:model','Ui_Vhr3.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/science_branch+edit:name_is_unique','Ui_Vhr3.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/science_branch+edit:save','Ui_Vhr3.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/science_branch','vhr3');
uis.form('/vhr/href/science_branch+add','/vhr/href/science_branch','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/science_branch+edit','/vhr/href/science_branch','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/science_branch+add','.model.');
uis.ready('/vhr/href/science_branch+edit','.model.');

commit;
end;
/
