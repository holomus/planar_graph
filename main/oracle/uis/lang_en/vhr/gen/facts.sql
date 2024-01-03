prompt PATH TRANSLATE /vhr/gen/facts
begin
uis.lang_en('#a:/vhr/gen/facts$select_devices','Select device');
uis.lang_en('#a:/vhr/gen/facts$select_request_kind','Select absence type');
uis.lang_en('#a:/vhr/gen/facts$select_staffs','Select employee');
uis.lang_en('#f:/vhr/gen/facts','Generate Facts');
uis.lang_en('ui-vhr232:generate_requests: at least one request_kind should be selected','At least one Request kind should be selected.');
uis.lang_en('ui-vhr232:generate_requests: request left border is later that right border','Request left border is later than the right border.');
commit;
end;
/
