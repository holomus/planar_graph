set define off
prompt PATH /vhr/hln/exam
begin
uis.route('/vhr/hln/exam+add:check_generating_questions','Ui_Vhr214.Check_Generating_Questions','M','L','A',null,null,null,null);
uis.route('/vhr/hln/exam+add:load_manual_questions','Ui_Vhr214.Load_Manual_Questions','M','L','A',null,null,null,null);
uis.route('/vhr/hln/exam+add:model','Ui_Vhr214.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hln/exam+add:question_types','Ui_Vhr214.Query_Question_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hln/exam+add:save','Ui_Vhr214.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hln/exam+edit:check_generating_questions','Ui_Vhr214.Check_Generating_Questions','M','L','A',null,null,null,null);
uis.route('/vhr/hln/exam+edit:load_manual_questions','Ui_Vhr214.Load_Manual_Questions','M','L','A',null,null,null,null);
uis.route('/vhr/hln/exam+edit:model','Ui_Vhr214.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/exam+edit:question_types','Ui_Vhr214.Query_Question_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hln/exam+edit:save','Ui_Vhr214.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hln/exam','vhr214');
uis.form('/vhr/hln/exam+add','/vhr/hln/exam','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hln/exam+edit','/vhr/hln/exam','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/exam+add','select_question','F','/vhr/hln/question_list','D','O');
uis.action('/vhr/hln/exam+edit','select_question','F','/vhr/hln/question_list','D','O');


uis.ready('/vhr/hln/exam+edit','.model.select_question.');
uis.ready('/vhr/hln/exam+add','.model.select_question.');

commit;
end;
/
