set define off
prompt PATH /vhr/href/person/person_edit
begin
uis.route('/vhr/href/person/person_edit$attach_employee','Ui_Vhr501.Attach_Employee','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/person/person_edit$save_photo','Ui_Vhr501.Save_Photo','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/person/person_edit:load_location','Ui_Vhr501.Load_Location','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/person/person_edit:load_person','Ui_Vhr501.Load_Person','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/person/person_edit:model','Ui_Vhr501.Model','M','M','A','Y',null,null,null,null);

uis.path('/vhr/href/person/person_edit','vhr501');
uis.form('/vhr/href/person/person_edit','/vhr/href/person/person_edit','A','A','F','H','M','N',null,'N',null);

uis.override_form('/anor/mr/person/natural_person+edit','vhr','/vhr/href/person/person_edit');


uis.action('/vhr/href/person/person_edit','attach_employee','A',null,null,'A');
uis.action('/vhr/href/person/person_edit','person_bank_account','A','/vhr/href/person/person_bank_account','S','O');
uis.action('/vhr/href/person/person_edit','person_document','A','/vhr/href/person/person_document','S','O');
uis.action('/vhr/href/person/person_edit','person_education','A','/vhr/href/person/person_education','S','O');
uis.action('/vhr/href/person/person_edit','person_family','A','/vhr/href/person/person_family','S','O');
uis.action('/vhr/href/person/person_edit','person_files','A','/vhr/href/person/person_files','S','O');
uis.action('/vhr/href/person/person_edit','person_inventories','A','/vhr/href/person/person_inventories','S','O');
uis.action('/vhr/href/person/person_edit','person_main','A','/vhr/href/person/person','S','O');
uis.action('/vhr/href/person/person_edit','person_reference','A','/vhr/href/person/person_references','S','O');
uis.action('/vhr/href/person/person_edit','person_settings','F','/vhr/hes/person_settings','S','O');
uis.action('/vhr/href/person/person_edit','person_trainings','F','/vhr/hln/person_trainings','S','O');
uis.action('/vhr/href/person/person_edit','person_work','A','/vhr/href/person/person_work','S','O');
uis.action('/vhr/href/person/person_edit','save_photo','A',null,null,'A');
uis.action('/vhr/href/person/person_edit','staff_location','F','/vhr/htt/staff_location','S','O');


uis.ready('/vhr/href/person/person_edit','.attach_employee.model.person_bank_account.person_document.person_education.person_family.person_files.person_inventories.person_main.person_reference.person_settings.person_trainings.person_work.save_photo.staff_location.');

commit;
end;
/
