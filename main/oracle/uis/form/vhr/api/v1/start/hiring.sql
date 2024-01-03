set define off
prompt PATH /vhr/api/v1/start/hiring
begin
uis.route('/vhr/api/v1/start/hiring$create','Ui_Vhr342.Create_Hiring','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/start/hiring$delete','Ui_Vhr342.Delete_Hiring','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/start/hiring$list','Ui_Vhr342.List_Hirings','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/start/hiring$update','Ui_Vhr342.Update_Hiring','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/start/hiring','vhr342');
uis.form('/vhr/api/v1/start/hiring','/vhr/api/v1/start/hiring','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/start/hiring','create','F',null,null,'A');
uis.action('/vhr/api/v1/start/hiring','delete','F',null,null,'A');
uis.action('/vhr/api/v1/start/hiring','list','F',null,null,'A');
uis.action('/vhr/api/v1/start/hiring','update','F',null,null,'A');


uis.ready('/vhr/api/v1/start/hiring','.create.delete.list.model.update.');

commit;
end;
/
