set define off
prompt PATH /vhr/href/person/person_family_view
begin
uis.route('/vhr/href/person/person_family_view:get_person_family_members','Ui_Vhr153.Get_Person_Family_Members','M','L','A',null,null,null,null);
uis.route('/vhr/href/person/person_family_view:get_person_marital_statuses','Ui_Vhr153.Get_Person_Merital_Status','M','L','A',null,null,null,null);
uis.route('/vhr/href/person/person_family_view:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/href/person/person_family_view','vhr153');
uis.form('/vhr/href/person/person_family_view','/vhr/href/person/person_family_view','A','A','F','H','M','N',null,'N');






uis.ready('/vhr/href/person/person_family_view','.model.');

commit;
end;
/
