set define off
prompt PATH /vhr/hsc/object_norm
begin
uis.route('/vhr/hsc/object_norm+add:actions','Ui_Vhr495.Query_Actions','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+add:areas','Ui_Vhr495.Query_Areas',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+add:division_objects','Ui_Vhr495.Query_Division_Objects',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+add:drivers','Ui_Vhr495.Query_Drivers',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+add:jobs','Ui_Vhr495.Query_Jobs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+add:model','Ui_Vhr495.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/object_norm+add:processes','Ui_Vhr495.Query_Processes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+add:save','Ui_Vhr495.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+edit:actions','Ui_Vhr495.Query_Actions','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+edit:areas','Ui_Vhr495.Query_Areas',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+edit:drivers','Ui_Vhr495.Query_Drivers',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+edit:jobs','Ui_Vhr495.Query_Jobs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+edit:model','Ui_Vhr495.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hsc/object_norm+edit:processes','Ui_Vhr495.Query_Processes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hsc/object_norm+edit:save','Ui_Vhr495.Edit','M',null,'A',null,null,null,null,null);

uis.path('/vhr/hsc/object_norm','vhr495');
uis.form('/vhr/hsc/object_norm+add','/vhr/hsc/object_norm','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hsc/object_norm+edit','/vhr/hsc/object_norm','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hsc/object_norm+add','select_action','F','/vhr/hsc/process_action_list','D','O');
uis.action('/vhr/hsc/object_norm+add','select_area','F','/vhr/hsc/area_list','D','O');
uis.action('/vhr/hsc/object_norm+add','select_driver','F','/vhr/hsc/driver_list','D','O');
uis.action('/vhr/hsc/object_norm+add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hsc/object_norm+add','select_process','F','/vhr/hsc/process_list','D','O');
uis.action('/vhr/hsc/object_norm+edit','select_action','F','/vhr/hsc/process_action_list','D','O');
uis.action('/vhr/hsc/object_norm+edit','select_area','F','/vhr/hsc/area_list','D','O');
uis.action('/vhr/hsc/object_norm+edit','select_driver','F','/vhr/hsc/driver_list','D','O');
uis.action('/vhr/hsc/object_norm+edit','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hsc/object_norm+edit','select_process','F','/vhr/hsc/process_list','D','O');


uis.ready('/vhr/hsc/object_norm+add','.model.select_action.select_area.select_driver.select_job.select_process.');
uis.ready('/vhr/hsc/object_norm+edit','.model.select_action.select_area.select_driver.select_job.select_process.');

commit;
end;
/
