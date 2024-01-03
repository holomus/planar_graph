set define off
prompt PATH /vhr/rep/hpr/staffing
begin
uis.route('/vhr/rep/hpr/staffing:jobs','Ui_Vhr599.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hpr/staffing:model','Ui_Vhr599.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hpr/staffing:run','Ui_Vhr599.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpr/staffing','vhr599');
uis.form('/vhr/rep/hpr/staffing','/vhr/rep/hpr/staffing','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/rep/hpr/staffing','.model.');

commit;
end;
/
