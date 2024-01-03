set define off
prompt PATH /vhr/href/nationality
begin
uis.route('/vhr/href/nationality+add:code_is_unique','Ui_Vhr450.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/nationality+add:model','Ui_Vhr450.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/nationality+add:name_is_unique','Ui_Vhr450.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/nationality+add:save','Ui_Vhr450.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/nationality+edit:code_is_unique','Ui_Vhr450.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/nationality+edit:model','Ui_Vhr450.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/nationality+edit:name_is_unique','Ui_Vhr450.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/nationality+edit:save','Ui_Vhr450.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/nationality','vhr450');
uis.form('/vhr/href/nationality+add','/vhr/href/nationality','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/nationality+edit','/vhr/href/nationality','A','A','F','H','M','N',null,null);





uis.ready('/vhr/href/nationality+add','.model.');
uis.ready('/vhr/href/nationality+edit','.model.');

commit;
end;
/
