set define off
prompt PATH /vhr/href/sick_leave_reason
begin
uis.route('/vhr/href/sick_leave_reason+add:code_is_unique','Ui_Vhr167.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/sick_leave_reason+add:model','Ui_Vhr167.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/sick_leave_reason+add:save','Ui_Vhr167.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/sick_leave_reason+edit:code_is_unique','Ui_Vhr167.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/sick_leave_reason+edit:model','Ui_Vhr167.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/sick_leave_reason+edit:save','Ui_Vhr167.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/sick_leave_reason','vhr167');
uis.form('/vhr/href/sick_leave_reason+add','/vhr/href/sick_leave_reason','F','A','F','H','M','N',null,'N');
uis.form('/vhr/href/sick_leave_reason+edit','/vhr/href/sick_leave_reason','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/sick_leave_reason+add','.model.');
uis.ready('/vhr/href/sick_leave_reason+edit','.model.');

commit;
end;
/
