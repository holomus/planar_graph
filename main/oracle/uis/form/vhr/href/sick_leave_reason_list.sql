set define off
prompt PATH /vhr/href/sick_leave_reason_list
begin
uis.route('/vhr/href/sick_leave_reason_list$delete','Ui_Vhr161.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/sick_leave_reason_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/sick_leave_reason_list:table','Ui_Vhr161.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/sick_leave_reason_list','vhr161');
uis.form('/vhr/href/sick_leave_reason_list','/vhr/href/sick_leave_reason_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/href/sick_leave_reason_list','add','F','/vhr/href/sick_leave_reason+add','S','O');
uis.action('/vhr/href/sick_leave_reason_list','delete','F',null,null,'A');
uis.action('/vhr/href/sick_leave_reason_list','edit','F','/vhr/href/sick_leave_reason+edit','S','O');
uis.action('/vhr/href/sick_leave_reason_list','view','F','/vhr/href/view/sick_leave_reason_view','S','O');


uis.ready('/vhr/href/sick_leave_reason_list','.add.delete.edit.model.view.');

commit;
end;
/
