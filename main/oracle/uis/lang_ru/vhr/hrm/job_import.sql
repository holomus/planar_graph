prompt PATH TRANSLATE /vhr/hrm/job_import
begin
uis.lang_ru('#a:/vhr/hrm/job_import$save_setting','Сохранить настройки');
uis.lang_ru('#f:/vhr/hrm/job_import','Импорт должностей');
uis.lang_ru('ui-vhr667:$1{error message} with coa $2{coa}','$1 связанная со счетом затрат: $2');
uis.lang_ru('ui-vhr667:$1{error message} with code $2{code}','$1 связанная с кодом: $2');
uis.lang_ru('ui-vhr667:$1{error message} with job group $2{job_group}','$1 связанная с группой должностей: $2');
uis.lang_ru('ui-vhr667:$1{error message} with job name $2{job_name}','$1 связанная с должностью: $2');
uis.lang_ru('ui-vhr667:$1{error message} with role $2{role_name}','$1 связанная с ролью: $2');
uis.lang_ru('ui-vhr667:code','Код');
uis.lang_ru('ui-vhr667:job_coa','Счет затрат');
uis.lang_ru('ui-vhr667:job_group','Группа должностей');
uis.lang_ru('ui-vhr667:job_name','Должность');
uis.lang_ru('ui-vhr667:jobs','Должности');
uis.lang_ru('ui-vhr667:role','Роль');
commit;
end;
/
