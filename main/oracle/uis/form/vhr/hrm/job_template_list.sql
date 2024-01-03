set define off
prompt PATH /vhr/hrm/job_template_list
begin
uis.route('/vhr/hrm/job_template_list$delete','Ui_Vhr279.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hrm/job_template_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hrm/job_template_list:table','Ui_Vhr279.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrm/job_template_list','vhr279');
uis.form('/vhr/hrm/job_template_list','/vhr/hrm/job_template_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hrm/job_template_list','add','F','/vhr/hrm/job_template+add','S','O');
uis.action('/vhr/hrm/job_template_list','delete','F',null,null,'A');
uis.action('/vhr/hrm/job_template_list','edit','F','/vhr/hrm/job_template+edit','S','O');


uis.ready('/vhr/hrm/job_template_list','.add.delete.edit.model.');

commit;
end;
/
