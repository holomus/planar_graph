set define off
prompt PATH /vhr/href/fte_list
begin
uis.route('/vhr/href/fte_list$delete','Ui_Vhr310.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/fte_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/fte_list:table','Ui_Vhr310.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/fte_list','vhr310');
uis.form('/vhr/href/fte_list','/vhr/href/fte_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/fte_list','add','A','/vhr/href/fte+add','S','O');
uis.action('/vhr/href/fte_list','delete','A',null,null,'A');
uis.action('/vhr/href/fte_list','edit','A','/vhr/href/fte+edit','S','O');
uis.action('/vhr/href/fte_list','view','A','/vhr/href/view/fte_view','S','O');


uis.ready('/vhr/href/fte_list','.add.delete.edit.model.view.');

commit;
end;
/
