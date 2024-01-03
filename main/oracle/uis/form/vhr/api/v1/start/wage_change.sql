set define off
prompt PATH /vhr/api/v1/start/wage_change
begin
uis.route('/vhr/api/v1/start/wage_change$create','Ui_Vhr347.Create_Wage_Change','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/start/wage_change$delete','Ui_Vhr347.Delete_Wage_Change','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/start/wage_change$list','Ui_Vhr347.List_Wage_Changes','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/start/wage_change$update','Ui_Vhr347.Update_Wage_Change','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/start/wage_change','vhr347');
uis.form('/vhr/api/v1/start/wage_change','/vhr/api/v1/start/wage_change','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/start/wage_change','create','F',null,null,'A');
uis.action('/vhr/api/v1/start/wage_change','delete','F',null,null,'A');
uis.action('/vhr/api/v1/start/wage_change','list','F',null,null,'A');
uis.action('/vhr/api/v1/start/wage_change','update','F',null,null,'A');


uis.ready('/vhr/api/v1/start/wage_change','.create.delete.list.model.update.');

commit;
end;
/
