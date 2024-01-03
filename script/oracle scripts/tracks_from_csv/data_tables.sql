prompt csv track data tables
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
create sequence migr_csv_tracks_sq;

------------------------------------------------------------------------------------------------
create table migr_csv_data(
  data_id    number(20),
  data       clob
) tablespace GWS_DATA;

---------------------------------------------------------------------------------------------------- 
create table migr_csv_tracks(
  track_date    varchar2(100),
  full_name     varchar2(1000),
  track_type    varchar2(100),
  track_time    varchar2(100),
  location_name varchar2(1000),
  pin           varchar2(1000),
  person_id     number(20),
  track_id      number(20) not null,
  constraint migr_csv_tracks_pk primary key (track_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

create index migr_csv_tracks_i1 on migr_csv_tracks(person_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table migr_inserted_tracks(
  track_id   number(20) not null,
  constraint migr_inserted_tracks_pk primary key (track_id) using index tablespace GWS_INDEX
) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
create table migr_employee_task_tracks(
  task_id               number(20),
  company_id            number(20),
  filial_id             number(20),
  employee_id           number(20),
  constraint migr_employee_task_tracks_pk primary key (company_id, filial_id, employee_id) using index tablespace GWS_INDEX  
) tablespace GWS_DATA;

create index migr_employee_task_tracks_i1 on migr_employee_task_tracks(task_id) tablespace GWS_INDEX;
