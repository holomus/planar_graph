set define off
prompt PATH /vhr/hsc/job_round_list
begin
uis.route('/vhr/hsc/job_round_list$delete','Ui_Vhr644.Del','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hsc/job_round_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,'S');
uis.route('/vhr/hsc/job_round_list:table','Ui_Vhr644.Query',null,'Q','A',null,null,null,null,'S');

uis.path('/vhr/hsc/job_round_list','vhr644');
uis.form('/vhr/hsc/job_round_list','/vhr/hsc/job_round_list','F','A','F','H','M','N',null,'N','S');



uis.action('/vhr/hsc/job_round_list','add','F','/vhr/hsc/job_round+add','S','O');
uis.action('/vhr/hsc/job_round_list','delete','F',null,null,'A');
uis.action('/vhr/hsc/job_round_list','edit','F','/vhr/hsc/job_round+edit','S','O');
uis.action('/vhr/hsc/job_round_list','import','F','/vhr/hsc/job_round_import','S','O');


uis.ready('/vhr/hsc/job_round_list','.add.delete.edit.import.model.');

commit;
end;
/
