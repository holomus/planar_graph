set define off
prompt PATH /vhr/hper/plan_group_list
begin
uis.route('/vhr/hper/plan_group_list$delete','Ui_Vhr130.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/plan_group_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hper/plan_group_list:table','Ui_Vhr130.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hper/plan_group_list','vhr130');
uis.form('/vhr/hper/plan_group_list','/vhr/hper/plan_group_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/hper/plan_group_list','add','F','/vhr/hper/plan_group+add','S','O');
uis.action('/vhr/hper/plan_group_list','delete','F',null,null,'A');
uis.action('/vhr/hper/plan_group_list','edit','F','/vhr/hper/plan_group+edit','S','O');
uis.action('/vhr/hper/plan_group_list','show_type','F','/vhr/hper/plan_type_list','S','O');
uis.action('/vhr/hper/plan_group_list','view','F','/vhr/hper/view/plan_group_view','S','O');


uis.ready('/vhr/hper/plan_group_list','.add.delete.edit.model.show_type.view.');

commit;
end;
/
