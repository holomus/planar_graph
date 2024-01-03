set define off
prompt PATH /vhr/api/v1/pro/book
begin
uis.route('/vhr/api/v1/pro/book$list','Ui_Vhr662.List_Books','M','JO','A',null,null,null,null,'S,BR,BS');

uis.path('/vhr/api/v1/pro/book','vhr662');
uis.form('/vhr/api/v1/pro/book','/vhr/api/v1/pro/book','F','A','E','Z','M','N',null,'N','BR,BS');



uis.action('/vhr/api/v1/pro/book','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/book','.list.model.');

commit;
end;
/
