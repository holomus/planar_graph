set define off
prompt PATH /vhr/href/edu_stage_list
begin
uis.route('/vhr/href/edu_stage_list$delete','Ui_Vhr1.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/edu_stage_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/edu_stage_list:table','Ui_Vhr1.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/edu_stage_list','vhr1');
uis.form('/vhr/href/edu_stage_list','/vhr/href/edu_stage_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/edu_stage_list','add','A','/vhr/href/edu_stage+add','S','O');
uis.action('/vhr/href/edu_stage_list','delete','A',null,null,'A');
uis.action('/vhr/href/edu_stage_list','edit','A','/vhr/href/edu_stage+edit','S','O');
uis.action('/vhr/href/edu_stage_list','view','A','/vhr/href/view/edu_stage_view','S','O');


uis.ready('/vhr/href/edu_stage_list','.add.delete.edit.model.view.');

commit;
end;
/
