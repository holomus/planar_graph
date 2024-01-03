set define off
prompt PATH /vhr/htt/location_type
begin
uis.route('/vhr/htt/location_type+add:model','Ui_Vhr160.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/location_type+add:save','Ui_Vhr160.Add','M','M','A',null,null,null,null);
uis.route('/vhr/htt/location_type+edit:model','Ui_Vhr160.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/location_type+edit:save','Ui_Vhr160.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/htt/location_type','vhr160');
uis.form('/vhr/htt/location_type+add','/vhr/htt/location_type','A','A','F','H','M','N',null,'N');
uis.form('/vhr/htt/location_type+edit','/vhr/htt/location_type','A','A','F','H','M','N',null,'N');






uis.ready('/vhr/htt/location_type+add','.model.');
uis.ready('/vhr/htt/location_type+edit','.model.');

commit;
end;
/
