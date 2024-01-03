set define off
prompt PATH /vhr/api/v1/pro/vacation
begin
uis.route('/vhr/api/v1/pro/vacation$list','Ui_Vhr285.List_Vacations','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/vacation','vhr285');
uis.form('/vhr/api/v1/pro/vacation','/vhr/api/v1/pro/vacation','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/vacation','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/vacation','.list.model.');

commit;
end;
/
