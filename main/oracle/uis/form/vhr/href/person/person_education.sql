set define off
prompt PATH /vhr/href/person/person_education
begin
uis.route('/vhr/href/person/person_education$del_edu_stage','Ui_Vhr41.Del_Edu_Stage','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_education$save_edu_stage','Ui_Vhr41.Save_Edu_Stage','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_education$save_lang','Ui_Vhr41.Save_Lang','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_education:download_files','Ui_Vhr41.Download_Edu_Stage_Files','M','F','A',null,null,null,null);
uis.route('/vhr/href/person/person_education:edu_stages','Ui_Vhr41.Query_Edu_Stages',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_education:institutions','Ui_Vhr41.Query_Institutions',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_education:lang_levels','Ui_Vhr41.Query_Lang_Levels',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_education:langs','Ui_Vhr41.Query_Langs',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_education:model','Ui_Vhr41.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/person/person_education:specialties','Ui_Vhr41.Query_Specialties',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/person/person_education','vhr41');
uis.form('/vhr/href/person/person_education','/vhr/href/person/person_education','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/person/person_education','add_edu_stage','A','/vhr/href/edu_stage+add','D','O');
uis.action('/vhr/href/person/person_education','add_institution','A','/vhr/href/institution+add','D','O');
uis.action('/vhr/href/person/person_education','add_lang','A','/vhr/href/lang+add','D','O');
uis.action('/vhr/href/person/person_education','add_lang_level','A','/vhr/href/lang_level+add','D','O');
uis.action('/vhr/href/person/person_education','del_edu_stage','A',null,null,'A');
uis.action('/vhr/href/person/person_education','save_edu_stage','A',null,null,'A');
uis.action('/vhr/href/person/person_education','save_lang','A',null,null,'A');
uis.action('/vhr/href/person/person_education','select_edu_stage','A','/vhr/href/edu_stage_list','D','O');
uis.action('/vhr/href/person/person_education','select_institution','A','/vhr/href/institution_list','D','O');
uis.action('/vhr/href/person/person_education','select_lang','A','/vhr/href/lang_list','D','O');
uis.action('/vhr/href/person/person_education','select_lang_level','A','/vhr/href/lang_level_list','D','O');
uis.action('/vhr/href/person/person_education','select_specialty','A','/vhr/href/specialty_list','D','O');


uis.ready('/vhr/href/person/person_education','.add_edu_stage.add_institution.add_lang.add_lang_level.del_edu_stage.model.save_edu_stage.save_lang.select_edu_stage.select_institution.select_lang.select_lang_level.select_specialty.');

commit;
end;
/
