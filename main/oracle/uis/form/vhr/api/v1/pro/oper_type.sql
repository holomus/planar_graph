set define off
prompt PATH /vhr/api/v1/pro/oper_type
begin
uis.route('/vhr/api/v1/pro/oper_type$list','Ui_Vhr422.List_Oper_Types','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/oper_type','vhr422');
uis.form('/vhr/api/v1/pro/oper_type','/vhr/api/v1/pro/oper_type','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/oper_type','list','A',null,null,'A');


uis.ready('/vhr/api/v1/pro/oper_type','.list.model.');

commit;
end;
/
