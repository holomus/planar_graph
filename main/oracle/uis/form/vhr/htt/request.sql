set define off
prompt PATH /vhr/htt/request
begin
uis.route('/vhr/htt/request+add:load_request_limits','Ui_Vhr119.Load_Request_Limits','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/request+add:model','Ui_Vhr119.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/htt/request+add:request_kinds','Ui_Vhr119.Query_Request_Kinds','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/request+add:save','Ui_Vhr119.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/request+add:staffs','Ui_Vhr119.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/request+add_personal:load_request_limits','Ui_Vhr119.Load_Request_Limits','M','L','A',null,null,null,null,null);
uis.route('/vhr/htt/request+add_personal:model','Ui_Vhr119.Add_Model_Personal',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/htt/request+add_personal:request_kinds','Ui_Vhr119.Query_Request_Kinds','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/request+add_personal:save','Ui_Vhr119.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/request+edit:load_request_limits','Ui_Vhr119.Load_Request_Limits','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/request+edit:model','Ui_Vhr119.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/request+edit:request_kinds','Ui_Vhr119.Query_Request_Kinds','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/request+edit:save','Ui_Vhr119.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/request+edit_personal:load_request_limits','Ui_Vhr119.Load_Request_Limits','M','L','A',null,null,null,null,null);
uis.route('/vhr/htt/request+edit_personal:model','Ui_Vhr119.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/request+edit_personal:request_kinds','Ui_Vhr119.Query_Request_Kinds','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/request+edit_personal:save','Ui_Vhr119.Edit','M',null,'A',null,null,null,null,null);

uis.path('/vhr/htt/request','vhr119');
uis.form('/vhr/htt/request+add','/vhr/htt/request','F','A','F','HM','M','N',null,'N',null);
uis.form('/vhr/htt/request+add_personal','/vhr/htt/request','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/htt/request+edit','/vhr/htt/request','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/htt/request+edit_personal','/vhr/htt/request','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/htt/request+add','add_request_kind','F','/vhr/htt/request_kind+add','D','O');
uis.action('/vhr/htt/request+add','select_request_kind','F','/vhr/htt/request_kind_list','D','O');
uis.action('/vhr/htt/request+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/htt/request+add_personal','add_request_kind','F','/vhr/htt/request_kind+add','D','O');
uis.action('/vhr/htt/request+add_personal','select_request_kind','F','/vhr/htt/request_kind_list','D','O');
uis.action('/vhr/htt/request+edit','add_request_kind','F','/vhr/htt/request_kind+add','D','O');
uis.action('/vhr/htt/request+edit','select_request_kind','F','/vhr/htt/request_kind_list','D','O');
uis.action('/vhr/htt/request+edit_personal','add_request_kind','F','/vhr/htt/request_kind+add','D','O');
uis.action('/vhr/htt/request+edit_personal','select_request_kind','F','/vhr/htt/request_kind_list','D','O');


uis.ready('/vhr/htt/request+add','.add_request_kind.model.select_request_kind.select_staff.');
uis.ready('/vhr/htt/request+add_personal','.add_request_kind.model.select_request_kind.');
uis.ready('/vhr/htt/request+edit','.add_request_kind.model.select_request_kind.');
uis.ready('/vhr/htt/request+edit_personal','.add_request_kind.model.select_request_kind.');

commit;
end;
/
