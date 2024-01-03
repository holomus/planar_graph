set define off
prompt PATH /vhr/rep/hpr/sales_bonus_and_book
begin
uis.route('/vhr/rep/hpr/sales_bonus_and_book:jobs','Ui_Vhr499.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hpr/sales_bonus_and_book:model','Ui_Vhr499.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hpr/sales_bonus_and_book:oper_types','Ui_Vhr499.Query_Oper_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hpr/sales_bonus_and_book:run','Ui_Vhr499.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/hpr/sales_bonus_and_book:save_preferences','Ui_Vhr499.Save_Preferences','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/hpr/sales_bonus_and_book:staffs','Ui_Vhr499.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/rep/hpr/sales_bonus_and_book','vhr499');
uis.form('/vhr/rep/hpr/sales_bonus_and_book','/vhr/rep/hpr/sales_bonus_and_book','F','A','R','H','M','N',null,'N');



uis.action('/vhr/rep/hpr/sales_bonus_and_book','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/rep/hpr/sales_bonus_and_book','.model.select_staff.');

commit;
end;
/
