set define off
prompt PATH /vhr/hrec/olx_data_mapping
begin
uis.route('/vhr/hrec/olx_data_mapping$auth_olx','Ui_Vhr629.Auth_Olx',null,'M','A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping$clear_auth','Ui_Vhr629.Clear_Auth_Credentials',null,null,'A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping$save_auth','Ui_Vhr629.Save_Auth_Credentials','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping$save_data_map','Ui_Vhr629.Save_Data_Map','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping$sync_attribute','Ui_Vhr629.Sync_Attributes','M','R','A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping$sync_categories','Ui_Vhr629.Sync_Categories',null,'R','A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping$sync_cities','Ui_Vhr629.Sync_Cities',null,'R','A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping$sync_districts','Ui_Vhr629.Sync_Districts',null,'R','A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping$sync_regions','Ui_Vhr629.Sync_Regions',null,'R','A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping:model','Ui_Vhr629.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrec/olx_data_mapping:olx_districts','Ui_Vhr629.Query_Olx_Districts','M','Q','A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping:olx_regions','Ui_Vhr629.Query_Olx_Regions',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/olx_data_mapping:system_regions','Ui_Vhr629.Query_System_Regions',null,null,'A',null,null,null,null);

uis.path('/vhr/hrec/olx_data_mapping','vhr629');
uis.form('/vhr/hrec/olx_data_mapping','/vhr/hrec/olx_data_mapping','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hrec/olx_data_mapping','auth_olx','A',null,null,'A');
uis.action('/vhr/hrec/olx_data_mapping','clear_auth','A',null,null,'A');
uis.action('/vhr/hrec/olx_data_mapping','save_auth','A',null,null,'A');
uis.action('/vhr/hrec/olx_data_mapping','save_credentials','A','/vhr/hrec/olx_save_credentials','S','O');
uis.action('/vhr/hrec/olx_data_mapping','save_data_map','A',null,null,'A');
uis.action('/vhr/hrec/olx_data_mapping','sync','A',null,null,'G');
uis.action('/vhr/hrec/olx_data_mapping','sync_attribute','A',null,null,'A');
uis.action('/vhr/hrec/olx_data_mapping','sync_categories','A',null,null,'A');
uis.action('/vhr/hrec/olx_data_mapping','sync_cities','A',null,null,'A');
uis.action('/vhr/hrec/olx_data_mapping','sync_districts','A',null,null,'A');
uis.action('/vhr/hrec/olx_data_mapping','sync_regions','A',null,null,'A');


uis.ready('/vhr/hrec/olx_data_mapping','.auth_olx.clear_auth.model.save_auth.save_credentials.save_data_map.sync.sync_attribute.sync_categories.sync_cities.sync_districts.sync_regions.');

commit;
end;
/
