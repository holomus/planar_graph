set define off
prompt PATH /vhr/href/relation_degree_list
begin
uis.route('/vhr/href/relation_degree_list$delete','Ui_Vhr21.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/relation_degree_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/relation_degree_list:table','Ui_Vhr21.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/relation_degree_list','vhr21');
uis.form('/vhr/href/relation_degree_list','/vhr/href/relation_degree_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/relation_degree_list','add','A','/vhr/href/relation_degree+add','S','O');
uis.action('/vhr/href/relation_degree_list','delete','A',null,null,'A');
uis.action('/vhr/href/relation_degree_list','edit','A','/vhr/href/relation_degree+edit','S','O');
uis.action('/vhr/href/relation_degree_list','view','A','/vhr/href/view/relation_degree_view','S','O');


uis.ready('/vhr/href/relation_degree_list','.add.delete.edit.model.view.');

commit;
end;
/
