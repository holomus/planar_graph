set define off
prompt PATH /vhr/href/business_trip_reason
begin
uis.route('/vhr/href/business_trip_reason+add:code_is_unique','Ui_Vhr179.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/business_trip_reason+add:model','Ui_Vhr179.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/href/business_trip_reason+add:save','Ui_Vhr179.Add','M','M','A',null,null,null,null);
uis.route('/vhr/href/business_trip_reason+edit:code_is_unique','Ui_Vhr179.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/href/business_trip_reason+edit:model','Ui_Vhr179.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/business_trip_reason+edit:save','Ui_Vhr179.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/href/business_trip_reason','vhr179');
uis.form('/vhr/href/business_trip_reason+add','/vhr/href/business_trip_reason','F','A','F','H','M','N',null,'N');
uis.form('/vhr/href/business_trip_reason+edit','/vhr/href/business_trip_reason','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/business_trip_reason+add','.model.');
uis.ready('/vhr/href/business_trip_reason+edit','.model.');

commit;
end;
/
