set define off
prompt PATH /vhr/hper/plan_list
begin
uis.route('/vhr/hper/plan_list$delete','Ui_Vhr137.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/plan_list$gen_plans','Ui_Vhr137.Gen_Plans','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/plan_list:contract_plans','Ui_Vhr137.Query_Contract_Plans',null,'Q','A',null,null,null,null);
uis.route('/vhr/hper/plan_list:model','Ui_Vhr137.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hper/plan_list:standard_plans','Ui_Vhr137.Query_Standard_Plans',null,'Q','A',null,null,null,null);

uis.path('/vhr/hper/plan_list','vhr137');
uis.form('/vhr/hper/plan_list','/vhr/hper/plan_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hper/plan_list','add','F','/vhr/hper/plan+add','S','O');
uis.action('/vhr/hper/plan_list','delete','F',null,null,'A');
uis.action('/vhr/hper/plan_list','edit','F','/vhr/hper/plan+edit','S','O');
uis.action('/vhr/hper/plan_list','emp_plans','F','/vhr/hper/staff_plan_list','S','O');
uis.action('/vhr/hper/plan_list','gen_plans','F',null,null,'A');



uis.ready('/vhr/hper/plan_list','.add.delete.edit.emp_plans.gen_plans.model.');

commit;
end;
/
