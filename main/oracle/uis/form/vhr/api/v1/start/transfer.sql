set define off
prompt PATH /vhr/api/v1/start/transfer
begin
uis.route('/vhr/api/v1/start/transfer$create','Ui_Vhr340.Create_Transfer','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/start/transfer$delete','Ui_Vhr340.Delete_Transfer','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/start/transfer$list','Ui_Vhr340.List_Transfers','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/start/transfer$update','Ui_Vhr340.Update_Transfer','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/start/transfer','vhr340');
uis.form('/vhr/api/v1/start/transfer','/vhr/api/v1/start/transfer','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/start/transfer','create','F',null,null,'A');
uis.action('/vhr/api/v1/start/transfer','delete','F',null,null,'A');
uis.action('/vhr/api/v1/start/transfer','list','F',null,null,'A');
uis.action('/vhr/api/v1/start/transfer','update','F',null,null,'A');


uis.ready('/vhr/api/v1/start/transfer','.create.delete.list.model.update.');

commit;
end;
/
