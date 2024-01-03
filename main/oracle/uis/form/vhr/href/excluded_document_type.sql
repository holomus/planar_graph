set define off
prompt PATH /vhr/href/excluded_document_type
begin
uis.route('/vhr/href/excluded_document_type+add:divisions','Ui_Vhr598.Query_Divisions',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/excluded_document_type+add:get_document_types','Ui_Vhr598.Get_Document_Types','M','L','A',null,null,null,null);
uis.route('/vhr/href/excluded_document_type+add:jobs','Ui_Vhr598.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/excluded_document_type+add:model','Ui_Vhr598.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/excluded_document_type+add:save','Ui_Vhr598.Save','M',null,'A',null,null,null,null);
uis.route('/vhr/href/excluded_document_type+edit:divisions','Ui_Vhr598.Query_Divisions',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/excluded_document_type+edit:get_document_types','Ui_Vhr598.Get_Document_Types','M','L','A',null,null,null,null);
uis.route('/vhr/href/excluded_document_type+edit:jobs','Ui_Vhr598.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/excluded_document_type+edit:model','Ui_Vhr598.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/excluded_document_type+edit:save','Ui_Vhr598.Save','M',null,'A',null,null,null,null);

uis.path('/vhr/href/excluded_document_type','vhr598');
uis.form('/vhr/href/excluded_document_type+add','/vhr/href/excluded_document_type','F','A','F','H','M','N',null,'N');
uis.form('/vhr/href/excluded_document_type+edit','/vhr/href/excluded_document_type','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/excluded_document_type+add','.model.');
uis.ready('/vhr/href/excluded_document_type+edit','.model.');

commit;
end;
/
