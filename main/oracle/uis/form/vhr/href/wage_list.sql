set define off
prompt PATH /vhr/href/wage_list
begin
uis.route('/vhr/href/wage_list$delete','Ui_Vhr143.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/wage_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/wage_list:table','Ui_Vhr143.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/wage_list','vhr143');
uis.form('/vhr/href/wage_list','/vhr/href/wage_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/wage_list','add','F','/vhr/href/wage+add','S','O');
uis.action('/vhr/href/wage_list','delete','F',null,null,'A');
uis.action('/vhr/href/wage_list','edit','F','/vhr/href/wage+edit','S','O');
uis.action('/vhr/href/wage_list','view','F','/vhr/href/view/wage_view','S','O');


uis.ready('/vhr/href/wage_list','.add.delete.edit.model.view.');

commit;
end;
/
