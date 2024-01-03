set define off
prompt PATH /vhr/rep/hrm/robot_structure
begin
uis.route('/vhr/rep/hrm/robot_structure:model','Ui_Vhr602.Model',null,'M','A','Y',null,null,null);

uis.path('/vhr/rep/hrm/robot_structure','vhr602');
uis.form('/vhr/rep/hrm/robot_structure','/vhr/rep/hrm/robot_structure','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/rep/hrm/robot_structure','.model.');

commit;
end;
/
