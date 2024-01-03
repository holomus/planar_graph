set define off
prompt PATH /vhr/hsc/object_norm_import
begin
uis.route('/vhr/hsc/object_norm_import$save_setting','Ui_Vhr558.Save_Setting','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_import:actions','Ui_Vhr558.Query_Actions','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_import:areas','Ui_Vhr558.Query_Areas','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_import:division_objects','Ui_Vhr558.Query_Division_Objects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_import:drivers','Ui_Vhr558.Query_Drivers',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_import:import','Ui_Vhr558.Import_File','M','M','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_import:import_data','Ui_Vhr558.Import_Data','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_import:jobs','Ui_Vhr558.Query_Jobs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_import:model','Ui_Vhr558.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/object_norm_import:processes','Ui_Vhr558.Query_Processes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm_import:template','Ui_Vhr558.Template',null,null,'A',null,null,null,null,null);

uis.path('/vhr/hsc/object_norm_import','vhr558');
uis.form('/vhr/hsc/object_norm_import','/vhr/hsc/object_norm_import','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hsc/object_norm_import','save_setting','F',null,null,'A');


uis.ready('/vhr/hsc/object_norm_import','.model.save_setting.');

commit;
end;
/
