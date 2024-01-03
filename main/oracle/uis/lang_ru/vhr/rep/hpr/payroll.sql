prompt PATH TRANSLATE /vhr/rep/hpr/payroll
begin
uis.lang_ru('#f:/vhr/rep/hpr/payroll','Заработная плата');
uis.lang_ru('ui-vhr221:$1{order_no}) $2{accrued_oper_type_name}: $3{amount} $4{currency}','+ $2: $3 $4');
uis.lang_ru('ui-vhr221:$1{order_no}) $2{accured_oper_type_name}: $3{amount} $4{currency}','+ $2: $3 $4');
uis.lang_ru('ui-vhr221:$1{order_no}) $2{deducted_oper_type_name}: $3{amount} $4{currency}','- $2: $3 $4');
uis.lang_ru('ui-vhr221:accrued: $1{total_accrual} $2{currency}','Начислено: $1 $2');
uis.lang_ru('ui-vhr221:approximately wage calculation','⚠️Предварительная оплата труда');
uis.lang_ru('ui-vhr221:day skip','Пропуск дня');
uis.lang_ru('ui-vhr221:deducted: $1{total_deduction} $2{currency}','Удержано: $1 $2');
uis.lang_ru('ui-vhr221:early','Ранний уход');
uis.lang_ru('ui-vhr221:job: $1{job_name}','Должность: $1');
uis.lang_ru('ui-vhr221:lack','Отсутствие');
uis.lang_ru('ui-vhr221:lateness','Опоздание');
uis.lang_ru('ui-vhr221:left: $1{left_amount} $2{currency}','Осталось выплатить: $1 $2');
uis.lang_ru('ui-vhr221:mark skip','Пропуск отметки');
uis.lang_ru('ui-vhr221:month','Месяц:');
uis.lang_ru('ui-vhr221:month: $1{yyyy-mm}','Месяц: $1');
uis.lang_ru('ui-vhr221:no license','Нет подписки');
uis.lang_ru('ui-vhr221:onetime accrual','Премия');
uis.lang_ru('ui-vhr221:onetime penalty','Штраф');
uis.lang_ru('ui-vhr221:overtime','Сверхурочно');
uis.lang_ru('ui-vhr221:paid out: $1{credit} $2{currency}','Выплачено: $1 $2');
uis.lang_ru('ui-vhr221:paid out: $1{payment} $2{currency}','Выплачено: $1 $2');
uis.lang_ru('ui-vhr221:personal income tax','НДФЛ');
uis.lang_ru('ui-vhr221:primary staff is not found for this user','Не найдены сотрудники для текущего пользователя');
uis.lang_ru('ui-vhr221:rank: $1{rank_name}','Разряд: $1');
uis.lang_ru('ui-vhr221:report payroll','Заработная плата');
uis.lang_ru('ui-vhr221:select month','Выберите месяц');
uis.lang_ru('ui-vhr221:tin: $1{tin}','ИНН: $1');
uis.lang_ru('ui-vhr221:to payoff: $1{total_accrual} $2{currency}','К выплате: $1 $2');
uis.lang_ru('ui-vhr221:wage','Оклад');
uis.lang_ru('ui-vhr221:worked days/hours: $1{fact_days}/$2{fact_hours}','Отработано дней/часов: $1/$2');
commit;
end;
/
