prompt PATH TRANSLATE /vhr/hsc/fact_import
begin
uis.lang_ru('#a:/vhr/hsc/fact_import$save_setting','Сохранить настройки');
uis.lang_ru('#f:/vhr/hsc/fact_import','Факт (импорт)');
uis.lang_ru('ui-vhr548:$1{error message} with area name $2{area_name}','Ошибка с зоной: $2. $1');
uis.lang_ru('ui-vhr548:$1{error message} with driver name $2{driver_name}','Ошибка с драйвером: $2. $1');
uis.lang_ru('ui-vhr548:$1{error message} with fact date $2{fact_date}','Ошибка с датой факта: $2. $1');
uis.lang_ru('ui-vhr548:$1{error message} with fact type $2{fact_type}','Ошибка с типом факта: $2. $1');
uis.lang_ru('ui-vhr548:$1{error message} with fact value $2{fact_value}','Ошибка со значением факта: $2. $1');
uis.lang_ru('ui-vhr548:$1{error message} with object name $2{object_name}','Ошибка с объектом: $2. $1');
uis.lang_ru('ui-vhr548:area_name','Зона');
uis.lang_ru('ui-vhr548:driver_name','Драйвер');
uis.lang_ru('ui-vhr548:fact_date','Дата факта');
uis.lang_ru('ui-vhr548:fact_import: fact type $1{fact_type} must be in $2{allowed_types}','Тип факта $1 должен быть в $2');
uis.lang_ru('ui-vhr548:fact_import: fact value should be defined','Значение факта должен быть');
uis.lang_ru('ui-vhr548:fact_import:cant find area with name $1{area_name}','Зона $1 не найдена');
uis.lang_ru('ui-vhr548:fact_import:cant find driver with name $1{driver_name}','Драйвер $1 не найден');
uis.lang_ru('ui-vhr548:fact_type','Тип факта');
uis.lang_ru('ui-vhr548:fact_value','Значение факта');
uis.lang_ru('ui-vhr548:facts','Факты');
uis.lang_ru('ui-vhr548:object_name','Объект');
commit;
end;
/
