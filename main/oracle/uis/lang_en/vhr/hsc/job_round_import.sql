prompt PATH TRANSLATE /vhr/hsc/job_round_import
begin
uis.lang_en('#f:/vhr/hsc/job_round_import','Job Round / Import');
uis.lang_en('ui-vhr646:$1{error message} with job name $2{job_name}','Error $1 with job: $2');
uis.lang_en('ui-vhr646:$1{error message} with round model type $2{round_model_type}','Error $1 with rounding type $2');
uis.lang_en('ui-vhr646:job_name','Job');
uis.lang_en('ui-vhr646:round_import: round model type should be defined','The rounding type must be specified');
uis.lang_en('ui-vhr646:round_import: round model type should be in $1{round_model_types}','The rounding type must be one of $1');
uis.lang_en('ui-vhr646:round_import:cant find job with name $1{job_name}','Could not find Job $1');
uis.lang_en('ui-vhr646:round_model_type','Rounding Type');
uis.lang_en('ui-vhr646:rounds','Rounding');
commit;
end;
/
