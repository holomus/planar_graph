set define off
prompt PATH /vhr/hrm/division_import
begin
uis.route('/vhr/hrm/division_import$save_setting','Ui_Vhr670.Save_Setting','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hrm/division_import:code_is_unique','Ui_Vhr670.Code_Is_Unique','M','V','A',null,null,null,null,'S');
uis.route('/vhr/hrm/division_import:division_groups','Ui_Vhr670.Query_Division_Groups',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/division_import:import','Ui_Vhr670.Import_File','M','M','A',null,null,null,null,'S');
uis.route('/vhr/hrm/division_import:import_data','Ui_Vhr670.Import_Data','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hrm/division_import:model','Ui_Vhr670.Model',null,'M','A','Y',null,null,null,'S');
uis.route('/vhr/hrm/division_import:name_is_unique','Ui_Vhr670.Name_Is_Unique','M','V','A',null,null,null,null,'S');
uis.route('/vhr/hrm/division_import:robots','Ui_Vhr670.Query_Robots',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/division_import:schedules','Ui_Vhr670.Query_Schedules',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/division_import:staffs','Ui_Vhr670.Query_Staffs',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/division_import:subfilials','Ui_Vhr670.Query_Subfilials',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/division_import:template','Ui_Vhr670.Template',null,null,'A',null,null,null,null,'S');

uis.path('/vhr/hrm/division_import','vhr670');
uis.form('/vhr/hrm/division_import','/vhr/hrm/division_import','F','A','F','H','M','N',null,'N','S');



uis.action('/vhr/hrm/division_import','save_setting','F',null,null,'A');


uis.ready('/vhr/hrm/division_import','.model.save_setting.');

commit;
end;
/
