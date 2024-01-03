set define off
prompt PATH /vhr/hpd/view/hiring_contract_view
begin
uis.route('/vhr/hpd/view/hiring_contract_view$post','Ui_Vhr657.Post','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hpd/view/hiring_contract_view$unpost','Ui_Vhr657.Unpost','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hpd/view/hiring_contract_view:model','Ui_Vhr657.Model','M','M','A','Y',null,null,null,'S');

uis.path('/vhr/hpd/view/hiring_contract_view','vhr657');
uis.form('/vhr/hpd/view/hiring_contract_view','/vhr/hpd/view/hiring_contract_view','F','A','F','H','M','N',null,'N','S');



uis.action('/vhr/hpd/view/hiring_contract_view','edit','F','/vhr/hpd/hiring_contract+edit','S','O');
uis.action('/vhr/hpd/view/hiring_contract_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/hiring_contract_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/hiring_contract_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/hiring_contract_view','.edit.model.post.sign_document.unpost.');

commit;
end;
/
