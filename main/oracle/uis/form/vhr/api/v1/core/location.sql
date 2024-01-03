set define off
prompt PATH /vhr/api/v1/core/location
begin
uis.route('/vhr/api/v1/core/location$attach_employees','Ui_Vhr345.Attach_Employees','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/location$create','Ui_Vhr345.Create_Location','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/location$delete','Ui_Vhr345.Delete_Location','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/location$detach_employees','Ui_Vhr345.Detach_Employees','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/location$list','Ui_Vhr345.List_Locations','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/location$update','Ui_Vhr345.Update_Location','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/location:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/api/v1/core/location','vhr345');
uis.form('/vhr/api/v1/core/location','/vhr/api/v1/core/location','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/core/location','attach_employees','F',null,null,'A');
uis.action('/vhr/api/v1/core/location','create','A',null,null,'A');
uis.action('/vhr/api/v1/core/location','delete','A',null,null,'A');
uis.action('/vhr/api/v1/core/location','detach_employees','F',null,null,'A');
uis.action('/vhr/api/v1/core/location','list','A',null,null,'A');
uis.action('/vhr/api/v1/core/location','update','A',null,null,'A');


uis.ready('/vhr/api/v1/core/location','.attach_employees.create.delete.detach_employees.list.model.update.');

commit;
end;
/
