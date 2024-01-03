set define off
prompt PATH /vhr/hpd/view/rank_change_view
begin
uis.route('/vhr/hpd/view/rank_change_view$post','Ui_Vhr433.Post','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/rank_change_view$unpost','Ui_Vhr433.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/rank_change_view:model','Ui_Vhr433.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/rank_change_view:table_rank_change_audit','Ui_Vhr433.Query_Rank_Change_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/rank_change_view','vhr433');
uis.form('/vhr/hpd/view/rank_change_view','/vhr/hpd/view/rank_change_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/rank_change_view','audit','F',null,null,'G');
uis.action('/vhr/hpd/view/rank_change_view','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/view/rank_change_view','edit','F','/vhr/hpd/rank_change+edit','S','O');
uis.action('/vhr/hpd/view/rank_change_view','edit_multiple','F','/vhr/hpd/rank_change+multiple_edit','S','O');
uis.action('/vhr/hpd/view/rank_change_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/rank_change_view','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');
uis.action('/vhr/hpd/view/rank_change_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/rank_change_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/rank_change_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/rank_change_view','.audit.audit_details.edit.edit_multiple.journal_audit.model.page_audit.post.sign_document.unpost.');

commit;
end;
/
