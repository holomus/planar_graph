set define off
prompt PATH /vhr/api/v1/pro/dismissal
begin
uis.route('/vhr/api/v1/pro/dismissal$list','Ui_Vhr288.List_Dismissals','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/dismissal','vhr288');
uis.form('/vhr/api/v1/pro/dismissal','/vhr/api/v1/pro/dismissal','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/dismissal','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/dismissal','.list.model.');

commit;
end;
/
