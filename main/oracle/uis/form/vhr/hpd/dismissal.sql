set define off
prompt PATH /vhr/hpd/dismissal
begin
uis.route('//vhr/hpd/dismissal+add:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/dismissal+add:dismissal_reasons','Ui_Vhr52.Query_Dismissal_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+add:employment_sources','Ui_Vhr52.Query_Employment_Sources',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+add:get_influences','Ui_Vhr52.Get_Influences','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+add:model','Ui_Vhr52.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/dismissal+add:process_cos_response','Ui_Vhr52.Process_Cos_Response','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+add:save','Ui_Vhr52.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+add:staffs','Ui_Vhr52.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+edit:dismissal_reasons','Ui_Vhr52.Query_Dismissal_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+edit:employment_sources','Ui_Vhr52.Query_Employment_Sources',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+edit:get_influences','Ui_Vhr52.Get_Influences','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+edit:model','Ui_Vhr52.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/dismissal+edit:process_cos_response','Ui_Vhr52.Process_Cos_Response','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+edit:save','Ui_Vhr52.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+edit:staffs','Ui_Vhr52.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_add:dismissal_reasons','Ui_Vhr52.Query_Dismissal_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_add:employment_sources','Ui_Vhr52.Query_Employment_Sources',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_add:get_influences','Ui_Vhr52.Get_Influences','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_add:model','Ui_Vhr52.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_add:process_cos_response','Ui_Vhr52.Process_Cos_Response','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_add:save','Ui_Vhr52.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_add:staffs','Ui_Vhr52.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_edit:dismissal_reasons','Ui_Vhr52.Query_Dismissal_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_edit:employment_sources','Ui_Vhr52.Query_Employment_Sources',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_edit:get_influences','Ui_Vhr52.Get_Influences','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_edit:model','Ui_Vhr52.Edit_Multiple_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_edit:process_cos_response','Ui_Vhr52.Process_Cos_Response','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_edit:save','Ui_Vhr52.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/dismissal+multiple_edit:staffs','Ui_Vhr52.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/dismissal','vhr52');
uis.form('/vhr/hpd/dismissal+add','/vhr/hpd/dismissal','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/dismissal+edit','/vhr/hpd/dismissal','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/dismissal+multiple_add','/vhr/hpd/dismissal','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/dismissal+multiple_edit','/vhr/hpd/dismissal','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/dismissal+add','add_dismissal_reason','F','/vhr/href/dismissal_reason+add','D','O');
uis.action('/vhr/hpd/dismissal+add','add_employment_source','F','/vhr/href/employment_source+add','D','O');
uis.action('/vhr/hpd/dismissal+add','select_dismissal_reason','F','/vhr/href/dismissal_reason_list','D','O');
uis.action('/vhr/hpd/dismissal+add','select_employment_source','F','/vhr/href/employment_source_list','D','O');
uis.action('/vhr/hpd/dismissal+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/dismissal+edit','add_dismissal_reason','F','/vhr/href/dismissal_reason+add','D','O');
uis.action('/vhr/hpd/dismissal+edit','add_employment_source','F','/vhr/href/employment_source+add','D','O');
uis.action('/vhr/hpd/dismissal+edit','select_dismissal_reason','F','/vhr/href/dismissal_reason_list','D','O');
uis.action('/vhr/hpd/dismissal+edit','select_employment_source','F','/vhr/href/employment_source_list','D','O');
uis.action('/vhr/hpd/dismissal+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/dismissal+multiple_add','add_dismissal_reason','F','/vhr/href/dismissal_reason+add','D','O');
uis.action('/vhr/hpd/dismissal+multiple_add','add_employment_source','F','/vhr/href/employment_source+add','D','O');
uis.action('/vhr/hpd/dismissal+multiple_add','select_dismissal_reason','F','/vhr/href/dismissal_reason_list','D','O');
uis.action('/vhr/hpd/dismissal+multiple_add','select_employment_source','F','/vhr/href/employment_source_list','D','O');
uis.action('/vhr/hpd/dismissal+multiple_add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/dismissal+multiple_edit','add_dismissal_reason','F','/vhr/href/dismissal_reason+add','D','O');
uis.action('/vhr/hpd/dismissal+multiple_edit','add_employment_source','F','/vhr/href/employment_source+add','D','O');
uis.action('/vhr/hpd/dismissal+multiple_edit','select_dismissal_reason','F','/vhr/href/dismissal_reason_list','D','O');
uis.action('/vhr/hpd/dismissal+multiple_edit','select_employment_source','F','/vhr/href/employment_source_list','D','O');
uis.action('/vhr/hpd/dismissal+multiple_edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/dismissal+add','.add_dismissal_reason.add_employment_source.model.select_dismissal_reason.select_employment_source.select_staff.');
uis.ready('/vhr/hpd/dismissal+edit','.add_dismissal_reason.add_employment_source.model.select_dismissal_reason.select_employment_source.select_staff.');
uis.ready('/vhr/hpd/dismissal+multiple_add','.add_dismissal_reason.add_employment_source.model.select_dismissal_reason.select_employment_source.select_staff.');
uis.ready('/vhr/hpd/dismissal+multiple_edit','.add_dismissal_reason.add_employment_source.model.select_dismissal_reason.select_employment_source.select_staff.');

commit;
end;
/
