set define off
prompt PATH /vhr/href/labor_function_list
begin
uis.route('/vhr/href/labor_function_list$delete','Ui_Vhr47.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/labor_function_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/labor_function_list:table','Ui_Vhr47.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/labor_function_list','vhr47');
uis.form('/vhr/href/labor_function_list','/vhr/href/labor_function_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/labor_function_list','add','A','/vhr/href/labor_function+add','S','O');
uis.action('/vhr/href/labor_function_list','delete','A',null,null,'A');
uis.action('/vhr/href/labor_function_list','edit','A','/vhr/href/labor_function+edit','S','O');
uis.action('/vhr/href/labor_function_list','view','A','/vhr/href/view/labor_function_view','S','O');


uis.ready('/vhr/href/labor_function_list','.add.delete.edit.model.view.');

commit;
end;
/
