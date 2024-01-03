set define off
prompt PATH /vhr/hrm/job_list
begin
uis.route('/vhr/hrm/job_list$delete','Ui_Vhr660.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/job_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,null);
uis.route('/vhr/hrm/job_list:table','Ui_Vhr660.Query','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hrm/job_list','vhr660');
uis.form('/vhr/hrm/job_list','/vhr/hrm/job_list','F','A','F','H','M','N',null,'N',null);

uis.override_form('/anor/mhr/job_list','vhr','/vhr/hrm/job_list');


uis.action('/vhr/hrm/job_list','add','F','/vhr/hrm/job+add','S','O');
uis.action('/vhr/hrm/job_list','audit','F','/core/md/audit_list','S','O');
uis.action('/vhr/hrm/job_list','delete','F',null,null,'A');
uis.action('/vhr/hrm/job_list','edit','F','/vhr/hrm/job+edit','S','O');
uis.action('/vhr/hrm/job_list','import','F','/vhr/hrm/job_import','S','O');
uis.action('/vhr/hrm/job_list','view','F','/vhr/hrm/job_view','S','O');


uis.ready('/vhr/hrm/job_list','.add.audit.delete.edit.import.model.view.');

commit;
end;
/
