set define off
prompt PATH /vhr/rep/href/general_summary
begin
uis.route('/vhr/rep/href/general_summary:filials','Ui_Vhr600.Query_Filials',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/href/general_summary:model','Ui_Vhr600.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/href/general_summary:run','Ui_Vhr600.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/href/general_summary:save_preferences','Ui_Vhr600.Save_Preferences','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/href/general_summary:time_kinds','Ui_Vhr600.Query_Time_Kinds',null,'Q','A',null,null,null,null);

uis.path('/vhr/rep/href/general_summary','vhr600');
uis.form('/vhr/rep/href/general_summary','/vhr/rep/href/general_summary','H','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/href/general_summary','.model.');

commit;
end;
/
