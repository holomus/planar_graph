prompt migr from 17.08.2022 1.ddl
----------------------------------------------------------------------------------------------------
prompt new table href_ftes
----------------------------------------------------------------------------------------------------
create table href_ftes(
  company_id                      number(20)         not null,
  fte_id                          number(20)         not null,
  name                            varchar2(100 char) not null,
  fte_value                       number(7,6)        not null,
  order_no                        number(6),
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_ftes_pk primary key (company_id, fte_id) using index tablespace GWS_INDEX,
  constraint href_ftes_u1 unique (fte_id) using index tablespace GWS_INDEX,
  constraint href_ftes_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_ftes_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_ftes_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_ftes_c2 check (fte_value <= 1 and fte_value > 0),
  constraint href_ftes_c3 check (decode(trim(pcode), pcode, 1, 0) = 1)
) tablespace GWS_DATA;

create unique index href_ftes_u2 on href_ftes(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;
create unique index href_ftes_u3 on href_ftes(company_id, lower(name)) tablespace GWS_INDEX;

create index href_ftes_i1 on href_ftes(company_id, created_by) tablespace GWS_INDEX;
create index href_ftes_i2 on href_ftes(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding wage sheet tables
----------------------------------------------------------------------------------------------------
-- Wage sheets
----------------------------------------------------------------------------------------------------
create table hpr_wage_sheets(
  company_id                  number(20)        not null,
  filial_id                   number(20)        not null,
  sheet_id                    number(20)        not null,
  sheet_number                varchar2(50 char) not null,
  sheet_date                  date              not null,
  month                       as (trunc(period_begin, 'mon')),
  period_begin                date              not null,
  period_end                  date              not null,  
  period_kind                 varchar2(1)       not null,
  division_id                 number(20),
  note                        varchar2(300 char),
  posted                      varchar2(1),
  created_by                  number(20)        not null,
  created_on                  timestamp with local time zone not null,
  modified_by                 number(20)        not null,
  modified_on                 timestamp with local time zone not null,
  constraint hpr_wage_sheets_pk primary key (company_id, filial_id, sheet_id) using index tablespace GWS_INDEX,
  constraint hpr_wage_sheets_u1 unique (sheet_id) using index tablespace GWS_INDEX,
  constraint hpr_wage_sheets_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_wage_sheets_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpr_wage_sheets_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpr_wage_sheets_c1 check (decode(trim(sheet_number), sheet_number, 1, 0) = 1),
  constraint hpr_wage_sheets_c2 check (trunc(sheet_date) = sheet_date),
  constraint hpr_wage_sheets_c3 check (trunc(period_begin) = period_begin and trunc(period_end) = period_end),
  constraint hpr_wage_sheets_c4 check (period_begin <= period_end and trunc(period_begin, 'mon') = trunc(period_end, 'mon')),
  constraint hpr_wage_sheets_c5 check (period_kind in ('M', 'F', 'S', 'C')),
  constraint hpr_wage_sheets_c6 check (posted in ('Y', 'N')),
  constraint hpr_wage_sheets_c7 check (period_kind = 'M' and period_begin = trunc(period_begin, 'mon') 
                                                         and period_end = last_day(period_begin) or
                                       period_kind = 'F' and period_begin = trunc(period_begin, 'mon') 
                                                         and period_end = (period_begin + trunc((last_day(period_begin) - period_begin + 1) / 2) - 1) or
                                       period_kind = 'S' and period_end = last_day(period_begin) 
                                                         and period_begin = (trunc(period_begin, 'mon') + trunc((last_day(period_begin) - trunc(period_begin, 'mon') + 1) / 2)) or
                                       period_kind = 'C')
) tablespace GWS_DATA; 

comment on table hpr_wage_sheets is 'Keeps wage info when using Verifix Start';

comment on column hpr_wage_sheets.period_kind is 'Full (M)onth, (F)irst half, (S)econd half of month, (C)ustom period';
comment on column hpr_wage_sheets.posted      is '(Y)es, (N)o';

create index hpr_wage_sheets_i1 on hpr_wage_sheets(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_wage_sheets_i2 on hpr_wage_sheets(company_id, created_by) tablespace GWS_INDEX;
create index hpr_wage_sheets_i3 on hpr_wage_sheets(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_sheet_parts(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  part_id                         number(20)   not null,
  part_begin                      date         not null,
  part_end                        date         not null,
  staff_id                        number(20)   not null,
  sheet_id                        number(20)   not null,
  division_id                     number(20)   not null,
  job_id                          number(20)   not null,
  schedule_id                     number(20),
  fte_id                          number(20),
  monthly_amount                  number(20,6) not null,
  plan_amount                     number(20,6) not null,
  wage_amount                     number(20,6) not null,
  late_amount                     number(20,6) not null,
  early_amount                    number(20,6) not null,
  lack_amount                     number(20,6) not null,
  penalty_amount                  as (late_amount + early_amount + lack_amount),
  amount                          as (wage_amount - (late_amount + early_amount + lack_amount)),
  constraint hpr_sheet_parts_pk primary key (company_id, filial_id, part_id) using index tablespace GWS_INDEX,
  constraint hpr_sheet_parts_u1 unique (part_id) using index tablespace GWS_INDEX,
  constraint hpr_sheet_parts_f1 foreign key (company_id, filial_id, sheet_id) references hpr_wage_sheets(company_id, filial_id, sheet_id) on delete cascade,
  constraint hpr_sheet_parts_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_sheet_parts_f3 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_sheet_parts_f4 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpr_sheet_parts_f5 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpr_sheet_parts_f6 foreign key (company_id, fte_id) references href_ftes(company_id, fte_id),
  constraint hpr_sheet_parts_c1 check (part_begin <= part_end),
  constraint hpr_sheet_parts_c2 check (monthly_amount >= 0 and plan_amount >= 0 and wage_amount >= 0 and late_amount >= 0 and early_amount >= 0 and lack_amount >= 0)
) tablespace GWS_DATA;

comment on table hpr_sheet_parts is 'Keeps sheet staffs info';

comment on column hpr_sheet_parts.schedule_id is 'Value from part_end day. No Index';
comment on column hpr_sheet_parts.job_id      is 'Value from part_end day. No Index';
comment on column hpr_sheet_parts.division_id is 'Value from part_end day. No Index';
comment on column hpr_sheet_parts.fte_id      is 'Value from part_end day. No Index. When null show closest fte value';

create index hpr_sheet_parts_i1 on hpr_sheet_parts(company_id, filial_id, staff_id, part_begin, part_end) tablespace GWS_INDEX;
create index hpr_sheet_parts_i2 on hpr_sheet_parts(company_id, filial_id, sheet_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding sheet sequence
----------------------------------------------------------------------------------------------------
create sequence hpr_wage_sheet_sq;
create sequence hpr_sheet_parts_sq;

----------------------------------------------------------------------------------------------------
prompt changing hper_staff_plans_i1 index
----------------------------------------------------------------------------------------------------
drop index hper_staff_plans_i1;
create index hper_staff_plans_i1 on hper_staff_plans(company_id, filial_id, staff_id, plan_date) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
prompt exec fazo_z.run('href_ftes'); exec fazo_z.run('hpr_wage_sheet'); exec fazo_z.run('hpr_sheet_parts');
----------------------------------------------------------------------------------------------------
exec fazo_z.run('href_ftes');
exec fazo_z.run('hpr_wage_sheet');
exec fazo_z.run('hpr_sheet_parts');
