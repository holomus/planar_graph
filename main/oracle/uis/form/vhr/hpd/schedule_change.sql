set define off
prompt PATH /vhr/hpd/schedule_change
begin
uis.route('/vhr/hpd/schedule_change+add:model','Ui_Vhr129.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/schedule_change+add:save','Ui_Vhr129.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/schedule_change+add:schedules','Ui_Vhr129.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/schedule_change+add:staffs','Ui_Vhr129.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/schedule_change+edit:model','Ui_Vhr129.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/schedule_change+edit:save','Ui_Vhr129.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/schedule_change+edit:schedules','Ui_Vhr129.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/schedule_change+edit:staffs','Ui_Vhr129.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/schedule_change','vhr129');
uis.form('/vhr/hpd/schedule_change+add','/vhr/hpd/schedule_change','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/schedule_change+edit','/vhr/hpd/schedule_change','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/schedule_change+add','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hpd/schedule_change+add','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hpd/schedule_change+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/schedule_change+edit','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hpd/schedule_change+edit','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hpd/schedule_change+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/schedule_change+add','.add_schedule.model.select_schedule.select_staff.');
uis.ready('/vhr/hpd/schedule_change+edit','.add_schedule.model.select_schedule.select_staff.');

commit;
end;
/
