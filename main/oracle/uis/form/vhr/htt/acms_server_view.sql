set define off
prompt PATH /vhr/htt/acms_server_view
begin
uis.route('/vhr/htt/acms_server_view$attach','Ui_Vhr472.Attach','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/acms_server_view$detach','Ui_Vhr472.Detach','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/acms_server_view:model','Ui_Vhr472.Modal','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/acms_server_view:table_company','Ui_Vhr472.Query_Companies','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/acms_server_view','vhr472');
uis.form('/vhr/htt/acms_server_view','/vhr/htt/acms_server_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/acms_server_view','attach','A',null,null,'A');
uis.action('/vhr/htt/acms_server_view','detach','A',null,null,'A');
uis.action('/vhr/htt/acms_server_view','edit','A','/vhr/htt/acms_server+edit','S','O');


uis.ready('/vhr/htt/acms_server_view','.attach.detach.edit.model.');

commit;
end;
/
