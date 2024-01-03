set define off
prompt PATH /vhr/hpr/payment_view
begin
uis.route('/vhr/hpr/payment_view$archive','Ui_Vhr592.Archive','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/payment_view$book','Ui_Vhr592.Book','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/payment_view$complete','Ui_Vhr592.Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/payment_view$draft','Ui_Vhr592.Draft','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/payment_view:audits','Ui_Vhr592.Query_Payment_Audits','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/payment_view:employees','Ui_Vhr592.Query_Employees','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/payment_view:model','Ui_Vhr592.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hpr/payment_view','vhr592');
uis.form('/vhr/hpr/payment_view','/vhr/hpr/payment_view','F','A','F','H','M','N',null,'N');

uis.override_form('/anor/mpr/payment_view','vhr','/vhr/hpr/payment_view');


uis.action('/vhr/hpr/payment_view','archive','F',null,null,'A');
uis.action('/vhr/hpr/payment_view','audit','F',null,null,'A');
uis.action('/vhr/hpr/payment_view','audit_details','F','/anor/mpr/payment_audit_details','D','O');
uis.action('/vhr/hpr/payment_view','book','F',null,null,'A');
uis.action('/vhr/hpr/payment_view','complete','F',null,null,'A');
uis.action('/vhr/hpr/payment_view','draft','F',null,null,'A');
uis.action('/vhr/hpr/payment_view','edit_advance','F','/anor/mpr/payment_advance+edit','D','O');
uis.action('/vhr/hpr/payment_view','edit_payroll','F','/vhr/hpr/payment+edit','D','O');
uis.action('/vhr/hpr/payment_view','view','F','/anor/mhr/employee_view','D','O');


uis.ready('/vhr/hpr/payment_view','.archive.audit.audit_details.book.complete.draft.edit_advance.edit_payroll.model.view.');

commit;
end;
/
