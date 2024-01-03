set define off
prompt PATH /vhr/hpd/audit/oper_type_audit
begin
uis.route('/vhr/hpd/audit/oper_type_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/oper_type_audit:table_audit','Ui_Vhr193.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/oper_type_audit','vhr193');
uis.form('/vhr/hpd/audit/oper_type_audit','/vhr/hpd/audit/oper_type_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/oper_type_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');



uis.ready('/vhr/hpd/audit/oper_type_audit','.audit_details.model.');

commit;
end;
/
