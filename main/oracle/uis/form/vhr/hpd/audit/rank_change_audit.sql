set define off
prompt PATH /vhr/hpd/audit/rank_change_audit
begin
uis.route('/vhr/hpd/audit/rank_change_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/rank_change_audit:table_audit','Ui_Vhr271.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/rank_change_audit','vhr271');
uis.form('/vhr/hpd/audit/rank_change_audit','/vhr/hpd/audit/rank_change_audit','F','A','F','H','M','N',null,null);



uis.action('/vhr/hpd/audit/rank_change_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/audit/rank_change_audit','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/audit/rank_change_audit','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');


uis.ready('/vhr/hpd/audit/rank_change_audit','.audit_details.journal_audit.model.page_audit.');

commit;
end;
/
