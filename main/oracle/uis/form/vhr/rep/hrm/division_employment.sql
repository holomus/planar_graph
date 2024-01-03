set define off
prompt PATH /vhr/rep/hrm/division_employment
begin
uis.route('/vhr/rep/hrm/division_employment:division_groups','Ui_Vhr579.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hrm/division_employment:divisions','Ui_Vhr579.Query_Divisions',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hrm/division_employment:model','Ui_Vhr579.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hrm/division_employment:run','Ui_Vhr579.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hrm/division_employment','vhr579');
uis.form('/vhr/rep/hrm/division_employment','/vhr/rep/hrm/division_employment','F','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/hrm/division_employment','.model.');

commit;
end;
/
