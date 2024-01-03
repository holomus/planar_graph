set define off
prompt PATH /vhr/hac/hik_device
begin
uis.route('/vhr/hac/hik_device+add$gen_device_name','Ui_Vhr524.Gen_Device_Name',null,'M','A',null,null,null,null);
uis.route('/vhr/hac/hik_device+add$gen_isup_password','Ui_Vhr524.Gen_Isup_Password',null,'M','A',null,null,null,null);
uis.route('/vhr/hac/hik_device+add:companies','Ui_Vhr524.Query_Companies','M','Q','A',null,null,null,null);
uis.route('/vhr/hac/hik_device+add:event_types','Ui_Vhr524.Query_Event_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/hac/hik_device+add:model','Ui_Vhr524.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hac/hik_device+add:save','Ui_Vhr524.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hac/hik_device+edit:companies','Ui_Vhr524.Query_Companies','M','Q','A',null,null,null,null);
uis.route('/vhr/hac/hik_device+edit:event_types','Ui_Vhr524.Query_Event_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/hac/hik_device+edit:model','Ui_Vhr524.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hac/hik_device+edit:save','Ui_Vhr524.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hac/hik_device','vhr524');
uis.form('/vhr/hac/hik_device+add','/vhr/hac/hik_device','A','A','F','H','M','Y',null,'N');
uis.form('/vhr/hac/hik_device+edit','/vhr/hac/hik_device','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/hik_device+add','gen_device_name','A',null,null,'A');
uis.action('/vhr/hac/hik_device+add','gen_isup_password','A',null,null,'A');


uis.ready('/vhr/hac/hik_device+add','.gen_device_name.gen_isup_password.model.');
uis.ready('/vhr/hac/hik_device+edit','.model.');

commit;
end;
/
