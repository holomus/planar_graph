set define off
prompt PATH /vhr/hpr/cv_fact
begin
uis.route('/vhr/hpr/cv_fact+complete$complete','Ui_Vhr331.Fact_Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/cv_fact+complete$save','Ui_Vhr331.Fact_Save','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/cv_fact+complete:model','Ui_Vhr331.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/cv_fact+complete:services','Ui_Vhr331.Query_Cached_Names',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/cv_fact+view:model','Ui_Vhr331.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hpr/cv_fact','vhr331');
uis.form('/vhr/hpr/cv_fact+complete','/vhr/hpr/cv_fact','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpr/cv_fact+view','/vhr/hpr/cv_fact','F','A','F','H','M','N',null,null);



uis.action('/vhr/hpr/cv_fact+complete','complete','F',null,null,'A');
uis.action('/vhr/hpr/cv_fact+complete','save','F',null,null,'A');


uis.ready('/vhr/hpr/cv_fact+complete','.complete.model.save.');
uis.ready('/vhr/hpr/cv_fact+view','.model.');

commit;
end;
/
