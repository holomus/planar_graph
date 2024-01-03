set define off
prompt PATH /vhr/rep/hpd/rank_changes
begin
uis.route('/vhr/rep/hpd/rank_changes:model','Ui_Vhr557.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hpd/rank_changes:run','Ui_Vhr557.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/hpd/rank_changes:staffs','Ui_Vhr557.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/rep/hpd/rank_changes','vhr557');
uis.form('/vhr/rep/hpd/rank_changes','/vhr/rep/hpd/rank_changes','F','A','R','H','M','N',null,'N');



uis.action('/vhr/rep/hpd/rank_changes','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/rep/hpd/rank_changes','.model.select_staff.');

commit;
end;
/
