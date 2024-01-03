set define off
prompt PATH /vhr/hpr/penalty
begin
uis.route('/vhr/hpr/penalty+add:model','Ui_Vhr307.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/penalty+add:save','Ui_Vhr307.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/penalty+copy:model','Ui_Vhr307.Copy_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/penalty+copy:save','Ui_Vhr307.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/penalty+edit:model','Ui_Vhr307.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/penalty+edit:save','Ui_Vhr307.Edit','M',null,'A',null,null,null,null);

uis.path('/vhr/hpr/penalty','vhr307');
uis.form('/vhr/hpr/penalty+add','/vhr/hpr/penalty','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpr/penalty+copy','/vhr/hpr/penalty','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpr/penalty+edit','/vhr/hpr/penalty','F','A','F','H','M','N',null,null);





uis.ready('/vhr/hpr/penalty+add','.model.');
uis.ready('/vhr/hpr/penalty+copy','.model.');
uis.ready('/vhr/hpr/penalty+edit','.model.');

commit;
end;
/
