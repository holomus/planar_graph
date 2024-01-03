set define off
prompt PATH /vhr/hsc/job_round_import
begin
uis.route('/vhr/hsc/job_round_import:import','Ui_Vhr646.Import_File','M','M','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_round_import:import_data','Ui_Vhr646.Import_Data','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/job_round_import:jobs','Ui_Vhr646.Query_Jobs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_round_import:model','Ui_Vhr646.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/job_round_import:objects','Ui_Vhr646.Query_Division_Objects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/job_round_import:template','Ui_Vhr646.Template',null,null,'A',null,null,null,null,null);

uis.path('/vhr/hsc/job_round_import','vhr646');
uis.form('/vhr/hsc/job_round_import','/vhr/hsc/job_round_import','F','A','F','H','M','N',null,null,null);





uis.ready('/vhr/hsc/job_round_import','.model.');

commit;
end;
/
