set define off
prompt PATH /vhr/href/person/person_document
begin
uis.route('/vhr/href/person/person_document$del_document','Ui_Vhr112.Del_Document','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_document$save_document','Ui_Vhr112.Save_Person_Document','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_document$status_approved','Ui_Vhr112.Document_Status_Approved','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_document$status_new','Ui_Vhr112.Document_Status_New','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_document$status_rejected','Ui_Vhr112.Document_Status_Rejected','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_document:doc_valid','Ui_Vhr112.Doc_Is_Valid','M','V','A',null,null,null,null);
uis.route('/vhr/href/person/person_document:document_types','Ui_Vhr112.Query_Document_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_document:download_files','Ui_Vhr112.Download_Files','M','F','A',null,null,null,null);
uis.route('/vhr/href/person/person_document:model','Ui_Vhr112.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/person/person_document:reload','Ui_Vhr112.Model','M','M','A',null,null,null,null);

uis.path('/vhr/href/person/person_document','vhr112');
uis.form('/vhr/href/person/person_document','/vhr/href/person/person_document','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/href/person/person_document','add_doc_type','F','/vhr/href/document_type+add','D','O');
uis.action('/vhr/href/person/person_document','del_document','F',null,null,'A');
uis.action('/vhr/href/person/person_document','save_document','F',null,null,'A');
uis.action('/vhr/href/person/person_document','select_doc_type','F','/vhr/href/document_type_list','D','O');
uis.action('/vhr/href/person/person_document','status_approved','F',null,null,'A');
uis.action('/vhr/href/person/person_document','status_new','F',null,null,'A');
uis.action('/vhr/href/person/person_document','status_rejected','F',null,null,'A');


uis.ready('/vhr/href/person/person_document','.add_doc_type.del_document.model.save_document.select_doc_type.status_approved.status_new.status_rejected.');

commit;
end;
/
