set define off
prompt PATH /vhr/hpd/timeoff_list
begin
uis.route('/vhr/hpd/timeoff_list$delete','Ui_Vhr617.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/timeoff_list$post','Ui_Vhr617.Post','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/timeoff_list$unpost','Ui_Vhr617.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/timeoff_list:model','Ui_Vhr617.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/timeoff_list:table','Ui_Vhr617.Query',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/timeoff_list','vhr617');
uis.form('/vhr/hpd/timeoff_list','/vhr/hpd/timeoff_list','F','A','F','HM','M','N',null,null,null);



uis.action('/vhr/hpd/timeoff_list','delete','F',null,null,'A');
uis.action('/vhr/hpd/timeoff_list','post','F',null,null,'A');
uis.action('/vhr/hpd/timeoff_list','sick_leave_add','F','/vhr/hpd/sick_leave+add','S','O');
uis.action('/vhr/hpd/timeoff_list','sick_leave_audit','F','/vhr/hpd/audit/sick_leave_audit','S','O');
uis.action('/vhr/hpd/timeoff_list','sick_leave_edit','F','/vhr/hpd/sick_leave+edit','S','O');
uis.action('/vhr/hpd/timeoff_list','sick_leave_multiple_add','F','/vhr/hpd/sick_leave+multiple_add','S','O');
uis.action('/vhr/hpd/timeoff_list','sick_leave_multiple_audit','F','/vhr/hpd/audit/sick_leave_audit','S','O');
uis.action('/vhr/hpd/timeoff_list','sick_leave_multiple_edit','F','/vhr/hpd/sick_leave+multiple_edit','S','O');
uis.action('/vhr/hpd/timeoff_list','sick_leave_multiple_view','F','/vhr/hpd/view/sick_leave_view','S','O');
uis.action('/vhr/hpd/timeoff_list','sick_leave_view','F','/vhr/hpd/view/sick_leave_view','S','O');
uis.action('/vhr/hpd/timeoff_list','unpost','F',null,null,'A');
uis.action('/vhr/hpd/timeoff_list','vacation_add','F','/vhr/hpd/vacation+add','S','O');
uis.action('/vhr/hpd/timeoff_list','vacation_edit','F','/vhr/hpd/vacation+edit','S','O');
uis.action('/vhr/hpd/timeoff_list','vacation_multiple_add','F','/vhr/hpd/vacation+multiple_add','S','O');
uis.action('/vhr/hpd/timeoff_list','vacation_multiple_edit','F','/vhr/hpd/vacation+multiple_edit','S','O');
uis.action('/vhr/hpd/timeoff_list','vacation_multiple_view','F','/vhr/hpd/view/vacation_view','S','O');
uis.action('/vhr/hpd/timeoff_list','vacation_view','F','/vhr/hpd/view/vacation_view','S','O');


uis.ready('/vhr/hpd/timeoff_list','.delete.model.post.sick_leave_add.sick_leave_audit.sick_leave_edit.sick_leave_multiple_add.sick_leave_multiple_audit.sick_leave_multiple_edit.sick_leave_multiple_view.sick_leave_view.unpost.vacation_add.vacation_edit.vacation_multiple_add.vacation_multiple_edit.vacation_multiple_view.vacation_view.');

commit;
end;
/
