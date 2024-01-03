set define off
prompt PATH /vhr/href/dismissal_reason_list
begin
uis.route('/vhr/href/dismissal_reason_list$delete','Ui_Vhr49.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/dismissal_reason_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/dismissal_reason_list:table','Ui_Vhr49.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/dismissal_reason_list','vhr49');
uis.form('/vhr/href/dismissal_reason_list','/vhr/href/dismissal_reason_list','A','A','F','HM','M','N',null);



uis.action('/vhr/href/dismissal_reason_list','add','A','/vhr/href/dismissal_reason+add','S','O');
uis.action('/vhr/href/dismissal_reason_list','delete','A',null,null,'A');
uis.action('/vhr/href/dismissal_reason_list','edit','A','/vhr/href/dismissal_reason+edit','S','O');



uis.ready('/vhr/href/dismissal_reason_list','.add.delete.edit.model.');

commit;
end;
/
