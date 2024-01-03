set define off
prompt PATH /vhr/htt/terminal_model_list
begin
uis.route('/vhr/htt/terminal_model_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/terminal_model_list:table','Ui_Vhr224.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/terminal_model_list','vhr224');
uis.form('/vhr/htt/terminal_model_list','/vhr/htt/terminal_model_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/terminal_model_list','edit','A','/vhr/htt/terminal_model+edit','S','O');



uis.ready('/vhr/htt/terminal_model_list','.edit.model.');

commit;
end;
/
