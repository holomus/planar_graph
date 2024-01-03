set define off
prompt PATH /vhr/href/reference_type_list
begin
uis.route('/vhr/href/reference_type_list$delete','Ui_Vhr45.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/reference_type_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/reference_type_list:table','Ui_Vhr45.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/reference_type_list','vhr45');
uis.form('/vhr/href/reference_type_list','/vhr/href/reference_type_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/reference_type_list','add','A','/vhr/href/reference_type+add','S','O');
uis.action('/vhr/href/reference_type_list','delete','A',null,null,'A');
uis.action('/vhr/href/reference_type_list','edit','A','/vhr/href/reference_type+edit','S','O');
uis.action('/vhr/href/reference_type_list','view','A','/vhr/href/view/reference_type_view','S','O');


uis.ready('/vhr/href/reference_type_list','.add.delete.edit.model.view.');

commit;
end;
/
