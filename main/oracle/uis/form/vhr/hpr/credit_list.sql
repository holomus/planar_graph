set define off
prompt PATH /vhr/hpr/credit_list
begin
uis.route('/vhr/hpr/credit_list$archive','Ui_Vhr678.Credit_Archive','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hpr/credit_list$book','Ui_Vhr678.Credit_Book','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hpr/credit_list$complete','Ui_Vhr678.Credit_Complete','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hpr/credit_list$delete','Ui_Vhr678.Del','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hpr/credit_list$draft','Ui_Vhr678.Credit_Draft','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hpr/credit_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,'S');
uis.route('/vhr/hpr/credit_list:table','Ui_Vhr678.Query',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/hpr/credit_list:transactions','Ui_Vhr678.Transactions','M',null,'A',null,null,null,null,'S');

uis.path('/vhr/hpr/credit_list','vhr678');
uis.form('/vhr/hpr/credit_list','/vhr/hpr/credit_list','F','A','F','H','M','N',null,'N','S');



uis.action('/vhr/hpr/credit_list','add','F','/vhr/hpr/credit+add','S','O');
uis.action('/vhr/hpr/credit_list','archive','F',null,null,'A');
uis.action('/vhr/hpr/credit_list','book','F',null,null,'A');
uis.action('/vhr/hpr/credit_list','complete','F',null,null,'A');
uis.action('/vhr/hpr/credit_list','delete','F',null,null,'A');
uis.action('/vhr/hpr/credit_list','draft','F',null,null,'A');
uis.action('/vhr/hpr/credit_list','edit','F','/vhr/hpr/credit+edit','S','O');
uis.action('/vhr/hpr/credit_list','transactions','F',null,null,'G');
uis.action('/vhr/hpr/credit_list','view','F','/vhr/hpr/credit_view','S','O');


uis.ready('/vhr/hpr/credit_list','.add.archive.book.complete.delete.draft.edit.model.transactions.view.');

commit;
end;
/
