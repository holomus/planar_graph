set define off
prompt PATH /vhr/hsc/fact_import
begin
uis.route('/vhr/hsc/fact_import$save_setting','Ui_Vhr548.Save_Setting','M',null,'A',null,null,null,null);
uis.route('/vhr/hsc/fact_import:areas','Ui_Vhr548.Query_Areas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact_import:drivers','Ui_Vhr548.Query_Drivers',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact_import:import','Ui_Vhr548.Import_File','M','M','A',null,null,null,null);
uis.route('/vhr/hsc/fact_import:import_data','Ui_Vhr548.Import_Data','M',null,'A',null,null,null,null);
uis.route('/vhr/hsc/fact_import:model','Ui_Vhr548.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hsc/fact_import:objects','Ui_Vhr548.Query_Objects',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact_import:template','Ui_Vhr548.Template',null,null,'A',null,null,null,null);

uis.path('/vhr/hsc/fact_import','vhr548');
uis.form('/vhr/hsc/fact_import','/vhr/hsc/fact_import','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hsc/fact_import','save_setting','F',null,null,'A');


uis.ready('/vhr/hsc/fact_import','.model.save_setting.');

commit;
end;
/
