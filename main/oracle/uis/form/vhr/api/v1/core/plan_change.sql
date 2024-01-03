set define off
prompt PATH /vhr/api/v1/core/plan_change
begin
uis.route('/vhr/api/v1/core/plan_change$create','Ui_Vhr456.Create_Change','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/core/plan_change$delete','Ui_Vhr456.Delete_Change','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/plan_change$list','Ui_Vhr456.List_Changes','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/core/plan_change$update','Ui_Vhr456.Update_Change','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/core/plan_change:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/api/v1/core/plan_change','vhr456');
uis.form('/vhr/api/v1/core/plan_change','/vhr/api/v1/core/plan_change','F','A','E','H','M','N',null,'N');



uis.action('/vhr/api/v1/core/plan_change','create','F',null,null,'A');
uis.action('/vhr/api/v1/core/plan_change','delete','F',null,null,'A');
uis.action('/vhr/api/v1/core/plan_change','list','F',null,null,'A');
uis.action('/vhr/api/v1/core/plan_change','update','F',null,null,'A');


uis.ready('/vhr/api/v1/core/plan_change','.create.delete.list.model.update.');

commit;
end;
/
