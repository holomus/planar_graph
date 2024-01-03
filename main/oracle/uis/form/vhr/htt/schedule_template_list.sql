set define off
prompt PATH /vhr/htt/schedule_template_list
begin
uis.route('/vhr/htt/schedule_template_list$delete','Ui_Vhr354.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/schedule_template_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/schedule_template_list:table','Ui_Vhr354.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/schedule_template_list','vhr354');
uis.form('/vhr/htt/schedule_template_list','/vhr/htt/schedule_template_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/schedule_template_list','add','A','/vhr/htt/schedule_template+add','S','O');
uis.action('/vhr/htt/schedule_template_list','delete','A',null,null,'A');
uis.action('/vhr/htt/schedule_template_list','edit','A','/vhr/htt/schedule_template+edit','S','O');


uis.ready('/vhr/htt/schedule_template_list','.add.delete.edit.model.');

commit;
end;
/
