set define off
prompt PATH /vhr/api/v1/core/schedule
begin
uis.route('/vhr/api/v1/core/schedule$create','Ui_Vhr339.Create_Schedule','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/schedule$delete','Ui_Vhr339.Delete_Schedule','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/schedule$list','Ui_Vhr339.List_Schedules','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/schedule$update','Ui_Vhr339.Update_Schedule','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/schedule:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/api/v1/core/schedule','vhr339');
uis.form('/vhr/api/v1/core/schedule','/vhr/api/v1/core/schedule','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/core/schedule','create','F',null,null,'A');
uis.action('/vhr/api/v1/core/schedule','delete','F',null,null,'A');
uis.action('/vhr/api/v1/core/schedule','list','F',null,null,'A');
uis.action('/vhr/api/v1/core/schedule','update','F',null,null,'A');


uis.ready('/vhr/api/v1/core/schedule','.create.delete.list.model.update.');

commit;
end;
/
