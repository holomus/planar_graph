set define off
prompt PATH /vhr/htt/staff_subordinate
begin
uis.route('/vhr/htt/staff_subordinate:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/staff_subordinate:table','Ui_Vhr296.Query_Subordinates','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/staff_subordinate','vhr296');
uis.form('/vhr/htt/staff_subordinate','/vhr/htt/staff_subordinate','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/htt/staff_subordinate','.model.');

commit;
end;
/
