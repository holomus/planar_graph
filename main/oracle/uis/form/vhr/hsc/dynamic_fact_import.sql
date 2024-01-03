set define off
prompt PATH /vhr/hsc/dynamic_fact_import
begin
uis.route('/vhr/hsc/dynamic_fact_import$import_ftp_file','Ui_Vhr564.Load_Ftp_File','M','R','A',null,null,null,null);
uis.route('/vhr/hsc/dynamic_fact_import$list_files','Ui_Vhr564.List_Ftp_Files',null,'R','A',null,null,null,null);
uis.route('/vhr/hsc/dynamic_fact_import$save_setting','Ui_Vhr564.Save_Setting','M',null,'A',null,null,null,null);
uis.route('/vhr/hsc/dynamic_fact_import:areas','Ui_Vhr564.Query_Areas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/dynamic_fact_import:drivers','Ui_Vhr564.Query_Drivers',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/dynamic_fact_import:import','Ui_Vhr564.Import_File','M','M','A',null,null,null,null);
uis.route('/vhr/hsc/dynamic_fact_import:load_ftp_file','Ui_Vhr564.Load_Ftp_File','M','R','A',null,null,null,null);
uis.route('/vhr/hsc/dynamic_fact_import:load_setting','Ui_Vhr564.Load_Setting','M','M','A',null,null,null,null);
uis.route('/vhr/hsc/dynamic_fact_import:model','Ui_Vhr564.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hsc/dynamic_fact_import:objects','Ui_Vhr564.Query_Objects',null,'Q','A',null,null,null,null);

uis.path('/vhr/hsc/dynamic_fact_import','vhr564');
uis.form('/vhr/hsc/dynamic_fact_import','/vhr/hsc/dynamic_fact_import','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hsc/dynamic_fact_import','import_ftp_file','F',null,null,'A');
uis.action('/vhr/hsc/dynamic_fact_import','list_files','F',null,null,'A');
uis.action('/vhr/hsc/dynamic_fact_import','save_setting','F',null,null,'A');
uis.action('/vhr/hsc/dynamic_fact_import','server_settings','F','/vhr/hsc/server_settings','S','O');


uis.ready('/vhr/hsc/dynamic_fact_import','.import_ftp_file.list_files.model.save_setting.server_settings.');

commit;
end;
/
