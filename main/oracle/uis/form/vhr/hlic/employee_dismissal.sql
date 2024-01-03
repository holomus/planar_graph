set define off
prompt PATH /vhr/hlic/employee_dismissal
begin
uis.route('/vhr/hlic/employee_dismissal$delete_dismissal','Ui_Vhr350.Delete_Dismissal','M',null,'A',null,null,null,null);
uis.route('/vhr/hlic/employee_dismissal$save_dismissal','Ui_Vhr350.Save_Dismissal','M',null,'A',null,null,null,null);
uis.route('/vhr/hlic/employee_dismissal:get_dismissal_data','Ui_Vhr350.Get_Dismissal_Data','M','M','A',null,null,null,null);
uis.route('/vhr/hlic/employee_dismissal:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hlic/employee_dismissal:reasons','Ui_Vhr350.Query_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hlic/employee_dismissal:table','Ui_Vhr350.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hlic/employee_dismissal','vhr350');
uis.form('/vhr/hlic/employee_dismissal','/vhr/hlic/employee_dismissal','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hlic/employee_dismissal','delete_dismissal','A',null,null,'A');
uis.action('/vhr/hlic/employee_dismissal','save_dismissal','A',null,null,'A');


uis.ready('/vhr/hlic/employee_dismissal','.delete_dismissal.model.save_dismissal.');

commit;
end;
/
