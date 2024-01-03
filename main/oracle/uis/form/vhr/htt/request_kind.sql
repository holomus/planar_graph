set define off
prompt PATH /vhr/htt/request_kind
begin
uis.route('/vhr/htt/request_kind+add:model','Ui_Vhr117.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/request_kind+add:save','Ui_Vhr117.Add','M','M','A',null,null,null,null);
uis.route('/vhr/htt/request_kind+add:time_kinds','Ui_Vhr117.Query_Time_Kinds',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/request_kind+edit:model','Ui_Vhr117.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/request_kind+edit:save','Ui_Vhr117.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/htt/request_kind+edit:time_kinds','Ui_Vhr117.Query_Time_Kinds',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/request_kind','vhr117');
uis.form('/vhr/htt/request_kind+add','/vhr/htt/request_kind','A','A','F','H','M','N',null,'N');
uis.form('/vhr/htt/request_kind+edit','/vhr/htt/request_kind','A','A','F','H','M','N',null,'N');






uis.ready('/vhr/htt/request_kind+add','.model.');
uis.ready('/vhr/htt/request_kind+edit','.model.');

commit;
end;
/
