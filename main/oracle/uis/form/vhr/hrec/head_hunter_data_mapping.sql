set define off
prompt PATH /vhr/hrec/head_hunter_data_mapping
begin
uis.route('/vhr/hrec/head_hunter_data_mapping$clear_auth','Ui_Vhr614.Clear_Auth_Credentials',null,null,'A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping$save_auth','Ui_Vhr614.Save_Auth_Credentials','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping$save_data_map','Ui_Vhr614.Save_Data_Map','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping$subscribe','Ui_Vhr614.Webhook_Subscribe','M','R','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping$sync_dictionaries','Ui_Vhr614.Sync_Dictionaries',null,'R','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping$sync_jobs','Ui_Vhr614.Sync_Jobs',null,'R','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping$sync_langs','Ui_Vhr614.Sync_Langs',null,'R','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping$sync_regions','Ui_Vhr614.Sync_Regions',null,'R','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping$unsubscribe','Ui_Vhr614.Webhook_Unsubscribe',null,'R','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:hh_driver_licences','Ui_Vhr614.Query_Hh_Driver_Licences',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:hh_employments','Ui_Vhr614.Query_Hh_Employments',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:hh_experiences','Ui_Vhr614.Query_Hh_Experiences',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:hh_jobs','Ui_Vhr614.Query_Hh_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:hh_lang_levels','Ui_Vhr614.Query_Hh_Lang_Levels',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:hh_langs','Ui_Vhr614.Query_Hh_Langs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:hh_regions','Ui_Vhr614.Query_Hh_Regions',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:hh_schedules','Ui_Vhr614.Query_Hh_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:model','Ui_Vhr614.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:stages','Ui_Vhr614.Query_System_Stages',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:system_driver_licences','Ui_Vhr614.Query_System_Vacancy_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:system_employments','Ui_Vhr614.Query_System_Vacancy_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:system_experiences','Ui_Vhr614.Query_System_Vacancy_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:system_jobs','Ui_Vhr614.Query_System_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:system_lang_levels','Ui_Vhr614.Query_System_Lang_Levels',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:system_langs','Ui_Vhr614.Query_System_Langs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:system_regions','Ui_Vhr614.Query_System_Regions',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrec/head_hunter_data_mapping:system_schedules','Ui_Vhr614.Query_System_Schedules',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrec/head_hunter_data_mapping','vhr614');
uis.form('/vhr/hrec/head_hunter_data_mapping','/vhr/hrec/head_hunter_data_mapping','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hrec/head_hunter_data_mapping','clear_auth','A',null,null,'A');
uis.action('/vhr/hrec/head_hunter_data_mapping','save_auth','A',null,null,'A');
uis.action('/vhr/hrec/head_hunter_data_mapping','save_data_map','A',null,null,'A');
uis.action('/vhr/hrec/head_hunter_data_mapping','sign','A','/vhr/hrec/hh_auth_controls','S','O');
uis.action('/vhr/hrec/head_hunter_data_mapping','subscribe','A',null,null,'A');
uis.action('/vhr/hrec/head_hunter_data_mapping','sync','A',null,null,'G');
uis.action('/vhr/hrec/head_hunter_data_mapping','sync_dictionaries','A',null,null,'A');
uis.action('/vhr/hrec/head_hunter_data_mapping','sync_jobs','F',null,null,'A');
uis.action('/vhr/hrec/head_hunter_data_mapping','sync_langs','A',null,null,'A');
uis.action('/vhr/hrec/head_hunter_data_mapping','sync_regions','A',null,null,'A');
uis.action('/vhr/hrec/head_hunter_data_mapping','unsubscribe','A',null,null,'A');


uis.ready('/vhr/hrec/head_hunter_data_mapping','.clear_auth.model.save_auth.save_data_map.sign.subscribe.sync.sync_dictionaries.sync_jobs.sync_langs.sync_regions.unsubscribe.');

commit;
end;
/
