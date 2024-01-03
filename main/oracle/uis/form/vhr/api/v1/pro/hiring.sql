set define off
prompt PATH /vhr/api/v1/pro/hiring
begin
uis.route('/vhr/api/v1/pro/hiring$list','Ui_Vhr281.List_Hirings','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/hiring','vhr281');
uis.form('/vhr/api/v1/pro/hiring','/vhr/api/v1/pro/hiring','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/hiring','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/hiring','.list.model.');

commit;
end;
/
