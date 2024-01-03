set define off
prompt PATH /vhr/htt/location_list
begin
uis.route('/vhr/htt/location_list$delete','Ui_Vhr78.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_list$detach','Ui_Vhr78.Detach','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_list$generate_qr_code','Ui_Vhr78.Generate_Qr_Code','M','M','A',null,null,null,null);
uis.route('/vhr/htt/location_list+open_attach$attach','Ui_Vhr78.Attach','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_list+open_attach:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/location_list+open_attach:table','Ui_Vhr78.Detached_Query',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/location_list:get_influences','Ui_Vhr78.Get_Influences','M','M','A',null,null,null,null);
uis.route('/vhr/htt/location_list:model','Ui_Vhr78.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/location_list:table','Ui_Vhr78.Attached_Query','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/location_list','vhr78');
uis.form('/vhr/htt/location_list','/vhr/htt/location_list','A','A','F','H','M','N',null,'N');
uis.form('/vhr/htt/location_list+open_attach','/vhr/htt/location_list','F','A','F','H','M','N',null,null);



uis.action('/vhr/htt/location_list','add','A','/vhr/htt/location+add','S','O');
uis.action('/vhr/htt/location_list','delete','A',null,null,'A');
uis.action('/vhr/htt/location_list','detach','F',null,null,'A');
uis.action('/vhr/htt/location_list','devices','A','/vhr/htt/device_list','S','O');
uis.action('/vhr/htt/location_list','edit','A','/vhr/htt/location+edit','S','O');
uis.action('/vhr/htt/location_list','generate_qr_code','A',null,null,'A');
uis.action('/vhr/htt/location_list','import','A','/vhr/htt/location_import','S','O');
uis.action('/vhr/htt/location_list','open_attach','F','/vhr/htt/location_list+open_attach','S','O');
uis.action('/vhr/htt/location_list','view','A','/vhr/htt/location_view','S','O');
uis.action('/vhr/htt/location_list+open_attach','attach','F',null,null,'A');

uis.form_sibling('vhr','/vhr/htt/location_list','/vhr/htt/location_type_list',1);
uis.form_sibling('vhr','/vhr/htt/location_list','/vhr/htt/device_list',2);
uis.form_sibling('vhr','/vhr/htt/location_list','/vhr/htt/qr_code_list',3);
uis.form_sibling('vhr','/vhr/htt/location_list','/vhr/htt/new_devices_list',4);

uis.ready('/vhr/htt/location_list','.add.delete.detach.devices.edit.generate_qr_code.import.model.open_attach.view.');
uis.ready('/vhr/htt/location_list+open_attach','.attach.model.');

commit;
end;
/
