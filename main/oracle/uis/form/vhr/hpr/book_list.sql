set define off
prompt PATH /vhr/hpr/book_list
begin
uis.route('/vhr/hpr/book_list$delete','Ui_Vhr63.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/book_list$post','Ui_Vhr63.Post','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/book_list$unpost','Ui_Vhr63.Unpost','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/book_list:model','Ui_Vhr63.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/book_list:table','Ui_Vhr63.Query','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/book_list:transactions','Ui_Vhr63.Transactions','M',null,'A',null,null,null,null);

uis.path('/vhr/hpr/book_list','vhr63');
uis.form('/vhr/hpr/book_list','/vhr/hpr/book_list','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/hpr/book_list','add','F','/vhr/hpr/book+add','S','O');
uis.action('/vhr/hpr/book_list','delete','F',null,null,'A');
uis.action('/vhr/hpr/book_list','edit','F','/vhr/hpr/book+edit','S','O');
uis.action('/vhr/hpr/book_list','post','F',null,null,'A');
uis.action('/vhr/hpr/book_list','transactions','F',null,null,'G');
uis.action('/vhr/hpr/book_list','unpost','F',null,null,'A');
uis.action('/vhr/hpr/book_list','view','F','/vhr/hpr/book_view','S','O');

uis.form_sibling('vhr','/vhr/hpr/book_list','/vhr/hpr/charge_list',1);

uis.ready('/vhr/hpr/book_list','.add.delete.edit.model.post.transactions.unpost.view.');

commit;
end;
/
