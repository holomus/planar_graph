set define off
prompt PATH /vhr/hrec/vacancy_type_list
begin
uis.route('/vhr/hrec/vacancy_type_list$delete','Ui_Vhr642.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hrec/vacancy_type_list:model','Ui_Vhr642.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hrec/vacancy_type_list:table','Ui_Vhr642.Query','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hrec/vacancy_type_list','vhr642');
uis.form('/vhr/hrec/vacancy_type_list','/vhr/hrec/vacancy_type_list','H','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hrec/vacancy_type_list','add','H','/vhr/hrec/vacancy_type+add','S','O');
uis.action('/vhr/hrec/vacancy_type_list','delete','H',null,null,'A');
uis.action('/vhr/hrec/vacancy_type_list','edit','H','/vhr/hrec/vacancy_type+edit','S','O');


uis.ready('/vhr/hrec/vacancy_type_list','.add.delete.edit.model.');

commit;
end;
/
