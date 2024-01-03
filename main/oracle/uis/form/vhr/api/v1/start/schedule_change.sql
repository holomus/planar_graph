set define off
prompt PATH /vhr/api/v1/start/schedule_change
begin
uis.route('/vhr/api/v1/start/schedule_change$create','Ui_Vhr344.Create_Schedule_Change','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/start/schedule_change$delete','Ui_Vhr344.Delete_Schedule_Change','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/start/schedule_change$list','Ui_Vhr344.List_Schedule_Changes','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/start/schedule_change$update','Ui_Vhr344.Update_Schedule_Change','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/start/schedule_change','vhr344');
uis.form('/vhr/api/v1/start/schedule_change','/vhr/api/v1/start/schedule_change','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/start/schedule_change','create','F',null,null,'A');
uis.action('/vhr/api/v1/start/schedule_change','delete','F',null,null,'A');
uis.action('/vhr/api/v1/start/schedule_change','list','F',null,null,'A');
uis.action('/vhr/api/v1/start/schedule_change','update','F',null,null,'A');


uis.ready('/vhr/api/v1/start/schedule_change','.create.delete.list.model.update.');

commit;
end;
/
