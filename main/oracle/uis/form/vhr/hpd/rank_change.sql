set define off
prompt PATH /vhr/hpd/rank_change
begin
uis.route('/vhr/hpd/rank_change+add:get_new_wage','Ui_Vhr263.Get_New_Wage','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+add:get_staff_info','Ui_Vhr263.Get_Staff_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+add:model','Ui_Vhr263.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/rank_change+add:ranks','Ui_Vhr263.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+add:save','Ui_Vhr263.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+add:staffs','Ui_Vhr263.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+edit:get_new_wage','Ui_Vhr263.Get_New_Wage','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+edit:get_staff_info','Ui_Vhr263.Get_Staff_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+edit:model','Ui_Vhr263.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/rank_change+edit:ranks','Ui_Vhr263.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+edit:save','Ui_Vhr263.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+edit:staffs','Ui_Vhr263.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_add:get_staff_info','Ui_Vhr263.Get_Staff_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_add:get_staff_infos','Ui_Vhr263.Get_Staff_Infos','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_add:model','Ui_Vhr263.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_add:ranks','Ui_Vhr263.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_add:save','Ui_Vhr263.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_add:staffs','Ui_Vhr263.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_edit:get_staff_info','Ui_Vhr263.Get_Staff_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_edit:get_staff_infos','Ui_Vhr263.Get_Staff_Infos','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_edit:model','Ui_Vhr263.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_edit:ranks','Ui_Vhr263.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_edit:save','Ui_Vhr263.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/rank_change+multiple_edit:staffs','Ui_Vhr263.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/rank_change','vhr263');
uis.form('/vhr/hpd/rank_change+add','/vhr/hpd/rank_change','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/rank_change+edit','/vhr/hpd/rank_change','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/rank_change+multiple_add','/vhr/hpd/rank_change','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpd/rank_change+multiple_edit','/vhr/hpd/rank_change','F','A','F','H','M','N',null,null);



uis.action('/vhr/hpd/rank_change+add','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hpd/rank_change+add','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hpd/rank_change+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/rank_change+edit','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hpd/rank_change+edit','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hpd/rank_change+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/rank_change+multiple_add','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hpd/rank_change+multiple_add','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hpd/rank_change+multiple_add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/rank_change+multiple_edit','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hpd/rank_change+multiple_edit','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hpd/rank_change+multiple_edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/rank_change+multiple_edit','.add_rank.model.select_rank.select_staff.');
uis.ready('/vhr/hpd/rank_change+multiple_add','.add_rank.model.select_rank.select_staff.');
uis.ready('/vhr/hpd/rank_change+add','.add_rank.model.select_rank.select_staff.');
uis.ready('/vhr/hpd/rank_change+edit','.add_rank.model.select_rank.select_staff.');

commit;
end;
/
