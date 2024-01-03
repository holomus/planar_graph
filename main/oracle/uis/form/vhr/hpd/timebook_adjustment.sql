set define off
prompt PATH /vhr/hpd/timebook_adjustment
begin
uis.route('/vhr/hpd/timebook_adjustment+add:load_data','Ui_Vhr497.Load_Data','JO','JA','A',null,null,null,null);
uis.route('/vhr/hpd/timebook_adjustment+add:model','Ui_Vhr497.Add_Model','JO','JO','A','Y',null,null,null);
uis.route('/vhr/hpd/timebook_adjustment+add:save','Ui_Vhr497.Add','JO','JO','A',null,null,null,null);
uis.route('/vhr/hpd/timebook_adjustment+add:staffs','Ui_Vhr497.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/timebook_adjustment+edit:load_data','Ui_Vhr497.Load_Data','JO','JA','A',null,null,null,null);
uis.route('/vhr/hpd/timebook_adjustment+edit:model','Ui_Vhr497.Edit_Model','JO','JO','A','Y',null,null,null);
uis.route('/vhr/hpd/timebook_adjustment+edit:save','Ui_Vhr497.Edit','JO','JO','A',null,null,null,null);
uis.route('/vhr/hpd/timebook_adjustment+edit:staffs','Ui_Vhr497.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/timebook_adjustment','vhr497');
uis.form('/vhr/hpd/timebook_adjustment+add','/vhr/hpd/timebook_adjustment','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpd/timebook_adjustment+edit','/vhr/hpd/timebook_adjustment','F','A','F','H','M','N',null,null);



uis.action('/vhr/hpd/timebook_adjustment+add','adjustment_full','F',null,null,'G');
uis.action('/vhr/hpd/timebook_adjustment+add','adjustment_incomplete','F',null,null,'G');
uis.action('/vhr/hpd/timebook_adjustment+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/timebook_adjustment+edit','adjustment_full','F',null,null,'G');
uis.action('/vhr/hpd/timebook_adjustment+edit','adjustment_incomplete','F',null,null,'G');
uis.action('/vhr/hpd/timebook_adjustment+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/timebook_adjustment+add','.adjustment_full.adjustment_incomplete.model.select_staff.');
uis.ready('/vhr/hpd/timebook_adjustment+edit','.adjustment_full.adjustment_incomplete.model.select_staff.');

commit;
end;
/
