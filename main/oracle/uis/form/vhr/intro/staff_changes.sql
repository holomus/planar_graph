set define off
prompt PATH /vhr/intro/staff_changes
begin
uis.route('/vhr/intro/staff_changes:filials','Ui_Vhr138.Query_Filials',null,'Q','A',null,null,null,null);
uis.route('/vhr/intro/staff_changes:job_groups','Ui_Vhr138.Query_Job_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/intro/staff_changes:model','Ui_Vhr138.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/intro/staff_changes:reload_filter','Ui_Vhr138.Reload_Filter','M','M','A',null,null,null,null);

uis.path('/vhr/intro/staff_changes','vhr138');
uis.form('/vhr/intro/staff_changes','/vhr/intro/staff_changes','A','A','F','HM','M','N',null,'N');





uis.ready('/vhr/intro/staff_changes','.model.');

commit;
end;
/
