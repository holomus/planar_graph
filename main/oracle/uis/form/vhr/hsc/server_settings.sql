set define off
prompt PATH /vhr/hsc/server_settings
begin
uis.route('/vhr/hsc/server_settings:model','Ui_Vhr575.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hsc/server_settings:save','Ui_Vhr575.Save','M',null,'A',null,null,null,null);

uis.path('/vhr/hsc/server_settings','vhr575');
uis.form('/vhr/hsc/server_settings','/vhr/hsc/server_settings','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hsc/server_settings','.model.');

commit;
end;
/
