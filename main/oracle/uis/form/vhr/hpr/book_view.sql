set define off
prompt PATH /vhr/hpr/book_view
begin
uis.route('/vhr/hpr/book_view$post','Ui_Vhr170.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/book_view$unpost','Ui_Vhr170.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/book_view:model','Ui_Vhr170.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/book_view:table_book_audit','Ui_Vhr170.Query_Book_Audit','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/book_view:table_operation_audit','Ui_Vhr170.Query_Operation_Audit','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/book_view:table_operations','Ui_Vhr170.Query_Operations','M','Q','A',null,null,null,null);

uis.path('/vhr/hpr/book_view','vhr170');
uis.form('/vhr/hpr/book_view','/vhr/hpr/book_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpr/book_view','audit','F',null,null,'A');
uis.action('/vhr/hpr/book_view','audit_details','F','/anor/mpr/book_audit_details','S','O');
uis.action('/vhr/hpr/book_view','edit','F','/vhr/hpr/book+edit','S','O');
uis.action('/vhr/hpr/book_view','post','F',null,null,'A');
uis.action('/vhr/hpr/book_view','unpost','F',null,null,'A');
uis.action('/vhr/hpr/book_view','view_employee','F','/vhr/href/employee/employee_edit','S','O');


uis.ready('/vhr/hpr/book_view','.audit.audit_details.edit.model.post.unpost.view_employee.');

commit;
end;
/
