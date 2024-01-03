set define off
prompt PATH /vhr/hsc/job_norm_list
begin
uis.route('/vhr/hsc/job_norm_list$delete','Ui_Vhr552.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hsc/job_norm_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hsc/job_norm_list:table','Ui_Vhr552.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hsc/job_norm_list','vhr552');
uis.form('/vhr/hsc/job_norm_list','/vhr/hsc/job_norm_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hsc/job_norm_list','add','F','/vhr/hsc/job_norm+add','S','O');
uis.action('/vhr/hsc/job_norm_list','delete','F',null,null,'A');
uis.action('/vhr/hsc/job_norm_list','edit','F','/vhr/hsc/job_norm+edit','S','O');
uis.action('/vhr/hsc/job_norm_list','import','F','/vhr/hsc/job_norm_import','S','O');


uis.ready('/vhr/hsc/job_norm_list','.add.delete.edit.import.model.');

commit;
end;
/
