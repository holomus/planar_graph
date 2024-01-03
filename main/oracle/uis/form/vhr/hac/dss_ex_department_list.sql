set define off
prompt PATH /vhr/hac/dss_ex_department_list
begin
uis.route('/vhr/hac/dss_ex_department_list$delete','Ui_Vhr521.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_department_list$get_departments','Ui_Vhr521.Get_Departments','M','R','A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_department_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/dss_ex_department_list:table','Ui_Vhr521.Query_Departments','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/dss_ex_department_list','vhr521');
uis.form('/vhr/hac/dss_ex_department_list','/vhr/hac/dss_ex_department_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/dss_ex_department_list','delete','A',null,null,'A');
uis.action('/vhr/hac/dss_ex_department_list','get_departments','A',null,null,'A');


uis.ready('/vhr/hac/dss_ex_department_list','.delete.get_departments.model.');

commit;
end;
/
