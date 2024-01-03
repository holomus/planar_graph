set define off
prompt PATH /vhr/hrec/hh_auth_controls
begin
uis.route('/vhr/hrec/hh_auth_controls$auth_hh','Ui_Vhr615.Auth_Hh',null,'M','A',null,null,null,null);
uis.route('/vhr/hrec/hh_auth_controls:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/hrec/hh_auth_controls','vhr615');
uis.form('/vhr/hrec/hh_auth_controls','/vhr/hrec/hh_auth_controls','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hrec/hh_auth_controls','auth_hh','A',null,null,'A');


uis.ready('/vhr/hrec/hh_auth_controls','.auth_hh.model.');

commit;
end;
/
