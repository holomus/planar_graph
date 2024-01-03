set define off
prompt PATH /vhr/href/experience_type_list
begin
uis.route('/vhr/href/experience_type_list$delete','Ui_Vhr25.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/experience_type_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/experience_type_list:table','Ui_Vhr25.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/experience_type_list','vhr25');
uis.form('/vhr/href/experience_type_list','/vhr/href/experience_type_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/experience_type_list','add','A','/vhr/href/experience_type+add','S','O');
uis.action('/vhr/href/experience_type_list','delete','A',null,null,'A');
uis.action('/vhr/href/experience_type_list','edit','A','/vhr/href/experience_type+edit','S','O');
uis.action('/vhr/href/experience_type_list','view','A','/vhr/href/view/experience_type_view','S','O');


uis.ready('/vhr/href/experience_type_list','.add.delete.edit.model.view.');

commit;
end;
/
