set define off
prompt PATH /vhr/rep/hrm/vacancy_report
begin
uis.route('/vhr/rep/hrm/vacancy_report:division_groups','Ui_Vhr578.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hrm/vacancy_report:job_groups','Ui_Vhr578.Query_Job_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hrm/vacancy_report:jobs','Ui_Vhr578.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hrm/vacancy_report:model','Ui_Vhr578.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hrm/vacancy_report:run','Ui_Vhr578.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hrm/vacancy_report','vhr578');
uis.form('/vhr/rep/hrm/vacancy_report','/vhr/rep/hrm/vacancy_report','F','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/hrm/vacancy_report','.model.');

commit;
end;
/
