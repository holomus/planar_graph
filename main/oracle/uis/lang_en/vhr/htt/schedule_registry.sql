prompt PATH TRANSLATE /vhr/htt/schedule_registry
begin
uis.lang_en('#a:/vhr/htt/schedule_registry+robot_add$add_calendar','Create production calendar');
uis.lang_en('#a:/vhr/htt/schedule_registry+robot_add$select_calendar','Select production calendar');
uis.lang_en('#a:/vhr/htt/schedule_registry+robot_add$select_robot','Select position');
uis.lang_en('#a:/vhr/htt/schedule_registry+robot_edit$add_calendar','Create production calendar');
uis.lang_en('#a:/vhr/htt/schedule_registry+robot_edit$select_calendar','Select production calendar');
uis.lang_en('#a:/vhr/htt/schedule_registry+robot_edit$select_staff','Select employee');
uis.lang_en('#a:/vhr/htt/schedule_registry+staff_add$add_calendar','Create production calendar');
uis.lang_en('#a:/vhr/htt/schedule_registry+staff_add$select_calendar','Select production calendar');
uis.lang_en('#a:/vhr/htt/schedule_registry+staff_add$select_staff','Select employee');
uis.lang_en('#a:/vhr/htt/schedule_registry+staff_edit$add_calendar','Create production calendar');
uis.lang_en('#a:/vhr/htt/schedule_registry+staff_edit$select_calendar','Select production calendar');
uis.lang_en('#a:/vhr/htt/schedule_registry+staff_edit$select_staff','Select employee');
uis.lang_en('#f:/vhr/htt/schedule_registry+robot_add','Individual Work Schedule / New');
uis.lang_en('#f:/vhr/htt/schedule_registry+robot_edit','Individual Work Schedule / Edit');
uis.lang_en('#f:/vhr/htt/schedule_registry+staff_add','Individual schedule / New');
uis.lang_en('#f:/vhr/htt/schedule_registry+staff_edit','Individual schedule / Edit');
uis.lang_en('ui-vhr446:$1{error message} with robot $2{robot_id}','$1 with position, Position ID: $2');
uis.lang_en('ui-vhr446:$1{error message} with staff $2{staff_id}','$1 with employee, Employee ID: $2');
uis.lang_en('ui-vhr446:1-all data types must be text','1.All data types should be in text format');
uis.lang_en('ui-vhr446:2-code must be unique','2.Code must be unique');
uis.lang_en('ui-vhr446:3-if there is no break, the beginning and the end of the break do not need to be written','3.Break start and Break end must be empty, if there is no break');
uis.lang_en('ui-vhr446:begin break time','Break start');
uis.lang_en('ui-vhr446:begin time','Start Time');
uis.lang_en('ui-vhr446:break enabled(y or n (y-yes, n-no))','Break(Y or N (Y - yes, N - no))');
uis.lang_en('ui-vhr446:code','Code');
uis.lang_en('ui-vhr446:code not found in metadata, please check code to correctly, date: $1{date}, row: $2{row}, code: $3{code}','Code not found in metadata, Date : $1, Row: $2, Code: $3');
uis.lang_en('ui-vhr446:division_name','Department');
uis.lang_en('ui-vhr446:employee_name','Name');
uis.lang_en('ui-vhr446:end break time','Break end');
uis.lang_en('ui-vhr446:end time','End Time');
uis.lang_en('ui-vhr446:example','Example');
uis.lang_en('ui-vhr446:id','ID');
uis.lang_en('ui-vhr446:job_name','Job');
uis.lang_en('ui-vhr446:plan time','By plan (hours)');
uis.lang_en('ui-vhr446:robot_name','Position');
commit;
end;
/