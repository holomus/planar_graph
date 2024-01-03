set define off
prompt PATH /vhr/href/document_type
begin
uis.route('/vhr/href/document_type+add:code_is_unique','Ui_Vhr114.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/document_type+add:model','Ui_Vhr114.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/document_type+add:name_is_unique','Ui_Vhr114.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/document_type+add:save','Ui_Vhr114.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/document_type+edit:code_is_unique','Ui_Vhr114.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/document_type+edit:model','Ui_Vhr114.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/document_type+edit:name_is_unique','Ui_Vhr114.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/document_type+edit:save','Ui_Vhr114.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/document_type','vhr114');
uis.form('/vhr/href/document_type+add','/vhr/href/document_type','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/document_type+edit','/vhr/href/document_type','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/document_type+add','.model.');
uis.ready('/vhr/href/document_type+edit','.model.');

commit;
end;
/
