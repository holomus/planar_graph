set define off
prompt PATH /vhr/htt/device_view
begin
uis.route('/vhr/htt/device_view$sync_attached_persons','Ui_Vhr94.Sync_Attach_Persons','M','R','A',null,null,null,null);
uis.route('/vhr/htt/device_view$sync_detached_persons','Ui_Vhr94.Sync_Detach_Persons','M','R','A',null,null,null,null);
uis.route('/vhr/htt/device_view$sync_device','Ui_Vhr94.Sync_Device','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/device_view$sync_person','Ui_Vhr94.Sync_Person','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/device_view$sync_tracks','Ui_Vhr94.Sync_Tracks','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/device_view:create_dss_person','Ui_Vhr94.Create_Dahua_Person','M','R','A',null,null,null,null);
uis.route('/vhr/htt/device_view:load_desync_dss_persons','Ui_Vhr94.Load_Desync_Dss_Persons','M','L','A',null,null,null,null);
uis.route('/vhr/htt/device_view:model','Ui_Vhr94.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/device_view:persons','Ui_Vhr94.Device_Persons','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/device_view:tracks','Ui_Vhr94.Device_Tracks','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/device_view','vhr94');
uis.form('/vhr/htt/device_view','/vhr/htt/device_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/device_view','edit','A','/vhr/htt/device+edit','S','O');
uis.action('/vhr/htt/device_view','migr','A','/vhr/hzk/migr_person_list','S','O');
uis.action('/vhr/htt/device_view','sync_attached_persons','A',null,null,'A');
uis.action('/vhr/htt/device_view','sync_detached_persons','A',null,null,'A');
uis.action('/vhr/htt/device_view','sync_device','A',null,null,'A');
uis.action('/vhr/htt/device_view','sync_person','A',null,null,'A');
uis.action('/vhr/htt/device_view','sync_tracks','A',null,null,'A');
uis.action('/vhr/htt/device_view','track_view','F','/vhr/htt/track_view','S','O');


uis.ready('/vhr/htt/device_view','.edit.migr.model.sync_attached_persons.sync_detached_persons.sync_device.sync_person.sync_tracks.track_view.');

commit;
end;
/
