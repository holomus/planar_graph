set define off
prompt PATH /vhr/hrec/hh_event_receiver
begin
uis.route('/vhr/hrec/hh_event_receiver:event_handler','Ui_Vhr618.Event_Handler','M','R','P',null,null,null,null);
uis.route('/vhr/hrec/hh_event_receiver:model','Ui.No_Model',null,null,'P','Y',null,null,null);

uis.path('/vhr/hrec/hh_event_receiver','vhr618');
uis.form('/vhr/hrec/hh_event_receiver','/vhr/hrec/hh_event_receiver','A','P','E','Z','M','N',null,'N');





uis.ready('/vhr/hrec/hh_event_receiver','.model.');

commit;
end;
/
