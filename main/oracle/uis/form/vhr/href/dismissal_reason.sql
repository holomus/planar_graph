set define off
prompt PATH /vhr/href/dismissal_reason
begin
uis.route('/vhr/href/dismissal_reason+add:model','Ui_Vhr50.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/dismissal_reason+add:save','Ui_Vhr50.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/dismissal_reason+edit:model','Ui_Vhr50.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/dismissal_reason+edit:save','Ui_Vhr50.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/dismissal_reason','vhr50');
uis.form('/vhr/href/dismissal_reason+add','/vhr/href/dismissal_reason','A','A','F','H','M','N',null,'N');
uis.form('/vhr/href/dismissal_reason+edit','/vhr/href/dismissal_reason','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/dismissal_reason+add','.model.');
uis.ready('/vhr/href/dismissal_reason+edit','.model.');

commit;
end;
/
