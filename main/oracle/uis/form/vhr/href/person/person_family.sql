set define off
prompt PATH /vhr/href/person/person_family
begin
uis.route('/vhr/href/person/person_family$del_family_member','Ui_Vhr40.Del_Family_Member','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_family$save_family_member','Ui_Vhr40.Save_Family_Member','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_family$save_marital_status','Ui_Vhr40.Save_Marital_Status','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_family:marital_statuses','Ui_Vhr40.Query_Marital_Statuses',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_family:model','Ui_Vhr40.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/person/person_family:relation_degrees','Ui_Vhr40.Query_Relation_Degrees',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/person/person_family','vhr40');
uis.form('/vhr/href/person/person_family','/vhr/href/person/person_family','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/person/person_family','add_marital_status','A','/vhr/href/marital_status+add','D','O');
uis.action('/vhr/href/person/person_family','add_relation_degree','A','/vhr/href/relation_degree+add','D','O');
uis.action('/vhr/href/person/person_family','del_family_member','A',null,null,'A');
uis.action('/vhr/href/person/person_family','save_family_member','A',null,null,'A');
uis.action('/vhr/href/person/person_family','save_marital_status','A',null,null,'A');
uis.action('/vhr/href/person/person_family','select_marital_status','A','/vhr/href/marital_status_list','D','O');
uis.action('/vhr/href/person/person_family','select_relation_degree','A','/vhr/href/relation_degree_list','D','O');


uis.ready('/vhr/href/person/person_family','.add_marital_status.add_relation_degree.del_family_member.model.save_family_member.save_marital_status.select_marital_status.select_relation_degree.');

commit;
end;
/
