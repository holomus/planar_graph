prompt PATH TRANSLATE /vhr/hpd/hiring_import
begin
uis.lang_ru('#a:/vhr/hpd/hiring_import$save_setting','Сохранить настройки');
uis.lang_ru('#f:/vhr/hpd/hiring_import','Прием на работу (импорт)');
uis.lang_ru('ui-vhr126:$1{error message} with concluding term $2{concluding_term}','$1 связанная со сроком заключения договора: $2');
uis.lang_ru('ui-vhr126:$1{error message} with contract date $2{hiring_date}','$1 связанная с датой договора: $2');
uis.lang_ru('ui-vhr126:$1{error message} with contract number $2{contract_number}','$1 связанная с номером договора: $2');
uis.lang_ru('ui-vhr126:$1{error message} with division $2{division}','$1 связанная с подразделением: $2');
uis.lang_ru('ui-vhr126:$1{error message} with employee $2{employee}','$1 связанная с сотрудником: $2');
uis.lang_ru('ui-vhr126:$1{error message} with expiry date $2{expiry_date}','$1 связанная со сроком истечения договора: $2');
uis.lang_ru('ui-vhr126:$1{error message} with fixed term $2{fixed_term}','$1 связанная с основанием срочного договора: $2');
uis.lang_ru('ui-vhr126:$1{error message} with fte $2{fte}','$1 связанная  со ставкой $2');
uis.lang_ru('ui-vhr126:$1{error message} with hiring conditions $2{hiring_conditions}','$1 связанная с условиями приема: $2');
uis.lang_ru('ui-vhr126:$1{error message} with hiring date $2{hiring_date}','$1 связанная с датой приема: $2');
uis.lang_ru('ui-vhr126:$1{error message} with indicator value $2{indicator_value}','$1 связанная с показателем: $2');
uis.lang_ru('ui-vhr126:$1{error message} with job $2{job}','$1 связанная с должностью: $2');
uis.lang_ru('ui-vhr126:$1{error message} with oper type $2{oper_type_name}','$1 связанная с начислением: $2');
uis.lang_ru('ui-vhr126:$1{error message} with other conditions $2{other_conditions}','$1 связанная с иными условиями: $2');
uis.lang_ru('ui-vhr126:$1{error message} with rank $2{rank}','$1 связанная с разрядом: $2');
uis.lang_ru('ui-vhr126:$1{error message} with representative basis $2{representative_basis}','$1 связанная с основанием представителя: $2');
uis.lang_ru('ui-vhr126:$1{error message} with robot $2{robot}','$1 связанная  со позицией $2');
uis.lang_ru('ui-vhr126:$1{error message} with schedule $2{schedule}','$1 связанная с графиком работы: $2');
uis.lang_ru('ui-vhr126:$1{error message} with staff number $2{staff_number}','$1 связанная с табельным номером: $2');
uis.lang_ru('ui-vhr126:$1{error message} with trial period $2{trial_period}','$1 связанная с испыт. сроком: $2');
uis.lang_ru('ui-vhr126:$1{error message} with vacation days limit $2{vacation_days_limit}','$1 связанная с кол-вом отпускных дней (в год): $2');
uis.lang_ru('ui-vhr126:$1{error message} with workplace equipment $2{workplace_equipment}','$1 связанная с оборудованием рабочего места: $2');
uis.lang_ru('ui-vhr126:concluding term','Срок заключения договора');
uis.lang_ru('ui-vhr126:contract date','Дата договора');
uis.lang_ru('ui-vhr126:contract number','Номер договора');
uis.lang_ru('ui-vhr126:division code','Код подразделения');
uis.lang_ru('ui-vhr126:division name','Подразделение');
uis.lang_ru('ui-vhr126:employee code','Код сотрудника');
uis.lang_ru('ui-vhr126:employee name','ФИО');
uis.lang_ru('ui-vhr126:employment type name','Вид работы');
uis.lang_ru('ui-vhr126:expiry date','Срок действия договора');
uis.lang_ru('ui-vhr126:fixed term','Срочный трудовой договор');
uis.lang_ru('ui-vhr126:fixed term base code','Основание срочного договора (код)');
uis.lang_ru('ui-vhr126:fixed term base name','Основание срочного договора');
uis.lang_ru('ui-vhr126:fixed_term:no','Нет');
uis.lang_ru('ui-vhr126:fixed_term:yes','Да');
uis.lang_ru('ui-vhr126:fte','Ставка');
uis.lang_ru('ui-vhr126:hiring conditions','Условия приема');
uis.lang_ru('ui-vhr126:hiring date','Дата приема');
uis.lang_ru('ui-vhr126:hirings','Прием списком');
uis.lang_ru('ui-vhr126:identifier:code','Код');
uis.lang_ru('ui-vhr126:identifier:name','Название');
uis.lang_ru('ui-vhr126:indicator value','Показатель');
uis.lang_ru('ui-vhr126:job code','Код должности');
uis.lang_ru('ui-vhr126:job name','Должность');
uis.lang_ru('ui-vhr126:oper type name','Начисление');
uis.lang_ru('ui-vhr126:other conditions','Иные условия');
uis.lang_ru('ui-vhr126:rank','Разряд');
uis.lang_ru('ui-vhr126:rank code','Разряд (код)');
uis.lang_ru('ui-vhr126:rank name','Разряд');
uis.lang_ru('ui-vhr126:representative basis','Основание представителя');
uis.lang_ru('ui-vhr126:robot code','Код позиции');
uis.lang_ru('ui-vhr126:robot name','Позиция');
uis.lang_ru('ui-vhr126:schedule code','График работы (код)');
uis.lang_ru('ui-vhr126:schedule name','График работы');
uis.lang_ru('ui-vhr126:staff_number','Табельный номер');
uis.lang_ru('ui-vhr126:trial period','Испыт. срок (дней)');
uis.lang_ru('ui-vhr126:vacation days limit','Кол-во отпускных дней (в год)');
uis.lang_ru('ui-vhr126:vacation days limit must be between 0 and 365','Кол-во отпускных дней (в  год) должно быть в промежутке от 0 до 365)');
uis.lang_ru('ui-vhr126:workplace equipment','Оборудование рабочего места');
commit;
end;
/
