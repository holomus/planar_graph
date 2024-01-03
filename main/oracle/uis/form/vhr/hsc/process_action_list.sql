set define off
prompt PATH /vhr/hsc/process_action_list
begin
uis.route('/vhr/hsc/process_action_list$delete','Ui_Vhr491.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hsc/process_action_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hsc/process_action_list:table','Ui_Vhr491.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hsc/process_action_list','vhr491');
uis.form('/vhr/hsc/process_action_list','/vhr/hsc/process_action_list','F','A','F','H','M','N',null,null);



uis.action('/vhr/hsc/process_action_list','add','F','/vhr/hsc/process_action+add','S','O');
uis.action('/vhr/hsc/process_action_list','delete','F',null,null,'A');
uis.action('/vhr/hsc/process_action_list','edit','F','/vhr/hsc/process_action+edit','S','O');


uis.ready('/vhr/hsc/process_action_list','.add.delete.edit.model.');

commit;
end;
/
