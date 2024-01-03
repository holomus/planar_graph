set define off
prompt PATH /vhr/hpd/audit/dismissal_audit
begin
uis.route('/vhr/hpd/audit/dismissal_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/dismissal_audit:table_audit','Ui_Vhr185.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/dismissal_audit','vhr185');
uis.form('/vhr/hpd/audit/dismissal_audit','/vhr/hpd/audit/dismissal_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/dismissal_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/audit/dismissal_audit','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/audit/dismissal_audit','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');



uis.ready('/vhr/hpd/audit/dismissal_audit','.audit_details.journal_audit.model.page_audit.');

commit;
end;
/
