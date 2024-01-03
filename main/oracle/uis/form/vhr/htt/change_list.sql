set define off
prompt PATH /vhr/htt/change_list
begin
uis.route('/vhr/htt/change_list$approve','Ui_Vhr216.Change_Approve','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/change_list$cancel','Ui_Vhr216.Change_Cancel','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/change_list$change_approve','Ui_Vhr216.Change_Approve','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/change_list$complete','Ui_Vhr216.Change_Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/change_list$delete','Ui_Vhr216.Change_Delete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/change_list$delete_personal','Ui_Vhr216.Change_Delete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/change_list$deny','Ui_Vhr216.Change_Deny','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/change_list$reset','Ui_Vhr216.Change_Reset','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/change_list$return','Ui_Vhr216.Change_Reset','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/change_list:available_changes','Ui_Vhr216.Query_Available_Changes',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/change_list:model','Ui_Vhr216.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/change_list:personal_changes','Ui_Vhr216.Query_Personal_Changes',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/change_list','vhr216');
uis.form('/vhr/htt/change_list','/vhr/htt/change_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/change_list','add','F','/vhr/htt/change+add','S','O');
uis.action('/vhr/htt/change_list','add_personal','F','/vhr/htt/change+add_personal','S','O');
uis.action('/vhr/htt/change_list','approve','F',null,null,'A');
uis.action('/vhr/htt/change_list','cancel','F',null,null,'A');
uis.action('/vhr/htt/change_list','complete','F',null,null,'A');
uis.action('/vhr/htt/change_list','delete','F',null,null,'A');
uis.action('/vhr/htt/change_list','deny','F',null,null,'A');
uis.action('/vhr/htt/change_list','edit','F','/vhr/htt/change+edit','S','O');
uis.action('/vhr/htt/change_list','edit_personal','F','/vhr/htt/change+edit_personal','S','O');
uis.action('/vhr/htt/change_list','reset','F',null,null,'A');
uis.action('/vhr/htt/change_list','view','F','/vhr/htt/change_view+view','S','O');
uis.action('/vhr/htt/change_list','view_personal','F','/vhr/htt/change_view+view_personal','S','O');


uis.ready('/vhr/htt/change_list','.add.add_personal.approve.cancel.complete.delete.deny.edit.edit_personal.model.reset.view.view_personal.');

commit;
end;
/
