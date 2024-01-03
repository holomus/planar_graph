set define off
prompt PATH /vhr/hpd/sign_document_view
begin
uis.route('/vhr/hpd/sign_document_view:model','Ui_Vhr653.Model','M','M','A','Y',null,null,null,null);

uis.path('/vhr/hpd/sign_document_view','vhr653');
uis.form('/vhr/hpd/sign_document_view','/vhr/hpd/sign_document_view','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hpd/sign_document_view','sign_document','F','/vhr/hpd/sign_document','S','O');


uis.ready('/vhr/hpd/sign_document_view','.model.sign_document.');

commit;
end;
/
