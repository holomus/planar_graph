set define off
prompt PATH /vhr/href/person/person_files
begin
uis.route('/vhr/href/person/person_files$del_file','Ui_Vhr43.Del_File','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_files$save_file','Ui_Vhr43.Save_File','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_files:get_person_files','Ui_Vhr43.Get_Person_Files','M','L','A',null,null,null,null);
uis.route('/vhr/href/person/person_files:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/href/person/person_files','vhr43');
uis.form('/vhr/href/person/person_files','/vhr/href/person/person_files','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/person/person_files','del_file','A',null,null,'A');
uis.action('/vhr/href/person/person_files','save_file','A',null,null,'A');


uis.ready('/vhr/href/person/person_files','.del_file.model.save_file.');

commit;
end;
/
