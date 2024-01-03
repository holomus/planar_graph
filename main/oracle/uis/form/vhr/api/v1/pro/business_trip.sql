set define off
prompt PATH /vhr/api/v1/pro/business_trip
begin
uis.route('/vhr/api/v1/pro/business_trip$list','Ui_Vhr289.List_Business_Trips','M','JO','A',null,null,null,null);

uis.path('/vhr/api/v1/pro/business_trip','vhr289');
uis.form('/vhr/api/v1/pro/business_trip','/vhr/api/v1/pro/business_trip','F','A','E','Z','M','N',null,'N');



uis.action('/vhr/api/v1/pro/business_trip','list','F',null,null,'A');


uis.ready('/vhr/api/v1/pro/business_trip','.list.model.');

commit;
end;
/
