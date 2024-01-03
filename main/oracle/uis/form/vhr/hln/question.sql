set define off
prompt PATH /vhr/hln/question
begin
uis.route('/vhr/hln/question+add:model','Ui_Vhr213.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hln/question+add:save','Ui_Vhr213.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hln/question+add:types','Ui_Vhr213.Query_Question_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hln/question+edit:model','Ui_Vhr213.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/question+edit:save','Ui_Vhr213.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hln/question+edit:types','Ui_Vhr213.Query_Question_Types','M','Q','A',null,null,null,null);

uis.path('/vhr/hln/question','vhr213');
uis.form('/vhr/hln/question+add','/vhr/hln/question','F','A','F','HM','M','N',null,null);
uis.form('/vhr/hln/question+edit','/vhr/hln/question','F','A','F','H','M','N',null,null);



uis.action('/vhr/hln/question+add','add_question_type','F','/vhr/hln/question_type+add','D','O');
uis.action('/vhr/hln/question+add','select_question_type','F','/vhr/hln/question_type_list','D','O');
uis.action('/vhr/hln/question+edit','add_question_type','F','/vhr/hln/question_type+add','D','O');
uis.action('/vhr/hln/question+edit','select_question_type','F','/vhr/hln/question_type_list','D','O');


uis.ready('/vhr/hln/question+add','.add_question_type.model.select_question_type.');
uis.ready('/vhr/hln/question+edit','.add_question_type.model.select_question_type.');

commit;
end;
/
