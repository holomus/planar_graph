prompt HR License module
prompt (c) 2022 Verifix HR

----------------------------------------------------------------------------------------------------
create table hlic_required_intervals(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  interval_id                     number(20)  not null,
  staff_id                        number(20)  not null,
  employee_id                     number(20)  not null,
  start_date                      date        not null,
  finish_date                     date,
  status                          varchar2(1) not null,
  constraint hlic_required_intervals_pk primary key (company_id, interval_id) using index tablespace GWS_INDEX,
  constraint hlic_required_intervals_u1 unique (company_id, filial_id, staff_id) using index tablespace GWS_INDEX,
  constraint hlic_required_intervals_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hlic_required_intervals_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hlic_required_intervals_c1 check (start_date <= finish_date),
  constraint hlic_required_intervals_c2 check (status in ('C', 'S'))
) tablespace GWS_DATA;

comment on table hlic_required_intervals is 'employees whose licenses are required intervals';
comment on column hlic_required_intervals.status is '(C)ontinue to generate required dates, (S)top to generate';

create index hlic_required_intervals_i1 on hlic_required_intervals(company_id, status) tablespace GWS_INDEX;
create index hlic_required_intervals_i2 on hlic_required_intervals(company_id, filial_id, employee_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hlic_required_dates(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  interval_id                     number(20) not null,  
  required_date                   date       not null,
  employee_id                     number(20) not null,
  staff_id                        number(20) not null,
  constraint hlic_required_dates_pk primary key (company_id, interval_id, required_date) using index tablespace GWS_INDEX,
  constraint hlic_required_dates_u1 unique (company_id, filial_id, employee_id, required_date) using index tablespace GWS_INDEX,
  constraint hlic_required_dates_f1 foreign key (company_id, interval_id) references hlic_required_intervals(company_id, interval_id),
  constraint hlic_required_dates_f2 foreign key (company_id, filial_id, employee_id) references mhr_employees(company_id, filial_id, employee_id),
  constraint hlic_required_dates_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hlic_required_dates_c1 check (trunc(required_date) = required_date)
) tablespace GWS_DATA;

create index hlic_required_dates_i1 on hlic_required_dates(company_id, filial_id, staff_id) tablespace GWS_INDEX;
