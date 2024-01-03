set define off
prompt PATH /vhr/rep/hrm/robot_plan
begin
uis.route('/vhr/rep/hrm/robot_plan:jobs','Ui_Vhr582.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hrm/robot_plan:model','Ui_Vhr582.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hrm/robot_plan:run','Ui_Vhr582.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hrm/robot_plan','vhr582');
uis.form('/vhr/rep/hrm/robot_plan','/vhr/rep/hrm/robot_plan','F','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/hrm/robot_plan','.model.');

commit;
end;
/
