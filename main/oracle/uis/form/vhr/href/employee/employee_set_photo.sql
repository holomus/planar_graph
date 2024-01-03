set define off
prompt PATH /vhr/href/employee/employee_set_photo
begin
uis.route('/vhr/href/employee/employee_set_photo:folders','Ui_Vhr671.Query_Folders',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/href/employee/employee_set_photo:load_photos','Ui_Vhr671.Set_Photo','M','M','A',null,null,null,null,'S');
uis.route('/vhr/href/employee/employee_set_photo:model','Ui_Vhr671.Model',null,'M','A','Y',null,null,null,'S');

uis.path('/vhr/href/employee/employee_set_photo','vhr671');
uis.form('/vhr/href/employee/employee_set_photo','/vhr/href/employee/employee_set_photo','F','A','F','H','M','N',null,'N','S');





uis.ready('/vhr/href/employee/employee_set_photo','.model.');

commit;
end;
/
