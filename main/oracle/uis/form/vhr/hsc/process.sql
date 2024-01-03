set define off
prompt PATH /vhr/hsc/process
begin
uis.route('/vhr/hsc/process+add:code_is_unique','Ui_Vhr488.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/process+add:model','Ui_Vhr488.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hsc/process+add:name_is_unique','Ui_Vhr488.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/process+add:save','Ui_Vhr488.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hsc/process+edit:code_is_unique','Ui_Vhr488.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/process+edit:model','Ui_Vhr488.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hsc/process+edit:name_is_unique','Ui_Vhr488.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hsc/process+edit:save','Ui_Vhr488.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hsc/process','vhr488');
uis.form('/vhr/hsc/process+add','/vhr/hsc/process','F','A','F','H','M','N',null,null);
uis.form('/vhr/hsc/process+edit','/vhr/hsc/process','F','A','F','H','M','N',null,null);





uis.ready('/vhr/hsc/process+add','.model.');
uis.ready('/vhr/hsc/process+edit','.model.');

commit;
end;
/
