set define off
prompt PATH /vhr/htt/tracking
begin
uis.route('/vhr/htt/tracking:calculate_all','Ui_Vhr245.Calculate_All',null,null,'A',null,null,null,null);
uis.route('/vhr/htt/tracking:employees','Ui_Vhr245.Query_Employees','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/tracking:load','Ui_Vhr245.Load','M','JO','A',null,null,null,null);
uis.route('/vhr/htt/tracking:location_types','Ui_Vhr245.Query_Location_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/tracking:model','Ui_Vhr245.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/tracking:run','Ui_Vhr245.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/htt/tracking','vhr245');
uis.form('/vhr/htt/tracking','/vhr/htt/tracking','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/htt/tracking','select_employee','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/htt/tracking','.model.select_employee.');

commit;
end;
/
