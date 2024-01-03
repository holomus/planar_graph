set define off
prompt PATH /vhr/hac/dss_server_view
begin
uis.route('/vhr/hac/dss_server_view$attach','Ui_Vhr505.Attach','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hac/dss_server_view$detach','Ui_Vhr505.Detach','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hac/dss_server_view$sync_companies','Ui_Vhr505.Sync_Companies','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hac/dss_server_view:get_departments','Ui_Vhr505.Get_Departments','M','R','A',null,null,null,null,null);
uis.route('/vhr/hac/dss_server_view:get_person_groups','Ui_Vhr505.Get_Person_Groups','M','R','A',null,null,null,null,null);
uis.route('/vhr/hac/dss_server_view:model','Ui_Vhr505.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hac/dss_server_view:table_company','Ui_Vhr505.Query_Companies','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hac/dss_server_view','vhr505');
uis.form('/vhr/hac/dss_server_view','/vhr/hac/dss_server_view','A','A','F','H','M','Y',null,'N',null);



uis.action('/vhr/hac/dss_server_view','attach','A',null,null,'A');
uis.action('/vhr/hac/dss_server_view','company_persons','A','/vhr/hac/dss_ex_person_list','S','O');
uis.action('/vhr/hac/dss_server_view','detach','A',null,null,'A');
uis.action('/vhr/hac/dss_server_view','devices','A','/vhr/hac/dss_device_list','S','O');
uis.action('/vhr/hac/dss_server_view','edit','A','/vhr/hac/dss_server+edit','S','O');
uis.action('/vhr/hac/dss_server_view','ex_access_groups','A','/vhr/hac/dss_ex_access_group_list','S','O');
uis.action('/vhr/hac/dss_server_view','ex_departments','A','/vhr/hac/dss_ex_department_list','S','O');
uis.action('/vhr/hac/dss_server_view','ex_devices','A','/vhr/hac/dss_ex_device_list','S','O');
uis.action('/vhr/hac/dss_server_view','ex_person_groups','A','/vhr/hac/dss_ex_person_group_list','S','O');
uis.action('/vhr/hac/dss_server_view','sync_companies','A',null,null,'A');


uis.ready('/vhr/hac/dss_server_view','.attach.company_persons.detach.devices.edit.ex_access_groups.ex_departments.ex_devices.ex_person_groups.model.sync_companies.');

commit;
end;
/
