set define off
prompt PATH /vhr/hac/hik_listening_device
begin
uis.route('/vhr/hac/hik_listening_device+add:companies','Ui_Vhr666.Query_Companies',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hac/hik_listening_device+add:model','Ui_Vhr666.Add_Model',null,'M','A','Y',null,null,null,'S');
uis.route('/vhr/hac/hik_listening_device+add:save','Ui_Vhr666.Save','M','M','A',null,null,null,null,'S');

uis.path('/vhr/hac/hik_listening_device','vhr666');
uis.form('/vhr/hac/hik_listening_device+add','/vhr/hac/hik_listening_device','A','A','F','H','M','Y',null,'N','S');





uis.ready('/vhr/hac/hik_listening_device+add','.model.');

commit;
end;
/
