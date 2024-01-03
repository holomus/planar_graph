set define off
prompt PATH /vhr/api/v1/pro/schedule_change
begin
uis.route('/vhr/api/v1/pro/schedule_change$list','Ui_Vhr287.List_Schedule_Changes','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/schedule_change','vhr287');
uis.form('/vhr/api/v1/pro/schedule_change','/vhr/api/v1/pro/schedule_change','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/schedule_change','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/schedule_change','.list.model.');

commit;
end;
/
