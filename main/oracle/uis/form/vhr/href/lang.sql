set define off
prompt PATH /vhr/href/lang
begin
uis.route('/vhr/href/lang+add:code_is_unique','Ui_Vhr18.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/lang+add:model','Ui_Vhr18.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/lang+add:name_is_unique','Ui_Vhr18.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/lang+add:save','Ui_Vhr18.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/lang+edit:code_is_unique','Ui_Vhr18.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/lang+edit:model','Ui_Vhr18.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/lang+edit:name_is_unique','Ui_Vhr18.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/lang+edit:save','Ui_Vhr18.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/lang','vhr18');
uis.form('/vhr/href/lang+add','/vhr/href/lang','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/lang+edit','/vhr/href/lang','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/lang+add','.model.');
uis.ready('/vhr/href/lang+edit','.model.');

commit;
end;
/
