set define off
prompt PATH /vhr/href/institution_list
begin
uis.route('/vhr/href/institution_list$delete','Ui_Vhr7.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/institution_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/institution_list:table','Ui_Vhr7.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/institution_list','vhr7');
uis.form('/vhr/href/institution_list','/vhr/href/institution_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/institution_list','add','A','/vhr/href/institution+add','S','O');
uis.action('/vhr/href/institution_list','delete','A',null,null,'A');
uis.action('/vhr/href/institution_list','edit','A','/vhr/href/institution+edit','S','O');
uis.action('/vhr/href/institution_list','view','A','/vhr/href/view/institution_view','S','O');


uis.ready('/vhr/href/institution_list','.add.delete.edit.model.view.');

commit;
end;
/
