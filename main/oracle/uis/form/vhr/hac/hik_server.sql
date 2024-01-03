set define off
prompt PATH /vhr/hac/hik_server
begin
uis.route('/vhr/hac/hik_server+add:gen_token','Ui_Vhr517.Gen_Token',null,'V','A',null,null,null,null);
uis.route('/vhr/hac/hik_server+add:model','Ui_Vhr517.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hac/hik_server+add:save','Ui_Vhr517.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hac/hik_server+edit:gen_token','Ui_Vhr517.Gen_Token',null,'V','A',null,null,null,null);
uis.route('/vhr/hac/hik_server+edit:model','Ui_Vhr517.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hac/hik_server+edit:save','Ui_Vhr517.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hac/hik_server','vhr517');
uis.form('/vhr/hac/hik_server+add','/vhr/hac/hik_server','A','A','F','H','M','Y',null,'N');
uis.form('/vhr/hac/hik_server+edit','/vhr/hac/hik_server','A','A','F','H','M','Y',null,'N');





uis.ready('/vhr/hac/hik_server+add','.model.');
uis.ready('/vhr/hac/hik_server+edit','.model.');

commit;
end;
/
