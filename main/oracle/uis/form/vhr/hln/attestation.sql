set define off
prompt PATH /vhr/hln/attestation
begin
uis.route('/vhr/hln/attestation+add:examiners','Ui_Vhr244.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/attestation+add:exams','Ui_Vhr244.Query_Exams',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/attestation+add:model','Ui_Vhr244.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hln/attestation+add:persons','Ui_Vhr244.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/attestation+add:save','Ui_Vhr244.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/attestation+edit:examiners','Ui_Vhr244.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/attestation+edit:exams','Ui_Vhr244.Query_Exams',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/attestation+edit:model','Ui_Vhr244.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/attestation+edit:persons','Ui_Vhr244.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hln/attestation+edit:save','Ui_Vhr244.Edit','M',null,'A',null,null,null,null);

uis.path('/vhr/hln/attestation','vhr244');
uis.form('/vhr/hln/attestation+add','/vhr/hln/attestation','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hln/attestation+edit','/vhr/hln/attestation','F','A','F','H','M','N',null,null);



uis.action('/vhr/hln/attestation+add','add_exam','F','/vhr/hln/exam+add','D','O');
uis.action('/vhr/hln/attestation+add','add_person','F','/vhr/href/person/person_add','D','O');
uis.action('/vhr/hln/attestation+add','select_exam','F','/vhr/hln/exam_list','D','O');
uis.action('/vhr/hln/attestation+add','select_person','F','/vhr/href/person/person_list','D','O');
uis.action('/vhr/hln/attestation+edit','add_exam','F','/vhr/hln/exam+add','D','O');
uis.action('/vhr/hln/attestation+edit','add_person','F','/vhr/href/person/person_add','D','O');
uis.action('/vhr/hln/attestation+edit','select_exam','F','/vhr/hln/exam_list','D','O');
uis.action('/vhr/hln/attestation+edit','select_person','F','/vhr/href/person/person_list','D','O');


uis.ready('/vhr/hln/attestation+add','.add_exam.add_person.model.select_exam.select_person.');
uis.ready('/vhr/hln/attestation+edit','.add_exam.add_person.model.select_exam.select_person.');

commit;
end;
/
