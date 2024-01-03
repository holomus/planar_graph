prompt mgir from 17.06.2022
----------------------------------------------------------------------------------------------------
comment on column hpd_transactions.trans_type is 'Ro(B)ot, (O)peration, (S)chedule, (R)ank, Vacation (L)imit';
---------------------------------------------------------------------------------------------------- 
create table hpd_page_vacation_limits(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  page_id                         number(20) not null,
  days_limit                      number(20)  not null,
  constraint hpd_page_vacation_limits_pk primary key (company_id, filial_id, page_id) using index tablespace GWS_INDEX,
  constraint hpd_page_vacation_limits_f1 foreign key (company_id, filial_id, page_id) references hpd_journal_pages(company_id, filial_id, page_id) on delete cascade,
  constraint hpd_page_vacation_limits_c1 check (days_limit between 0 and 366)
) tablespace GWS_DATA;

comment on table hpd_page_vacation_limits is 'Keeps days limit for vacations';

---------------------------------------------------------------------------------------------------- 
create table hpd_trans_vacation_limits(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  trans_id                        number(20) not null,
  days_limit                      number(20)  not null,
  constraint hpd_trans_vacation_limits_pk primary key (company_id, filial_id, trans_id) using index tablespace GWS_INDEX,
  constraint hpd_trans_vacation_limits_f1 foreign key (company_id, filial_id, trans_id) references hpd_transactions(company_id, filial_id, trans_id) on delete cascade,
  constraint hpd_trans_vacation_limits_c1 check (days_limit between 0 and 366)
) tablespace GWS_DATA;

comment on table hpd_page_vacation_limits is 'Keeps days limit for vacations';

----------------------------------------------------------------------------------------------------
create table hpd_vacation_turnover(
  company_id                      number(20)    not null,
  filial_id                       number(20)    not null,
  staff_id                        number(20)    not null,
  period                          date          not null,
  planned_days                    number(20, 6) not null, 
  used_days                       number(20, 6) not null,
  free_days                       as (planned_days - used_days),
  constraint hpd_vacation_turnover_pk primary key (company_id, filial_id, staff_id, period) using index tablespace GWS_INDEX,
  constraint hpd_vacation_turnover_f1 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id) on delete cascade,
  constraint hpd_vacation_turnover_c1 check (planned_days >= 0 and used_days >= 0),
  constraint hpd_vacation_turnover_c2 check (free_days >= 0) deferrable initially deferred
) tablespace GWS_DATA;

comment on table hpd_vacation_turnover is 'Keeps staff vacation days turnover';

----------------------------------------------------------------------------------------------------
create table hrm_robot_vacation_limits(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  robot_id                        number(20) not null,
  days_limit                      number(20) not null,
  constraint hrm_robot_vacation_limits_pk primary key (company_id, filial_id, robot_id) using index tablespace GWS_INDEX,
  constraint hrm_robot_vacation_limits_f1 foreign key (company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id) on delete cascade,
  constraint hrm_robot_vacation_limits_c1 check (days_limit between 0 and 366)
) tablespace GWS_DATA;

comment on table hrm_robot_vacation_limits is 'Keeps days limit for robots';

----------------------------------------------------------------------------------------------------
-- vacation limit changes
----------------------------------------------------------------------------------------------------
create table hpd_vacation_limit_changes(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  journal_id                      number(20) not null,
  division_id                     number(20),
  change_date                     date       not null,
  days_limit                      number(20) not null,
  constraint hpd_vacation_limit_changes_pk primary key (company_id, filial_id, journal_id) using index tablespace GWS_INDEX,
  constraint hpd_vacation_limit_changes_f1 foreign key (company_id, filial_id, journal_id) references hpd_journals(company_id, filial_id, journal_id) on delete cascade,
  constraint hpd_vacation_limit_changes_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpd_vacation_limit_changes_c1 check (trunc(change_date) = change_date),
  constraint hpd_vacation_limit_changes_c2 check (days_limit between 0 and 366)
) tablespace GWS_DATA;

