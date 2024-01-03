set define off
prompt PATH /vhr/hpd/application/dismissal
begin
uis.route('/vhr/hpd/application/dismissal+add:dismissal_reasons','Ui_Vhr543.Query_Dismissal_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal+add:get_staff_info','Ui_Vhr543.Get_Staff_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal+add:model','Ui_Vhr543.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/dismissal+add:save','Ui_Vhr543.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal+add:staffs','Ui_Vhr543.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal+edit:dismissal_reasons','Ui_Vhr543.Query_Dismissal_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal+edit:model','Ui_Vhr543.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/dismissal+edit:save','Ui_Vhr543.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal+edit:staffs','Ui_Vhr543.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/application/dismissal','vhr543');
uis.form('/vhr/hpd/application/dismissal+add','/vhr/hpd/application/dismissal','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/application/dismissal+edit','/vhr/hpd/application/dismissal','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/application/dismissal+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/application/dismissal+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/application/dismissal+add','.model.select_staff.');
uis.ready('/vhr/hpd/application/dismissal+edit','.model.select_staff.');

commit;
end;
/
