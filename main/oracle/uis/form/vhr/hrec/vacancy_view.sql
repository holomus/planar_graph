set define off
prompt PATH /vhr/hrec/vacancy_view
begin
uis.route('/vhr/hrec/vacancy_view$publish_head_hunter','Ui_Vhr573.Publish_Head_Hunter','M','R','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_view$publish_olx','Ui_Vhr573.Publish_Olx','M','R','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_view:get_attributes','Ui_Vhr573.Get_Attributes','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/vacancy_view:model','Ui_Vhr573.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrec/vacancy_view:olx_category','Ui_Vhr573.Query_Olx_Categories',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrec/vacancy_view','vhr573');
uis.form('/vhr/hrec/vacancy_view','/vhr/hrec/vacancy_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hrec/vacancy_view','load_olx_candidates','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_view','publish_head_hunter','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_view','publish_olx','F',null,null,'A');
uis.action('/vhr/hrec/vacancy_view','vacancy_operation','F','/vhr/hrec/vacancy_operation','S','O');


uis.ready('/vhr/hrec/vacancy_view','.load_olx_candidates.model.publish_head_hunter.publish_olx.vacancy_operation.');

commit;
end;
/
