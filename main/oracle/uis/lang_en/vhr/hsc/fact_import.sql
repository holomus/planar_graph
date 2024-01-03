prompt PATH TRANSLATE /vhr/hsc/fact_import
begin
uis.lang_en('#a:/vhr/hsc/fact_import$save_setting','Save Settings');
uis.lang_en('#f:/vhr/hsc/fact_import','Fact (import)');
uis.lang_en('ui-vhr548:$1{error message} with area name $2{area_name}','Error with area: $2. $1');
uis.lang_en('ui-vhr548:$1{error message} with driver name $2{driver_name}','Error with driver: $2. $1');
uis.lang_en('ui-vhr548:$1{error message} with fact date $2{fact_date}','Error with fact date: $2. $1');
uis.lang_en('ui-vhr548:$1{error message} with fact type $2{fact_type}','Error with fact type: $2. $1');
uis.lang_en('ui-vhr548:$1{error message} with fact value $2{fact_value}','Error with fact value: $2. $1');
uis.lang_en('ui-vhr548:$1{error message} with object name $2{object_name}','Error with object: $2. $1');
uis.lang_en('ui-vhr548:area_name','Zone');
uis.lang_en('ui-vhr548:driver_name','Driver');
uis.lang_en('ui-vhr548:fact_date','Fact Date');
uis.lang_en('ui-vhr548:fact_import: fact type $1{fact_type} must be in $2{allowed_types}','Fact type $1 must be in allowed $2');
uis.lang_en('ui-vhr548:fact_import: fact value should be defined','Fact value should be defined');
uis.lang_en('ui-vhr548:fact_import:cant find area with name $1{area_name}','Could not find area $1');
uis.lang_en('ui-vhr548:fact_import:cant find driver with name $1{driver_name}','Could not find driver $1');
uis.lang_en('ui-vhr548:fact_type','Fact Type');
uis.lang_en('ui-vhr548:fact_value','Fact Value');
uis.lang_en('ui-vhr548:facts','Facts');
uis.lang_en('ui-vhr548:object_name','Object');
commit;
end;
/
