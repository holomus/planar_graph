set define off
prompt PATH /vhr/hpr/nighttime_policy
begin
uis.route('/vhr/hpr/nighttime_policy+add:model','Ui_Vhr648.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hpr/nighttime_policy+add:save','Ui_Vhr648.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/nighttime_policy+edit:model','Ui_Vhr648.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpr/nighttime_policy+edit:save','Ui_Vhr648.Edit','M',null,'A',null,null,null,null,null);

uis.path('/vhr/hpr/nighttime_policy','vhr648');
uis.form('/vhr/hpr/nighttime_policy','/vhr/hpr/nighttime_policy','F','A','F','H','M','N',null,'N','S');
uis.form('/vhr/hpr/nighttime_policy+add','/vhr/hpr/nighttime_policy','A','A','F','H','M','N',null,null,null);
uis.form('/vhr/hpr/nighttime_policy+edit','/vhr/hpr/nighttime_policy','A','A','F','H','M','N',null,null,null);





uis.ready('/vhr/hpr/nighttime_policy+add','.model.');
uis.ready('/vhr/hpr/nighttime_policy','.model.');
uis.ready('/vhr/hpr/nighttime_policy+edit','.model.');

commit;
end;
/
