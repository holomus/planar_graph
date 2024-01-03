set define off
prompt PATH /vhr/href/person/person_document_view
begin
uis.route('/vhr/href/person/person_document_view:download_files','Ui_Vhr152.Download_Files','M','F','A',null,null,null,null);
uis.route('/vhr/href/person/person_document_view:model','Ui_Vhr152.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/person/person_document_view','vhr152');
uis.form('/vhr/href/person/person_document_view','/vhr/href/person/person_document_view','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/person/person_document_view','.model.');

commit;
end;
/
