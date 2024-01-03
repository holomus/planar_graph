set define off
prompt PATH /vhr/hpr/wage_settings
begin
uis.route('/vhr/hpr/wage_settings$save','Ui_Vhr560.Save','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/wage_settings:coas','Ui_Vhr560.Query_Coa',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/wage_settings:currencies','Ui_Vhr560.Query_Currencies',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/wage_settings:model','Ui_Vhr560.Model',null,'M','A','Y',null,null,null);

uis.path('/vhr/hpr/wage_settings','vhr560');
uis.form('/vhr/hpr/wage_settings','/vhr/hpr/wage_settings','F','A','F','H','M','N',null,'N');

uis.override_form('/anor/mpr/settings','vhr','/vhr/hpr/wage_settings');


uis.action('/vhr/hpr/wage_settings','save','F',null,null,'A');


uis.ready('/vhr/hpr/wage_settings','.model.save.');

commit;
end;
/
