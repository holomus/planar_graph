set define off
prompt PATH /vhr/href/employment_source_list
begin
uis.route('/vhr/href/employment_source_list$del','Ui_Vhr141.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/employment_source_list$delete','Ui_Vhr141.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/employment_source_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/employment_source_list:table','Ui_Vhr141.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/employment_source_list','vhr141');
uis.form('/vhr/href/employment_source_list','/vhr/href/employment_source_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/employment_source_list','add','A','/vhr/href/employment_source+add','S','O');
uis.action('/vhr/href/employment_source_list','delete','A',null,null,'A');
uis.action('/vhr/href/employment_source_list','edit','A','/vhr/href/employment_source+edit','S','O');
uis.action('/vhr/href/employment_source_list','view','A','/vhr/href/view/employment_source_view','S','O');


uis.ready('/vhr/href/employment_source_list','.add.delete.edit.model.view.');

commit;
end;
/
