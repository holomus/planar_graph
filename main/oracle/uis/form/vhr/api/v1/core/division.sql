set define off
prompt PATH /vhr/api/v1/core/division
begin
uis.route('/vhr/api/v1/core/division$create','Ui_Vhr337.Create_Division','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/division$delete','Ui_Vhr337.Delete_Division','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/division$list','Ui_Vhr337.List_Divisions','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/division$update','Ui_Vhr337.Update_Division','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/core/division','vhr337');
uis.form('/vhr/api/v1/core/division','/vhr/api/v1/core/division','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/core/division','create','F',null,null,'A');
uis.action('/vhr/api/v1/core/division','delete','F',null,null,'A');
uis.action('/vhr/api/v1/core/division','list','F',null,null,'A');
uis.action('/vhr/api/v1/core/division','update','F',null,null,'A');


uis.ready('/vhr/api/v1/core/division','.create.delete.list.model.update.');

commit;
end;
/
