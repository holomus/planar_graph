set define off
prompt PATH /vhr/hac/hik_event_receiver
begin
uis.route('/vhr/hac/hik_event_receiver$event_receiver','Ui_Vhr535.Receive_Event','A',null,'P',null,null,null,null);
uis.route('/vhr/hac/hik_event_receiver:model','Ui.No_Model',null,null,'A','Y',null,null,null);

uis.path('/vhr/hac/hik_event_receiver','vhr535');
uis.form('/vhr/hac/hik_event_receiver','/vhr/hac/hik_event_receiver','A','A','E','H','M','N',null,'N');



uis.action('/vhr/hac/hik_event_receiver','event_receiver','A',null,null,'A');


uis.ready('/vhr/hac/hik_event_receiver','.event_receiver.model.');

commit;
end;
/
