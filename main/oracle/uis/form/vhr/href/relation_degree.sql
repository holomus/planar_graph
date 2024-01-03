set define off
prompt PATH /vhr/href/relation_degree
begin
uis.route('/vhr/href/relation_degree+add:code_is_unique','Ui_Vhr22.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/relation_degree+add:model','Ui_Vhr22.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/relation_degree+add:name_is_unique','Ui_Vhr22.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/relation_degree+add:save','Ui_Vhr22.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/relation_degree+edit:code_is_unique','Ui_Vhr22.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/relation_degree+edit:model','Ui_Vhr22.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/relation_degree+edit:name_is_unique','Ui_Vhr22.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/relation_degree+edit:save','Ui_Vhr22.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/relation_degree','vhr22');
uis.form('/vhr/href/relation_degree+add','/vhr/href/relation_degree','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/relation_degree+edit','/vhr/href/relation_degree','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/relation_degree+add','.model.');
uis.ready('/vhr/href/relation_degree+edit','.model.');

commit;
end;
/
