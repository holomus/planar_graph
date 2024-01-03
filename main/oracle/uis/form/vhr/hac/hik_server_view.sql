set define off
prompt PATH /vhr/hac/hik_server_view
begin
uis.route('/vhr/hac/hik_server_view$attach','Ui_Vhr518.Attach','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hac/hik_server_view$detach','Ui_Vhr518.Detach','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hac/hik_server_view$gen_token','Ui_Vhr518.Gen_Token','M','V','A',null,null,null,null,null);
uis.route('/vhr/hac/hik_server_view$list_subsctiptions','Ui_Vhr518.List_Subscriptions','M','R','A',null,null,null,null,null);
uis.route('/vhr/hac/hik_server_view$subscribe_to_tracks','Ui_Vhr518.Subscribe_To_Tracks','M','R','A',null,null,null,null,null);
uis.route('/vhr/hac/hik_server_view$sync_companies','Ui_Vhr518.Sync_Companies','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hac/hik_server_view:get_organizations','Ui_Vhr518.Get_Organizations','M','R','A',null,null,null,null,null);
uis.route('/vhr/hac/hik_server_view:get_persons','Ui_Vhr518.Get_Persons','M','R','A',null,null,null,null,null);
uis.route('/vhr/hac/hik_server_view:model','Ui_Vhr518.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hac/hik_server_view:table_company','Ui_Vhr518.Query_Companies','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hac/hik_server_view:unsubscribe_from_tracks','Ui_Vhr518.Unsubscribe_From_Tracks','M','R','A',null,null,null,null,null);

uis.path('/vhr/hac/hik_server_view','vhr518');
uis.form('/vhr/hac/hik_server_view','/vhr/hac/hik_server_view','A','A','F','H','M','Y',null,'N',null);



uis.action('/vhr/hac/hik_server_view','attach','A',null,null,'A');
uis.action('/vhr/hac/hik_server_view','company_persons','A','/vhr/hac/hik_ex_person_list','S','O');
uis.action('/vhr/hac/hik_server_view','detach','A',null,null,'A');
uis.action('/vhr/hac/hik_server_view','devices','A','/vhr/hac/hik_device_list','S','O');
uis.action('/vhr/hac/hik_server_view','edit','A','/vhr/hac/hik_server+edit','S','O');
uis.action('/vhr/hac/hik_server_view','ex_access_levels','A','/vhr/hac/hik_ex_access_level_list','S','O');
uis.action('/vhr/hac/hik_server_view','ex_devices','A','/vhr/hac/hik_ex_device_list','S','O');
uis.action('/vhr/hac/hik_server_view','ex_doors','A','/vhr/hac/hik_ex_door_list','S','O');
uis.action('/vhr/hac/hik_server_view','ex_organizations','A','/vhr/hac/hik_ex_organization_list','S','O');
uis.action('/vhr/hac/hik_server_view','gen_token','A',null,null,'A');
uis.action('/vhr/hac/hik_server_view','list_subsctiptions','A',null,null,'A');
uis.action('/vhr/hac/hik_server_view','subscribe_to_tracks','A',null,null,'A');
uis.action('/vhr/hac/hik_server_view','sync_companies','A',null,null,'A');


uis.ready('/vhr/hac/hik_server_view','.attach.company_persons.detach.devices.edit.ex_access_levels.ex_devices.ex_doors.ex_organizations.gen_token.list_subsctiptions.model.subscribe_to_tracks.sync_companies.');

commit;
end;
/
