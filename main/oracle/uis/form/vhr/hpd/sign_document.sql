set define off
prompt PATH /vhr/hpd/sign_document
begin
uis.route('/vhr/hpd/sign_document:model','Ui_Vhr654.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/sign_document:sign','Ui_Vhr654.Sign','M',null,'A',null,null,null,null,null);

uis.path('/vhr/hpd/sign_document','vhr654');
uis.form('/vhr/hpd/sign_document','/vhr/hpd/sign_document','F','A','F','H','M','N',null,null,null);





uis.ready('/vhr/hpd/sign_document','.model.');

commit;
end;
/
