set define off
prompt PATH /vhr/hln/training
begin
uis.route('/vhr/hln/training+add:load_subjects','Ui_Vhr239.Load_Subjects','M','M','A',null,null,null,null,null);
uis.route('/vhr/hln/training+add:mentors','Ui_Vhr239.Query_Mentors',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hln/training+add:model','Ui.No_Model',null,null,'A','Y',null,null,null,null);
uis.route('/vhr/hln/training+add:save','Ui_Vhr239.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hln/training+add:subject_groups','Ui_Vhr239.Query_Subject_Groups',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hln/training+add:subjects','Ui_Vhr239.Query_Subjects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hln/training+edit:load_subjects','Ui_Vhr239.Load_Subjects','M','M','A',null,null,null,null,null);
uis.route('/vhr/hln/training+edit:mentors','Ui_Vhr239.Query_Mentors',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hln/training+edit:model','Ui_Vhr239.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hln/training+edit:save','Ui_Vhr239.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/hln/training+edit:subject_groups','Ui_Vhr239.Query_Subject_Groups',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hln/training+edit:subjects','Ui_Vhr239.Query_Subjects',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hln/training','vhr239');
uis.form('/vhr/hln/training+add','/vhr/hln/training','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hln/training+edit','/vhr/hln/training','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hln/training+add','add_mentor','F','/vhr/href/person/person_add','D','O');
uis.action('/vhr/hln/training+add','add_subject','F','/vhr/hln/training_subject+add','D','O');
uis.action('/vhr/hln/training+add','select_mentor','F','/vhr/href/person/person_list','D','O');
uis.action('/vhr/hln/training+add','select_person','F','/vhr/href/person/person_list','D','O');
uis.action('/vhr/hln/training+add','select_subject','F','/vhr/hln/training_subject_list','D','O');
uis.action('/vhr/hln/training+add','select_subject_group','F','/vhr/hln/training_subject_group_list','D','O');
uis.action('/vhr/hln/training+edit','add_mentor','F','/vhr/href/person/person_add','D','O');
uis.action('/vhr/hln/training+edit','add_subject','F','/vhr/hln/training_subject+add','D','O');
uis.action('/vhr/hln/training+edit','select_mentor','F','/vhr/href/person/person_list','D','O');
uis.action('/vhr/hln/training+edit','select_person','F','/vhr/href/person/person_list','D','O');
uis.action('/vhr/hln/training+edit','select_subject','F','/vhr/hln/training_subject_list','D','O');
uis.action('/vhr/hln/training+edit','select_subject_group','F','/vhr/hln/training_subject_group_list','D','O');


uis.ready('/vhr/hln/training+add','.add_mentor.add_subject.model.select_mentor.select_person.select_subject.select_subject_group.');
uis.ready('/vhr/hln/training+edit','.add_mentor.add_subject.model.select_mentor.select_person.select_subject.select_subject_group.');

commit;
end;
/
