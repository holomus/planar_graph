set define off
prompt PATH /vhr/hpr/timebook
begin
uis.route('/vhr/hpr/timebook+add:get_blocked_staffs','Ui_Vhr75.Get_Blocked_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+add:load_all_staffs','Ui_Vhr75.Load_All_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+add:load_staff','Ui_Vhr75.Load_Staff','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+add:load_staffs','Ui_Vhr75.Load_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+add:model','Ui_Vhr75.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/timebook+add:save','Ui_Vhr75.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+add:staffs','Ui_Vhr75.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+edit:get_blocked_staffs','Ui_Vhr75.Get_Blocked_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+edit:load_all_staffs','Ui_Vhr75.Load_All_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+edit:load_staff','Ui_Vhr75.Load_Staff','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+edit:load_staffs','Ui_Vhr75.Load_Staffs','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+edit:model','Ui_Vhr75.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/timebook+edit:save','Ui_Vhr75.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/timebook+edit:staffs','Ui_Vhr75.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/hpr/timebook','vhr75');
uis.form('/vhr/hpr/timebook+add','/vhr/hpr/timebook','F','A','F','HM','M','N',null,'N');
uis.form('/vhr/hpr/timebook+edit','/vhr/hpr/timebook','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/hpr/timebook+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpr/timebook+add','view','F','/vhr/hpr/timebook_view','R','O');
uis.action('/vhr/hpr/timebook+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpr/timebook+edit','view','F','/vhr/hpr/timebook_view','R','O');


uis.ready('/vhr/hpr/timebook+add','.model.select_staff.view.');
uis.ready('/vhr/hpr/timebook+edit','.model.select_staff.view.');

commit;
end;
/
