set define off
prompt PATH /vhr/hrm/job_view
begin
uis.route('/vhr/hrm/job_view:model','Ui_Vhr661.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hrm/job_view:table_audit','Ui_Vhr661.Query_Job_Audits','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hrm/job_view','vhr661');
uis.form('/vhr/hrm/job_view','/vhr/hrm/job_view','F','A','F','H','M','N',null,'N',null);

uis.override_form('/anor/mhr/job_view','vhr','/vhr/hrm/job_view');


uis.action('/vhr/hrm/job_view','audit_details','F','/anor/mhr/job_audit_details','S','O');
uis.action('/vhr/hrm/job_view','edit','F','/vhr/hrm/job+edit','S','O');


uis.ready('/vhr/hrm/job_view','.audit_details.edit.model.');

commit;
end;
/
