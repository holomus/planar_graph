set define off
prompt PATH /vhr/hpr/sales_bonus_payment_list
begin
uis.route('/vhr/hpr/sales_bonus_payment_list$delete','Ui_Vhr483.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment_list$post','Ui_Vhr483.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment_list$unpost','Ui_Vhr483.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment_list:table','Ui_Vhr483.Query',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment_list:transactions','Ui_Vhr483.Transactions','M',null,'A',null,null,null,null);

uis.path('/vhr/hpr/sales_bonus_payment_list','vhr483');
uis.form('/vhr/hpr/sales_bonus_payment_list','/vhr/hpr/sales_bonus_payment_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/hpr/sales_bonus_payment_list','add','F','/vhr/hpr/sales_bonus_payment+add','S','O');
uis.action('/vhr/hpr/sales_bonus_payment_list','delete','F',null,null,'A');
uis.action('/vhr/hpr/sales_bonus_payment_list','edit','F','/vhr/hpr/sales_bonus_payment+edit','S','O');
uis.action('/vhr/hpr/sales_bonus_payment_list','post','F',null,null,'A');
uis.action('/vhr/hpr/sales_bonus_payment_list','transactions','F',null,null,'G');
uis.action('/vhr/hpr/sales_bonus_payment_list','unpost','F',null,null,'A');

uis.form_sibling('vhr','/vhr/hpr/sales_bonus_payment_list','/vhr/hrm/job_bonus_type_settings',1);

uis.ready('/vhr/hpr/sales_bonus_payment_list','.add.delete.edit.model.post.transactions.unpost.');

commit;
end;
/
