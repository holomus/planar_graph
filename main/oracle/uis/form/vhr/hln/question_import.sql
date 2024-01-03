set define off
prompt PATH /vhr/hln/question_import
begin
uis.route('/vhr/hln/question_import$save_setting','Ui_Vhr243.Save_Setting','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/question_import:import','Ui_Vhr243.Import_File','M','M','A',null,null,null,null);
uis.route('/vhr/hln/question_import:import_data','Ui_Vhr243.Import_Data','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/question_import:model','Ui_Vhr243.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hln/question_import:template','Ui_Vhr243.Template',null,null,'A',null,null,null,null);

uis.path('/vhr/hln/question_import','vhr243');
uis.form('/vhr/hln/question_import','/vhr/hln/question_import','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/question_import','save_setting','F',null,null,'A');


uis.ready('/vhr/hln/question_import','.model.save_setting.');

commit;
end;
/
