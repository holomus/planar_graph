set define off
prompt PATH /vhr/htt/head_change_list
begin
uis.route('/vhr/htt/head_change_list$approve','Ui_Vhr628.Change_Approve','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_change_list$cancel','Ui_Vhr628.Change_Cancel','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_change_list$complete','Ui_Vhr628.Change_Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_change_list$delete','Ui_Vhr628.Change_Delete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_change_list$deny','Ui_Vhr628.Change_Deny','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_change_list$reset','Ui_Vhr628.Change_Reset','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_change_list:available_changes','Ui_Vhr628.Query_Available_Changes',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/head_change_list:director_changes','Ui_Vhr628.Query_Director_Changes',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/head_change_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/htt/head_change_list','vhr628');
uis.form('/vhr/htt/head_change_list','/vhr/htt/head_change_list','H','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/head_change_list','approve','H',null,null,'A');
uis.action('/vhr/htt/head_change_list','cancel','H',null,null,'A');
uis.action('/vhr/htt/head_change_list','complete','H',null,null,'A');
uis.action('/vhr/htt/head_change_list','delete','H',null,null,'A');
uis.action('/vhr/htt/head_change_list','deny','H',null,null,'A');
uis.action('/vhr/htt/head_change_list','reset','H',null,null,'A');
uis.action('/vhr/htt/head_change_list','view','H','/vhr/htt/change_view+view','S','O');


uis.ready('/vhr/htt/head_change_list','.approve.cancel.complete.delete.deny.model.reset.view.');

commit;
end;
/
