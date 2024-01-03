set define off
prompt PATH /vhr/api/v1/rec/vacancy
begin
uis.route('/vhr/api/v1/rec/vacancy$jobs','Ui_Vhr656.List_Jobs','M','JO','A',null,null,null,null,'BR,BS');
uis.route('/vhr/api/v1/rec/vacancy$regions','Ui_Vhr656.List_Regions','M','JO','A',null,null,null,null,'BR,BS');
uis.route('/vhr/api/v1/rec/vacancy$testing','Ui_Vhr656.Load_Vacancy_Exam','M','JO','A',null,null,null,null,'BR,BS');
uis.route('/vhr/api/v1/rec/vacancy$vacancies','Ui_Vhr656.List_Vacancies','M','JO','A',null,null,null,null,'BR,BS');

uis.path('/vhr/api/v1/rec/vacancy','vhr656');
uis.form('/vhr/api/v1/rec/vacancy','/vhr/api/v1/rec/vacancy','F','A','E','Z','M','N',null,'N','BR,BS');



uis.action('/vhr/api/v1/rec/vacancy','jobs','F',null,null,'A');
uis.action('/vhr/api/v1/rec/vacancy','regions','F',null,null,'A');
uis.action('/vhr/api/v1/rec/vacancy','testing','F',null,null,'A');
uis.action('/vhr/api/v1/rec/vacancy','vacancies','F',null,null,'A');


uis.ready('/vhr/api/v1/rec/vacancy','.jobs.model.regions.testing.vacancies.');

commit;
end;
/
