set define off
prompt PATH /vhr/api/v1/core/time_kind
begin
uis.route('/vhr/api/v1/core/time_kind$list','Ui_Vhr416.List_Time_Kinds','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/core/time_kind','vhr416');
uis.form('/vhr/api/v1/core/time_kind','/vhr/api/v1/core/time_kind','A','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/core/time_kind','list','A',null,null,'A');


uis.ready('/vhr/api/v1/core/time_kind','.list.model.');

commit;
end;
/
