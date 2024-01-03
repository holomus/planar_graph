set define off
prompt PATH /vhr/htm/recommended_rank_document_view
begin
uis.route('/vhr/htm/recommended_rank_document_view$return_to_set_training','Ui_Vhr611.To_Set_Training','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_view$return_to_training','Ui_Vhr611.To_Training','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_view$return_to_waiting','Ui_Vhr611.To_Waiting','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_view$to_approved','Ui_Vhr611.To_Approved','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_view$to_new','Ui_Vhr611.To_New','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_view$to_set_training','Ui_Vhr611.To_Set_Training','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_view$to_training','Ui_Vhr611.To_Training','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_view$to_waiting','Ui_Vhr611.To_Waiting','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_view:model','Ui_Vhr611.Model','M','M','A','Y',null,null,null,null);

uis.path('/vhr/htm/recommended_rank_document_view','vhr611');
uis.form('/vhr/htm/recommended_rank_document_view','/vhr/htm/recommended_rank_document_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/htm/recommended_rank_document_view','edit','F','/vhr/htm/recommended_rank_document+edit','S','O');
uis.action('/vhr/htm/recommended_rank_document_view','edit_statuses','F','/vhr/htm/recommended_rank_document_statuses','S','O');
uis.action('/vhr/htm/recommended_rank_document_view','edit_trainings','F','/vhr/htm/recommended_rank_document_trainings','S','O');
uis.action('/vhr/htm/recommended_rank_document_view','return_to_set_training','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_view','return_to_training','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_view','return_to_waiting','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_view','to_approved','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_view','to_new','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_view','to_set_training','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_view','to_training','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_view','to_waiting','F',null,null,'A');


uis.ready('/vhr/htm/recommended_rank_document_view','.edit.edit_statuses.edit_trainings.model.return_to_set_training.return_to_training.return_to_waiting.to_approved.to_new.to_set_training.to_training.to_waiting.');

commit;
end;
/
