set define off
prompt PATH /vhr/hac/dss_device_view
begin
uis.route('/vhr/hac/dss_device_view$attach','Ui_Vhr508.Attach','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_device_view$detach','Ui_Vhr508.Detach','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_device_view:model','Ui_Vhr508.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hac/dss_device_view:table_company','Ui_Vhr508.Query_Companies','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/dss_device_view','vhr508');
uis.form('/vhr/hac/dss_device_view','/vhr/hac/dss_device_view','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/dss_device_view','attach','A',null,null,'A');
uis.action('/vhr/hac/dss_device_view','detach','A',null,null,'A');
uis.action('/vhr/hac/dss_device_view','edit','A','/vhr/hac/dss_device+edit','S','O');


uis.ready('/vhr/hac/dss_device_view','.attach.detach.edit.model.');

commit;
end;
/
