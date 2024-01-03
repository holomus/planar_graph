set define off
prompt PATH /vhr/href/employee/employee_import
begin
uis.route('/vhr/href/employee/employee_import$save_setting','Ui_Vhr265.Save_Setting','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:ftes','Ui_Vhr265.Query_Fte',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:get_setting','Ui_Vhr265.Model',null,'M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:import','Ui_Vhr265.Import_File','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:import_data','Ui_Vhr265.Import_Data','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:jobs','Ui_Vhr265.Query_Jobs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:locations','Ui_Vhr265.Query_Locations',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:model','Ui_Vhr265.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/href/employee/employee_import:nationality','Ui_Vhr265.Query_Nationalities',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:oper_types','Ui_Vhr265.Query_Oper_Types',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:ranks','Ui_Vhr265.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:robots','Ui_Vhr265.Query_Robots','M','Q','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:schedules','Ui_Vhr265.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:template','Ui_Vhr265.Template',null,null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_import:wage_scales','Ui_Vhr265.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/href/employee/employee_import','vhr265');
uis.form('/vhr/href/employee/employee_import','/vhr/href/employee/employee_import','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/href/employee/employee_import','save_setting','F',null,null,'A');


uis.ready('/vhr/href/employee/employee_import','.model.save_setting.');

commit;
end;
/
