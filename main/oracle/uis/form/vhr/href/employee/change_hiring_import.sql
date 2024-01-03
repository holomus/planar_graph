set define off
prompt PATH /vhr/href/employee/change_hiring_import
begin
uis.route('/vhr/href/employee/change_hiring_import:division','Ui_Vhr566.Query_Division',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/employee/change_hiring_import:import','Ui_Vhr566.Import_File','M','M','A',null,null,null,null);
uis.route('/vhr/href/employee/change_hiring_import:import_data','Ui_Vhr566.Import_Data','M',null,'A',null,null,null,null);
uis.route('/vhr/href/employee/change_hiring_import:job','Ui_Vhr566.Query_Job',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/employee/change_hiring_import:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/employee/change_hiring_import:schedule','Ui_Vhr566.Query_Schedule',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/employee/change_hiring_import:template','Ui_Vhr566.Template',null,null,'A',null,null,null,null);

uis.path('/vhr/href/employee/change_hiring_import','vhr566');
uis.form('/vhr/href/employee/change_hiring_import','/vhr/href/employee/change_hiring_import','F','A','F','H','M','Y',null,'N');





uis.ready('/vhr/href/employee/change_hiring_import','.model.');

commit;
end;
/
