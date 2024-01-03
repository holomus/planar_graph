set define off
prompt PATH /vhr/hrm/job_import
begin
uis.route('/vhr/hrm/job_import$save_setting','Ui_Vhr667.Save_Setting','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hrm/job_import:code_is_unique','Ui_Vhr667.Code_Is_Unique','M','V','A',null,null,null,null,'S');
uis.route('/vhr/hrm/job_import:import','Ui_Vhr667.Import_File','M','M','A',null,null,null,null,'S');
uis.route('/vhr/hrm/job_import:import_data','Ui_Vhr667.Import_Data','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hrm/job_import:job_coa','Ui_Vhr667.Query_Coa',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/job_import:job_group','Ui_Vhr667.Query_Job_Groups',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/job_import:model','Ui_Vhr667.Model',null,'M','A','Y',null,null,null,'S');
uis.route('/vhr/hrm/job_import:name_is_unique','Ui_Vhr667.Name_Is_Unique','M','V','A',null,null,null,null,'S');
uis.route('/vhr/hrm/job_import:role','Ui_Vhr667.Query_Roles',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hrm/job_import:template','Ui_Vhr667.Template',null,null,'A',null,null,null,null,'S');

uis.path('/vhr/hrm/job_import','vhr667');
uis.form('/vhr/hrm/job_import','/vhr/hrm/job_import','F','A','F','H','M','N',null,'N','S');



uis.action('/vhr/hrm/job_import','save_setting','F',null,null,'A');


uis.ready('/vhr/hrm/job_import','.model.save_setting.');

commit;
end;
/
