prompt migr from 17.10.2022 (1.ddl)
----------------------------------------------------------------------------------------------------
prompt changing wage sheets 
----------------------------------------------------------------------------------------------------
alter table hpr_wage_sheets add sheet_kind varchar2(1);

alter table hpr_wage_sheets drop constraint hpr_wage_sheets_c7;
alter table hpr_wage_sheets add constraint hpr_wage_sheets_c7 check (sheet_kind in ('R', 'O'));
alter table hpr_wage_sheets add constraint hpr_wage_sheets_c8 
                                check (period_kind = 'M' and period_begin = trunc(period_begin, 'mon')
                                                         and period_end = last_day(period_begin) or
                                       period_kind = 'F' and period_begin = trunc(period_begin, 'mon')
                                                         and period_end = (period_begin + trunc((last_day(period_begin) - period_begin + 1) / 2) - 1) or
                                       period_kind = 'S' and period_end = last_day(period_begin)
                                                         and period_begin = (trunc(period_begin, 'mon') + trunc((last_day(period_begin) - trunc(period_begin, 'mon') + 1) / 2)) or
                                       period_kind = 'C');

comment on column hpr_wage_sheets.sheet_kind   is '(R)egular, (O)ne-time';

----------------------------------------------------------------------------------------------------
create index hpr_sheet_parts_i3 on hpr_sheet_parts(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_sheet_parts_i4 on hpr_sheet_parts(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpr_sheet_parts_i5 on hpr_sheet_parts(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
create index hpr_sheet_parts_i6 on hpr_sheet_parts(company_id, fte_id) tablespace GWS_INDEX;

comment on column hpr_sheet_parts.schedule_id is 'Value from part_end day';
comment on column hpr_sheet_parts.job_id      is 'Value from part_end day';
comment on column hpr_sheet_parts.division_id is 'Value from part_end day';
comment on column hpr_sheet_parts.fte_id      is 'Value from part_end day. When null show closest fte value';

---------------------------------------------------------------------------------------------------- 
create table hpr_onetime_sheet_staffs(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  sheet_id                        number(20) not null,
  staff_id                        number(20) not null,
  month                           date       not null,
  division_id                     number(20) not null,
  job_id                          number(20) not null,
  schedule_id                     number(20),
  accrual_amount                  number(20) not null,
  penalty_amount                  number(20) not null,
  total_amount                    as (accrual_amount - penalty_amount),
  constraint hpr_onetime_sheet_staffs_pk primary key (company_id, filial_id, sheet_id, staff_id) using index tablespace GWS_INDEX,
  constraint hpr_onetime_sheet_staffs_f1 foreign key (company_id, filial_id, sheet_id) references hpr_wage_sheets(company_id, filial_id, sheet_id) on delete cascade,
  constraint hpr_onetime_sheet_staffs_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_onetime_sheet_staffs_f3 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_onetime_sheet_staffs_f4 foreign key (company_id, filial_id, job_id) references mhr_jobs(company_id, filial_id, job_id),
  constraint hpr_onetime_sheet_staffs_f5 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpr_onetime_sheet_staffs_c1 check (trunc(month, 'mon') = month),
  constraint hpr_onetime_sheet_staffs_c2 check (accrual_amount >= 0 and penalty_amount >= 0)
) tablespace GWS_DATA;

comment on table hpr_onetime_sheet_staffs is 'Keeps staffs bonuses and penalties for one-time wage_sheet';

comment on column hpr_onetime_sheet_staffs.schedule_id is 'Value from month day';
comment on column hpr_onetime_sheet_staffs.job_id      is 'Value from month day';
comment on column hpr_onetime_sheet_staffs.division_id is 'Value from month day';

create index hpr_onetime_sheet_staffs_i1 on hpr_onetime_sheet_staffs(company_id, filial_id, staff_id, month) tablespace GWS_INDEX;
create index hpr_onetime_sheet_staffs_i2 on hpr_onetime_sheet_staffs(company_id, filial_id, sheet_id) tablespace GWS_INDEX;
create index hpr_onetime_sheet_staffs_i3 on hpr_onetime_sheet_staffs(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_onetime_sheet_staffs_i4 on hpr_onetime_sheet_staffs(company_id, filial_id, job_id) tablespace GWS_INDEX;
create index hpr_onetime_sheet_staffs_i5 on hpr_onetime_sheet_staffs(company_id, filial_id, schedule_id) tablespace GWS_INDEX;
