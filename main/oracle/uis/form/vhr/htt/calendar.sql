set define off
prompt PATH /vhr/htt/calendar
begin
uis.route('/vhr/htt/calendar+add:calculate_monthly_details','Ui_Vhr166.Calculate_Monthly_Details','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/calendar+add:model','Ui_Vhr166.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/htt/calendar+add:save','Ui_Vhr166.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/calendar+edit:calculate_monthly_details','Ui_Vhr166.Calculate_Monthly_Details','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/calendar+edit:load_dates','Ui_Vhr166.Load_Dates','M','L','A',null,null,null,null,null);
uis.route('/vhr/htt/calendar+edit:model','Ui_Vhr166.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/calendar+edit:save','Ui_Vhr166.Edit','M','M','A',null,null,null,null,null);

uis.path('/vhr/htt/calendar','vhr166');
uis.form('/vhr/htt/calendar+add','/vhr/htt/calendar','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/htt/calendar+edit','/vhr/htt/calendar','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/htt/calendar+add','edit','F','/vhr/htt/calendar+edit','R','O');


uis.ready('/vhr/htt/calendar+add','.edit.model.');
uis.ready('/vhr/htt/calendar+edit','.model.');

commit;
end;
/
