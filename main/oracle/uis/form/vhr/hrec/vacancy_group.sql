set define off
prompt PATH /vhr/hrec/vacancy_group
begin
uis.route('/vhr/hrec/vacancy_group+add:code_is_unique','Ui_Vhr641.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_group+add:model','Ui_Vhr641.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrec/vacancy_group+add:name_is_unique','Ui_Vhr641.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_group+add:save','Ui_Vhr641.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_group+edit:code_is_unique','Ui_Vhr641.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_group+edit:model','Ui_Vhr641.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrec/vacancy_group+edit:name_is_unique','Ui_Vhr641.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_group+edit:save','Ui_Vhr641.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hrec/vacancy_group','vhr641');
uis.form('/vhr/hrec/vacancy_group+add','/vhr/hrec/vacancy_group','H','A','F','H','M','N',null,null);
uis.form('/vhr/hrec/vacancy_group+edit','/vhr/hrec/vacancy_group','H','A','F','H','M','N',null,null);





uis.ready('/vhr/hrec/vacancy_group+add','.model.');
uis.ready('/vhr/hrec/vacancy_group+edit','.model.');

commit;
end;
/
