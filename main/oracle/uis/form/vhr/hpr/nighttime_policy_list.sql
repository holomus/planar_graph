set define off
prompt PATH /vhr/hpr/nighttime_policy_list
begin
uis.route('/vhr/hpr/nighttime_policy_list$delete','Ui_Vhr647.Del','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hpr/nighttime_policy_list:common_policies','Ui_Vhr647.Query_Common_Nighttime_Policy',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hpr/nighttime_policy_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,'S');
uis.route('/vhr/hpr/nighttime_policy_list:standart_policies','Ui_Vhr647.Query_Standart_Nighttime_Policy',null,'Q','A',null,null,null,null,'S');

uis.path('/vhr/hpr/nighttime_policy_list','vhr647');
uis.form('/vhr/hpr/nighttime_policy_list','/vhr/hpr/nighttime_policy_list','F','A','F','H','M','N',null,'N','S');



uis.action('/vhr/hpr/nighttime_policy_list','add','F','/vhr/hpr/nighttime_policy+add','S','O');
uis.action('/vhr/hpr/nighttime_policy_list','delete','F',null,null,'A');
uis.action('/vhr/hpr/nighttime_policy_list','edit','F','/vhr/hpr/nighttime_policy+edit','S','O');


uis.ready('/vhr/hpr/nighttime_policy_list','.add.delete.edit.model.');

commit;
end;
/
