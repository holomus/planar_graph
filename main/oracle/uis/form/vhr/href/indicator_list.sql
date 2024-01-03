set define off
prompt PATH /vhr/href/indicator_list
begin
uis.route('/vhr/href/indicator_list$delete','Ui_Vhr57.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/indicator_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/indicator_list:table','Ui_Vhr57.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/indicator_list','vhr57');
uis.form('/vhr/href/indicator_list','/vhr/href/indicator_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/indicator_list','add','F','/vhr/href/indicator+add','S','O');
uis.action('/vhr/href/indicator_list','delete','F',null,null,'A');
uis.action('/vhr/href/indicator_list','edit','F','/vhr/href/indicator+edit','S','O');
uis.action('/vhr/href/indicator_list','view','F','/vhr/href/view/indicator_view','S','O');


uis.ready('/vhr/href/indicator_list','.add.delete.edit.model.view.');

commit;
end;
/
