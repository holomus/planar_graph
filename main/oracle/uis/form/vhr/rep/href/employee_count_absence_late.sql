set define off
prompt PATH /vhr/rep/href/employee_count_absence_late
begin
uis.route('/vhr/rep/href/employee_count_absence_late:jobs','Ui_Vhr293.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/rep/href/employee_count_absence_late:model','Ui_Vhr293.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/href/employee_count_absence_late:run','Ui_Vhr293.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/href/employee_count_absence_late:staffs','Ui_Vhr293.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/rep/href/employee_count_absence_late','vhr293');
uis.form('/vhr/rep/href/employee_count_absence_late','/vhr/rep/href/employee_count_absence_late','F','A','R','H','M','N',null,'N');



uis.action('/vhr/rep/href/employee_count_absence_late','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/rep/href/employee_count_absence_late','.model.select_staff.');

commit;
end;
/
