set define off
prompt PATH /vhr/href/employee/employee_salary
begin
uis.route('/vhr/href/employee/employee_salary:get_payroll','Ui_Vhr610.Get_Payroll','M','M','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_salary:get_yearly_payrolls','Ui_Vhr610.Get_Yearly_Payrolls','M','M','A',null,null,null,null);
uis.route('/vhr/href/employee/employee_salary:model','Ui_Vhr610.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/employee/employee_salary','vhr610');
uis.form('/vhr/href/employee/employee_salary','/vhr/href/employee/employee_salary','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/employee/employee_salary','.model.');

commit;
end;
/
