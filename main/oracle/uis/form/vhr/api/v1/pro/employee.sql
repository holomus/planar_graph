set define off
prompt PATH /vhr/api/v1/pro/employee
begin
uis.route('/vhr/api/v1/pro/employee$list','Ui_Vhr266.List_Employees','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/employee:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/api/v1/pro/employee','vhr266');
uis.form('/vhr/api/v1/pro/employee','/vhr/api/v1/pro/employee','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/employee','list','A',null,null,'A');


uis.ready('/vhr/api/v1/pro/employee','.list.model.');

commit;
end;
/
