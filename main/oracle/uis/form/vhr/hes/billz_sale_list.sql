set define off
prompt PATH /vhr/hes/billz_sale_list
begin
uis.route('/vhr/hes/billz_sale_list$get_sales','Ui_Vhr480.Get_Sales','M','R','A',null,null,null,null);
uis.route('/vhr/hes/billz_sale_list$save_credentials','Ui_Vhr480.Save_Credentials','M',null,'A',null,null,null,null);
uis.route('/vhr/hes/billz_sale_list:model','Ui_Vhr480.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hes/billz_sale_list:table','Ui_Vhr480.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hes/billz_sale_list','vhr480');
uis.form('/vhr/hes/billz_sale_list','/vhr/hes/billz_sale_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hes/billz_sale_list','get_sales','F',null,null,'A');
uis.action('/vhr/hes/billz_sale_list','save_credentials','F',null,null,'A');


uis.ready('/vhr/hes/billz_sale_list','.get_sales.model.save_credentials.');

commit;
end;
/
