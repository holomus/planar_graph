set define off
prompt PATH /vhr/api/v1/pro/region
begin
uis.route('/vhr/api/v1/pro/region$create','Ui_Vhr420.Create_Region','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/region$delete','Ui_Vhr420.Delete_Region','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/pro/region$list','Ui_Vhr420.List_Regions','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/region$update','Ui_Vhr420.Update_Region','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/pro/region','vhr420');
uis.form('/vhr/api/v1/pro/region','/vhr/api/v1/pro/region','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/region','create','A',null,null,'A');
uis.action('/vhr/api/v1/pro/region','delete','A',null,null,'A');
uis.action('/vhr/api/v1/pro/region','list','A',null,null,'A');
uis.action('/vhr/api/v1/pro/region','update','A',null,null,'A');


uis.ready('/vhr/api/v1/pro/region','.create.delete.list.model.update.');

commit;
end;
/
