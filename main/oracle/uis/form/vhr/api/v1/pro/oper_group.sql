set define off
prompt PATH /vhr/api/v1/pro/oper_group
begin
uis.route('/vhr/api/v1/pro/oper_group$list','Ui_Vhr419.List_Oper_Groups','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/oper_group','vhr419');
uis.form('/vhr/api/v1/pro/oper_group','/vhr/api/v1/pro/oper_group','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/oper_group','list','A',null,null,'A');


uis.ready('/vhr/api/v1/pro/oper_group','.list.model.');

commit;
end;
/
