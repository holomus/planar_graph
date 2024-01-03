prompt PATH TRANSLATE /vhr/hes/hikvision_service
begin
uis.lang_ru('#f:/vhr/hes/hikvision_service','Сервис Hikvision');
uis.lang_ru('ui-vhr470:the person is not attached to the location where the device is installed, filial_id=$2, location_id=$1, person_id=$3','Физическое лицо не прикреплено к локации, где установлено устройство. ИД организации = $2, ИД локации = $1, ИД физического лица = $3');
commit;
end;
/
