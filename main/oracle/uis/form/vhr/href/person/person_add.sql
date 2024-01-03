set define off
prompt PATH /vhr/href/person/person_add
begin
uis.route('/vhr/href/person/person_add:attach_person','Ui_Vhr13.Attach_Person','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_add:model','Ui_Vhr13.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/person/person_add:nationalities','Ui_Vhr13.Query_Nationalities',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_add:save','Ui_Vhr13.Save','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_add:table_persons','Ui_Vhr13.Query_Persons',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/person/person_add','vhr13');
uis.form('/vhr/href/person/person_add','/vhr/href/person/person_add','A','A','F','H','M','N',null,'N');

uis.override_form('/anor/mr/person/natural_person+add','vhr','/vhr/href/person/person_add');


uis.action('/vhr/href/person/person_add','add_nationality','A','/vhr/href/nationality+add','D','O');
uis.action('/vhr/href/person/person_add','person_edit','A','/vhr/href/person/person_edit','R','O');
uis.action('/vhr/href/person/person_add','select_nationality','A','/vhr/href/nationality_list','D','O');


uis.ready('/vhr/href/person/person_add','.add_nationality.model.person_edit.select_nationality.');

commit;
end;
/
