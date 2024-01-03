set define off
prompt PATH /vhr/htt/calendar_list
begin
uis.route('/vhr/htt/calendar_list$delete','Ui_Vhr165.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/calendar_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/calendar_list:table','Ui_Vhr165.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/calendar_list','vhr165');
uis.form('/vhr/htt/calendar_list','/vhr/htt/calendar_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/calendar_list','add','F','/vhr/htt/calendar+add','S','O');
uis.action('/vhr/htt/calendar_list','delete','F',null,null,'A');
uis.action('/vhr/htt/calendar_list','edit','F','/vhr/htt/calendar+edit','S','O');



uis.ready('/vhr/htt/calendar_list','.add.delete.edit.model.');

commit;
end;
/
