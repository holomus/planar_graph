set define off
prompt PATH /vhr/htm/recommended_rank_document_trainings
begin
uis.route('/vhr/htm/recommended_rank_document_trainings:exams','Ui_Vhr676.Query_Exams',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/htm/recommended_rank_document_trainings:model','Ui_Vhr676.Model','M','M','A','Y',null,null,null,'S');
uis.route('/vhr/htm/recommended_rank_document_trainings:save','Ui_Vhr676.Edit_Trainings','JO',null,'A',null,null,null,null,'S');
uis.route('/vhr/htm/recommended_rank_document_trainings:subjects','Ui_Vhr676.Query_Subjects',null,'Q','A',null,null,null,null,'S');

uis.path('/vhr/htm/recommended_rank_document_trainings','vhr676');
uis.form('/vhr/htm/recommended_rank_document_trainings','/vhr/htm/recommended_rank_document_trainings','F','A','F','H','M','N',null,'N','S');





uis.ready('/vhr/htm/recommended_rank_document_trainings','.model.');

commit;
end;
/
