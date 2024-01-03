set define off
prompt PATH /vhr/hpd/view/wage_change_view
begin
uis.route('/vhr/hpd/view/wage_change_view$post','Ui_Vhr432.Post','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/wage_change_view$unpost','Ui_Vhr432.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/wage_change_view:model','Ui_Vhr432.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/wage_change_view:table_wage_change_audit','Ui_Vhr432.Query_Wage_Change_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/wage_change_view','vhr432');
uis.form('/vhr/hpd/view/wage_change_view','/vhr/hpd/view/wage_change_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/wage_change_view','audit','F',null,null,'G');
uis.action('/vhr/hpd/view/wage_change_view','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/view/wage_change_view','currency_audit','F','/vhr/hpd/audit/currency_audit','S','O');
uis.action('/vhr/hpd/view/wage_change_view','edit','F','/vhr/hpd/wage_change+edit','S','O');
uis.action('/vhr/hpd/view/wage_change_view','edit_multiple','F','/vhr/hpd/wage_change_multiple+edit','S','O');
uis.action('/vhr/hpd/view/wage_change_view','indicator_audit','F','/vhr/hpd/audit/indicator_audit','S','O');
uis.action('/vhr/hpd/view/wage_change_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/wage_change_view','oper_type_audit','F','/vhr/hpd/audit/oper_type_audit','S','O');
uis.action('/vhr/hpd/view/wage_change_view','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');
uis.action('/vhr/hpd/view/wage_change_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/wage_change_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/wage_change_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/wage_change_view','.audit.audit_details.currency_audit.edit.edit_multiple.indicator_audit.journal_audit.model.oper_type_audit.page_audit.post.sign_document.unpost.');

commit;
end;
/
