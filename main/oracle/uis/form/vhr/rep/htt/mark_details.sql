set define off
prompt PATH /vhr/rep/htt/mark_details
begin
uis.route('/vhr/rep/htt/mark_details:jobs','Ui_Vhr475.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/mark_details:locations','Ui_Vhr475.Query_Locations',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/mark_details:model','Ui_Vhr475.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/htt/mark_details:run','Ui_Vhr475.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/htt/mark_details:save_preferences','Ui_Vhr475.Save_Preferences','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/htt/mark_details:staffs','Ui_Vhr475.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/rep/htt/mark_details','vhr475');
uis.form('/vhr/rep/htt/mark_details','/vhr/rep/htt/mark_details','F','A','R','H','M','N',null,'N');



uis.action('/vhr/rep/htt/mark_details','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/rep/htt/mark_details','.model.select_staff.');

commit;
end;
/
