set define off
prompt PATH /vhr/href/person/person_references
begin
uis.route('/vhr/href/person/person_references$del_reference','Ui_Vhr42.Del_Reference','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_references$save_reference','Ui_Vhr42.Save_Reference','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_references:model','Ui_Vhr42.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/person/person_references:reference_types','Ui_Vhr42.Query_Reference_Types',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/person/person_references','vhr42');
uis.form('/vhr/href/person/person_references','/vhr/href/person/person_references','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/person/person_references','add_reference_type','A','/vhr/href/reference_type+add','D','O');
uis.action('/vhr/href/person/person_references','del_reference','A',null,null,'A');
uis.action('/vhr/href/person/person_references','save_reference','A',null,null,'A');
uis.action('/vhr/href/person/person_references','select_reference_type','A','/vhr/href/reference_type_list','D','O');


uis.ready('/vhr/href/person/person_references','.add_reference_type.del_reference.model.save_reference.select_reference_type.');

commit;
end;
/
