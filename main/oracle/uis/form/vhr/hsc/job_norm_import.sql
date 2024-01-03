set define off
prompt PATH /vhr/hsc/job_norm_import
begin
uis.route('/vhr/hsc/job_norm_import$save_setting','Ui_Vhr561.Save_Setting','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm_import:divisions','Ui_Vhr561.Query_Divisions',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm_import:import','Ui_Vhr561.Import_File','M','M','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm_import:import_data','Ui_Vhr561.Import_Data','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm_import:jobs','Ui_Vhr561.Query_Jobs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm_import:model','Ui_Vhr561.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/job_norm_import:objects','Ui_Vhr561.Query_Division_Objects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_norm_import:template','Ui_Vhr561.Template',null,null,'A',null,null,null,null,null);

uis.path('/vhr/hsc/job_norm_import','vhr561');
uis.form('/vhr/hsc/job_norm_import','/vhr/hsc/job_norm_import','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hsc/job_norm_import','save_setting','F',null,null,'A');


uis.ready('/vhr/hsc/job_norm_import','.model.save_setting.');

commit;
end;
/
