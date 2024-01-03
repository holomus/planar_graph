set define off
prompt PATH /vhr/htt/request_kind_staffs
begin
uis.route('/vhr/htt/request_kind_staffs$attach','Ui_Vhr451.Attach','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_kind_staffs$detach','Ui_Vhr451.Detach','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_kind_staffs:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/request_kind_staffs:table','Ui_Vhr451.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/request_kind_staffs','vhr451');
uis.form('/vhr/htt/request_kind_staffs','/vhr/htt/request_kind_staffs','F','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/request_kind_staffs','attach','F',null,null,'A');
uis.action('/vhr/htt/request_kind_staffs','detach','F',null,null,'A');


uis.ready('/vhr/htt/request_kind_staffs','.attach.detach.model.');

commit;
end;
/
