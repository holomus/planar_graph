set define off
prompt PATH /vhr/hper/plan_type_list
begin
uis.route('/vhr/hper/plan_type_list$delete','Ui_Vhr132.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hper/plan_type_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hper/plan_type_list:table','Ui_Vhr132.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hper/plan_type_list','vhr132');
uis.form('/vhr/hper/plan_type_list','/vhr/hper/plan_type_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/hper/plan_type_list','add','F','/vhr/hper/plan_type+add','S','O');
uis.action('/vhr/hper/plan_type_list','delete','F',null,null,'A');
uis.action('/vhr/hper/plan_type_list','edit','F','/vhr/hper/plan_type+edit','S','O');

uis.form_sibling('vhr','/vhr/hper/plan_type_list','/vhr/hper/plan_group_list',1);


uis.ready('/vhr/hper/plan_type_list','.add.delete.edit.model.');

commit;
end;
/
