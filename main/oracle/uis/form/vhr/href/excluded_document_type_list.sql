set define off
prompt PATH /vhr/href/excluded_document_type_list
begin
uis.route('/vhr/href/excluded_document_type_list$delete','Ui_Vhr597.Del','L',null,'A',null,null,null,null);
uis.route('/vhr/href/excluded_document_type_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/excluded_document_type_list:table','Ui_Vhr597.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/href/excluded_document_type_list','vhr597');
uis.form('/vhr/href/excluded_document_type_list','/vhr/href/excluded_document_type_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/href/excluded_document_type_list','add','F','/vhr/href/excluded_document_type+add','S','O');
uis.action('/vhr/href/excluded_document_type_list','delete','F',null,null,'A');
uis.action('/vhr/href/excluded_document_type_list','edit','F','/vhr/href/excluded_document_type+edit','S','O');


uis.ready('/vhr/href/excluded_document_type_list','.add.delete.edit.model.');

commit;
end;
/
