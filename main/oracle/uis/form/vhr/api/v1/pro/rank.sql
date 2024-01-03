set define off
prompt PATH /vhr/api/v1/pro/rank
begin
uis.route('/vhr/api/v1/pro/rank$create','Ui_Vhr425.Create_Rank','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/rank$delete','Ui_Vhr425.Delete_Rank','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/pro/rank$list','Ui_Vhr425.List_Ranks','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/rank$update','Ui_Vhr425.Update_Rank','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/pro/rank','vhr425');
uis.form('/vhr/api/v1/pro/rank','/vhr/api/v1/pro/rank','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/rank','create','F',null,null,'A');
uis.action('/vhr/api/v1/pro/rank','delete','F',null,null,'A');
uis.action('/vhr/api/v1/pro/rank','list','F',null,null,'A');
uis.action('/vhr/api/v1/pro/rank','update','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/rank','.create.delete.list.model.update.');

commit;
end;
/
