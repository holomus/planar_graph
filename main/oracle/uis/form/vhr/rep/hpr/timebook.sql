set define off
prompt PATH /vhr/rep/hpr/timebook
begin
uis.route('/vhr/rep/hpr/timebook:definitions','Ui_Vhr164.Definitions',null,'L','A',null,null,null,null);
uis.route('/vhr/rep/hpr/timebook:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/hpr/timebook:run','Ui_Vhr164.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpr/timebook','vhr164');
uis.form('/vhr/rep/hpr/timebook','/vhr/rep/hpr/timebook','F','A','D','Z','M','N',null,'Y');






uis.ready('/vhr/rep/hpr/timebook','.model.');

commit;
end;
/
