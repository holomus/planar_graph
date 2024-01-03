prompt PATH TRANSLATE /vhr/hsc/job_norm_import
begin
uis.lang_ru('#a:/vhr/hsc/job_norm_import$save_setting','Сохранить настройки');
uis.lang_ru('#f:/vhr/hsc/job_norm_import','Норма по должностям (импорт)');
uis.lang_ru('ui-vhr561:$1{error message} with absense margin $2{absense_margin}','Ошибка $1 с Отпуска и больничные (%)  $2');
uis.lang_ru('ui-vhr561:$1{error message} with idle margin $2{idle_margin}','Ошибка $1 с Простой (%) $2');
uis.lang_ru('ui-vhr561:$1{error message} with job name $2{job_name}','Ошибка $1 с должностью: $2');
uis.lang_ru('ui-vhr561:$1{error message} with month $2{month}','Ошибка $1 с месяцем: $2');
uis.lang_ru('ui-vhr561:$1{error message} with monthky days $2{monthly_days}','Ошибка $1 с нормой дней: $2');
uis.lang_ru('ui-vhr561:$1{error message} with monthly hours $2{monthly_hours}','Ошибка $1 с нормой часов: $2');
uis.lang_ru('ui-vhr561:absense_margin','Отпуска и больничные (%)*');
uis.lang_ru('ui-vhr561:idle_margin','Простой (%)');
uis.lang_ru('ui-vhr561:job_name','Должность');
uis.lang_ru('ui-vhr561:month','Месяц');
uis.lang_ru('ui-vhr561:monthly_days','Норма дней');
uis.lang_ru('ui-vhr561:monthly_hours','Норма часов');
uis.lang_ru('ui-vhr561:norm_import: absense margin should be defined','Отпуска и больничные (%) должны быть определены');
uis.lang_ru('ui-vhr561:norm_import: idle margin should be defined','Месяц должен быть определен');
uis.lang_ru('ui-vhr561:norm_import: month should be defined','Норма часов должна быть определена');
uis.lang_ru('ui-vhr561:norm_import: monthly days should be defined','Норма дней должна быть определена');
uis.lang_ru('ui-vhr561:norm_import: monthly hours should be defined','Норма часов должна быть определена');
uis.lang_ru('ui-vhr561:norm_import:cant find job with name $1{job_name}','Не удалось найти должность $1');
uis.lang_ru('ui-vhr561:norms','Нормы');
commit;
end;
/
