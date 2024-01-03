set define off
prompt PATH /vhr/hrec/olx_save_credentials
begin
uis.route('/vhr/hrec/olx_save_credentials$clear_auth','Ui_Vhr631.Clear_Auth_Credentials',null,null,'A',null,null,null,null);
uis.route('/vhr/hrec/olx_save_credentials$save_auth','Ui_Vhr631.Save_Auth_Credentials','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/olx_save_credentials:model','Ui_Vhr631.Model',null,'M','A','Y',null,null,null);

uis.path('/vhr/hrec/olx_save_credentials','vhr631');
uis.form('/vhr/hrec/olx_save_credentials','/vhr/hrec/olx_save_credentials','H','A','F','H','M','Y',null,'N');



uis.action('/vhr/hrec/olx_save_credentials','clear_auth','H',null,null,'A');
uis.action('/vhr/hrec/olx_save_credentials','save_auth','H',null,null,'A');


uis.ready('/vhr/hrec/olx_save_credentials','.clear_auth.model.save_auth.');

commit;
end;
/
