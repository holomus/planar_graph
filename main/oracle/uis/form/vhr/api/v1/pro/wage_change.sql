set define off
prompt PATH /vhr/api/v1/pro/wage_change
begin
uis.route('/vhr/api/v1/pro/wage_change$list','Ui_Vhr426.List_Wage_Changes','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/wage_change','vhr426');
uis.form('/vhr/api/v1/pro/wage_change','/vhr/api/v1/pro/wage_change','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/wage_change','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/wage_change','.list.model.');

commit;
end;
/
