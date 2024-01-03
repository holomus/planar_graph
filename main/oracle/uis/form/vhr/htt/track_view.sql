set define off
prompt PATH /vhr/htt/track_view
begin
uis.route('/vhr/htt/track_view$set_invalid','Ui_Vhr83.Set_Invalid','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/track_view$set_valid','Ui_Vhr83.Set_Valid','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/track_view:model','Ui_Vhr83.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/track_view:table_audit','Ui_Vhr83.Query_Track_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/track_view','vhr83');
uis.form('/vhr/htt/track_view','/vhr/htt/track_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/track_view','audit','A',null,null,'G');
uis.action('/vhr/htt/track_view','audit_details','A','/vhr/htt/view/track_audit_details','S','O');
uis.action('/vhr/htt/track_view','set_invalid','A',null,null,'A');
uis.action('/vhr/htt/track_view','set_valid','A',null,null,'A');


uis.ready('/vhr/htt/track_view','.audit.audit_details.model.set_invalid.set_valid.');

commit;
end;
/
