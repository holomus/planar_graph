set define off
prompt PATH /vhr/api/v1/pro/transfer
begin
uis.route('/vhr/api/v1/pro/transfer$list','Ui_Vhr286.List_Transfers','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/transfer','vhr286');
uis.form('/vhr/api/v1/pro/transfer','/vhr/api/v1/pro/transfer','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/transfer','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/transfer','.list.model.');

commit;
end;
/
