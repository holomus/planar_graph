set define off
prompt PATH /vhr/api/v1/start/overtime
begin
uis.route('/vhr/api/v1/start/overtime$create','Ui_Vhr462.Create_Overtime','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/start/overtime$delete','Ui_Vhr462.Delete_Overtime','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/start/overtime$list','Ui_Vhr462.List_Overtimes','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/start/overtime$update','Ui_Vhr462.Update_Overtime','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/start/overtime','vhr462');
uis.form('/vhr/api/v1/start/overtime','/vhr/api/v1/start/overtime','F','A','F','H','M','N',null,'N');



uis.action('/vhr/api/v1/start/overtime','create','F',null,null,'A');
uis.action('/vhr/api/v1/start/overtime','delete','F',null,null,'A');
uis.action('/vhr/api/v1/start/overtime','list','F',null,null,'A');
uis.action('/vhr/api/v1/start/overtime','update','F',null,null,'A');


uis.ready('/vhr/api/v1/start/overtime','.create.delete.list.model.update.');

commit;
end;
/
