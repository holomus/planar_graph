set define off
prompt PATH /vhr/href/employment_source
begin
uis.route('/vhr/href/employment_source+add:model','Ui_Vhr142.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/employment_source+add:save','Ui_Vhr142.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/employment_source+edit:model','Ui_Vhr142.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/employment_source+edit:save','Ui_Vhr142.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/employment_source','vhr142');
uis.form('/vhr/href/employment_source+add','/vhr/href/employment_source','A','A','F','H','M','N',null,null);
uis.form('/vhr/href/employment_source+edit','/vhr/href/employment_source','A','A','F','H','M','N',null,null);






uis.ready('/vhr/href/employment_source+add','.model.');
uis.ready('/vhr/href/employment_source+edit','.model.');

commit;
end;
/
