set define off
prompt PATH /vhr/hpd/hiring_import
begin
uis.route('/vhr/hpd/hiring_import$save_setting','Ui_Vhr126.Save_Setting','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/hiring_import:import','Ui_Vhr126.Import','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/hiring_import:model','Ui_Vhr126.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/hiring_import:setting_model','Ui_Vhr126.Model',null,'M','A',null,null,null,null);
uis.route('/vhr/hpd/hiring_import:template','Ui_Vhr126.Template',null,null,'A',null,null,null,null);

uis.path('/vhr/hpd/hiring_import','vhr126');
uis.form('/vhr/hpd/hiring_import','/vhr/hpd/hiring_import','F','A','F','H','M','N',null);



uis.action('/vhr/hpd/hiring_import','save_setting','F',null,null,'A');



uis.ready('/vhr/hpd/hiring_import','.model.save_setting.');

commit;
end;
/
