set define off
prompt PATH /vhr/hpd/sign_template
begin
uis.route('/vhr/hpd/sign_template+add:cashflow_reasons','Ui_Vhr651.Query_Cashflow_Reasons',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+add:employees','Ui_Vhr651.Query_Employees',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+add:journal_types','Ui_Vhr651.Query_Journal_Types',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+add:model','Ui_Vhr651.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/sign_template+add:processes','Ui_Vhr651.Query_Processes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+add:save','Ui_Vhr651.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+add:subfilials','Ui_Vhr651.Query_Subfilials',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+edit:cashflow_reasons','Ui_Vhr651.Query_Cashflow_Reasons',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+edit:employees','Ui_Vhr651.Query_Employees',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+edit:journal_types','Ui_Vhr651.Query_Journal_Types',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+edit:model','Ui_Vhr651.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/sign_template+edit:processes','Ui_Vhr651.Query_Processes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+edit:save','Ui_Vhr651.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/sign_template+edit:subfilials','Ui_Vhr651.Query_Subfilials',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/sign_template','vhr651');
uis.form('/vhr/hpd/sign_template+add','/vhr/hpd/sign_template','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hpd/sign_template+edit','/vhr/hpd/sign_template','F','A','F','H','M','N',null,null,null);





uis.ready('/vhr/hpd/sign_template+add','.model.');
uis.ready('/vhr/hpd/sign_template+edit','.model.');

commit;
end;
/
