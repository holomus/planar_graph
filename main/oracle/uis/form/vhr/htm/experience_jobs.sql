set define off
prompt PATH /vhr/htm/experience_jobs
begin
uis.route('/vhr/htm/experience_jobs$attach','Ui_Vhr529.Attach','M',null,'A',null,null,null,null);
uis.route('/vhr/htm/experience_jobs$detach','Ui_Vhr529.Detach','M',null,'A',null,null,null,null);
uis.route('/vhr/htm/experience_jobs:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htm/experience_jobs:table','Ui_Vhr529.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/htm/experience_jobs','vhr529');
uis.form('/vhr/htm/experience_jobs','/vhr/htm/experience_jobs','F','A','F','H','M','N',null,'N');



uis.action('/vhr/htm/experience_jobs','attach','F',null,null,'A');
uis.action('/vhr/htm/experience_jobs','detach','F',null,null,'A');


uis.ready('/vhr/htm/experience_jobs','.attach.detach.model.');

commit;
end;
/
