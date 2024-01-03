set define off
prompt PATH /vhr/href/candidate/candidate_list
begin
uis.route('/vhr/href/candidate/candidate_list$create_employee','Ui_Vhr305.Create_Employee','JO',null,'A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate_list$delete','Ui_Vhr305.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/candidate/candidate_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/candidate/candidate_list:table','Ui_Vhr305.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/candidate/candidate_list','vhr305');
uis.form('/vhr/href/candidate/candidate_list','/vhr/href/candidate/candidate_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/href/candidate/candidate_list','add','F','/vhr/href/candidate/candidate+add','S','O');
uis.action('/vhr/href/candidate/candidate_list','create_employee','F',null,null,'A');
uis.action('/vhr/href/candidate/candidate_list','delete','F',null,null,'A');
uis.action('/vhr/href/candidate/candidate_list','edit','F','/vhr/href/candidate/candidate+edit','S','O');
uis.action('/vhr/href/candidate/candidate_list','view_employee','F','/vhr/href/employee/employee_edit','S','O');

uis.form_sibling('vhr','/vhr/href/candidate/candidate_list','/vhr/href/candidate/candidate_form_settings',1);

uis.ready('/vhr/href/candidate/candidate_list','.add.create_employee.delete.edit.model.view_employee.');

commit;
end;
/
