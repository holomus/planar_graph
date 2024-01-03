set define off
prompt PATH /vhr/api/v1/core/timesheet
begin
uis.route('/vhr/api/v1/core/timesheet$export','Ui_Vhr283.Export','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/timesheet:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/api/v1/core/timesheet','vhr283');
uis.form('/vhr/api/v1/core/timesheet','/vhr/api/v1/core/timesheet','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/core/timesheet','export','F',null,null,'A');


uis.ready('/vhr/api/v1/core/timesheet','.export.model.');

commit;
end;
/
