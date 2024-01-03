set define off
prompt PATH /vhr/hpd/business_trip
begin
uis.route('/vhr/hpd/business_trip+add:calc_trip_days','Ui_Vhr180.Calc_Trip_Days','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+add:legal_persons','Ui_Vhr180.Query_Legal_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+add:model','Ui_Vhr180.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/business_trip+add:reasons','Ui_Vhr180.Query_Business_Trip_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+add:save','Ui_Vhr180.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+add:staffs','Ui_Vhr180.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+edit:calc_trip_days','Ui_Vhr180.Calc_Trip_Days','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+edit:legal_persons','Ui_Vhr180.Query_Legal_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+edit:model','Ui_Vhr180.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/business_trip+edit:reasons','Ui_Vhr180.Query_Business_Trip_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+edit:save','Ui_Vhr180.Edit','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+edit:staffs','Ui_Vhr180.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_add:calc_trip_days','Ui_Vhr180.Calc_Trip_Days','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_add:legal_persons','Ui_Vhr180.Query_Legal_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_add:model','Ui_Vhr180.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_add:reasons','Ui_Vhr180.Query_Business_Trip_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_add:save','Ui_Vhr180.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_add:staffs','Ui_Vhr180.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_edit:calc_trip_days','Ui_Vhr180.Calc_Trip_Days','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_edit:legal_persons','Ui_Vhr180.Query_Legal_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_edit:model','Ui_Vhr180.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_edit:reasons','Ui_Vhr180.Query_Business_Trip_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_edit:save','Ui_Vhr180.Edit','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/business_trip+multiple_edit:staffs','Ui_Vhr180.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/business_trip','vhr180');
uis.form('/vhr/hpd/business_trip+add','/vhr/hpd/business_trip','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/business_trip+edit','/vhr/hpd/business_trip','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/business_trip+multiple_add','/vhr/hpd/business_trip','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpd/business_trip+multiple_edit','/vhr/hpd/business_trip','F','A','F','H','M','N',null,null);



uis.action('/vhr/hpd/business_trip+add','add_legal_person','F','/anor/mr/person/legal_person+add','D','O');
uis.action('/vhr/hpd/business_trip+add','add_reason','F','/vhr/href/business_trip_reason+add','D','O');
uis.action('/vhr/hpd/business_trip+add','select_legal_person','F','/anor/mr/person/legal_person_list','D','O');
uis.action('/vhr/hpd/business_trip+add','select_reason','F','/vhr/href/business_trip_reason_list','D','O');
uis.action('/vhr/hpd/business_trip+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/business_trip+edit','add_legal_person','F','/anor/mr/person/legal_person+add','D','O');
uis.action('/vhr/hpd/business_trip+edit','add_reason','F','/vhr/href/business_trip_reason+add','D','O');
uis.action('/vhr/hpd/business_trip+edit','select_legal_person','F','/anor/mr/person/legal_person_list','D','O');
uis.action('/vhr/hpd/business_trip+edit','select_reason','F','/vhr/href/business_trip_reason_list','D','O');
uis.action('/vhr/hpd/business_trip+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/business_trip+multiple_add','add_legal_person','F','/anor/mr/person/legal_person+add','D','O');
uis.action('/vhr/hpd/business_trip+multiple_add','add_reason','F','/vhr/href/business_trip_reason+add','D','O');
uis.action('/vhr/hpd/business_trip+multiple_add','select_legal_person','F','/anor/mr/person/legal_person_list','D','O');
uis.action('/vhr/hpd/business_trip+multiple_add','select_reason','F','/vhr/href/business_trip_reason_list','D','O');
uis.action('/vhr/hpd/business_trip+multiple_add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/business_trip+multiple_edit','add_legal_person','F','/anor/mr/person/legal_person+add','D','O');
uis.action('/vhr/hpd/business_trip+multiple_edit','add_reason','F','/vhr/href/business_trip_reason+add','D','O');
uis.action('/vhr/hpd/business_trip+multiple_edit','select_legal_person','F','/anor/mr/person/legal_person_list','D','O');
uis.action('/vhr/hpd/business_trip+multiple_edit','select_reason','F','/vhr/href/business_trip_reason_list','D','O');
uis.action('/vhr/hpd/business_trip+multiple_edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/business_trip+multiple_add','.add_legal_person.add_reason.model.select_legal_person.select_reason.select_staff.');
uis.ready('/vhr/hpd/business_trip+multiple_edit','.add_legal_person.add_reason.model.select_legal_person.select_reason.select_staff.');
uis.ready('/vhr/hpd/business_trip+add','.add_legal_person.add_reason.model.select_legal_person.select_reason.select_staff.');
uis.ready('/vhr/hpd/business_trip+edit','.add_legal_person.add_reason.model.select_legal_person.select_reason.select_staff.');

commit;
end;
/
