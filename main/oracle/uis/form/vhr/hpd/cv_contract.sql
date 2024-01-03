set define off
prompt PATH /vhr/hpd/cv_contract
begin
uis.route('/vhr/hpd/cv_contract+add:model','Ui_Vhr327.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/cv_contract+add:persons','Ui_Vhr327.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/cv_contract+add:save','Ui_Vhr327.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/cv_contract+add:services','Ui_Vhr327.Query_Service_Names',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/cv_contract+edit:model','Ui_Vhr327.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/cv_contract+edit:persons','Ui_Vhr327.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/cv_contract+edit:save','Ui_Vhr327.Edit','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/cv_contract+edit:services','Ui_Vhr327.Query_Service_Names',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/cv_contract','vhr327');
uis.form('/vhr/hpd/cv_contract+add','/vhr/hpd/cv_contract','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpd/cv_contract+edit','/vhr/hpd/cv_contract','F','A','F','H','M','N',null,null);



uis.action('/vhr/hpd/cv_contract+add','add_person','F','/vhr/href/person/person_add','D','O');
uis.action('/vhr/hpd/cv_contract+add','select_person','F','/vhr/href/person/person_list','D','O');
uis.action('/vhr/hpd/cv_contract+edit','add_person','F','/vhr/href/person/person_add','D','O');
uis.action('/vhr/hpd/cv_contract+edit','select_person','F','/vhr/href/person/person_list','D','O');


uis.ready('/vhr/hpd/cv_contract+add','.add_person.model.select_person.');
uis.ready('/vhr/hpd/cv_contract+edit','.add_person.model.select_person.');

commit;
end;
/
