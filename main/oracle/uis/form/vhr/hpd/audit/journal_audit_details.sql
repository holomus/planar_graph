set define off
prompt PATH /vhr/hpd/audit/journal_audit_details
begin
uis.route('/vhr/hpd/audit/journal_audit_details:model','Ui_Vhr183.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hpd/audit/journal_audit_details','vhr183');
uis.form('/vhr/hpd/audit/journal_audit_details','/vhr/hpd/audit/journal_audit_details','F','A','F','H','M','N',null,'N');






uis.ready('/vhr/hpd/audit/journal_audit_details','.model.');

commit;
end;
/
