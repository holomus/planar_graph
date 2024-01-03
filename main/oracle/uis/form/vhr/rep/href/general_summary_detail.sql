set define off
prompt PATH /vhr/rep/href/general_summary_detail
begin
uis.route('/vhr/rep/href/general_summary_detail:model','Ui_Vhr601.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/href/general_summary_detail:run','Ui_Vhr601.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/href/general_summary_detail:save_preferences','Ui_Vhr601.Save_Preferences','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/href/general_summary_detail:time_kinds','Ui_Vhr601.Query_Time_Kinds',null,'Q','A',null,null,null,null);

uis.path('/vhr/rep/href/general_summary_detail','vhr601');
uis.form('/vhr/rep/href/general_summary_detail','/vhr/rep/href/general_summary_detail','A','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/href/general_summary_detail','.model.');

commit;
end;
/
