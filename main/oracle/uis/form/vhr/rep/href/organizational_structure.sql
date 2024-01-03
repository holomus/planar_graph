set define off
prompt PATH /vhr/rep/href/organizational_structure
begin
uis.route('/vhr/rep/href/organizational_structure:load_children','Ui_Vhr299.Division_Children','M','M','A',null,null,null,null);
uis.route('/vhr/rep/href/organizational_structure:model','Ui_Vhr299.Model',null,'M','A','Y',null,null,null);

uis.path('/vhr/rep/href/organizational_structure','vhr299');
uis.form('/vhr/rep/href/organizational_structure','/vhr/rep/href/organizational_structure','A','A','F','H','M','N',null,'N');



uis.action('/vhr/rep/href/organizational_structure','view_all','F','/vhr/href/employee/employee_list','S','O');

uis.form_sibling('vhr','/vhr/rep/href/organizational_structure','/vhr/hrm/division_list',1);

uis.ready('/vhr/rep/href/organizational_structure','.model.view_all.');

commit;
end;
/
