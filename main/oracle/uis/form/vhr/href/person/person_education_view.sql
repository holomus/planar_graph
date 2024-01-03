set define off
prompt PATH /vhr/href/person/person_education_view
begin
uis.route('/vhr/href/person/person_education_view:download_files','Ui_Vhr154.Download_Edu_Stage_Files','M','F','A',null,null,null,null);
uis.route('/vhr/href/person/person_education_view:model','Ui_Vhr154.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/person/person_education_view','vhr154');
uis.form('/vhr/href/person/person_education_view','/vhr/href/person/person_education_view','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/person/person_education_view','.model.');

commit;
end;
/
