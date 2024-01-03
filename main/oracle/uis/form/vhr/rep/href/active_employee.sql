set define off
prompt PATH /vhr/rep/href/active_employee
begin
uis.route('/vhr/rep/href/active_employee:companies','Ui_Vhr485.Query_Company',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/href/active_employee:model','Ui_Vhr485.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/href/active_employee:run','Ui_Vhr485.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/href/active_employee','vhr485');
uis.form('/vhr/rep/href/active_employee','/vhr/rep/href/active_employee','A','A','R','H','M','Y',null,'N');





uis.ready('/vhr/rep/href/active_employee','.model.');

commit;
end;
/
