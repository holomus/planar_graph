prompt altering schedule tables
----------------------------------------------------------------------------------------------------
alter table htt_schedules modify shift             null;
alter table htt_schedules modify input_acceptance  null;
alter table htt_schedules modify output_acceptance null;

alter table htt_schedules add schedule_kind varchar2(1);

comment on column htt_schedules.schedule_kind     is '(C)ustom, (F)lexible, (H)ourly. When (F)lexible cannot set shift, input/output acceptance. When (H)ourly will calculate only turnout from input to output';

---------------------------------------------------------------------------------------------------- 
alter table htt_schedule_origin_days modify shift_begin_time null;
alter table htt_schedule_origin_days modify shift_end_time   null;
alter table htt_schedule_origin_days modify input_border     null;
alter table htt_schedule_origin_days modify output_border    null;

alter table htt_schedule_days modify shift_begin_time null;
alter table htt_schedule_days modify shift_end_time   null;
alter table htt_schedule_days modify input_border     null;
alter table htt_schedule_days modify output_border    null;

---------------------------------------------------------------------------------------------------- 
alter table htt_timesheets modify shift_begin_time null;
alter table htt_timesheets modify shift_end_time   null;
alter table htt_timesheets modify input_border     null;
alter table htt_timesheets modify output_border    null;

alter table htt_timesheets add constraint htt_timesheets_c20 check(shift_begin_time is not null) deferrable initially deferred;
alter table htt_timesheets add constraint htt_timesheets_c21 check(shift_end_time   is not null) deferrable initially deferred;
alter table htt_timesheets add constraint htt_timesheets_c22 check(input_border     is not null) deferrable initially deferred;
alter table htt_timesheets add constraint htt_timesheets_c23 check(output_border    is not null) deferrable initially deferred;

alter table htt_timesheets drop constraint htt_timesheets_c7;
alter table htt_timesheets add constraint htt_timesheets_c7 check (trunc(begin_time) = timesheet_date);

alter table htt_timesheets add schedule_kind varchar2(1);

comment on column htt_timesheets.schedule_kind  is '(C)ustom, (F)lexible, (H)ourly';

----------------------------------------------------------------------------------------------------
alter table htt_tracks add trans_input  varchar2(1);
alter table htt_tracks add trans_output varchar2(1);

comment on column htt_tracks.trans_input    is '(Y)es, (N)o. Transformable to input. (Y)es when device setting autogen_input was turned at track cretion time';
comment on column htt_tracks.trans_output   is '(Y)es, (N)o. Transformable to output. (Y)es when device setting autogen_output was turned at track cretion time';

----------------------------------------------------------------------------------------------------
alter table htt_timesheet_tracks add trans_input varchar2(1);
alter table htt_timesheet_tracks add trans_output varchar2(1);

comment on column htt_timesheet_tracks.track_type   is '(I)nput, (O)utput, (C)heck, (M)erger, (P)otential output. (M)erger tracks appear only after fact calculation. (C)heck tracks can be transformed to other types';
comment on column htt_Timesheet_tracks.trans_input  is '(Y)es, (N)o. Same as htt_tracks.trans_input';
comment on column htt_Timesheet_tracks.trans_output is '(Y)es, (N)o. Same as htt_tracks.trans_output';

----------------------------------------------------------------------------------------------------
alter table htt_timesheet_facts modify fact_value number(6);

---------------------------------------------------------------------------------------------------- 
drop table htt_dirty_timesheets;

create global temporary table htt_dirty_timesheets(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  timesheet_id                    number(20)  not null,
  locked                          varchar2(1) not null,
  constraint htt_dirty_timesheets_pk primary key (company_id, filial_id, timesheet_id),
  constraint htt_dirty_timesheets_c1 check (timesheet_id is null) deferrable initially deferred,
  constraint htt_dirty_timesheets_c2 check (locked in ('Y', 'N'))
);

comment on column htt_dirty_timesheets.locked is '(Y)es, (N)o. Locked (Y)es when exists corresponding row in htt_timesheet_locks';

---------------------------------------------------------------------------------------------------- 
prompt adding acms devices table
----------------------------------------------------------------------------------------------------
create table htt_acms_devices(
  company_id                      number(20)         not null,
  device_id                       number(20)         not null,
  dynamic_ip                      varchar2(1)        not null,
  ip_address                      varchar2(30),
  port                            varchar2(10),
  protocol                        varchar2(1),
  host                            varchar2(100),
  login                           varchar2(100 char) not null,
  password                        varchar2(100 char) not null,
  constraint htt_acms_devices_pk primary key (company_id, device_id) using index tablespace GWS_INDEX,
  constraint htt_acms_devices_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade,
  constraint htt_acms_devices_c1 check (dynamic_ip in ('Y', 'N')),
  constraint htt_acms_devices_c2 check (decode(trim(ip_address), ip_address, 1, 0) = 1),
  constraint htt_acms_devices_c3 check (decode(trim(port), port, 1, 0) = 1),
  constraint htt_acms_devices_c4 check (protocol in ('H', 'S')),
  constraint htt_acms_devices_c5 check (decode(trim(host), host, 1, 0) = 1),
  constraint htt_acms_devices_c6 check (dynamic_ip = 'Y' and ip_address is not null and port is not null and protocol is not null or
                                             dynamic_ip = 'N' and host is not null),
  constraint htt_acms_devices_c7 check (decode(trim(login), login, 1, 0) = 1),
  constraint htt_acms_devices_c8 check (decode(trim(password), password, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column htt_acms_devices.dynamic_ip is '(Y)es, (N)o';
comment on column htt_acms_devices.protocol is '(H)ttp, Http(S)';
