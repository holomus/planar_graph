set define off
prompt PATH /vhr/hrec/vacancy_type
begin
uis.route('/vhr/hrec/vacancy_type+add:code_is_unique','Ui_Vhr643.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_type+add:model','Ui_Vhr643.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrec/vacancy_type+add:name_is_unique','Ui_Vhr643.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_type+add:save','Ui_Vhr643.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_type+edit:code_is_unique','Ui_Vhr643.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_type+edit:model','Ui_Vhr643.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrec/vacancy_type+edit:name_is_unique','Ui_Vhr643.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_type+edit:save','Ui_Vhr643.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hrec/vacancy_type','vhr643');
uis.form('/vhr/hrec/vacancy_type+add','/vhr/hrec/vacancy_type','H','A','F','H','M','N',null,null);
uis.form('/vhr/hrec/vacancy_type+edit','/vhr/hrec/vacancy_type','H','A','F','H','M','N',null,null);





uis.ready('/vhr/hrec/vacancy_type+add','.model.');
uis.ready('/vhr/hrec/vacancy_type+edit','.model.');

commit;
end;
/
