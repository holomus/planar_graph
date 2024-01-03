set define off
prompt PATH /vhr/hpd/application/transfer_view
begin
uis.route('/vhr/hpd/application/transfer_view:approved_to_in_progress','Ui_Vhr547.Change_Status_To_In_Progress','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_view:approved_to_waiting','Ui_Vhr547.Change_Status_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_view:bind_journal','Ui_Vhr547.Application_Bind_Journal','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_view:canceled_to_waiting','Ui_Vhr547.Change_Status_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_view:completed_to_in_progress','Ui_Vhr547.Change_Status_To_In_Progress','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_view:in_progress_to_approved','Ui_Vhr547.Change_Status_From_In_Progress_To_Approved','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_view:in_progress_to_completed','Ui_Vhr547.Change_Status_To_Completed','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_view:model','Ui_Vhr547.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/transfer_view:new_to_waiting','Ui_Vhr547.Change_Status_From_New_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_view:waiting_to_approved','Ui_Vhr547.Change_Status_From_Waiting_To_Approved','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_view:waiting_to_canceled','Ui_Vhr547.Change_Status_To_Canceled','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/transfer_view:waiting_to_new','Ui_Vhr547.Change_Status_To_New','M',null,'A',null,null,null,null);

uis.path('/vhr/hpd/application/transfer_view','vhr547');
uis.form('/vhr/hpd/application/transfer_view','/vhr/hpd/application/transfer_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/application/transfer_view','add_journal','F','/vhr/hpd/transfer+add','D','O');
uis.action('/vhr/hpd/application/transfer_view','edit','F','/vhr/hpd/application/transfer+edit','S','O');
uis.action('/vhr/hpd/application/transfer_view','view_journal','F','/vhr/hpd/view/transfer_view','S','O');


uis.ready('/vhr/hpd/application/transfer_view','.add_journal.edit.model.view_journal.');

commit;
end;
/
