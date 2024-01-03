set define off
prompt PATH /vhr/hpd/sign_document_list
begin
uis.route('/vhr/hpd/sign_document_list$to_progress','Ui_Vhr652.To_Progress','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hpd/sign_document_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,'S');
uis.route('/vhr/hpd/sign_document_list:table','Ui_Vhr652.Query',null,'Q','A',null,null,null,null,'S');

uis.path('/vhr/hpd/sign_document_list','vhr652');
uis.form('/vhr/hpd/sign_document_list','/vhr/hpd/sign_document_list','F','A','F','H','M','N',null,'N','S');



uis.action('/vhr/hpd/sign_document_list','to_progress','F',null,null,'A');
uis.action('/vhr/hpd/sign_document_list','view','F','/vhr/hpd/sign_document_view','S','O');

uis.form_sibling('vhr','/vhr/hpd/sign_document_list','/vhr/hpd/sign_template_list',1);

uis.ready('/vhr/hpd/sign_document_list','.model.to_progress.view.');

commit;
end;
/
