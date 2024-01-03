set define off
prompt PATH /vhr/api/v1/pro/rank_change
begin
uis.route('/vhr/api/v1/pro/rank_change$list','Ui_Vhr428.List_Rank_Changes','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/rank_change','vhr428');
uis.form('/vhr/api/v1/pro/rank_change','/vhr/api/v1/pro/rank_change','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/rank_change','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/rank_change','.list.model.');

commit;
end;
/
