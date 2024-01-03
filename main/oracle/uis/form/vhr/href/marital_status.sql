set define off
prompt PATH /vhr/href/marital_status
begin
uis.route('/vhr/href/marital_status+add:code_is_unique','Ui_Vhr24.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/marital_status+add:model','Ui_Vhr24.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/marital_status+add:name_is_unique','Ui_Vhr24.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/marital_status+add:save','Ui_Vhr24.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/marital_status+edit:code_is_unique','Ui_Vhr24.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/marital_status+edit:model','Ui_Vhr24.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/marital_status+edit:name_is_unique','Ui_Vhr24.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/marital_status+edit:save','Ui_Vhr24.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/marital_status','vhr24');
uis.form('/vhr/href/marital_status+add','/vhr/href/marital_status','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/marital_status+edit','/vhr/href/marital_status','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/marital_status+add','.model.');
uis.ready('/vhr/href/marital_status+edit','.model.');

commit;
end;
/
