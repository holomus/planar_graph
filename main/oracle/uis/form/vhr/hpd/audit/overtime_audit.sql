set define off
prompt PATH /vhr/hpd/audit/overtime_audit
begin
uis.route('/vhr/hpd/audit/overtime_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/overtime_audit:table_overtime_audit','Ui_Vhr623.Query','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/audit/overtime_audit:table_overtime_day_audit','Ui_Vhr623.Query_Overtime_Day_Audits','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/overtime_audit','vhr623');
uis.form('/vhr/hpd/audit/overtime_audit','/vhr/hpd/audit/overtime_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/overtime_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/audit/overtime_audit','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');


uis.ready('/vhr/hpd/audit/overtime_audit','.audit_details.journal_audit.model.');

commit;
end;
/
