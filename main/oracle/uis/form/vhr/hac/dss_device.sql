set define off
prompt PATH /vhr/hac/dss_device
begin
uis.route('/vhr/hac/dss_device+add:companies','Ui_Vhr507.Query_Companies','M','Q','A',null,null,null,null);
uis.route('/vhr/hac/dss_device+add:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/dss_device+add:save','Ui_Vhr507.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hac/dss_device+edit$gen_device_name','Ui_Vhr507.Gen_Device_Name',null,'M','A',null,null,null,null);
uis.route('/vhr/hac/dss_device+edit:companies','Ui_Vhr507.Query_Companies','M','Q','A',null,null,null,null);
uis.route('/vhr/hac/dss_device+edit:model','Ui_Vhr507.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hac/dss_device+edit:save','Ui_Vhr507.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hac/dss_device+edit:servers','Ui_Vhr507.Query_Servers',null,null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_device:model','Ui_Vhr507.Add','M','M','A','Y',null,null,null);

uis.path('/vhr/hac/dss_device','vhr507');
uis.form('/vhr/hac/dss_device+add','/vhr/hac/dss_device','A','A','F','H','M','Y',null,'N');
uis.form('/vhr/hac/dss_device+edit','/vhr/hac/dss_device','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/dss_device+edit','gen_device_name','A',null,null,'A');


uis.ready('/vhr/hac/dss_device+add','.model.');
uis.ready('/vhr/hac/dss_device+edit','.gen_device_name.model.');

commit;
end;
/
