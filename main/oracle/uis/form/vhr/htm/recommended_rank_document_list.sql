set define off
prompt PATH /vhr/htm/recommended_rank_document_list
begin
uis.route('/vhr/htm/recommended_rank_document_list$delete','Ui_Vhr549.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list$return_to_set_training','Ui_Vhr549.To_Set_Training','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list$return_to_training','Ui_Vhr549.To_Training','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list$return_to_waiting','Ui_Vhr549.To_Waiting','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list$to_approved','Ui_Vhr549.To_Approved','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list$to_new','Ui_Vhr549.To_New','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list$to_set_training','Ui_Vhr549.To_Set_Training','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list$to_training','Ui_Vhr549.To_Training','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list$to_waiting','Ui_Vhr549.To_Waiting','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list:model','Ui_Vhr549.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list:run','Ui_Vhr549.Run','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htm/recommended_rank_document_list:table','Ui_Vhr549.Query',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/htm/recommended_rank_document_list','vhr549');
uis.form('/vhr/htm/recommended_rank_document_list','/vhr/htm/recommended_rank_document_list','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/htm/recommended_rank_document_list','add','F','/vhr/htm/recommended_rank_document+add','S','O');
uis.action('/vhr/htm/recommended_rank_document_list','delete','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_list','edit','F','/vhr/htm/recommended_rank_document+edit','S','O');
uis.action('/vhr/htm/recommended_rank_document_list','edit_statuses','F','/vhr/htm/recommended_rank_document_statuses','S','O');
uis.action('/vhr/htm/recommended_rank_document_list','edit_trainings','F','/vhr/htm/recommended_rank_document_trainings','S','O');
uis.action('/vhr/htm/recommended_rank_document_list','list_status_approved','F',null,null,'G');
uis.action('/vhr/htm/recommended_rank_document_list','list_status_new','F',null,null,'G');
uis.action('/vhr/htm/recommended_rank_document_list','list_status_set_training','F',null,null,'G');
uis.action('/vhr/htm/recommended_rank_document_list','list_status_training','F',null,null,'G');
uis.action('/vhr/htm/recommended_rank_document_list','list_status_waiting','F',null,null,'G');
uis.action('/vhr/htm/recommended_rank_document_list','return_to_set_training','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_list','return_to_training','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_list','return_to_waiting','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_list','run','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_list','to_approved','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_list','to_new','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_list','to_set_training','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_list','to_training','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_list','to_waiting','F',null,null,'A');
uis.action('/vhr/htm/recommended_rank_document_list','view','F','/vhr/htm/recommended_rank_document_view','S','O');
uis.action('/vhr/htm/recommended_rank_document_list','view_journal','F','/vhr/hpd/view/rank_change_view','S','O');

uis.form_sibling('vhr','/vhr/htm/recommended_rank_document_list','/vhr/htm/experience_list',1);

uis.ready('/vhr/htm/recommended_rank_document_list','.add.delete.edit.edit_statuses.edit_trainings.list_status_approved.list_status_new.list_status_set_training.list_status_training.list_status_waiting.model.return_to_set_training.return_to_training.return_to_waiting.run.to_approved.to_new.to_set_training.to_training.to_waiting.view.view_journal.');

commit;
end;
/
