set define off
prompt PATH /vhr/hrec/stage
begin
uis.route('/vhr/hrec/stage:model','Ui_Vhr567.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrec/stage:save','Ui_Vhr567.Save','M',null,'A',null,null,null,null);

uis.path('/vhr/hrec/stage','vhr567');
uis.form('/vhr/hrec/stage','/vhr/hrec/stage','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/hrec/stage','.model.');

commit;
end;
/
