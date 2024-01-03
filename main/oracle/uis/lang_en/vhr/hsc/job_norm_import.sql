prompt PATH TRANSLATE /vhr/hsc/job_norm_import
begin
uis.lang_en('#a:/vhr/hsc/job_norm_import$save_setting','Save Settings');
uis.lang_en('#f:/vhr/hsc/job_norm_import','Norm by Jobs / Import');
uis.lang_en('ui-vhr561:$1{error message} with absense margin $2{absense_margin}','Error $1 from Holidays and sick days (%) $2');
uis.lang_en('ui-vhr561:$1{error message} with division name $2{division_name}','Error $1 in Department: $2');
uis.lang_en('ui-vhr561:$1{error message} with idle margin $2{idle_margin}','Error $1 with Simple (%) $2');
uis.lang_en('ui-vhr561:$1{error message} with job name $2{job_name}','Error $1 with job: $2');
uis.lang_en('ui-vhr561:$1{error message} with month $2{month}','Error $1 with month: $2');
uis.lang_en('ui-vhr561:$1{error message} with monthky days $2{monthly_days}','Error $1 with day norm: $2');
uis.lang_en('ui-vhr561:$1{error message} with monthly hours $2{monthly_hours}','Error $1 with hour norm: $2');
uis.lang_en('ui-vhr561:$1{error message} with round model type $2{round_model_type}','Error $1 with rounding type $2');
uis.lang_en('ui-vhr561:absense_margin','Vacations and sick leaves(%)*');
uis.lang_en('ui-vhr561:division_name','Department');
uis.lang_en('ui-vhr561:idle_margin','Simple (%)');
uis.lang_en('ui-vhr561:job_name','Job');
uis.lang_en('ui-vhr561:month','Month');
uis.lang_en('ui-vhr561:monthly_days','Norm of days');
uis.lang_en('ui-vhr561:monthly_hours','Hours norm');
uis.lang_en('ui-vhr561:norm_import: absense margin should be defined','Vacation and sick leave (%) to be determined');
uis.lang_en('ui-vhr561:norm_import: idle margin should be defined','Month must be specified');
uis.lang_en('ui-vhr561:norm_import: month should be defined','Hours must be determined');
uis.lang_en('ui-vhr561:norm_import: monthly days should be defined','The norm of days must be determined');
uis.lang_en('ui-vhr561:norm_import: monthly hours should be defined','Hours must be determined');
uis.lang_en('ui-vhr561:norm_import: round model type should be defined','Rounding type must be defined');
uis.lang_en('ui-vhr561:norm_import: round model type should be in $1{round_model_types}','Rounding type must be one of $1');
uis.lang_en('ui-vhr561:norm_import:cant find division with name $1{division_name}','Department $1 could not be found');
uis.lang_en('ui-vhr561:norm_import:cant find job with name $1{job_name}','Could not find Job $1');
uis.lang_en('ui-vhr561:norms','Norms');
uis.lang_en('ui-vhr561:round_model_type','Rounding Type');
commit;
end;
/
