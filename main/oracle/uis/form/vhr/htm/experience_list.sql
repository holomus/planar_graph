set define off
prompt PATH /vhr/htm/experience_list
begin
uis.route('/vhr/htm/experience_list$delete','Ui_Vhr527.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htm/experience_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htm/experience_list:table','Ui_Vhr527.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htm/experience_list','vhr527');
uis.form('/vhr/htm/experience_list','/vhr/htm/experience_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/htm/experience_list','add','F','/vhr/htm/experience+add','S','O');
uis.action('/vhr/htm/experience_list','delete','F',null,null,'A');
uis.action('/vhr/htm/experience_list','edit','F','/vhr/htm/experience+edit','S','O');
uis.action('/vhr/htm/experience_list','jobs','F','/vhr/htm/experience_jobs','S','O');


uis.ready('/vhr/htm/experience_list','.add.delete.edit.jobs.model.');

commit;
end;
/
