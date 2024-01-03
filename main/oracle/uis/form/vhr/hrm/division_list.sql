set define off
prompt PATH /vhr/hrm/division_list
begin
uis.route('/vhr/hrm/division_list$delete','Ui_Vhr276.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/division_list:model','Ui_Vhr276.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hrm/division_list:table','Ui_Vhr276.Query','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hrm/division_list','vhr276');
uis.form('/vhr/hrm/division_list','/vhr/hrm/division_list','F','A','F','H','M','N',null,'N',null);

uis.override_form('/anor/mhr/division_list','vhr','/vhr/hrm/division_list');


uis.action('/vhr/hrm/division_list','add','F','/vhr/hrm/division+add','S','O');
uis.action('/vhr/hrm/division_list','audit','F','/core/md/audit_list','S','O');
uis.action('/vhr/hrm/division_list','child_division','F','/vhr/hrm/division_list','S','O');
uis.action('/vhr/hrm/division_list','delete','F',null,null,'A');
uis.action('/vhr/hrm/division_list','edit','F','/vhr/hrm/division+edit','S','O');
uis.action('/vhr/hrm/division_list','import','F','/vhr/hrm/division_import','S','O');
uis.action('/vhr/hrm/division_list','view','F','/vhr/hrm/division_view','S','O');
uis.action('/vhr/hrm/division_list','view_employee','F','/vhr/href/employee/employee_list','S','O');

uis.form_sibling('vhr','/vhr/hrm/division_list','/vhr/rep/href/organizational_structure',1);

uis.ready('/vhr/hrm/division_list','.add.audit.child_division.delete.edit.import.model.view.view_employee.');

commit;
end;
/
