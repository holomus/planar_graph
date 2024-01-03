set define off
prompt PATH /vhr/href/lang_level_list
begin
uis.route('/vhr/href/lang_level_list$delete','Ui_Vhr19.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/lang_level_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/lang_level_list:table','Ui_Vhr19.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/lang_level_list','vhr19');
uis.form('/vhr/href/lang_level_list','/vhr/href/lang_level_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/lang_level_list','add','A','/vhr/href/lang_level+add','S','O');
uis.action('/vhr/href/lang_level_list','delete','A',null,null,'A');
uis.action('/vhr/href/lang_level_list','edit','A','/vhr/href/lang_level+edit','S','O');
uis.action('/vhr/href/lang_level_list','view','A','/vhr/href/view/lang_level_view','S','O');


uis.ready('/vhr/href/lang_level_list','.add.delete.edit.model.view.');

commit;
end;
/
