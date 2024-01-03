set define off
prompt PATH /vhr/href/staff/staff_list
begin
uis.route('/vhr/href/staff/staff_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/staff/staff_list:table','Ui_Vhr54.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/href/staff/staff_list','vhr54');
uis.form('/vhr/href/staff/staff_list','/vhr/href/staff/staff_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/href/staff/staff_list','view','F','/vhr/href/staff/staff_view','S','O');
uis.action('/vhr/href/staff/staff_list','view_employee','F','/vhr/href/employee/employee_edit','S','O');


uis.ready('/vhr/href/staff/staff_list','.model.view.view_employee.');

commit;
end;
/
