set define off
prompt PATH /vhr/hac/dss_server
begin
uis.route('/vhr/hac/dss_server+add:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/dss_server+add:save','Ui_Vhr504.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hac/dss_server+edit:model','Ui_Vhr504.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hac/dss_server+edit:save','Ui_Vhr504.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hac/dss_server','vhr504');
uis.form('/vhr/hac/dss_server+add','/vhr/hac/dss_server','A','A','F','H','M','Y',null,'N');
uis.form('/vhr/hac/dss_server+edit','/vhr/hac/dss_server','A','A','F','H','M','Y',null,'N');





uis.ready('/vhr/hac/dss_server+edit','.model.');
uis.ready('/vhr/hac/dss_server+add','.model.');

commit;
end;
/
