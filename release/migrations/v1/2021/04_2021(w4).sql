prompt 04.2021 4th week migr
----------------------------------------------------------------------------------------------------
prompt new href_person_documents table
----------------------------------------------------------------------------------------------------
create table href_person_documents(
  company_id                      number(20)   not null,
  document_id                     number(20)   not null,
  person_id                       number(20)   not null,
  doc_type_id                     number(20)   not null,
  doc_series                      varchar2(50 char),
  doc_number                      varchar2(50 char),
  issued_by                       varchar2(150 char),
  issued_date                     date,
  begin_date                      date,
  expiry_date                     date,  
  note                            varchar2(300 char),
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20) not null,
  modified_on                     timestamp with local time zone not null,
  constraint href_person_documents_pk primary key (company_id, document_id) using index tablespace GWS_INDEX,
  constraint href_person_documents_u1 unique (document_id) using index tablespace GWS_INDEX,
  constraint href_person_documents_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id) on delete cascade,
  constraint href_person_documents_f2 foreign key (company_id, doc_type_id) references href_document_types(company_id, doc_type_id),
  constraint href_person_documents_f3 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_person_documents_f4 foreign key (company_id, modified_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index href_person_documents_i1 on href_person_documents(company_id, person_id) tablespace GWS_INDEX;
create index href_person_documents_i2 on href_person_documents(company_id, doc_type_id) tablespace GWS_INDEX;
create index href_person_documents_i3 on href_person_documents(company_id, created_by) tablespace GWS_INDEX;
create index href_person_documents_i4 on href_person_documents(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table href_person_document_files(
  company_id                      number(20)   not null,
  document_id                     number(20)   not null,
  sha                             varchar2(64) not null,
  constraint href_person_document_files_pk primary key (company_id, document_id, sha) using index tablespace GWS_INDEX,
  constraint href_person_document_files_f1 foreign key (company_id, document_id) references href_person_documents(company_id, document_id) on delete cascade,
  constraint href_person_document_files_f2 foreign key (sha) references biruni_files(sha)
) tablespace GWS_DATA;

create index href_person_document_files_i1 on href_person_document_files(sha) tablespace GWS_INDEX;

create sequence href_person_documents_sq;

----------------------------------------------------------------------------------------------------
prompt new htt_leave_types table
----------------------------------------------------------------------------------------------------
create table htt_leave_types(
  company_id                      number(20)         not null,
  leave_type_id                   number(20)         not null,
  name                            varchar2(100 char) not null,
  short_name                      varchar2(100 char) not null,
  bg_color                        varchar2(7),
  color                           varchar2(7),
  timesheet_coef                  number(5,2)        not null,
  allow_unused_time               varchar2(1)        not null,
  requestable                     varchar2(1)        not null,
  request_restriction_days        number(3),
  state                           varchar2(1)        not null,
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_leave_types_pk primary key (company_id, leave_type_id) using index tablespace GWS_INDEX,
  constraint htt_leave_types_u1 unique (leave_type_id) using index tablespace GWS_INDEX,
  constraint htt_leave_types_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_leave_types_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_leave_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_leave_types_c2 check (decode(trim(short_name), short_name, 1, 0) = 1),
  constraint htt_leave_types_c3 check (allow_unused_time in ('Y', 'N')),
  constraint htt_leave_types_c4 check (requestable in ('Y', 'N')),
  constraint htt_leave_types_c5 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column htt_leave_types.timesheet_coef           is 'The ratio of counting attendance';
comment on column htt_leave_types.allow_unused_time        is 'Take into account unused time of the leave when calculating working hours';
comment on column htt_leave_types.requestable              is 'Employees can request this type of time off or it can be entered only by administrators and managers';
comment on column htt_leave_types.request_restriction_days is 'Days before the leave begin date is necessary to request it. A negative value allows you to request leave retroactively.';
comment on column htt_leave_types.state                    is '(A)ctive, (P)assive. Used to filter when attached to an employee';

create index htt_leave_types_i1 on htt_leave_types(company_id, created_by) tablespace GWS_INDEX;
create index htt_leave_types_i2 on htt_leave_types(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new htt_request_types table
----------------------------------------------------------------------------------------------------
create table htt_request_types(
  company_id                      number(20)         not null,
  request_type_id                 number(20)         not null,
  name                            varchar2(100 char) not null,
  order_no                        number(6)          not null,
  state                           varchar2(1)        not null,
  pcode                           varchar2(20)       not null,
  constraint htt_request_types_pk primary key (company_id, request_type_id) using index tablespace GWS_INDEX,
  constraint htt_request_types_u1 unique (request_type_id) using index tablespace GWS_INDEX,
  constraint htt_request_types_u2 unique (company_id, pcode) using index tablespace GWS_INDEX,
  constraint htt_request_types_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_request_types_c2 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column htt_request_types.state is '(A)ctive, (P)assive';

----------------------------------------------------------------------------------------------------
prompt new htt_requests table
----------------------------------------------------------------------------------------------------
create table htt_requests(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  request_id                      number(20)   not null,
  request_type_id                 number(20)   not null,
  staff_id                        number(20)   not null,
  leave_type_id                   number(20),
  leave_kind                      varchar2(1),
  timesheet_coef                  number(5,2),
  allow_unused_time               varchar2(1),
  change_kind                     varchar2(1),
  manager_note                    varchar2(300 char),
  note                            varchar2(300 char),
  status                          varchar2(1)  not null,
  barcode                         varchar2(25) not null,
  created_by                      number(20)   not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)   not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_requests_pk primary key (company_id, filial_id, request_id) using index tablespace GWS_INDEX,
  constraint htt_requests_u1 unique (request_id) using index tablespace GWS_INDEX,
  constraint htt_requests_f1 foreign key (company_id, request_type_id) references htt_request_types(company_id, request_type_id),
  constraint htt_requests_f2 foreign key (company_id, leave_type_id) references htt_leave_types(company_id, leave_type_id),
  constraint htt_requests_f3 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint htt_requests_f4 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_requests_f5 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_requests_c1 check (leave_kind in ('P', 'F', 'M')),
  constraint htt_requests_c2 check (change_kind in ('S', 'C')),
  constraint htt_requests_c3 check (nvl2(leave_type_id, 2, 0) = nvl2(leave_kind, 1, 0) + nvl2(timesheet_coef, 1, 0)),
  constraint htt_requests_c4 check (nvl2(leave_type_id, 1, 0) = nvl2(change_kind, 0, 1)),
  constraint htt_requests_c5 check (status in ('N', 'A', 'C', 'D'))
) tablespace GWS_DATA;

comment on column htt_requests.leave_kind     is '(P)art of day, (F)ull day, (M)ultiple days, used when leaving type is specified';
comment on column htt_requests.change_kind    is '(S)wap, (C)hange day';
comment on column htt_requests.timesheet_coef is 'used when leaving type is specified';
comment on column htt_requests.status         is '(N)ew, (A)pproved, (C)ompleted, (D)enied';

create index htt_requests_i1 on htt_requests(company_id, request_type_id) tablespace GWS_INDEX;
create index htt_requests_i2 on htt_requests(company_id, leave_type_id) tablespace GWS_INDEX;
create index htt_requests_i3 on htt_requests(company_id, filial_id, staff_id) tablespace GWS_INDEX;
create index htt_requests_i4 on htt_requests(company_id, created_by) tablespace GWS_INDEX;
create index htt_requests_i5 on htt_requests(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt new htt_request_times table
----------------------------------------------------------------------------------------------------
create table htt_request_times(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  request_time_id                 number(20) not null,
  request_id                      number(20) not null,
  request_date                    date       not null,
  begin_time                      date       not null,
  end_time                        date,
  day_kind                        varchar2(1),
  break_enabled                   varchar2(1),
  break_begin_time                date,
  break_end_time                  date,
  plan_time                       number(4),
  constraint htt_request_times_pk primary key (company_id, filial_id, request_time_id) using index tablespace GWS_INDEX,
  constraint htt_request_times_u1 unique (request_time_id) using index tablespace GWS_INDEX,
  constraint htt_request_times_f1 foreign key (company_id, filial_id, request_id) references htt_requests(company_id, filial_id, request_id) on delete cascade,
  constraint htt_request_times_c1 check (trunc(request_date) = request_date),
  constraint htt_request_times_c2 check (day_kind = 'W' and begin_time < end_time and break_enabled is not null and plan_time >= 0 or
                                         day_kind = 'R' and end_time is null and break_enabled is null or
                                         day_kind is null and begin_time <= end_time and break_enabled is null),
  constraint htt_request_times_c3 check (break_enabled = 'Y' and break_begin_time is not null and break_end_time is not null or
                                         break_begin_time is null and break_end_time is null),
  constraint htt_request_times_c4 check (break_begin_time < break_end_time),
  constraint htt_request_times_c5 check (begin_time <= break_begin_time and break_end_time <= end_time)
) tablespace GWS_DATA;

comment on column htt_request_times.day_kind      is '(W)orking, (R)est';
comment on column htt_request_times.break_enabled is '(Y)es, (N)o';

create index htt_request_times_i1 on htt_request_times(company_id, filial_id, request_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_leave_helpers(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  interval_date                   date       not null,
  request_id                      number(20) not null,
  constraint htt_leave_helpers_pk primary key (company_id, filial_id, staff_id, interval_date, request_id) using index tablespace GWS_INDEX,
  constraint htt_leave_helpers_f1 foreign key (company_id, filial_id, request_id) references htt_requests(company_id, filial_id, request_id) on delete cascade 
) tablespace GWS_DATA;

create index htt_leave_helpers_i1 on htt_leave_helpers(company_id, filial_id, request_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt sequences
----------------------------------------------------------------------------------------------------
create sequence htt_leave_types_sq;
create sequence htt_request_types_sq;
create sequence htt_requests_sq;
create sequence htt_request_times_sq;

----------------------------------------------------------------------------------------------------
prompt timesheet leave
----------------------------------------------------------------------------------------------------
alter table htt_timesheets add leave_time number(4);
alter table htt_timesheets add leave_paid_time number(20,6);
update htt_timesheets set leave_time = 0;
update htt_timesheets set leave_paid_time = 0;
commit;
alter table htt_timesheets drop constraint htt_timesheets_c8;
alter table htt_timesheets add constraint htt_timesheets_c8 check (in_time >= 0 and free_time >= 0 and late_time >= 0 and lack_time >= 0 and early_time >= 0 and leave_time >= 0);

----------------------------------------------------------------------------------------------------
create table htt_timesheet_leaves(
  company_id                      number(20)   not null,
  filial_id                       number(20)   not null,
  timesheet_id                    number(20)   not null,
  request_id                      number(20)   not null,
  constraint htt_timesheet_leaves_pk primary key (company_id, filial_id, timesheet_id, request_id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_leaves_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_leaves_f2 foreign key (company_id, filial_id, request_id) references htt_requests(company_id, filial_id, request_id)
) tablespace GWS_DATA;

create index htt_timesheet_leaves_i1 on htt_timesheet_leaves(company_id, filial_id, request_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_timesheet_helpers(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  interval_date                   date        not null,
  timesheet_id                    number(20)  not null,
  day_kind                        varchar2(1) not null,
  shift_begin_date                date,
  shift_end_date                  date,
  constraint htt_timesheet_helpers_pk primary key (company_id, filial_id, staff_id, interval_date, timesheet_id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_helpers_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade
) tablespace GWS_DATA;

create index htt_timesheet_helpers_i1 on htt_timesheet_helpers(company_id, filial_id, timesheet_id) tablespace GWS_INDEX;
