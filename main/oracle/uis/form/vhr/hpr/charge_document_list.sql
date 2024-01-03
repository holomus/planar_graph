set define off
prompt PATH /vhr/hpr/charge_document_list
begin
uis.route('/vhr/hpr/charge_document_list$delete','Ui_Vhr613.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document_list$post','Ui_Vhr613.Post','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document_list$unpost','Ui_Vhr613.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document_list:accrual_table','Ui_Vhr613.Query_Accrual_Documents',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document_list:deduction_table','Ui_Vhr613.Query_Deduction_Documents',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document_list:model','Ui_Vhr613.Model',null,'M','A','Y',null,null,null,null);

uis.path('/vhr/hpr/charge_document_list','vhr613');
uis.form('/vhr/hpr/charge_document_list','/vhr/hpr/charge_document_list','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpr/charge_document_list','add','F','/vhr/hpr/charge_document+add','S','O');
uis.action('/vhr/hpr/charge_document_list','delete','F',null,null,'A');
uis.action('/vhr/hpr/charge_document_list','edit','F','/vhr/hpr/charge_document+edit','S','O');
uis.action('/vhr/hpr/charge_document_list','post','F',null,null,'A');
uis.action('/vhr/hpr/charge_document_list','unpost','F',null,null,'A');


uis.ready('/vhr/hpr/charge_document_list','.add.delete.edit.model.post.unpost.');

commit;
end;
/
