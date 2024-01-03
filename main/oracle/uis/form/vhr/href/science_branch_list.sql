set define off
prompt PATH /vhr/href/science_branch_list
begin
uis.route('/vhr/href/science_branch_list$delete','Ui_Vhr2.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/science_branch_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/science_branch_list:table','Ui_Vhr2.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/science_branch_list','vhr2');
uis.form('/vhr/href/science_branch_list','/vhr/href/science_branch_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/science_branch_list','add','A','/vhr/href/science_branch+add','S','O');
uis.action('/vhr/href/science_branch_list','delete','A',null,null,'A');
uis.action('/vhr/href/science_branch_list','edit','A','/vhr/href/science_branch+edit','S','O');
uis.action('/vhr/href/science_branch_list','view','A','/vhr/href/view/science_branch_view','S','O');


uis.ready('/vhr/href/science_branch_list','.add.delete.edit.model.view.');

commit;
end;
/
