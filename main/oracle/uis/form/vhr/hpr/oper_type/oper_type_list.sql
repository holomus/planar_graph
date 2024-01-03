set define off
prompt PATH /vhr/hpr/oper_type/oper_type_list
begin
uis.route('/vhr/hpr/oper_type/oper_type_list+accrual$delete','Ui_Vhr59.Del_Accruals','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type_list+accrual:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type_list+accrual:table','Ui_Vhr59.Query_Accruals',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type_list+deduction$delete','Ui_Vhr59.Del_Deductions','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type_list+deduction:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type_list+deduction:table','Ui_Vhr59.Query_Deductions',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpr/oper_type/oper_type_list','vhr59');
uis.form('/vhr/hpr/oper_type/oper_type_list+accrual','/vhr/hpr/oper_type/oper_type_list','A','A','F','H','M','N',null);
uis.form('/vhr/hpr/oper_type/oper_type_list+deduction','/vhr/hpr/oper_type/oper_type_list','A','A','F','H','M','N',null);



uis.action('/vhr/hpr/oper_type/oper_type_list+accrual','add','A','/vhr/hpr/oper_type/oper_type+add_accrual','S','O');
uis.action('/vhr/hpr/oper_type/oper_type_list+accrual','delete','A',null,null,'A');
uis.action('/vhr/hpr/oper_type/oper_type_list+accrual','edit','A','/vhr/hpr/oper_type/oper_type+edit_accrual','S','O');
uis.action('/vhr/hpr/oper_type/oper_type_list+deduction','add','A','/vhr/hpr/oper_type/oper_type+add_deduction','S','O');
uis.action('/vhr/hpr/oper_type/oper_type_list+deduction','delete','A',null,null,'A');
uis.action('/vhr/hpr/oper_type/oper_type_list+deduction','edit','A','/vhr/hpr/oper_type/oper_type+edit_deduction','S','O');



uis.ready('/vhr/hpr/oper_type/oper_type_list+accrual','.add.delete.edit.model.');
uis.ready('/vhr/hpr/oper_type/oper_type_list+deduction','.add.delete.edit.model.');

commit;
end;
/
