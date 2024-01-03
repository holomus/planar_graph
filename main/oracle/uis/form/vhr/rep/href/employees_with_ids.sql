set define off
prompt PATH /vhr/rep/href/employees_with_ids
begin
uis.route('/vhr/rep/href/employees_with_ids:filials','Ui_Vhr603.Query_Filial',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/rep/href/employees_with_ids:model','Ui_Vhr603.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/rep/href/employees_with_ids:run','Ui_Vhr603.Run','M',null,'A',null,null,null,null,null);
uis.route('/vhr/rep/href/employees_with_ids:save_preferences','Ui_Vhr603.Save_Preferences','M',null,'A',null,null,null,null,null);

uis.path('/vhr/rep/href/employees_with_ids','vhr603');
uis.form('/vhr/rep/href/employees_with_ids','/vhr/rep/href/employees_with_ids','H','A','R','H','M','N',null,'N',null);





uis.ready('/vhr/rep/href/employees_with_ids','.model.');

commit;
end;
/
