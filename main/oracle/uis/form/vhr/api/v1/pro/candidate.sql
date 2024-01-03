set define off
prompt PATH /vhr/api/v1/pro/candidate
begin
uis.route('/vhr/api/v1/pro/candidate$create','Ui_Vhr588.Create_Candidate','JO','JO','A',null,null,null,null,null);
uis.route('/vhr/api/v1/pro/candidate$telegram_create','Ui_Vhr588.Create_Candidate_Via_Telegram','JO',null,'A',null,null,null,null,null);

uis.path('/vhr/api/v1/pro/candidate','vhr588');
uis.form('/vhr/api/v1/pro/candidate','/vhr/api/v1/pro/candidate','F','A','E','Z','M','N',null,'N',null);



uis.action('/vhr/api/v1/pro/candidate','create','F',null,null,'A');
uis.action('/vhr/api/v1/pro/candidate','telegram_create','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/candidate','.create.model.telegram_create.');

commit;
end;
/
