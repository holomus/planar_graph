set define off
prompt PATH /vhr/api/v1/pro/business_trip_reason
begin
uis.route('/vhr/api/v1/pro/business_trip_reason$create','Ui_Vhr424.Create_Business_Trip_Reason','M','M','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/business_trip_reason$delete','Ui_Vhr424.Delete_Business_Trip_Reason','M',null,'A',null,null,null,null);
uis.route('/vhr/api/v1/pro/business_trip_reason$list','Ui_Vhr424.List_Business_Trip_Reasons','M','JO','A',null,null,null,null);
uis.route('/vhr/api/v1/pro/business_trip_reason$update','Ui_Vhr424.Update_Business_Trip_Reason','M',null,'A',null,null,null,null);

uis.path('/vhr/api/v1/pro/business_trip_reason','vhr424');
uis.form('/vhr/api/v1/pro/business_trip_reason','/vhr/api/v1/pro/business_trip_reason','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/business_trip_reason','create','F',null,null,'A');
uis.action('/vhr/api/v1/pro/business_trip_reason','delete','F',null,null,'A');
uis.action('/vhr/api/v1/pro/business_trip_reason','list','F',null,null,'A');
uis.action('/vhr/api/v1/pro/business_trip_reason','update','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/business_trip_reason','.create.delete.list.model.update.');

commit;
end;
/
