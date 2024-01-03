set define off
prompt PATH /vhr/rep/hrm/robot
begin
uis.route('/vhr/rep/hrm/robot:model','Ui_Vhr260.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hrm/robot:run','Ui_Vhr260.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hrm/robot','vhr260');
uis.form('/vhr/rep/hrm/robot','/vhr/rep/hrm/robot','F','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/hrm/robot','.model.');

commit;
end;
/
