set define off
prompt PATH /vhr/hrec/funnel_list
begin
uis.route('/vhr/hrec/funnel_list$delete','Ui_Vhr572.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/funnel_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hrec/funnel_list:table','Ui_Vhr572.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrec/funnel_list','vhr572');
uis.form('/vhr/hrec/funnel_list','/vhr/hrec/funnel_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hrec/funnel_list','add','A','/vhr/hrec/funnel+add','S','O');
uis.action('/vhr/hrec/funnel_list','delete','A',null,null,'A');
uis.action('/vhr/hrec/funnel_list','edit','A','/vhr/hrec/funnel+edit','S','O');


uis.ready('/vhr/hrec/funnel_list','.add.delete.edit.model.');

commit;
end;
/
