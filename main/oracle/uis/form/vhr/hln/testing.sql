set define off
prompt PATH /vhr/hln/testing
begin
uis.route('/vhr/hln/testing+add:examiners','Ui_Vhr225.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/testing+add:exams','Ui_Vhr225.Query_Exams',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/testing+add:model','Ui_Vhr225.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hln/testing+add:persons','Ui_Vhr225.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/testing+add:save','Ui_Vhr225.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/testing+edit:examiners','Ui_Vhr225.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/testing+edit:exams','Ui_Vhr225.Query_Exams',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/testing+edit:model','Ui_Vhr225.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/testing+edit:persons','Ui_Vhr225.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/testing+edit:save','Ui_Vhr225.Edit','M',null,'A',null,null,null,null);

uis.path('/vhr/hln/testing','vhr225');
uis.form('/vhr/hln/testing+add','/vhr/hln/testing','F','A','F','H','M','N',null,null);
uis.form('/vhr/hln/testing+edit','/vhr/hln/testing','F','A','F','H','M','N',null,null);



uis.action('/vhr/hln/testing+add','add_exam','F','/vhr/hln/exam+add','D','O');
uis.action('/vhr/hln/testing+add','add_person','F','/vhr/href/person/person_add','D','O');
uis.action('/vhr/hln/testing+add','select_exam','F','/vhr/hln/exam_list','D','O');
uis.action('/vhr/hln/testing+add','select_person','F','/vhr/href/person/person_list','D','O');
uis.action('/vhr/hln/testing+edit','add_exam','F','/vhr/hln/exam+add','D','O');
uis.action('/vhr/hln/testing+edit','add_person','F','/vhr/href/person/person_add','D','O');
uis.action('/vhr/hln/testing+edit','select_exam','F','/vhr/hln/exam_list','D','O');
uis.action('/vhr/hln/testing+edit','select_person','F','/vhr/href/person/person_list','D','O');


uis.ready('/vhr/hln/testing+add','.add_exam.add_person.model.select_exam.select_person.');
uis.ready('/vhr/hln/testing+edit','.add_exam.add_person.model.select_exam.select_person.');

commit;
end;
/
