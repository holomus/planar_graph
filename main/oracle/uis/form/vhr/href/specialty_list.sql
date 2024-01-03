set define off
prompt PATH /vhr/href/specialty_list
begin
uis.route('/vhr/href/specialty_list$delete','Ui_Vhr9.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/specialty_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/specialty_list:table','Ui_Vhr9.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/href/specialty_list','vhr9');
uis.form('/vhr/href/specialty_list','/vhr/href/specialty_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/specialty_list','add','A','/vhr/href/specialty+add','S','O');
uis.action('/vhr/href/specialty_list','child_specialty','A','/vhr/href/specialty_list','S','O');
uis.action('/vhr/href/specialty_list','delete','A',null,null,'A');
uis.action('/vhr/href/specialty_list','edit','A','/vhr/href/specialty+edit','S','O');
uis.action('/vhr/href/specialty_list','view','A','/vhr/href/view/specialty_view','S','O');


uis.ready('/vhr/href/specialty_list','.add.child_specialty.delete.edit.model.view.');

commit;
end;
/
