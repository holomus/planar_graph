prompt PATH TRANSLATE /vhr/rep/hpd/dismissal_reason
begin
uis.lang_en('#f:/vhr/rep/hpd/dismissal_reason','Report of dismissals by reason');
uis.lang_en('ui-vhr500:%','%');
uis.lang_en('ui-vhr500:... others','and others');
uis.lang_en('ui-vhr500:all','All');
uis.lang_en('ui-vhr500:count','Qty');
uis.lang_en('ui-vhr500:dismissal date','Dismissal Date');
uis.lang_en('ui-vhr500:dismissal reason','Dismissal Reason');
uis.lang_en('ui-vhr500:divisions: $1{division_names}','Department: $1');
uis.lang_en('ui-vhr500:employee name','Employee');
uis.lang_en('ui-vhr500:jobs: $1{job_names}','Job: $1');
uis.lang_en('ui-vhr500:key employee','Key Employee');
uis.lang_en('ui-vhr500:key employee: $1{is_key_employee_name}','Key Employee: $1');
uis.lang_en('ui-vhr500:last division','Last Department');
uis.lang_en('ui-vhr500:last job','Last Department');
uis.lang_en('ui-vhr500:no reason','Reason not selected');
uis.lang_en('ui-vhr500:not key employee','Not Key Employee');
uis.lang_en('ui-vhr500:period: from $1{begin_date} to $2{end_date}','Period: $1 - $2');
uis.lang_en('ui-vhr500:reason type: $1{reason_type}','Reason Type: $1');
uis.lang_en('ui-vhr500:reason: $1{reason_name}','Reason: $1');
uis.lang_en('ui-vhr500:reason_detail','Details');
commit;
end;
/
