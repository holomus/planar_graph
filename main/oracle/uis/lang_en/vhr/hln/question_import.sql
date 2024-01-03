prompt PATH TRANSLATE /vhr/hln/question_import
begin
uis.lang_en('#a:/vhr/hln/question_import$save_setting','Save');
uis.lang_en('#f:/vhr/hln/question_import','Questions / Import');
uis.lang_en('ui-vhr243:$1{error message} with answer type $2{answer_type}','Error $1 in Answer Type: $2');
uis.lang_en('ui-vhr243:$1{error message} with code $2{code}','Error $1 in Code: $2');
uis.lang_en('ui-vhr243:$1{error message} with question name $2{question_name}','Error $1 in Name: $2');
uis.lang_en('ui-vhr243:$1{error message} with right option no $2{right_option_no}','Error $1 in Correct Answers: $2');
uis.lang_en('ui-vhr243:$1{error message} with writing hint $2{writing_hint}','Error $1 in Hint: $2');
uis.lang_en('ui-vhr243:answer_type','Answer Type');
uis.lang_en('ui-vhr243:code','Code');
uis.lang_en('ui-vhr243:option$1','Answer $1');
uis.lang_en('ui-vhr243:question_import: answer type {answer_type $1} must be in ($2, $3, $4)','$1 answer type must be in ($2, $3, $4)');
uis.lang_en('ui-vhr243:question_import: option count must be between 2 and 10, option_count $1','$1 answers qty must be between 2 and 10');
uis.lang_en('ui-vhr243:question_import: right option no must be number and between 1 and $1, $2{right_option_no}','$2 correct answers numbers must be between 1 and $1');
uis.lang_en('ui-vhr243:question_name','Name');
uis.lang_en('ui-vhr243:questions','Questions');
uis.lang_en('ui-vhr243:right_option_no','Correct Answers');
uis.lang_en('ui-vhr243:writing_hint','Hint');
commit;
end;
/
