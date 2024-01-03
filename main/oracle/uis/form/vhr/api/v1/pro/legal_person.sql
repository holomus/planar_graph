set define off
prompt PATH /vhr/api/v1/pro/legal_person
begin
uis.route('/vhr/api/v1/pro/legal_person$list','Ui_Vhr427.List_Legal_Persons','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/legal_person','vhr427');
uis.form('/vhr/api/v1/pro/legal_person','/vhr/api/v1/pro/legal_person','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/legal_person','list','A',null,null,'A');


uis.ready('/vhr/api/v1/pro/legal_person','.list.model.');

commit;
end;
/
