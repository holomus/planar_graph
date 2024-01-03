set define off
prompt PATH /vhr/rep/hpr/payroll_book
begin
uis.route('/vhr/rep/hpr/payroll_book:definitions','Ui_Vhr217.Definitions',null,'L','A',null,null,null,null);
uis.route('/vhr/rep/hpr/payroll_book:jobs','Ui_Vhr217.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/rep/hpr/payroll_book:model','Ui_Vhr217.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hpr/payroll_book:run','Ui_Vhr217.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/hpr/payroll_book:run_easy_report','Ui_Vhr217.Run_Easy_Report','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/hpr/payroll_book:staffs','Ui_Vhr217.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/rep/hpr/payroll_book','vhr217');
uis.form('/vhr/rep/hpr/payroll_book','/vhr/rep/hpr/payroll_book','F','A','R','H','M','N',null,'Y');



uis.action('/vhr/rep/hpr/payroll_book','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/rep/hpr/payroll_book','select_staffs','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/rep/hpr/payroll_book','.model.select_job.select_staffs.');

commit;
end;
/
