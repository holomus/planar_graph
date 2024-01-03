set define off
prompt PATH /vhr/href/employee/employee
begin
uis.route('/vhr/href/employee/employee$save_contacts','Ui_Vhr321.Save_Contacts','M',null,'A',null,null,null,null);
uis.route('/vhr/href/employee/employee$save_personal','Ui_Vhr321.Save_Personal','M',null,'A',null,null,null,null);
uis.route('/vhr/href/employee/employee:email_is_unique','Ui_Vhr321.Email_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/employee/employee:employee_','Ui_Vhr321.Query_Employee_Audit',null,null,'A',null,null,null,null);
uis.route('/vhr/href/employee/employee:load_xy_chart_stats','Ui_Vhr321.Load_Xy_Chart_Stats','M','M','A',null,null,null,null);
uis.route('/vhr/href/employee/employee:model','Ui_Vhr321.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/employee/employee:nationalities','Ui_Vhr321.Query_Nationalities',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/employee/employee:npin_validate','Ui_Vhr321.Npin_Is_Valid','M','V','A',null,null,null,null);
uis.route('/vhr/href/employee/employee:phone_is_unique','Ui_Vhr321.Phone_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/employee/employee:table_contact_audit','Ui_Vhr321.Query_Contact_Audit','M','Q','A',null,null,null,null);
uis.route('/vhr/href/employee/employee:table_personal_audit','Ui_Vhr321.Query_Personal_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/employee/employee','vhr321');
uis.form('/vhr/href/employee/employee','/vhr/href/employee/employee','F','A','F','H','M','N',null,'N');



uis.action('/vhr/href/employee/employee','add_nationality','F','/vhr/href/nationality+add','D','O');
uis.action('/vhr/href/employee/employee','contact_audit','F',null,null,'G');
uis.action('/vhr/href/employee/employee','personal_audit','F',null,null,'G');
uis.action('/vhr/href/employee/employee','save_contacts','F',null,null,'A');
uis.action('/vhr/href/employee/employee','save_personal','F',null,null,'A');
uis.action('/vhr/href/employee/employee','select_nationality','F','/vhr/href/nationality_list','D','O');


uis.ready('/vhr/href/employee/employee','.add_nationality.contact_audit.model.personal_audit.save_contacts.save_personal.select_nationality.');

commit;
end;
/
