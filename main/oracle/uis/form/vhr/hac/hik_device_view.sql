set define off
prompt PATH /vhr/hac/hik_device_view
begin
uis.route('/vhr/hac/hik_device_view$attach','Ui_Vhr525.Attach','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_device_view$detach','Ui_Vhr525.Detach','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_device_view:model','Ui_Vhr525.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hac/hik_device_view:table_company','Ui_Vhr525.Query_Companies','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/hik_device_view','vhr525');
uis.form('/vhr/hac/hik_device_view','/vhr/hac/hik_device_view','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/hik_device_view','attach','A',null,null,'A');
uis.action('/vhr/hac/hik_device_view','detach','A',null,null,'A');
uis.action('/vhr/hac/hik_device_view','edit','A','/vhr/hac/hik_device+edit','S','O');


uis.ready('/vhr/hac/hik_device_view','.attach.detach.edit.model.');

commit;
end;
/
