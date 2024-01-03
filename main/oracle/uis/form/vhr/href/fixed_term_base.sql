set define off
prompt PATH /vhr/href/fixed_term_base
begin
uis.route('/vhr/href/fixed_term_base+add:code_is_unique','Ui_Vhr71.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/fixed_term_base+add:model','Ui_Vhr71.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/fixed_term_base+add:name_is_unique','Ui_Vhr71.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/fixed_term_base+add:save','Ui_Vhr71.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/fixed_term_base+edit:code_is_unique','Ui_Vhr71.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/fixed_term_base+edit:model','Ui_Vhr71.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/fixed_term_base+edit:name_is_unique','Ui_Vhr71.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/fixed_term_base+edit:save','Ui_Vhr71.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/fixed_term_base','vhr71');
uis.form('/vhr/href/fixed_term_base+add','/vhr/href/fixed_term_base','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/fixed_term_base+edit','/vhr/href/fixed_term_base','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/fixed_term_base+add','.model.');
uis.ready('/vhr/href/fixed_term_base+edit','.model.');

commit;
end;
/
