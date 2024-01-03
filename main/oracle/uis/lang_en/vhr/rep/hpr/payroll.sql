prompt PATH TRANSLATE /vhr/rep/hpr/payroll
begin
uis.lang_en('#f:/vhr/rep/hpr/payroll','Payroll');
uis.lang_en('ui-vhr221:$1{order_no}) $2{accrued_oper_type_name}: $3{amount} $4{currency}','+ $2: $3 $4');
uis.lang_en('ui-vhr221:$1{order_no}) $2{accured_oper_type_name}: $3{amount} $4{currency}','+ $2: $3 $4');
uis.lang_en('ui-vhr221:$1{order_no}) $2{deducted_oper_type_name}: $3{amount} $4{currency}','- $2: $3 $4');
uis.lang_en('ui-vhr221:accrued: $1{total_accrual} $2{currency}','Paid: $1 $2');
uis.lang_en('ui-vhr221:approximately wage calculation','⚠️Approximately Remuneration');
uis.lang_en('ui-vhr221:day skip','Skip Track');
uis.lang_en('ui-vhr221:deducted: $1{total_deduction} $2{currency}','Deducted: $1 $2');
uis.lang_en('ui-vhr221:early','Early Check Out');
uis.lang_en('ui-vhr221:job: $1{job_name}','Job: $1');
uis.lang_en('ui-vhr221:lack','Absence');
uis.lang_en('ui-vhr221:lateness','Lateness');
uis.lang_en('ui-vhr221:left: $1{left_amount} $2{currency}','Left to pay: $1 $2');
uis.lang_en('ui-vhr221:mark skip','Skip Track');
uis.lang_en('ui-vhr221:month','Month:');
uis.lang_en('ui-vhr221:month: $1{yyyy-mm}','Month: $1');
uis.lang_en('ui-vhr221:no license','No license');
uis.lang_en('ui-vhr221:onetime accrual','One-time accrual');
uis.lang_en('ui-vhr221:onetime penalty','One-time deduction');
uis.lang_en('ui-vhr221:overtime','Overtime');
uis.lang_en('ui-vhr221:paid out: $1{credit} $2{currency}','Paid out: $1 $2');
uis.lang_en('ui-vhr221:paid out: $1{payment} $2{currency}','Paid out: $1 $2');
uis.lang_en('ui-vhr221:personal income tax','Personal Income Tax');
uis.lang_en('ui-vhr221:primary staff is not found for this user','No employees found for current user');
uis.lang_en('ui-vhr221:rank: $1{rank_name}','Rank: $1');
uis.lang_en('ui-vhr221:report payroll','Payroll');
uis.lang_en('ui-vhr221:select month','Select month');
uis.lang_en('ui-vhr221:tin: $1{tin}','TIN: $1');
uis.lang_en('ui-vhr221:to payoff: $1{total_accrual} $2{currency}','Amount Due: $1 $2');
uis.lang_en('ui-vhr221:wage','Salary');
uis.lang_en('ui-vhr221:worked days/hours: $1{fact_days}/$2{fact_hours}','Worked days/hours: $1/$2');
commit;
end;
/
