set define off
prompt PATH /vhr/href/document_type_list
begin
uis.route('/vhr/href/document_type_list$delete','Ui_Vhr113.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/href/document_type_list$set_not_required','Ui_Vhr113.Set_Not_Required','M',null,'A',null,null,null,null);
uis.route('/vhr/href/document_type_list$set_required','Ui_Vhr113.Set_Required','M',null,'A',null,null,null,null);
uis.route('/vhr/href/document_type_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/document_type_list:table','Ui_Vhr113.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/document_type_list','vhr113');
uis.form('/vhr/href/document_type_list','/vhr/href/document_type_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/document_type_list','add','A','/vhr/href/document_type+add','S','O');
uis.action('/vhr/href/document_type_list','delete','A',null,null,'A');
uis.action('/vhr/href/document_type_list','edit','A','/vhr/href/document_type+edit','S','O');
uis.action('/vhr/href/document_type_list','set_not_required','A',null,null,'A');
uis.action('/vhr/href/document_type_list','set_required','A',null,null,'A');
uis.action('/vhr/href/document_type_list','view','A','/vhr/href/view/document_type_view','S','O');

uis.form_sibling('vhr','/vhr/href/document_type_list','/vhr/href/excluded_document_type_list',1);

uis.ready('/vhr/href/document_type_list','.add.delete.edit.model.set_not_required.set_required.view.');

commit;
end;
/
