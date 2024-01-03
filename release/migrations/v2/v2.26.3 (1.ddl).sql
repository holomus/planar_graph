----------------------------------------------------------------------------------------------------
create table hisl_settings(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  integration_enabled             varchar2(1) not null,
  api_host                        varchar2(200 char),
  auth_url                        varchar2(200 char),
  auth_email                      varchar2(200 char),
  auth_password                   varchar2(200 char),
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  modified_id                     number(20)  not null,
  constraint hisl_settings_pk primary key (company_id, filial_id) using index tablespace GWS_INDEX,
  constraint hisl_settings_f1 foreign key (company_id, filial_id) references md_filials(company_id, filial_id),
  constraint hisl_settings_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hisl_settings_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hisl_settings_c1 check (integration_enabled in ('Y', 'N')),
  constraint hisl_settings_c2 check (decode(trim(api_host), api_host, 1, 0) = 1),
  constraint hisl_settings_c3 check (decode(trim(auth_url), auth_url, 1, 0) = 1),
  constraint hisl_settings_c4 check (decode(trim(auth_email), auth_email, 1, 0) = 1),
  constraint hisl_settings_c5 check (decode(trim(auth_password), auth_password, 1, 0) = 1)
) tablespace GWS_DATA;

create index hisl_settings_i1 on hisl_settings(company_id, created_by) tablespace GWS_INDEX;
create index hisl_settings_i2 on hisl_settings(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hisl_divisions(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  division_id                     number(20)        not null,
  division_code                   varchar2(50 char) not null,
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  constraint hisl_divisions_pk primary key (company_id, filial_id, division_id) using index tablespace GWS_INDEX,
  constraint hisl_divisions_u1 unique (company_id, filial_id, division_code) using index tablespace GWS_INDEX,
  constraint hisl_divisions_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint hisl_divisions_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hisl_divisions_c1 check (decode(trim(division_code), division_code, 1, 0) = 1)
) tablespace GWS_DATA;

create index hisl_divisions_i1 on hisl_divisions(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hisl_users(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  user_id                         number(20)        not null,
  user_code                       varchar2(50 char) not null,
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  constraint hisl_users_pk primary key (company_id, filial_id, user_id) using index tablespace GWS_INDEX,
  constraint hisl_users_u1 unique (company_id, filial_id, user_code) using index tablespace GWS_INDEX,
  constraint hisl_users_f1 foreign key (company_id, filial_id, user_id) references mrf_persons(company_id, filial_id, person_id) on delete cascade,
  constraint hisl_users_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hisl_users_c1 check (decode(trim(user_code), user_code, 1, 0) = 1)
) tablespace GWS_DATA;

create index hisl_users_i1 on hisl_users(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hisl_logs(
  company_id                      number(20)          not null,
  filial_id                       number(20)          not null,
  log_id                          number(20)          not null,
  status                          varchar2(1)         not null,
  url                             varchar2(200 char)  not null,
  request_body                    varchar2(4000 char) not null,
  response_body                   varchar2(4000 char),
  created_by                      number(20)          not null,
  created_on                      timestamp with local time zone not null,
  constraint hisl_logs_pk primary key (company_id, filial_id, log_id) using index tablespace GWS_INDEX,
  constraint hisl_logs_u1 unique (log_id) using index tablespace GWS_INDEX,
  constraint hisl_logs_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hisl_logs_c1 check (status in ('S', 'E')),
  constraint hisl_logs_c2 check (decode(trim(url), url, 1, 0) = 1)
) tablespace GWS_DATA;

create index hisl_logs_i1 on hisl_logs(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create sequence hisl_logs_sq;
