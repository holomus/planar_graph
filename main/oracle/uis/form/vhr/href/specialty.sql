set define off
prompt PATH /vhr/href/specialty
begin
uis.route('/vhr/href/specialty+add:code_is_unique','Ui_Vhr10.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/specialty+add:model','Ui_Vhr10.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/specialty+add:name_is_unique','Ui_Vhr10.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/specialty+add:save','Ui_Vhr10.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/specialty+edit:code_is_unique','Ui_Vhr10.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/specialty+edit:model','Ui_Vhr10.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/specialty+edit:name_is_unique','Ui_Vhr10.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/specialty+edit:save','Ui_Vhr10.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/specialty','vhr10');
uis.form('/vhr/href/specialty+add','/vhr/href/specialty','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/specialty+edit','/vhr/href/specialty','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/specialty+add','.model.');
uis.ready('/vhr/href/specialty+edit','.model.');

commit;
end;
/
