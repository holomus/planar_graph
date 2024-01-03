set define off
prompt PATH /vhr/api/v1/pro/indicator
begin
uis.route('/vhr/api/v1/pro/indicator$list','Ui_Vhr415.List_Indicators','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/indicator','vhr415');
uis.form('/vhr/api/v1/pro/indicator','/vhr/api/v1/pro/indicator','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/indicator','list','A',null,null,'A');


uis.ready('/vhr/api/v1/pro/indicator','.list.model.');

commit;
end;
/
