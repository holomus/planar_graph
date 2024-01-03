set define off
prompt PATH /vhr/htt/qr_code_list
begin
uis.route('/vhr/htt/qr_code_list$deactivate','Ui_Vhr357.Deactivate','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/qr_code_list$delete','Ui_Vhr357.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/qr_code_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/qr_code_list:table','Ui_Vhr357.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/qr_code_list','vhr357');
uis.form('/vhr/htt/qr_code_list','/vhr/htt/qr_code_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/qr_code_list','deactivate','A',null,null,'A');
uis.action('/vhr/htt/qr_code_list','delete','A',null,null,'A');


uis.ready('/vhr/htt/qr_code_list','.deactivate.delete.model.');

commit;
end;
/
