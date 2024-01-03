set define off
prompt PATH /vhr/href/start/employee_import
begin
uis.route('/vhr/href/start/employee_import$save_setting','Ui_Vhr309.Save_Setting','M',null,'A',null,null,null,null);
uis.route('/vhr/href/start/employee_import:ftes','Ui_Vhr309.Query_Fte',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/start/employee_import:import','Ui_Vhr309.Import_File','M','M','A',null,null,null,null);
uis.route('/vhr/href/start/employee_import:import_data','Ui_Vhr309.Import_Data','M',null,'A',null,null,null,null);
uis.route('/vhr/href/start/employee_import:jobs','Ui_Vhr309.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/start/employee_import:locations','Ui_Vhr309.Query_Locations',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/start/employee_import:model','Ui_Vhr309.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/start/employee_import:nationalities','Ui_Vhr309.Query_Nationalities',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/start/employee_import:salary_types','Ui_Vhr309.Query_Salary_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/start/employee_import:schedules','Ui_Vhr309.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/start/employee_import:template','Ui_Vhr309.Template',null,null,'A',null,null,null,null);

uis.path('/vhr/href/start/employee_import','vhr309');
uis.form('/vhr/href/start/employee_import','/vhr/href/start/employee_import','F','A','F','H','M','N',null,'N');



uis.action('/vhr/href/start/employee_import','save_setting','F',null,null,'A');


uis.ready('/vhr/href/start/employee_import','.model.save_setting.');

commit;
end;
/
