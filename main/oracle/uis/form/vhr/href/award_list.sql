set define off
prompt PATH /vhr/href/award_list
begin
uis.route('/vhr/href/award_list$delete','Ui_Vhr28.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/award_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/award_list:table','Ui_Vhr28.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/award_list','vhr28');
uis.form('/vhr/href/award_list','/vhr/href/award_list','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/award_list','add','A','/vhr/href/award+add','S','O');
uis.action('/vhr/href/award_list','delete','A',null,null,'A');
uis.action('/vhr/href/award_list','edit','A','/vhr/href/award+edit','S','O');
uis.action('/vhr/href/award_list','view','A','/vhr/href/view/award_view','S','O');


uis.ready('/vhr/href/award_list','.add.delete.edit.model.view.');

commit;
end;
/
