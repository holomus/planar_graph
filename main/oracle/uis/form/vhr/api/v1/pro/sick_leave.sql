set define off
prompt PATH /vhr/api/v1/pro/sick_leave
begin
uis.route('/vhr/api/v1/pro/sick_leave$list','Ui_Vhr290.List_Sick_Leaves','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/sick_leave','vhr290');
uis.form('/vhr/api/v1/pro/sick_leave','/vhr/api/v1/pro/sick_leave','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/sick_leave','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/sick_leave','.list.model.');

commit;
end;
/
