set define off
prompt PATH /vhr/href/labor_function
begin
uis.route('/vhr/href/labor_function+add:code_is_unique','Ui_Vhr48.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/labor_function+add:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/href/labor_function+add:save','Ui_Vhr48.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/labor_function+edit:code_is_unique','Ui_Vhr48.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/labor_function+edit:model','Ui_Vhr48.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/labor_function+edit:save','Ui_Vhr48.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/labor_function','vhr48');
uis.form('/vhr/href/labor_function+add','/vhr/href/labor_function','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/labor_function+edit','/vhr/href/labor_function','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/labor_function+add','.model.');
uis.ready('/vhr/href/labor_function+edit','.model.');

commit;
end;
/
