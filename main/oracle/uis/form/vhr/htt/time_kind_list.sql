set define off
prompt PATH /vhr/htt/time_kind_list
begin
uis.route('/vhr/htt/time_kind_list$delete','Ui_Vhr72.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/time_kind_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/time_kind_list:table','Ui_Vhr72.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/time_kind_list','vhr72');
uis.form('/vhr/htt/time_kind_list','/vhr/htt/time_kind_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/time_kind_list','add','A','/vhr/htt/time_kind+add','S','O');
uis.action('/vhr/htt/time_kind_list','delete','A',null,null,'A');
uis.action('/vhr/htt/time_kind_list','edit','A','/vhr/htt/time_kind+edit','S','O');



uis.ready('/vhr/htt/time_kind_list','.add.delete.edit.model.');

commit;
end;
/
