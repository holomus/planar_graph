set define off
prompt PATH /vhr/htm/recommended_rank_document_statuses
begin
uis.route('/vhr/htm/recommended_rank_document_statuses:model','Ui_Vhr677.Model','M','M','A','Y',null,null,null,'S');
uis.route('/vhr/htm/recommended_rank_document_statuses:recalc_indicators','Ui_Vhr677.Recalc_Indicators','JO','JA','A',null,null,null,null,'S');
uis.route('/vhr/htm/recommended_rank_document_statuses:save','Ui_Vhr677.Edit_Statuses','JO',null,'A',null,null,null,null,'S');

uis.path('/vhr/htm/recommended_rank_document_statuses','vhr677');
uis.form('/vhr/htm/recommended_rank_document_statuses','/vhr/htm/recommended_rank_document_statuses','F','A','F','H','M','N',null,'N','S');





uis.ready('/vhr/htm/recommended_rank_document_statuses','.model.');

commit;
end;
/
