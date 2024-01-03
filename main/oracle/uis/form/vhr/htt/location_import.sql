set define off
prompt PATH /vhr/htt/location_import
begin
uis.route('/vhr/htt/location_import$save_settings','Ui_Vhr272.Save_Settings','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_import:import','Ui_Vhr272.Import_File','M','M','A',null,null,null,null);
uis.route('/vhr/htt/location_import:import_data','Ui_Vhr272.Import_Data','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_import:model','Ui_Vhr272.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/location_import:template','Ui_Vhr272.Template',null,null,'A',null,null,null,null);

uis.path('/vhr/htt/location_import','vhr272');
uis.form('/vhr/htt/location_import','/vhr/htt/location_import','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/location_import','save_settings','A',null,null,'A');


uis.ready('/vhr/htt/location_import','.model.save_settings.');

commit;
end;
/
