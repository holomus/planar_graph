prompt PATH TRANSLATE /vhr/gen/facts
begin
uis.lang_ru('#a:/vhr/gen/facts$select_devices','Выбрать устройство');
uis.lang_ru('#a:/vhr/gen/facts$select_request_kind','Выбрать вид отсутствия');
uis.lang_ru('#a:/vhr/gen/facts$select_staffs','Выбрать сотрудника');
uis.lang_ru('#f:/vhr/gen/facts','Генерация фактов');
uis.lang_ru('ui-vhr232:generate_requests: at least one request_kind should be selected','Должен быть выбран хотя бы один вид запроса.');
uis.lang_ru('ui-vhr232:generate_requests: request left border is later that right border','Левая граница запроса позже правой границы.');
commit;
end;
/
