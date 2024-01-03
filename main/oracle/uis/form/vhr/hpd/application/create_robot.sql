set define off
prompt PATH /vhr/hpd/application/create_robot
begin
uis.route('/vhr/hpd/application/create_robot+add:jobs','Ui_Vhr540.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot+add:model','Ui_Vhr540.Add_Modal',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/create_robot+add:save','Ui_Vhr540.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot+edit:jobs','Ui_Vhr540.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/create_robot+edit:model','Ui_Vhr540.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/create_robot+edit:save','Ui_Vhr540.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hpd/application/create_robot','vhr540');
uis.form('/vhr/hpd/application/create_robot+add','/vhr/hpd/application/create_robot','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/application/create_robot+edit','/vhr/hpd/application/create_robot','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hpd/application/create_robot+add','.model.');
uis.ready('/vhr/hpd/application/create_robot+edit','.model.');

commit;
end;
/
