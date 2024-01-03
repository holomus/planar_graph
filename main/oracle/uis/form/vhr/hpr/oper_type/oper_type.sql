set define off
prompt PATH /vhr/hpr/oper_type/oper_type
begin
uis.route('/vhr/hpr/oper_type/oper_type+add_accrual:coa_info','Ui_Vhr61.Coa_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_accrual:coas','Ui_Vhr61.Query_Coas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_accrual:formula_validate','Ui_Vhr61.Formula_Validate','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_accrual:model','Ui_Vhr61.Add_Accrual_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_accrual:oper_groups','Ui_Vhr61.Query_Oper_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_accrual:origins','Ui_Vhr61.Query_Origins','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_accrual:save','Ui_Vhr61.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_deduction:coa_info','Ui_Vhr61.Coa_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_deduction:coas','Ui_Vhr61.Query_Coas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_deduction:formula_validate','Ui_Vhr61.Formula_Validate','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_deduction:model','Ui_Vhr61.Add_Deduction_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_deduction:oper_groups','Ui_Vhr61.Query_Oper_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_deduction:origins','Ui_Vhr61.Query_Origins','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+add_deduction:save','Ui_Vhr61.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_accrual:coa_info','Ui_Vhr61.Coa_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_accrual:coas','Ui_Vhr61.Query_Coas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_accrual:formula_validate','Ui_Vhr61.Formula_Validate','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_accrual:model','Ui_Vhr61.Edit_Accrual_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_accrual:oper_groups','Ui_Vhr61.Query_Oper_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_accrual:origins','Ui_Vhr61.Query_Origins','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_accrual:save','Ui_Vhr61.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_deduction:coa_info','Ui_Vhr61.Coa_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_deduction:coas','Ui_Vhr61.Query_Coas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_deduction:formula_validate','Ui_Vhr61.Formula_Validate','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_deduction:model','Ui_Vhr61.Edit_Deduction_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_deduction:oper_groups','Ui_Vhr61.Query_Oper_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_deduction:origins','Ui_Vhr61.Query_Origins','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/oper_type/oper_type+edit_deduction:save','Ui_Vhr61.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hpr/oper_type/oper_type','vhr61');
uis.form('/vhr/hpr/oper_type/oper_type+add_accrual','/vhr/hpr/oper_type/oper_type','A','A','F','H','M','N',null,'N');
uis.form('/vhr/hpr/oper_type/oper_type+add_deduction','/vhr/hpr/oper_type/oper_type','A','A','F','H','M','N',null,'N');
uis.form('/vhr/hpr/oper_type/oper_type+edit_accrual','/vhr/hpr/oper_type/oper_type','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpr/oper_type/oper_type+edit_deduction','/vhr/hpr/oper_type/oper_type','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hpr/oper_type/oper_type+add_accrual','add_coa','F','/anor/mk/coa+add','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+add_accrual','add_indicator','F','/vhr/href/indicator+add','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+add_accrual','edit_indicator','F','/vhr/href/indicator+edit','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+add_accrual','select_coa','F','/anor/mk/coa_list','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+add_deduction','add_coa','A','/anor/mk/coa+add','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+add_deduction','add_indicator','A','/vhr/href/indicator+add','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+add_deduction','edit_indicator','A','/vhr/href/indicator+edit','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+add_deduction','select_coa','A','/anor/mk/coa_list','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+edit_accrual','add_coa','F','/anor/mk/coa+add','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+edit_accrual','add_indicator','F','/vhr/href/indicator+add','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+edit_accrual','edit_indicator','F','/vhr/href/indicator+edit','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+edit_accrual','select_coa','F','/anor/mk/coa_list','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+edit_deduction','add_coa','A','/anor/mk/coa+add','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+edit_deduction','add_indicator','A','/vhr/href/indicator+add','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+edit_deduction','edit_indicator','A','/vhr/href/indicator+edit','D','O');
uis.action('/vhr/hpr/oper_type/oper_type+edit_deduction','select_coa','A','/anor/mk/coa_list','D','O');



uis.ready('/vhr/hpr/oper_type/oper_type+add_accrual','.add_coa.add_indicator.edit_indicator.model.select_coa.');
uis.ready('/vhr/hpr/oper_type/oper_type+add_deduction','.add_coa.add_indicator.edit_indicator.model.select_coa.');
uis.ready('/vhr/hpr/oper_type/oper_type+edit_accrual','.add_coa.add_indicator.edit_indicator.model.select_coa.');
uis.ready('/vhr/hpr/oper_type/oper_type+edit_deduction','.add_coa.add_indicator.edit_indicator.model.select_coa.');

commit;
end;
/
