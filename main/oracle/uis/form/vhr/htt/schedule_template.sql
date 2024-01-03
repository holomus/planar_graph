set define off
prompt PATH /vhr/htt/schedule_template
begin
uis.route('/vhr/htt/schedule_template+add:model','Ui_Vhr352.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/schedule_template+add:save','Ui_Vhr352.Add','M','M','A',null,null,null,null);
uis.route('/vhr/htt/schedule_template+edit:model','Ui_Vhr352.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/schedule_template+edit:save','Ui_Vhr352.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/htt/schedule_template:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/htt/schedule_template','vhr352');
uis.form('/vhr/htt/schedule_template+add','/vhr/htt/schedule_template','A','A','F','H','M','N',null,'N');
uis.form('/vhr/htt/schedule_template+edit','/vhr/htt/schedule_template','A','A','F','H','M','N',null,null);





uis.ready('/vhr/htt/schedule_template+add','.model.');
uis.ready('/vhr/htt/schedule_template+edit','.model.');

commit;
end;
/
