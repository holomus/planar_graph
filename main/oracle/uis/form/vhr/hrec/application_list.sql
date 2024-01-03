set define off
prompt PATH /vhr/hrec/application_list
begin
uis.route('/vhr/hrec/application_list$delete','Ui_Vhr585.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_list$set_approved','Ui_Vhr585.Change_Status_To_Approve','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_list$set_canceled','Ui_Vhr585.Change_Status_To_Cancel','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_list$set_complete','Ui_Vhr585.Change_Status_To_Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_list$set_draft','Ui_Vhr585.Change_Status_To_Draft','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_list$set_waiting','Ui_Vhr585.Change_Status_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/application_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hrec/application_list:table','Ui_Vhr585.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrec/application_list','vhr585');
uis.form('/vhr/hrec/application_list','/vhr/hrec/application_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hrec/application_list','add','F','/vhr/hrec/application+add','S','O');
uis.action('/vhr/hrec/application_list','delete','F',null,null,'A');
uis.action('/vhr/hrec/application_list','edit','F','/vhr/hrec/application+edit','S','O');
uis.action('/vhr/hrec/application_list','set_approved','F',null,null,'A');
uis.action('/vhr/hrec/application_list','set_canceled','F',null,null,'A');
uis.action('/vhr/hrec/application_list','set_complete','F',null,null,'A');
uis.action('/vhr/hrec/application_list','set_draft','F',null,null,'A');
uis.action('/vhr/hrec/application_list','set_waiting','F',null,null,'A');
uis.action('/vhr/hrec/application_list','view','F','/vhr/hrec/application_view','S','O');


uis.ready('/vhr/hrec/application_list','.add.delete.edit.model.set_approved.set_canceled.set_complete.set_draft.set_waiting.view.');

commit;
end;
/
