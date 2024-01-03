set define off
prompt PATH /vhr/htt/acms_server
begin
uis.route('/vhr/htt/acms_server+add:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/acms_server+add:save','Ui_Vhr471.Add','M','M','A',null,null,null,null);
uis.route('/vhr/htt/acms_server+edit:model','Ui_Vhr471.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/acms_server+edit:save','Ui_Vhr471.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/htt/acms_server','vhr471');
uis.form('/vhr/htt/acms_server+add','/vhr/htt/acms_server','A','A','F','H','M','N',null,null);
uis.form('/vhr/htt/acms_server+edit','/vhr/htt/acms_server','A','A','F','H','M','N',null,null);





uis.ready('/vhr/htt/acms_server+add','.model.');
uis.ready('/vhr/htt/acms_server+edit','.model.');

commit;
end;
/
