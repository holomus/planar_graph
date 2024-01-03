set define off
prompt PATH /vhr/htt/time_kind
begin
uis.route('/vhr/htt/time_kind+add:model','Ui_Vhr73.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/time_kind+add:save','Ui_Vhr73.Add','M','M','A',null,null,null,null);
uis.route('/vhr/htt/time_kind+add:time_kinds','Ui_Vhr73.Query_Time_Kinds',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/time_kind+edit:model','Ui_Vhr73.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/time_kind+edit:save','Ui_Vhr73.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/htt/time_kind','vhr73');
uis.form('/vhr/htt/time_kind+add','/vhr/htt/time_kind','A','A','F','H','M','N',null,'N');
uis.form('/vhr/htt/time_kind+edit','/vhr/htt/time_kind','A','A','F','H','M','N',null,'N');






uis.ready('/vhr/htt/time_kind+add','.model.');
uis.ready('/vhr/htt/time_kind+edit','.model.');

commit;
end;
/
