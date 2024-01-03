set define off
prompt PATH /vhr/api/v1/core/calendar
begin
uis.route('/vhr/api/v1/core/calendar$create','Ui_Vhr461.Create_Calendar','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/calendar$delete','Ui_Vhr461.Delete_Calendar','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/calendar$list','Ui_Vhr461.List_Calendar','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/calendar$update','Ui_Vhr461.Update_Calendar','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/calendar:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/api/v1/core/calendar','vhr461');
uis.form('/vhr/api/v1/core/calendar','/vhr/api/v1/core/calendar','F','A','E','H','M','N',null,'N');



uis.action('/vhr/api/v1/core/calendar','create','F',null,null,'A');
uis.action('/vhr/api/v1/core/calendar','delete','F',null,null,'A');
uis.action('/vhr/api/v1/core/calendar','list','F',null,null,'A');
uis.action('/vhr/api/v1/core/calendar','update','F',null,null,'A');


uis.ready('/vhr/api/v1/core/calendar','.create.delete.list.model.update.');

commit;
end;
/
