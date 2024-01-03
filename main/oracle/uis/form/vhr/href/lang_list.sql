set define off
prompt PATH /vhr/href/lang_list
begin
uis.route('/vhr/href/lang_list$delete','Ui_Vhr17.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/lang_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/lang_list:table','Ui_Vhr17.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/lang_list','vhr17');
uis.form('/vhr/href/lang_list','/vhr/href/lang_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/lang_list','add','A','/vhr/href/lang+add','S','O');
uis.action('/vhr/href/lang_list','delete','A',null,null,'A');
uis.action('/vhr/href/lang_list','edit','A','/vhr/href/lang+edit','S','O');
uis.action('/vhr/href/lang_list','view','A','/vhr/href/view/lang_view','S','O');


uis.ready('/vhr/href/lang_list','.add.delete.edit.model.view.');

commit;
end;
/
