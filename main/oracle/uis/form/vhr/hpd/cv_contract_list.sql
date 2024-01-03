set define off
prompt PATH /vhr/hpd/cv_contract_list
begin
uis.route('/vhr/hpd/cv_contract_list$delete','Ui_Vhr326.Contract_Delete','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/cv_contract_list$early_close','Ui_Vhr326.Contract_Close','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/cv_contract_list$post','Ui_Vhr326.Contract_Post','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/cv_contract_list$unpost','Ui_Vhr326.Contract_Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/cv_contract_list:model','Ui_Vhr326.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpd/cv_contract_list:table','Ui_Vhr326.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/cv_contract_list','vhr326');
uis.form('/vhr/hpd/cv_contract_list','/vhr/hpd/cv_contract_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/cv_contract_list','add','F','/vhr/hpd/cv_contract+add','S','O');
uis.action('/vhr/hpd/cv_contract_list','add_journal','F','/vhr/hpd/hiring_contract+add','S','O');
uis.action('/vhr/hpd/cv_contract_list','delete','F',null,null,'A');
uis.action('/vhr/hpd/cv_contract_list','early_close','F',null,null,'A');
uis.action('/vhr/hpd/cv_contract_list','edit','F','/vhr/hpd/cv_contract+edit','S','O');
uis.action('/vhr/hpd/cv_contract_list','edit_journal','F','/vhr/hpd/hiring_contract+edit','S','O');
uis.action('/vhr/hpd/cv_contract_list','post','F',null,null,'A');
uis.action('/vhr/hpd/cv_contract_list','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/cv_contract_list','.add.add_journal.delete.early_close.edit.edit_journal.model.post.unpost.');

commit;
end;
/
