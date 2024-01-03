set define off
prompt PATH /vhr/hrec/reject_reason_list
begin
uis.route('/vhr/hrec/reject_reason_list$delete','Ui_Vhr568.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hrec/reject_reason_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hrec/reject_reason_list:table','Ui_Vhr568.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrec/reject_reason_list','vhr568');
uis.form('/vhr/hrec/reject_reason_list','/vhr/hrec/reject_reason_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hrec/reject_reason_list','add','A','/vhr/hrec/reject_reason+add','S','O');
uis.action('/vhr/hrec/reject_reason_list','delete','A',null,null,'A');
uis.action('/vhr/hrec/reject_reason_list','edit','A','/vhr/hrec/reject_reason+edit','S','O');


uis.ready('/vhr/hrec/reject_reason_list','.add.delete.edit.model.');

commit;
end;
/
