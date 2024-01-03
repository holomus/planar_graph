set define off
prompt PATH /vhr/api/v1/pro/robot
begin
uis.route('/vhr/api/v1/pro/robot$list','Ui_Vhr423.List_Robots','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/robot','vhr423');
uis.form('/vhr/api/v1/pro/robot','/vhr/api/v1/pro/robot','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/robot','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/robot','.list.model.');

commit;
end;
/
