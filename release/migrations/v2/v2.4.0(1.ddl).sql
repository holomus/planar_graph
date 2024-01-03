prompt migr from 04.08.2022 1.ddl
----------------------------------------------------------------------------------------------------
prompt new penalty tables
----------------------------------------------------------------------------------------------------
create table hpr_penalties(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  penalty_id                      number(20)  not null,
  month                           date        not null,
  name                            varchar2(100 char),
  division_id                     number(20),
  state                           varchar2(1) not null,
  constraint hpr_penalties_pk primary key (company_id, filial_id, penalty_id) using index tablespace GWS_INDEX,
  constraint hpr_penalties_u1 unique (penalty_id) using index tablespace GWS_INDEX,
  constraint hpr_penalties_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_penalties_c1 check (month = trunc(month, 'mon')),
  constraint hpr_penalties_c2 check (decode(trim(name), name, 1, 0) = 1),  
  constraint hpr_penalties_c3 check (state in ('A', 'P'))
) tablespace GWS_DATA;

create unique index hpr_penalties_u2 on hpr_penalties(company_id, filial_id, month, division_id) tablespace GWS_INDEX;

create index hpr_penalties_i1 on hpr_penalties(company_id, filial_id, division_id);

----------------------------------------------------------------------------------------------------
create table hpr_penalty_policies(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  penalty_id                      number(20)  not null, 
  penalty_kind                    varchar2(1) not null,
  from_day                        number(4)   not null,
  to_day                          number(4),
  from_time                       number(4)   not null,
  to_time                         number(4),
  penalty_coef                    number(20,6),
  penalty_per_time                number(4),
  penalty_amount                  number(20,6),
  constraint hpr_penalty_policies_pk primary key (company_id, filial_id, penalty_id, penalty_kind, from_day, from_time) using index tablespace GWS_INDEX,
  constraint hpr_penalty_policies_f1 foreign key (company_id, filial_id, penalty_id) references hpr_penalties(company_id, filial_id, penalty_id) on delete cascade,
  constraint hpr_penalty_policies_c1 check (penalty_kind in ('L', 'E', 'C')),
  constraint hpr_penalty_policies_c2 check (from_day >= 0 and from_day <= 31),
  constraint hpr_penalty_policies_c3 check (from_day <= to_day),
  constraint hpr_penalty_policies_c4 check (to_day <= 31),
  constraint hpr_penalty_policies_c5 check (from_time >= 0 and from_time <= 1440),
  constraint hpr_penalty_policies_c6 check (from_time <= to_time),  
  constraint hpr_penalty_policies_c7 check (to_time <= 1440),
  constraint hpr_penalty_policies_c8 check (penalty_coef is not null and penalty_coef >= 0 or 
                                           (penalty_per_time is null or penalty_per_time > 0) and
                                            penalty_amount is not null and penalty_amount >= 0)
) tablespace GWS_DATA;

comment on column hpr_penalty_policies.penalty_kind is '(L)ate time, (E)arly time, La(C)k time';

----------------------------------------------------------------------------------------------------
create sequence hpr_penalties_sq;

----------------------------------------------------------------------------------------------------
prompt fazo_z.run
----------------------------------------------------------------------------------------------------
exec fazo_z.run('hpr_penalties');
exec fazo_z.run('hpr_penalty_policies');
