set define off
prompt PATH /vhr/htt/request_kind_list
begin
uis.route('/vhr/htt/request_kind_list$delete','Ui_Vhr116.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_kind_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/request_kind_list:table','Ui_Vhr116.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/request_kind_list','vhr116');
uis.form('/vhr/htt/request_kind_list','/vhr/htt/request_kind_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/request_kind_list','add','A','/vhr/htt/request_kind+add','S','O');
uis.action('/vhr/htt/request_kind_list','delete','A',null,null,'A');
uis.action('/vhr/htt/request_kind_list','edit','A','/vhr/htt/request_kind+edit','S','O');
uis.action('/vhr/htt/request_kind_list','staffs','A','/vhr/htt/request_kind_staffs','S','O');
uis.action('/vhr/htt/request_kind_list','view','A','/vhr/htt/view/request_kind_view','S','O');

uis.form_sibling('vhr','/vhr/htt/request_kind_list','/vhr/htt/time_kind_list',1);

uis.ready('/vhr/htt/request_kind_list','.add.delete.edit.model.staffs.view.');

commit;
end;
/
