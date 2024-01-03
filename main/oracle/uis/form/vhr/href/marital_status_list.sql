set define off
prompt PATH /vhr/href/marital_status_list
begin
uis.route('/vhr/href/marital_status_list$delete','Ui_Vhr23.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/marital_status_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/marital_status_list:table','Ui_Vhr23.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/marital_status_list','vhr23');
uis.form('/vhr/href/marital_status_list','/vhr/href/marital_status_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/marital_status_list','add','A','/vhr/href/marital_status+add','S','O');
uis.action('/vhr/href/marital_status_list','delete','A',null,null,'A');
uis.action('/vhr/href/marital_status_list','edit','A','/vhr/href/marital_status+edit','S','O');
uis.action('/vhr/href/marital_status_list','view','A','/vhr/href/view/marital_status_view','S','O');


uis.ready('/vhr/href/marital_status_list','.add.delete.edit.model.view.');

commit;
end;
/
