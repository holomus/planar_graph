set define off
prompt PATH /vhr/hrec/vacancy_list
begin
uis.route('/vhr/hrec/vacancy_list$delete','Ui_Vhr570.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_list$publish_head_hunter','Ui_Vhr570.Publish_Head_Hunter','M','R','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_list$publish_olx','Ui_Vhr570.Publish_Olx','M','R','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_list:get_attributes','Ui_Vhr570.Get_Attributes','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_list:model','Ui_Vhr570.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrec/vacancy_list:olx_category','Ui_Vhr570.Query_Olx_Categories',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_list:table','Ui_Vhr570.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrec/vacancy_list','vhr570');
uis.form('/vhr/hrec/vacancy_list','/vhr/hrec/vacancy_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/hrec/vacancy_list','add','F','/vhr/hrec/vacancy+add','S','O');
uis.action('/vhr/hrec/vacancy_list','delete','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_list','edit','F','/vhr/hrec/vacancy+edit','S','O');
uis.action('/vhr/hrec/vacancy_list','publish_head_hunter','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_list','publish_olx','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_list','view','F','/vhr/hrec/vacancy_view','S','O');


uis.ready('/vhr/hrec/vacancy_list','.add.delete.edit.model.publish_head_hunter.publish_olx.view.');

commit;
end;
/
