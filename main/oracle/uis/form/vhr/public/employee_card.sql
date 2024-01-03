set define off
prompt PATH /vhr/public/employee_card
begin
uis.route('/vhr/public/employee_card$employee_details','Ui_Vhr452.Employee_Details','M','M','P',null,null,null,null);
uis.route('/vhr/public/employee_card:model','Ui.No_Model',null,null,'P','Y',null,null,null);

uis.path('/vhr/public/employee_card','vhr452');
uis.form('/vhr/public/employee_card','/vhr/public/employee_card','A','P','F','H','M','N',null,'N');





uis.ready('/vhr/public/employee_card','.model.');

commit;
end;
/
