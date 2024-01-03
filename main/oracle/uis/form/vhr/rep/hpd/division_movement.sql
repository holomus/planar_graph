set define off
prompt PATH /vhr/rep/hpd/division_movement
begin
uis.route('/vhr/rep/hpd/division_movement:division_group','Ui_Vhr577.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hpd/division_movement:jobs','Ui_Vhr577.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/rep/hpd/division_movement:model','Ui_Vhr577.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hpd/division_movement:run','Ui_Vhr577.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/division_movement','vhr577');
uis.form('/vhr/rep/hpd/division_movement','/vhr/rep/hpd/division_movement','F','A','R','H','M','N',null,'N');



uis.action('/vhr/rep/hpd/division_movement','select_division_group','F','/anor/mhr/division_group_list','D','O');
uis.action('/vhr/rep/hpd/division_movement','select_job','F','/anor/mhr/job_list','D','O');


uis.ready('/vhr/rep/hpd/division_movement','.model.select_division_group.select_job.');

commit;
end;
/
