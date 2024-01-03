set define off
prompt PATH /vhr/hln/attestation_view
begin
uis.route('/vhr/hln/attestation_view:model','Ui_Vhr248.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/attestation_view:testings','Ui_Vhr248.Query_Testings','M','Q','A',null,null,null,null);

uis.path('/vhr/hln/attestation_view','vhr248');
uis.form('/vhr/hln/attestation_view','/vhr/hln/attestation_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/attestation_view','control','F','/vhr/hln/testing_list+control','S','O');
uis.action('/vhr/hln/attestation_view','edit','F','/vhr/hln/attestation+edit','S','O');
uis.action('/vhr/hln/attestation_view','testing_view','F','/vhr/hln/testing_view','S','O');


uis.ready('/vhr/hln/attestation_view','.control.edit.model.testing_view.');

commit;
end;
/