create index hpd_vacation_limit_changes_i1 on hpd_vacation_limit_changes(company_id, filial_id, division_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt rename htt_gps_tracks to htt_gps_tracks_old
----------------------------------------------------------------------------------------------------
rename htt_gps_tracks to htt_gps_tracks_old;

drop index htt_gps_tracks_i1;
drop index htt_gps_tracks_i2;
drop index htt_gps_tracks_i3;

alter table htt_gps_tracks_old rename constraint htt_gps_tracks_pk to htt_gps_tracks_pk_old;
alter table htt_gps_tracks_old rename constraint htt_gps_tracks_u1 to htt_gps_tracks_u1_old;
alter table htt_gps_tracks_old rename constraint htt_gps_tracks_u2 to htt_gps_tracks_u2_old;
alter table htt_gps_tracks_old rename constraint htt_gps_tracks_f1 to htt_gps_tracks_f1_old;
alter table htt_gps_tracks_old rename constraint htt_gps_tracks_f2 to htt_gps_tracks_f2_old;
alter table htt_gps_tracks_old rename constraint htt_gps_tracks_f3 to htt_gps_tracks_f3_old;
alter table htt_gps_tracks_old rename constraint htt_gps_tracks_c1 to htt_gps_tracks_c1_old;

alter index htt_gps_tracks_pk rename to htt_gps_tracks_pk_old;
alter index htt_gps_tracks_u1 rename to htt_gps_tracks_u1_old;
alter index htt_gps_tracks_u2 rename to htt_gps_tracks_u2_old;

----------------------------------------------------------------------------------------------------
prompt create new htt_gps_tracks tables
----------------------------------------------------------------------------------------------------
create table htt_gps_tracks(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  track_id                        number(20)  not null,
  person_id                       number(20)  not null,
  track_date                      date        not null,
  total_distance                  number(20),
  calculated                      varchar2(1) not null,
  created_by                      number(20)  not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)  not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_gps_tracks_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_gps_tracks_u1 unique (track_id) using index tablespace GWS_INDEX,
  constraint htt_gps_tracks_u2 unique (company_id, filial_id, person_id, track_date) using index tablespace GWS_INDEX,
  constraint htt_gps_tracks_f1 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id),
  constraint htt_gps_tracks_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_gps_tracks_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_gps_tracks_c1 check (total_distance >= 0),
  constraint htt_gps_tracks_c2 check (calculated in ('Y', 'N')),
  constraint htt_gps_tracks_c3 check (calculated = 'N' or calculated = 'Y' and total_distance is not null)
) tablespace GWS_DATA;

comment on table htt_gps_tracks is 'stores person''s gps daily unit';
comment on column htt_gps_tracks.total_distance is 'total distance on track date';
comment on column htt_gps_tracks.calculated     is '(Y)es, (N)o - track data changed but the total distance has not yet been calculated';

