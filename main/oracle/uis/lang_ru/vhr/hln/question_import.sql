prompt PATH TRANSLATE /vhr/hln/question_import
begin
uis.lang_ru('#a:/vhr/hln/question_import$save_setting','Сохранить');
uis.lang_ru('#f:/vhr/hln/question_import','База вопросов (импорт)');
uis.lang_ru('ui-vhr243:$1{error message} with answer type $2{answer_type}','Ошибка $1, связанная с типом ответа: $2');
uis.lang_ru('ui-vhr243:$1{error message} with code $2{code}','Ошибка $1, связанная с кодом: $2');
uis.lang_ru('ui-vhr243:$1{error message} with question name $2{question_name}','Ошибка $1, связанная с названием: $2');
uis.lang_ru('ui-vhr243:$1{error message} with right option no $2{right_option_no}','Ошибка $1, связанная с правильными ответами: $2');
uis.lang_ru('ui-vhr243:$1{error message} with writing hint $2{writing_hint}','Ошибка $1, связанная с подсказкой: $2');
uis.lang_ru('ui-vhr243:answer_type','Тип ответа');
uis.lang_ru('ui-vhr243:code','Код');
uis.lang_ru('ui-vhr243:option$1','Ответ номер $1');
uis.lang_ru('ui-vhr243:question_import: answer type {answer_type $1} must be in ($2, $3, $4)','Тип ответа ($1) должeн быть в ($2, $3, $4)');
uis.lang_ru('ui-vhr243:question_import: option count must be between 2 and 10, option_count $1','Кол-во ответов($1) должно быть между 2 и 10');
uis.lang_ru('ui-vhr243:question_import: right option no must be number and between 1 and $1, $2{right_option_no}','Номера правильных ответов($2) должны быть между 1 и $1');
uis.lang_ru('ui-vhr243:question_name','Название');
uis.lang_ru('ui-vhr243:questions','Вопросы');
uis.lang_ru('ui-vhr243:right_option_no','Правильные ответы');
uis.lang_ru('ui-vhr243:writing_hint','Подсказка');
commit;
end;
/
