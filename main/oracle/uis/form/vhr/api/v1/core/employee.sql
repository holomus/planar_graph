set define off
prompt PATH /vhr/api/v1/core/employee
begin
uis.route('/vhr/api/v1/core/employee$create','Ui_Vhr343.Create_Employee','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/employee$delete','Ui_Vhr343.Delete_Employee','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/employee$list','Ui_Vhr343.List_Employees','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/employee$save_locations','Ui_Vhr343.Save_Locations','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/employee$search_by_npin','Ui_Vhr343.Search_By_Npin','JO','JA','A',null,null,null,null);
uis.route('/vhr/api/v1/core/employee$set_photo','Ui_Vhr343.Set_Photo','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/employee$update','Ui_Vhr343.Update_Employee','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/core/employee','vhr343');
uis.form('/vhr/api/v1/core/employee','/vhr/api/v1/core/employee','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/core/employee','create','F',null,null,'A');
uis.action('/vhr/api/v1/core/employee','delete','F',null,null,'A');
uis.action('/vhr/api/v1/core/employee','list','F',null,null,'A');
uis.action('/vhr/api/v1/core/employee','save_locations','F',null,null,'A');
uis.action('/vhr/api/v1/core/employee','search_by_npin','F',null,null,'A');
uis.action('/vhr/api/v1/core/employee','set_photo','F',null,null,'A');
uis.action('/vhr/api/v1/core/employee','update','F',null,null,'A');


uis.ready('/vhr/api/v1/core/employee','.create.delete.list.model.save_locations.search_by_npin.set_photo.update.');

commit;
end;
/