create index htt_gps_tracks_i1 on htt_gps_tracks(company_id, person_id) tablespace GWS_INDEX;
create index htt_gps_tracks_i2 on htt_gps_tracks(company_id, created_by) tablespace GWS_INDEX;
create index htt_gps_tracks_i3 on htt_gps_tracks(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_gps_track_datas(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  track_id                        number(20) not null,
  data                            blob       not null,
  constraint htt_gps_track_datas_pk primary key (company_id, filial_id, track_id) using index tablespace GWS_INDEX,
  constraint htt_gps_track_datas_f1 foreign key (company_id, filial_id, track_id) references htt_gps_tracks(company_id, filial_id, track_id) on delete cascade
) tablespace GWS_DATA;

comment on column htt_gps_track_datas.data is 'stores track datas separated by the tab(\t) with enter(\n), track data - track_time, lat, lng, accuracy, provider (G)ps, (N)etwork; 
example: "09:00:00\t43.21245663\t45.215466985\t50\tG\n..."';

----------------------------------------------------------------------------------------------------
create table htt_gps_track_batches(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  track_id                        number(20) not null,
  batch_id                        number(20) not null,
  constraint htt_gps_track_batches_pk primary key (company_id, filial_id, track_id, batch_id) using index tablespace GWS_INDEX,
  constraint htt_gps_track_batches_f1 foreign key (company_id, filial_id, track_id) references htt_gps_tracks(company_id, filial_id, track_id) on delete cascade
) tablespace GWS_DATA;

comment on table htt_gps_track_batches is 'stores batch id sent by mobile in each request and saved data to database succesfully';
---------------------------------------------------------------------------------------------------- 
prompt htt_location_persons add new column
----------------------------------------------------------------------------------------------------
alter table htt_location_persons add attach_type varchar2(1);
alter table htt_location_persons add constraint htt_location_persons_c1 check (attach_type in ('A', 'M'));
comment on column htt_location_persons.attach_type is '(M)anual, (A)uto'; 

update Htt_Location_Persons
   set Attach_Type = 'M';

alter table htt_location_persons modify attach_type not null;

----------------------------------------------------------------------------------------------------  
create global temporary table hpd_dirty_persons (
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  person_id                       number(20) not null,
  constraint hpd_dirty_persons_pk primary key (company_id, filial_id, person_id),
  constraint hpd_dirty_persons_c1 check (company_id is null) deferrable initially deferred
);

----------------------------------------------------------------------------------------------------
alter table hpr_timebooks add period_begin date;
alter table hpr_timebooks add period_end date;
alter table hpr_timebooks add period_kind varchar2(1);

alter table hpr_timebooks drop constraint hpr_timebooks_c4;
alter table hpr_timebooks drop constraint hpr_timebooks_c5;

alter table hpr_timebooks add constraint hpr_timebooks_c4 check (trunc(period_begin) = period_begin and trunc(period_end) = period_end);
alter table hpr_timebooks add constraint hpr_timebooks_c5 check (period_begin <= period_end and trunc(period_begin, 'mon') = trunc(period_end, 'mon'));
alter table hpr_timebooks add constraint hpr_timebooks_c6 check (period_kind in ('M', 'F', 'S', 'C'));
alter table hpr_timebooks add constraint hpr_timebooks_c7 check (decode(trim(barcode), barcode, 1, 0) = 1);
alter table hpr_timebooks add constraint hpr_timebooks_c8 check (period_kind = 'M' and period_begin = trunc(period_begin, 'mon') 
                                                                                   and period_end = last_day(period_begin) or
                                                                 period_kind = 'F' and period_begin = trunc(period_begin, 'mon') 
                                                                                   and period_end = (period_begin + trunc((last_day(period_begin) - period_begin + 1) / 2) - 1) or
                                                                 period_kind = 'S' and period_end = last_day(period_begin) 
                                                                                   and period_begin = (trunc(period_begin, 'mon') + trunc((last_day(period_begin) - trunc(period_begin, 'mon') + 1) / 2)) or
                                                                 period_kind = 'C');

comment on column hpr_timebooks.period_kind is 'Full (M)onth, (F)irst half, (S)econd half of month, (C)ustom period';

----------------------------------------------------------------------------------------------------
prompt fill hpr_timebooks period_begin, period_end, period_kind
----------------------------------------------------------------------------------------------------
update hpr_timebooks p
   set p.period_begin = p.month,
       p.period_end = last_day(p.month),
       p.period_kind = 'M';
commit;

alter table hpr_timebooks modify period_begin not null;
alter table hpr_timebooks modify period_end not null;
alter table hpr_timebooks modify period_kind not null;

alter table hpr_timebooks drop column month;
alter table hpr_timebooks add month as (trunc(period_begin, 'mon'));

drop index hpr_timebooks_i1;
create index hpr_timebooks_i1 on hpr_timebooks(company_id, filial_id, division_id, month) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------                       
create table hrm_robot_divisions (
  company_id     number(20)   not null,
  filial_id      number(20)   not null,
  robot_id       number(20)   not null,
  division_id    number(20)   not null,
  access_type    varchar2(1)  not null,
  constraint hrm_robot_divisions_pk primary key(company_id, filial_id, robot_id, division_id) using index tablespace GWS_INDEX,
  constraint hrm_robot_divisions_f1 foreign key(company_id, filial_id, robot_id) references hrm_robots(company_id, filial_id, robot_id) on delete cascade,
  constraint hrm_robot_divisions_f2 foreign key(company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id) on delete cascade,
  constraint hrm_robot_divisions_c1 check (access_type in ('S', 'M'))
) tablespace GWS_DATA;

comment on table  hrm_robot_divisions             is 'Keeps robot accesses for divisions';
comment on column hrm_robot_divisions.access_type is '(S)tructural, (M)anual';

create index hrm_robot_divisions_i1 on hrm_robot_divisions(company_id, filial_id, division_id) tablespace GWS_INDEX;

insert into hrm_robot_divisions
  (company_id, filial_id, robot_id, division_id, access_type)
  select s.company_id, s.filial_id, s.manager_id, s.division_id, 'S'
    from mrf_division_managers s
   where exists (select *
            from hrm_robots r
           where r.company_id = s.company_id
             and r.filial_id = s.filial_id
             and r.robot_id = s.manager_id);
commit;

----------------------------------------------------------------------------------------------------
drop index hrm_robot_transactions_i1;
create index hrm_robot_transactions_i1 on hrm_robot_transactions(company_id, filial_id, robot_id, trans_date) tablespace GWS_INDEX;
----------------------------------------------------------------------------------------------------
insert into Hrm_Settings p
  (p.Company_Id,
   p.Filial_Id,
   p.Position_Enable,
   p.Position_Check,
   p.Position_Booking,
   p.Position_History,
   p.Parttime_Enable)
  select f.Company_Id, f.Filial_Id, 'Y', 'N', 'N', 'N', 'N'
    from Md_Filials f
   where not exists (select *
            from Hrm_Settings t
           where t.Company_Id = f.Company_Id
             and t.Filial_Id = f.Filial_Id)
     and exists (select *
            from Hpd_Page_Robots q
           where q.Company_Id = f.Company_Id
             and q.Filial_Id = f.Filial_Id
           group by q.Robot_Id
          having count(*) > 1);
          
update Hrm_Settings p
   set p.Position_Enable = 'Y'
 where p.Position_Enable = 'N'
   and exists (select *
          from Hpd_Page_Robots q
         where q.Company_Id = p.Company_Id
           and q.Filial_Id = p.Filial_Id
         group by q.Robot_Id
        having count(*) > 1);
commit;

----------------------------------------------------------------------------------------------------
alter table htt_schedules drop constraint htt_schedules_c11;
alter table htt_schedules drop constraint htt_schedules_c12;

alter table htt_schedules add constraint htt_schedules_c11 check (state in ('A', 'P'));

update htt_schedules q
   set q.take_holidays = 'N',
       q.take_nonworking = 'N'
 where q.calendar_id is null;
commit;

alter table htt_schedules modify take_holidays not null;
alter table htt_schedules modify take_nonworking not null;

comment on column htt_schedules.take_holidays   is '(Y)es, (N)o, when yes and calendar is given takes holidays from calendar';
comment on column htt_schedules.take_nonworking is '(Y)es, (N)o, when yes and calendar is given takes nonworking days from calendar';

----------------------------------------------------------------------------------------------------
prompt dropping changed index and constraints
----------------------------------------------------------------------------------------------------
-- hzk_migr_tracks
drop index hzk_migr_tracks_i1;
drop index hzk_migr_tracks_i2;

alter table hzk_migr_tracks drop constraint hzk_migr_tracks_pk;
alter table hzk_migr_tracks drop constraint hzk_migr_tracks_f1;
alter table hzk_migr_tracks drop constraint hzk_migr_tracks_f2;

alter table hzk_migr_tracks drop column filial_id;

-- hzk_migr_fprints
alter table hzk_migr_fprints drop constraint hzk_migr_fprints_pk;

alter table hzk_migr_fprints drop column filial_id;

-- hzk_migr_persons
alter table hzk_migr_persons drop constraint hzk_migr_persons_u2;
alter table hzk_migr_persons drop constraint hzk_migr_persons_f1;

alter table hzk_migr_persons drop column filial_id;

-- hzk_attlog_errors
alter table hzk_attlog_errors drop constraint hzk_attlog_errors_pk;
alter table hzk_attlog_errors drop constraint hzk_attlog_errors_f1;

alter table hzk_attlog_errors drop column filial_id;

-- hzk_commands
drop index hzk_commands_i1;

alter table hzk_commands drop constraint hzk_commands_pk;
alter table hzk_commands drop constraint hzk_commands_f1;

alter table hzk_commands drop column filial_id;

-- hzk_device_fprints
alter table hzk_device_fprints drop constraint hzk_device_fprints_pk;
alter table hzk_device_fprints drop constraint hzk_device_fprints_f1;

alter table hzk_device_fprints drop column filial_id;

-- hzk_device_persons
alter table hzk_device_persons drop constraint hzk_device_persons_pk;
alter table hzk_device_persons drop constraint hzk_device_persons_f1;

alter table hzk_device_persons drop column filial_id;

-- hzk_devices
alter table hzk_devices drop constraint hzk_devices_pk;
alter table hzk_devices drop constraint hzk_devices_f1;

alter table hzk_devices drop column filial_id;

----------------------------------------------------------------------------------------------------
-- htt_tracks
drop index htt_tracks_i2;
alter table htt_tracks drop constraint htt_tracks_f2;

-- htt_device_admins
alter table htt_device_admins drop constraint htt_device_admins_pk;
alter table htt_device_admins drop constraint htt_device_admins_f1;

alter table htt_device_admins drop column filial_id;

-- htt_devices
drop index htt_devices_i2;

alter table htt_devices drop constraint htt_devices_pk;
alter table htt_devices drop constraint htt_devices_u2;
alter table htt_devices drop constraint htt_devices_f3;

alter table htt_devices drop column filial_id;

-- htt_location_persons
alter table htt_location_persons drop constraint htt_location_persons_f1;
alter table htt_location_persons drop constraint htt_location_persons_f2;

-- htt_location_divisions
alter table htt_location_divisions drop constraint htt_location_divisions_f1;
alter table htt_location_divisions drop constraint htt_location_divisions_f2;


----------------------------------------------------------------------------------------------------
prompt new table htt_location_filials
----------------------------------------------------------------------------------------------------
create table htt_location_filials(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  location_id                     number(20) not null,
  created_by                      number(20) not null,
  created_on                      timestamp with local time zone not null,
  constraint htt_location_filials_pk primary key (company_id, filial_id, location_id) using index tablespace GWS_INDEX,
  constraint htt_location_filials_f2 foreign key (company_id, created_by) references md_users(company_id, user_id)
) tablespace GWS_DATA;

create index htt_location_filials_i1 on htt_location_filials(company_id, created_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
prompt adding changed index and constraints
----------------------------------------------------------------------------------------------------
declare
begin
  insert into Htt_Location_Filials
    (Company_Id, Filial_Id, Location_Id, Created_By, Created_On)
    select q.Company_Id, q.Filial_Id, q.Location_Id, q.Created_By, q.Created_On
      from Htt_Locations q;
  commit;                                                                                                                
end;
/

-- htt_locations
drop index htt_locations_u2;

alter table htt_locations drop constraint htt_locations_pk;
alter table htt_locations drop column filial_id;

alter table htt_locations add constraint htt_locations_pk primary key(company_id, location_id) using index tablespace gws_index;

----------------------------------------------------------------------------------------------------
-- code uniqueness fix
----------------------------------------------------------------------------------------------------
declare
begin
  for r in (with Locations as
               (select w.Company_Id,
                      w.Code,
                      (select d.Location_Id
                         from Htt_Locations d
                        where d.Company_Id = w.Company_Id
                          and d.Code = w.Code
                          and d.Created_On = (select max(d.Created_On)
                                                from Htt_Locations d
                                               where d.Company_Id = w.Company_Id
                                                 and d.Code = w.Code)
                          and Rownum = 1) as Last_Location_Id
                 from Htt_Locations w
                group by w.Company_Id, w.Code
               having count(*) > 1)
              --
              select q.Company_Id, q.Location_Id
                from Htt_Locations q
               where exists (select 1
                        from Locations Loc
                       where Loc.Company_Id = q.Company_Id
                         and Loc.Code = q.Code
                         and Loc.Last_Location_Id <> q.Location_Id))
  loop
    update Htt_Locations q
       set q.Code = q.Code || '(' || r.Location_Id || ')'
     where q.Company_Id = r.Company_Id
       and q.Location_Id = r.Location_Id;
  
    commit;
  end loop;
end;
/

create unique index htt_locations_u2 on htt_locations(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

-- htt_location_filials
alter table htt_location_filials add constraint htt_location_filials_f1 foreign key(company_id, location_id) 
                                                references htt_locations(company_id, location_id) on delete cascade;

-- htt_location_divisions
alter table htt_location_divisions add constraint htt_location_divisions_f1 foreign key (company_id, filial_id, location_id) 
                                                  references htt_location_filials(company_id, filial_id, location_id) on delete cascade;
alter table htt_location_divisions add constraint htt_location_divisions_f2 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id);

-- htt_location_persons
alter table htt_location_persons add constraint htt_location_persons_f1 foreign key (company_id, filial_id, location_id) references htt_location_filials(company_id, filial_id, location_id) on delete cascade;
alter table htt_location_persons add constraint htt_location_persons_f2 foreign key (company_id, person_id) references mr_natural_persons(company_id, person_id);

create index htt_location_persons_i3 on htt_location_persons(company_id, location_id, person_id) tablespace GWS_INDEX;

-- htt_devices
declare
begin
  for r in (with Devices as
               (select w.Company_Id,
                      w.Device_Type_Id,
                      w.Serial_Number,
                      (select d.Device_Id
                         from Htt_Devices d
                        where d.Company_Id = w.Company_Id
                          and d.Device_Type_Id = w.Device_Type_Id
                          and d.Serial_Number = w.Serial_Number
                          and d.Created_On =
                              (select max(d.Created_On)
                                 from Htt_Devices d
                                where d.Company_Id = w.Company_Id
                                  and d.Device_Type_Id = w.Device_Type_Id
                                  and d.Serial_Number = w.Serial_Number)
                          and Rownum = 1) as Last_Device_Id
                 from Htt_Devices w
                group by w.Company_Id, w.Device_Type_Id, w.Serial_Number
               having count(*) > 1)
              --
              select q.Company_Id, q.Device_Id
                from Htt_Devices q
               where exists (select 1
                        from Devices Dev
                       where Dev.Company_Id = q.Company_Id
                         and Dev.Device_Type_Id = q.Device_Type_Id
                         and Dev.Serial_Number = q.Serial_Number
                         and Dev.Last_Device_Id <> q.Device_Id))
  loop
    update Htt_Devices q
       set q.Serial_Number = q.Serial_Number || '(' || r.Device_Id || ')'
     where q.Company_Id = r.Company_Id
       and q.Device_Id = r.Device_Id;
  
    commit;
  end loop;
end;
/

alter table htt_devices add constraint htt_devices_pk primary key (company_id, device_id) using index tablespace GWS_INDEX;
alter table htt_devices add constraint htt_devices_u2 unique (company_id, device_type_id, serial_number) using index tablespace GWS_INDEX;
alter table htt_devices add constraint htt_devices_f3 foreign key (company_id, location_id) references htt_locations(company_id, location_id);

create index htt_devices_i2 on htt_devices(company_id, location_id) tablespace GWS_INDEX;

-- htt_device_admins
alter table htt_device_admins add constraint htt_device_admins_pk primary key (company_id, device_id, person_id) using index tablespace GWS_INDEX;
alter table htt_device_admins add constraint htt_device_admins_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade;

-- htt_tracks
alter table htt_tracks add constraint htt_tracks_f2 foreign key (company_id, location_id) references htt_locations(company_id, location_id);

create index htt_tracks_i2 on htt_tracks(company_id, location_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
-- hzk_devices
alter table hzk_devices add constraint hzk_devices_pk primary key (company_id, device_id) using index tablespace GWS_INDEX;
alter table hzk_devices add constraint hzk_devices_f1 foreign key (company_id, device_id) references htt_devices(company_id, device_id) on delete cascade;

-- hzk_device_persons
alter table hzk_device_persons add constraint hzk_device_persons_pk primary key (company_id, device_id, person_id) using index tablespace GWS_INDEX;
alter table hzk_device_persons add constraint hzk_device_persons_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id) on delete cascade;

-- hzk_device_fprints
alter table hzk_device_fprints add constraint hzk_device_fprints_pk primary key (company_id, device_id, person_id, finger_no) using index tablespace GWS_INDEX;
alter table hzk_device_fprints add constraint hzk_device_fprints_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id) on delete cascade;

-- hzk_commands
alter table hzk_commands add constraint hzk_commands_pk primary key (company_id, command_id) using index tablespace GWS_INDEX;
alter table hzk_commands add constraint hzk_commands_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id) on delete cascade;

