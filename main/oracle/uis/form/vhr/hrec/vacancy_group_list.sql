set define off
prompt PATH /vhr/hrec/vacancy_group_list
begin
uis.route('/vhr/hrec/vacancy_group_list$delete','Ui_Vhr640.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_group_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hrec/vacancy_group_list:table','Ui_Vhr640.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrec/vacancy_group_list','vhr640');
uis.form('/vhr/hrec/vacancy_group_list','/vhr/hrec/vacancy_group_list','H','A','F','H','M','N',null,'N');



uis.action('/vhr/hrec/vacancy_group_list','add','H','/vhr/hrec/vacancy_group+add','S','O');
uis.action('/vhr/hrec/vacancy_group_list','delete','H',null,null,'A');
uis.action('/vhr/hrec/vacancy_group_list','edit','H','/vhr/hrec/vacancy_group+edit','S','O');
uis.action('/vhr/hrec/vacancy_group_list','types','H','/vhr/hrec/vacancy_type_list','S','O');


uis.ready('/vhr/hrec/vacancy_group_list','.add.delete.edit.model.types.');

commit;
end;
/
