set define off
prompt PATH /vhr/href/person/person_work
begin
uis.route('/vhr/href/person/person_work$del_award','Ui_Vhr44.Del_Award','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_work$del_experience','Ui_Vhr44.Del_Experience','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_work$del_work_place','Ui_Vhr44.Del_Work_Place','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_work$save_award','Ui_Vhr44.Save_Award','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_work$save_experience','Ui_Vhr44.Save_Experience','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_work$save_work_place','Ui_Vhr44.Save_Work_Place','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_work:awards','Ui_Vhr44.Query_Awards',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_work:experience_types','Ui_Vhr44.Query_Experience_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_work:model','Ui_Vhr44.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/person/person_work','vhr44');
uis.form('/vhr/href/person/person_work','/vhr/href/person/person_work','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/person/person_work','add_award','A','/vhr/href/award+add','D','O');
uis.action('/vhr/href/person/person_work','add_experience_type','A','/vhr/href/experience_type+add','D','O');
uis.action('/vhr/href/person/person_work','del_award','A',null,null,'A');
uis.action('/vhr/href/person/person_work','del_experience','A',null,null,'A');
uis.action('/vhr/href/person/person_work','del_work_place','A',null,null,'A');
uis.action('/vhr/href/person/person_work','save_award','A',null,null,'A');
uis.action('/vhr/href/person/person_work','save_experience','A',null,null,'A');
uis.action('/vhr/href/person/person_work','save_work_place','A',null,null,'A');
uis.action('/vhr/href/person/person_work','select_award','A','/vhr/href/award_list','D','O');
uis.action('/vhr/href/person/person_work','select_experience_type','A','/vhr/href/experience_type_list','D','O');


uis.ready('/vhr/href/person/person_work','.add_award.add_experience_type.del_award.del_experience.del_work_place.model.save_award.save_experience.save_work_place.select_award.select_experience_type.');

commit;
end;
/
