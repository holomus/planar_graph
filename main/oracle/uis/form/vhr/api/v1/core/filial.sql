set define off
prompt PATH /vhr/api/v1/core/filial
begin
uis.route('/vhr/api/v1/core/filial$info','Ui_Vhr658.Filial_Info',null,'JO','A',null,null,null,null,'BR,BS');

uis.path('/vhr/api/v1/core/filial','vhr658');
uis.form('/vhr/api/v1/core/filial','/vhr/api/v1/core/filial','F','A','E','Z','M','N',null,'N','BR,BS');



uis.action('/vhr/api/v1/core/filial','info','F',null,null,'A');


uis.ready('/vhr/api/v1/core/filial','.info.model.');

commit;
end;
/