create index hzk_commands_i1 on hzk_commands(company_id, device_id) tablespace GWS_DATA;

-- hzk_attlog_errors
alter table hzk_attlog_errors add constraint hzk_attlog_errors_pk primary key (company_id, error_id) using index tablespace GWS_INDEX;
alter table hzk_attlog_errors add constraint hzk_attlog_errors_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id);

-- hzk_migr_persons
alter table hzk_migr_persons add constraint hzk_migr_persons_u2 unique (company_id, device_id, pin) using index tablespace GWS_INDEX;
alter table hzk_migr_persons add constraint hzk_migr_persons_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id);

-- hzk_migr_fprints
alter table hzk_migr_fprints add constraint hzk_migr_fprints_pk primary key (company_id, device_id, pin, finger_no) using index tablespace GWS_INDEX;

-- hzk_migr_tracks
alter table hzk_migr_tracks add constraint hzk_migr_tracks_pk primary key (company_id, migr_track_id) using  index tablespace GWS_INDEX;
alter table hzk_migr_tracks add constraint hzk_migr_tracks_f1 foreign key (company_id, device_id) references hzk_devices(company_id, device_id);
alter table hzk_migr_tracks add constraint hzk_migr_tracks_f2 foreign key (company_id, location_id) references htt_locations(company_id, location_id);

create index hzk_migr_tracks_i1 on hzk_migr_tracks(company_id, device_id) tablespace GWS_DATA;
create index hzk_migr_tracks_i2 on hzk_migr_tracks(company_id, location_id) tablespace GWS_DATA;

----------------------------------------------------------------------------------------------------
prompt hrm_settings added rabk_enable and wage_scale_enable
----------------------------------------------------------------------------------------------------
alter table hrm_settings add rank_enable varchar2(1);
alter table hrm_settings add wage_scale_enable varchar2(1);
alter table hrm_settings add constraint hrm_settings_c6 check (rank_enable in ('Y', 'N'));
alter table hrm_settings add constraint hrm_settings_c7 check (wage_scale_enable in ('Y', 'N'));

update hrm_settings p
   set p.rank_enable = 'N',
       p.wage_scale_enable = 'N';
commit;

alter table hrm_settings modify rank_enable not null;
alter table hrm_settings modify wage_scale_enable not null;

----------------------------------------------------------------------------------------------------
prompt exec fazo_z.run('h'); 
----------------------------------------------------------------------------------------------------
exec fazo_z.run('h'); 
