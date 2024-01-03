prompt PATH TRANSLATE /vhr/hsc/job_round_import
begin
uis.lang_ru('#f:/vhr/hsc/job_round_import','Округления по должностям (импорт)');
uis.lang_ru('ui-vhr646:$1{error message} with job name $2{job_name}','Ошибка $1 с должностью: $2');
uis.lang_ru('ui-vhr646:$1{error message} with round model type $2{round_model_type}','Ошибка $1 с видом округления $2');
uis.lang_ru('ui-vhr646:job_name','Должность');
uis.lang_ru('ui-vhr646:round_import: round model type should be defined','Вид округления должен быть определен');
uis.lang_ru('ui-vhr646:round_import: round model type should be in $1{round_model_types}','Вид округления должен быть одним из $1');
uis.lang_ru('ui-vhr646:round_import:cant find job with name $1{job_name}','Не удалось найти должность $1');
uis.lang_ru('ui-vhr646:round_model_type','Вид округления');
uis.lang_ru('ui-vhr646:rounds','Округления');
commit;
end;
/
