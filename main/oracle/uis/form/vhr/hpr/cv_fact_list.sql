set define off
prompt PATH /vhr/hpr/cv_fact_list
begin
uis.route('/vhr/hpr/cv_fact_list$accept','Ui_Vhr328.Accept','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/cv_fact_list$return_to_complete','Ui_Vhr328.Return_Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/cv_fact_list$return_to_new','Ui_Vhr328.To_New','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/cv_fact_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpr/cv_fact_list:table','Ui_Vhr328.Query',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/cv_fact_list:transactions','Ui_Vhr328.Transactions','M',null,'A',null,null,null,null);

uis.path('/vhr/hpr/cv_fact_list','vhr328');
uis.form('/vhr/hpr/cv_fact_list','/vhr/hpr/cv_fact_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpr/cv_fact_list','accept','F',null,null,'A');
uis.action('/vhr/hpr/cv_fact_list','complete','F','/vhr/hpr/cv_fact+complete','S','O');
uis.action('/vhr/hpr/cv_fact_list','return_to_complete','F',null,null,'A');
uis.action('/vhr/hpr/cv_fact_list','return_to_new','F',null,null,'A');
uis.action('/vhr/hpr/cv_fact_list','transactions','F',null,null,'G');
uis.action('/vhr/hpr/cv_fact_list','view','F','/vhr/hpr/cv_fact+view','S','O');


uis.ready('/vhr/hpr/cv_fact_list','.accept.complete.model.return_to_complete.return_to_new.transactions.view.');

commit;
end;
/
