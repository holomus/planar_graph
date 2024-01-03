set define off
prompt PATH /vhr/href/person/person_work_view
begin
uis.route('/vhr/href/person/person_work_view:get_person_awards','Ui_Vhr156.Get_Person_Awards','M','L','A',null,null,null,null);
uis.route('/vhr/href/person/person_work_view:get_person_experiences','Ui_Vhr156.Get_Person_Experiences','M','L','A',null,null,null,null);
uis.route('/vhr/href/person/person_work_view:get_person_work_places','Ui_Vhr156.Get_Person_Work_Places','M','L','A',null,null,null,null);
uis.route('/vhr/href/person/person_work_view:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/href/person/person_work_view','vhr156');
uis.form('/vhr/href/person/person_work_view','/vhr/href/person/person_work_view','A','A','F','H','M','N',null,'N');






uis.ready('/vhr/href/person/person_work_view','.model.');

commit;
end;
/
