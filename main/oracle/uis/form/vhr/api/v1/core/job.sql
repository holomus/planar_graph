set define off
prompt PATH /vhr/api/v1/core/job
begin
uis.route('/vhr/api/v1/core/job$create','Ui_Vhr338.Create_Job','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/job$delete','Ui_Vhr338.Delete_Job','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/job$list','Ui_Vhr338.List_Jobs','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/job$update','Ui_Vhr338.Update_Job','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/core/job','vhr338');
uis.form('/vhr/api/v1/core/job','/vhr/api/v1/core/job','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/core/job','create','F',null,null,'A');
uis.action('/vhr/api/v1/core/job','delete','F',null,null,'A');
uis.action('/vhr/api/v1/core/job','list','F',null,null,'A');
uis.action('/vhr/api/v1/core/job','update','F',null,null,'A');


uis.ready('/vhr/api/v1/core/job','.create.delete.list.model.update.');

commit;
end;
/
