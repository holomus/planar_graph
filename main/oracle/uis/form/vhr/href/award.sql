set define off
prompt PATH /vhr/href/award
begin
uis.route('/vhr/href/award+add:model','Ui_Vhr29.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/award+add:name_is_unique','Ui_Vhr29.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/award+add:save','Ui_Vhr29.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/award+edit:model','Ui_Vhr29.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/award+edit:name_is_unique','Ui_Vhr29.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/award+edit:save','Ui_Vhr29.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/award','vhr29');
uis.form('/vhr/href/award+add','/vhr/href/award','A','A','F','HM','M','N',null,'N');
uis.form('/vhr/href/award+edit','/vhr/href/award','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/award+add','.model.');
uis.ready('/vhr/href/award+edit','.model.');

commit;
end;
/
