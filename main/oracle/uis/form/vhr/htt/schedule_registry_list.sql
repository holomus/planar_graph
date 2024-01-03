set define off
prompt PATH /vhr/htt/schedule_registry_list
begin
uis.route('/vhr/htt/schedule_registry_list+robot$delete','Ui_Vhr445.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/schedule_registry_list+robot$post','Ui_Vhr445.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/schedule_registry_list+robot$unpost','Ui_Vhr445.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/schedule_registry_list+robot:model','Ui_Vhr445.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/schedule_registry_list+robot:table','Ui_Vhr445.Query',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/schedule_registry_list+staff$delete','Ui_Vhr445.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/schedule_registry_list+staff$post','Ui_Vhr445.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/schedule_registry_list+staff$unpost','Ui_Vhr445.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/schedule_registry_list+staff:model','Ui_Vhr445.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/schedule_registry_list+staff:table','Ui_Vhr445.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/schedule_registry_list','vhr445');
uis.form('/vhr/htt/schedule_registry_list+robot','/vhr/htt/schedule_registry_list','F','A','F','H','M','N',null,'N');
uis.form('/vhr/htt/schedule_registry_list+staff','/vhr/htt/schedule_registry_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/schedule_registry_list+robot','add','F','/vhr/htt/schedule_registry+robot_add','S','O');
uis.action('/vhr/htt/schedule_registry_list+robot','custom','F',null,null,'G');
uis.action('/vhr/htt/schedule_registry_list+robot','delete','F',null,null,'A');
uis.action('/vhr/htt/schedule_registry_list+robot','edit','F','/vhr/htt/schedule_registry+robot_edit','S','O');
uis.action('/vhr/htt/schedule_registry_list+robot','flexible','F',null,null,'G');
uis.action('/vhr/htt/schedule_registry_list+robot','hourly','F',null,null,'G');
uis.action('/vhr/htt/schedule_registry_list+robot','post','F',null,null,'A');
uis.action('/vhr/htt/schedule_registry_list+robot','unpost','F',null,null,'A');
uis.action('/vhr/htt/schedule_registry_list+staff','add','F','/vhr/htt/schedule_registry+staff_add','S','O');
uis.action('/vhr/htt/schedule_registry_list+staff','custom','F',null,null,'G');
uis.action('/vhr/htt/schedule_registry_list+staff','delete','F',null,null,'A');
uis.action('/vhr/htt/schedule_registry_list+staff','edit','F','/vhr/htt/schedule_registry+staff_edit','S','O');
uis.action('/vhr/htt/schedule_registry_list+staff','flexible','F',null,null,'G');
uis.action('/vhr/htt/schedule_registry_list+staff','hourly','F',null,null,'G');
uis.action('/vhr/htt/schedule_registry_list+staff','post','F',null,null,'A');
uis.action('/vhr/htt/schedule_registry_list+staff','unpost','F',null,null,'A');


uis.ready('/vhr/htt/schedule_registry_list+robot','.add.custom.delete.edit.flexible.hourly.model.post.unpost.');
uis.ready('/vhr/htt/schedule_registry_list+staff','.add.custom.delete.edit.flexible.hourly.model.post.unpost.');

commit;
end;
/
