prompt migr from 10.02.2022

----------------------------------------------------------------------------------------------------
create table hpr_advance_settings(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  payment_id                      number(20)  not null,
  limit_kind                      varchar2(1) not null,
  days_limit                      number(3),  
  constraint hpr_advance_settings_pk primary key (company_id, filial_id, payment_id) using index tablespace GWS_INDEX,
  constraint hpr_advance_settings_f1 foreign key (company_id, filial_id, payment_id) references mpr_payments(company_id, filial_id, payment_id) on delete cascade,
  constraint hpr_advance_settings_c1 check (limit_kind in ('T', 'C')),
  constraint hpr_advance_settings_c2 check (days_limit between 0 and 366),
  constraint hpr_advance_settings_c3 check (decode(limit_kind , 'T', 1, 0) <= nvl2(days_limit, 1, 0))
) tablespace GWS_DATA;

comment on table hpr_advance_settings is 'Keeps advance settings. Does not include payroll info';

comment on column hpr_advance_settings.limit_kind is '(T)urnout, (C)alendar days. On (T)urnout days_limit will count only turnout days';
comment on column hpr_advance_settings.days_limit is 'Employees that worked less than this number will not be given advance';
