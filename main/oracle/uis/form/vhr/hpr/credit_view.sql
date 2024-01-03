set define off
prompt PATH /vhr/hpr/credit_view
begin
uis.route('/vhr/hpr/credit_view$archive','Ui_Vhr680.Archive','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/credit_view$book','Ui_Vhr680.Book','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/credit_view$complete','Ui_Vhr680.Complete','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/credit_view$draft','Ui_Vhr680.Draft','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/credit_view:audits','Ui_Vhr680.Query_Credit_Audit','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit_view:model','Ui_Vhr680.Model','M','M','A','Y',null,null,null,null);

uis.path('/vhr/hpr/credit_view','vhr680');
uis.form('/vhr/hpr/credit_view','/vhr/hpr/credit_view','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hpr/credit_view','archive','F',null,null,'A');
uis.action('/vhr/hpr/credit_view','audit','F',null,null,'G');
uis.action('/vhr/hpr/credit_view','audit_details','F','/vhr/hpr/credit_audit_details','S','O');
uis.action('/vhr/hpr/credit_view','book','F',null,null,'A');
uis.action('/vhr/hpr/credit_view','complete','F',null,null,'A');
uis.action('/vhr/hpr/credit_view','draft','F',null,null,'A');
uis.action('/vhr/hpr/credit_view','edit','F','/vhr/hpr/credit+edit','S','O');


uis.ready('/vhr/hpr/credit_view','.archive.audit.audit_details.book.complete.draft.edit.model.');

commit;
end;
/
