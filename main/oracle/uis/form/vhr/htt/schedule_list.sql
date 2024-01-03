set define off
prompt PATH /vhr/htt/schedule_list
begin
uis.route('/vhr/htt/schedule_list$delete','Ui_Vhr30.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/schedule_list:model','Ui_Vhr30.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/schedule_list:table','Ui_Vhr30.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/schedule_list','vhr30');
uis.form('/vhr/htt/schedule_list','/vhr/htt/schedule_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/htt/schedule_list','add','F','/vhr/htt/schedule+add','S','O');
uis.action('/vhr/htt/schedule_list','custom','F',null,null,'G');
uis.action('/vhr/htt/schedule_list','delete','F',null,null,'A');
uis.action('/vhr/htt/schedule_list','edit','F','/vhr/htt/schedule+edit','S','O');
uis.action('/vhr/htt/schedule_list','flexible','F',null,null,'G');
uis.action('/vhr/htt/schedule_list','hourly','F',null,null,'G');

uis.form_sibling('vhr','/vhr/htt/schedule_list','/vhr/htt/calendar_list',1);

uis.ready('/vhr/htt/schedule_list','.add.custom.delete.edit.flexible.hourly.model.');

commit;
end;
/
