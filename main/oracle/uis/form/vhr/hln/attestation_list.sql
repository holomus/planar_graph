set define off
prompt PATH /vhr/hln/attestation_list
begin
uis.route('/vhr/hln/attestation_list$delete','Ui_Vhr246.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/attestation_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hln/attestation_list:table','Ui_Vhr246.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hln/attestation_list','vhr246');
uis.form('/vhr/hln/attestation_list','/vhr/hln/attestation_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/attestation_list','add','F','/vhr/hln/attestation+add','S','O');
uis.action('/vhr/hln/attestation_list','control','F','/vhr/hln/testing_list+control','S','O');
uis.action('/vhr/hln/attestation_list','delete','F',null,null,'A');
uis.action('/vhr/hln/attestation_list','edit','F','/vhr/hln/attestation+edit','S','O');
uis.action('/vhr/hln/attestation_list','view','F','/vhr/hln/attestation_view','S','O');


uis.ready('/vhr/hln/attestation_list','.add.control.delete.edit.model.view.');

commit;
end;
/
