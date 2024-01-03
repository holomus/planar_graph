set define off
prompt PATH /vhr/hsc/process_list
begin
uis.route('/vhr/hsc/process_list$delete','Ui_Vhr487.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hsc/process_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hsc/process_list:table','Ui_Vhr487.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hsc/process_list','vhr487');
uis.form('/vhr/hsc/process_list','/vhr/hsc/process_list','F','A','F','HM','M','N',null,null);



uis.action('/vhr/hsc/process_list','actions','F','/vhr/hsc/process_action_list','S','O');
uis.action('/vhr/hsc/process_list','add','F','/vhr/hsc/process+add','S','O');
uis.action('/vhr/hsc/process_list','delete','F',null,null,'A');
uis.action('/vhr/hsc/process_list','edit','F','/vhr/hsc/process+edit','S','O');


uis.ready('/vhr/hsc/process_list','.actions.add.delete.edit.model.');

commit;
end;
/
