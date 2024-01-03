prompt adding server settings
----------------------------------------------------------------------------------------------------
create table hsc_server_settings(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  ftp_server_url                  varchar2(300) not null,
  ftp_username                    varchar2(300) not null,
  ftp_password                    varchar2(300) not null,
  predict_server_url              varchar2(300) not null,
  last_ftp_file_date              date,
  constraint hsc_server_settings_pk primary key (company_id, filial_id) using index tablespace GWS_INDEX,
  constraint hsc_server_settings_c1 check(trunc(last_ftp_file_date) = last_ftp_file_date)
) tablespace GWS_DATA;

comment on column hsc_server_settings.predict_server_url is 'DEFAULT: http://127.0.0.1:5000';

----------------------------------------------------------------------------------------------------
create table hsc_job_error_log(
  log_id                          number(20) not null,
  company_id                      number(20),
  filial_id                       number(20),
  error_log                       varchar2(4000),
  created_on                      timestamp with local time zone not null,
  constraint hsc_job_error_log_pk primary key (log_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

---------------------------------------------------------------------------------------------------- 
create sequence hsc_job_error_log_sq;

exec fazo_z.run('hsc_server_settings');
exec fazo_z.run('hsc_job_error_log');
