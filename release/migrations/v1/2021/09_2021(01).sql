prompt migr 01.09.2021
set define off
set serveroutput on
drop index htt_persons_u2;
alter index htt_persons_u3 rename to htt_persons_u2;
alter index htt_persons_u4 rename to htt_persons_u3;
alter table hpd_page_indicators rename constraint hpd_hire_indicators_f1 to hpd_page_indicators_f1;
alter table hpd_page_indicators rename constraint hpd_hire_indicators_pk to hpd_page_indicators_pk;
alter table hpd_page_indicators rename constraint hpd_hire_indicators_f2 to hpd_page_indicators_f2;
alter table hper_plans rename constraint hper_plans_c4 to hper_plans_c5;
alter table hper_plans rename constraint hper_plans_c3 to hper_plans_c4;
alter table hper_plans rename constraint hper_plans_c2 to hper_plans_c3;
alter table hper_plans rename constraint vx_pr_plans_c2 to hper_plans_c2;
alter table hper_staff_plan_rules rename constraint hper_satff_plan_rules_f1 to hper_staff_plan_rules_f1;
alter table hper_staff_plan_rules rename constraint hper_satff_plan_rules_c1 to hper_staff_plan_rules_c1;
alter table hper_staff_plan_rules rename constraint hper_satff_plan_rules_c2 to hper_staff_plan_rules_c2;
alter table hper_staff_plan_rules rename constraint hper_satff_plan_rules_c3 to hper_staff_plan_rules_c3;
alter table hper_staff_plan_rules rename constraint hper_satff_plan_rules_pk to hper_staff_plan_rules_pk;
alter table hper_staff_plan_task_types rename constraint hrep_staff_plan_task_types_f1 to hper_staff_plan_task_types_f1;
alter table hper_staff_plan_task_types rename constraint hrep_staff_plan_task_types_pk to hper_staff_plan_task_types_pk;
alter table hper_staff_plan_task_types rename constraint hrep_staff_plan_task_types_f2 to hper_staff_plan_task_types_f2;
alter table hpr_indicators rename constraint hpt_indicators_c4 to hpr_indicators_c4;
alter table hzk_migr_persons rename constraint hzk_migr_porsons_pk to hzk_migr_persons_pk;
alter table hzk_person_fprints rename constraint hzk_fprints_pk to hzk_person_fprints_pk;
alter table hzk_person_fprints rename constraint hzk_fprints_f1 to hzk_person_fprints_f1;

----------------------------------------------------------------------------------------------------              
create table htt_time_kinds(
  company_id                      number(20)         not null,
  time_kind_id                    number(20)         not null,
  name                            varchar2(100 char) not null,
  letter_code                     varchar2(50 char)  not null,
  digital_code                    varchar2(50),
  parent_id                       number(20),
  plan_load                       varchar2(1)        not null,
  requestable                     varchar2(1)        not null,  
  bg_color                        varchar2(7),
  color                           varchar2(7),
  state                           varchar2(1)        not null,
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_time_kinds_pk primary key (company_id, time_kind_id) using index tablespace GWS_INDEX,
  constraint htt_time_kinds_u1 unique (time_kind_id) using index tablespace GWS_INDEX,
  constraint htt_time_kinds_f1 foreign key (company_id, parent_id) references htt_time_kinds(company_id, time_kind_id) on delete cascade,
  constraint htt_time_kinds_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_time_kinds_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_time_kinds_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_time_kinds_c2 check (decode(trim(letter_code), letter_code, 1, 0) = 1),
  constraint htt_time_kinds_c3 check (decode(trim(digital_code), digital_code, 1, 0) = 1),
  constraint htt_time_kinds_c5 check (plan_load in ('F', 'P', 'E')),
  constraint htt_time_kinds_c6 check (requestable in ('Y', 'N')),
  constraint htt_time_kinds_c7 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column htt_time_kinds.plan_load is '(F)ull, (P)art, (E)xtra';
comment on column htt_time_kinds.requestable is '(Y)es, (N)o';
comment on column htt_time_kinds.state is '(A)ctive, (P)assive';

create unique index htt_time_kinds_u2 on htt_time_kinds(company_id, lower(name)) tablespace GWS_INDEX;
create unique index htt_time_kinds_u3 on htt_time_kinds(company_id, lower(letter_code)) tablespace GWS_INDEX;
create unique index htt_time_kinds_u4 on htt_time_kinds(nvl2(pcode, company_id, null), pcode) tablespace GWS_INDEX;

create index htt_time_kinds_i1 on htt_time_kinds(company_id, parent_id) tablespace GWS_INDEX;
create index htt_time_kinds_i2 on htt_time_kinds(company_id, created_by) tablespace GWS_INDEX;
create index htt_time_kinds_i3 on htt_time_kinds(company_id, modified_by) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create table htt_timesheet_facts(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  timesheet_id                    number(20) not null,
  time_kind_id                    number(20) not null,
  fact_value                      number(4)  not null,
  constraint htt_timesheet_facts_pk primary key (company_id, filial_id, timesheet_id, time_kind_id) using index tablespace GWS_INDEX,
  constraint htt_timesheet_facts_f1 foreign key (company_id, filial_id, timesheet_id) references htt_timesheets(company_id, filial_id, timesheet_id) on delete cascade,
  constraint htt_timesheet_facts_f2 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id),
  constraint htt_timesheet_facts_c1 check (fact_value >= 0 and fact_value <= 1440)
) tablespace GWS_DATA;

comment on column htt_timesheet_facts.fact_value is 'Measured in minutes';
comment on column htt_timesheet_facts.time_kind_id is 'Only one time_kind with plan_load FULL can be entered in one day';

create index htt_timesheet_facts_i1 on htt_timesheet_facts(company_id, time_kind_id) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
-- rename table
---------------------------------------------------------------------------------------------------- 
alter table htt_leave_helpers rename constraint htt_leave_helpers_pk to htt_request_helpers_pk;
alter table htt_leave_helpers rename constraint htt_leave_helpers_f1 to htt_request_helpers_f1;

alter index htt_leave_helpers_pk rename to htt_request_helpers_pk;
alter index htt_leave_helpers_i1 rename to htt_request_helpers_i1;

rename htt_leave_helpers to htt_request_helpers;

-------------------------------------------------- 
alter table htt_timesheet_leaves rename constraint htt_timesheet_leaves_pk to htt_timesheet_requests_pk;
alter table htt_timesheet_leaves rename constraint htt_timesheet_leaves_f1 to htt_timesheet_requests_f1;
alter table htt_timesheet_leaves rename constraint htt_timesheet_leaves_f2 to htt_timesheet_requests_f2;

alter index htt_timesheet_leaves_pk rename to htt_timesheet_requests_pk;
alter index htt_timesheet_leaves_i1 rename to htt_timesheet_requests_i1;

rename htt_timesheet_leaves to htt_timesheet_requests;

---------------------------------------------------------------------------------------------------- 
-- add columns to htt_requests
----------------------------------------------------------------------------------------------------
alter table htt_requests add request_kind_id number(20);
alter table htt_requests add begin_time      date;
alter table htt_requests add end_time        date;
alter table htt_requests add request_type    varchar2(1);

alter table htt_requests add constraint htt_requests_c2 check (begin_time <= end_time);
alter table htt_requests add constraint htt_requests_c3 check (request_type in ('P', 'F', 'M'));

comment on column htt_requests.request_type is '(P)art of day, (F)ull day, (M)ultiple days';

---------------------------------------------------------------------------------------------------- 
-- rename and refactor htt_leave_types
---------------------------------------------------------------------------------------------------- 
alter table htt_leave_types rename column leave_type_id to request_kind_id;
alter table htt_leave_types rename column requestable   to user_permitted;

alter table htt_leave_types add time_kind_id     number(20);
alter table htt_leave_types add annually_limited varchar2(1);
alter table htt_leave_types add day_count_type   varchar2(1);
alter table htt_leave_types add annual_day_limit number(3);

alter table htt_leave_types rename constraint htt_leave_types_pk to htt_request_kinds_pk;
alter table htt_leave_types rename constraint htt_leave_types_u1 to htt_request_kinds_u1;
alter table htt_leave_types rename constraint htt_leave_types_f1 to htt_request_kinds_f2;
alter table htt_leave_types rename constraint htt_leave_types_f2 to htt_request_kinds_f3;

alter index htt_leave_types_pk rename to htt_request_kinds_pk;
alter index htt_leave_types_u1 rename to htt_request_kinds_u1;
alter index htt_leave_types_i1 rename to htt_request_kinds_i2;
alter index htt_leave_types_i2 rename to htt_request_kinds_i3;

alter table htt_leave_types drop constraint htt_leave_types_c1; 
alter table htt_leave_types drop constraint htt_leave_types_c2; 
alter table htt_leave_types drop constraint htt_leave_types_c3;
alter table htt_leave_types drop constraint htt_leave_types_c4;
alter table htt_leave_types drop constraint htt_leave_types_c5;

alter table htt_leave_types drop column short_name;
alter table htt_leave_types drop column bg_color;
alter table htt_leave_types drop column color;
alter table htt_leave_types drop column timesheet_coef;

alter table htt_leave_types add constraint htt_request_kinds_c1 check (decode(trim(name), name, 1, 0) = 1);
alter table htt_leave_types add constraint htt_request_kinds_c2 check (annually_limited in ('Y', 'N'));
alter table htt_leave_types add constraint htt_request_kinds_c3 check (day_count_type in ('C', 'W', 'P'));
alter table htt_leave_types add constraint htt_request_kinds_c4 check (user_permitted in ('Y', 'N'));
alter table htt_leave_types add constraint htt_request_kinds_c5 check (allow_unused_time in ('Y', 'N'));
alter table htt_leave_types add constraint htt_request_kinds_c6 check (state in ('A', 'P'));
alter table htt_leave_types add constraint htt_request_kinds_c7 check (annually_limited = 'Y' or annual_day_limit is null);
alter table htt_leave_types add constraint htt_request_kinds_c8 check (annual_day_limit >= 0);

rename htt_leave_types to htt_request_kinds;

comment on column htt_request_kinds.annually_limited         is '(Y)es, (N)o. Sets annual limit to number of times this request_type can be requested';
comment on column htt_request_kinds.day_count_type           is '(C)alendar, (W)ork days, (P)roduction days. Days of this request_type will count only on calendar/work/production days';
comment on column htt_request_kinds.annual_day_limit         is 'If annually_limited is set to (Y)es, this attribute keeps limit to number of times this request_type can be requested';
comment on column htt_request_kinds.user_permitted           is 'Employees can request this type of time off or it can be entered only by administrators and managers';
comment on column htt_request_kinds.allow_unused_time        is '(Y)es, (N)o. When set to yes unused request time goes to another time kind';
comment on column htt_request_kinds.request_restriction_days is 'Days before the request begin date is necessary to request it. A negative value allows you to request request retroactively.';
comment on column htt_request_kinds.state                    is '(A)ctive, (P)assive. Used to filter when attached to an employee';

---------------------------------------------------------------------------------------------------- 
-- refactor sequences
---------------------------------------------------------------------------------------------------- 
drop sequence htt_request_types_sq;
drop sequence htt_time_types_sq;

rename htt_leave_types_sq to htt_request_kinds_sq;

create sequence htt_time_kinds_sq;

---------------------------------------------------------------------------------------------------- 
exec fazo_z.run('htt');

exec fazo_z.compile_invalid_objects;

prompt default time kinds insert
declare
  Procedure Time_Kind
  (
    a varchar2,
    b varchar2,
    c varchar2 := null,
    d varchar2,
    e varchar2,
    f varchar2 := null,
    g varchar2 := null,
    h varchar2
  ) is
    v_Time_Kind_Id number;
  begin
    z_Htt_Time_Kinds.Save_One(i_Company_Id   => Ui.Company_Id,
                              i_Time_Kind_Id => Htt_Time_Kinds_Sq.Nextval,
                              i_Name         => a,
                              i_Letter_Code  => b,
                              i_Digital_Code => c,
                              i_Parent_Id    => null,
                              i_Plan_Load    => d,
                              i_Requestable  => e,
                              i_Bg_Color     => f,
                              i_Color        => g,
                              i_State        => 'A',
                              i_Pcode        => h);
  end;
  --------------------------------------------------
  Procedure Table_Record_Setting
  (
    i_Table_Name  varchar2,
    i_Column_Set  varchar2,
    i_Extra_Where varchar2 := null
  ) is
  begin
    z_Md_Table_Record_Translate_Settings.Save_One(i_Table_Name  => i_Table_Name,
                                                  i_Column_Set  => i_Column_Set,
                                                  i_Extra_Where => i_Extra_Where);
  end;
begin
  for r in (select *
              from Md_Companies q
             where q.State = 'A')
  loop
    Ui_Auth.Logon_As_System(i_Company_Id => r.Company_Id);
  
    Time_Kind('Явка', 'Я', null, 'P', 'N', null, null, 'VHR:1');
    Time_Kind('Опоздание', 'ОП', null, 'P', 'N', null, null, 'VHR:2');
    Time_Kind('Ранний Уход', 'РУ', null, 'P', 'N', null, null, 'VHR:3');
    Time_Kind('Почасовой Отгул', 'ПО', null, 'P', 'Y', null, null, 'VHR:4');
    Time_Kind('Выходной', 'В', null, 'F', 'N', null, null, 'VHR:5');
    Time_Kind('Отсутствие', 'ОТС', null, 'P', 'N', null, null, 'VHR:6');
    Time_Kind('Свободное Время', 'СВ', null, 'P', 'N', null, null, 'VHR:7');
    Time_Kind('Больничный', 'Б', null, 'F', 'Y', null, null, 'VHR:8');
    Time_Kind('Отгул', 'О', null, 'F', 'Y', null, null, 'VHR:9');
    Time_Kind('Командировка', 'К', null, 'F', 'Y', null, null, 'VHR:10');
    Time_Kind('Отпуск', 'ОТ', null, 'F', 'Y', null, null, 'VHR:11');
    Time_Kind('Сверхурочныe', 'СУ', null, 'E', 'Y', null, null, 'VHR:12');
  end loop;
  z_Md_Table_Record_Translate_Settings.Delete_One('HTT_TIME_KINDS');
  z_Md_Table_Record_Translate_Settings.Save_One(i_Table_Name => 'HTT_TIME_KINDS',
                                                i_Column_Set => 'NAME');
  commit;
exception
  when others then
    rollback;
    Raise_Application_Error(-20001,
                            'default time kinds insertion error' || Chr(10) || b.Trimmed_Sqlerrm);
end;
/
prompt timesheet requests refactoring vs request kinds fixes
declare
  v_Time_Kind_Id number;
  -------------------------------------------------- 
  Function Time_Kind_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select Time_Kind_Id
      into result
      from Htt_Time_Kinds
     where Company_Id = i_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;
begin
  -- remove change requests
  delete from Htt_Timesheet_Requests Tr
   where not exists (select 1
            from Htt_Leaves l
           where l.Company_Id = Tr.Company_Id
             and l.Filial_Id = Tr.Filial_Id
             and l.Request_Id = Tr.Request_Id);

  ---------------------------------------------------------------------------------------------------- 
  delete from Htt_Requests r
   where not exists (select 1
            from Htt_Leaves l
           where l.Company_Id = r.Company_Id
             and l.Filial_Id = r.Filial_Id
             and l.Request_Id = r.Request_Id);

  ----------------------------------------------------------------------------------------------------
  for r in (select *
              from Md_Companies q
             where q.State = 'A')
  loop
    v_Time_Kind_Id := Time_Kind_Id(i_Company_Id => r.Company_Id, i_Pcode => 'VHR:4');
    begin
      update Htt_Request_Kinds Rk
         set Rk.Time_Kind_Id     = v_Time_Kind_Id,
             Rk.Annually_Limited = 'N',
             Rk.Day_Count_Type   = 'W'
       where Rk.Company_Id = r.Company_Id;
      if sql%notfound then
        null;
      end if;
    end;
  end loop;

  ------------------------------------------------------------------------------------------------
  begin
    update Htt_Requests r
       set (r.Request_Kind_Id, r.Begin_Time, r.End_Time, r.Request_Type) =
           (select l.Leave_Type_Id, l.Begin_Time, l.End_Time, l.Leave_Kind
              from Htt_Leaves l
             where l.Company_Id = r.Company_Id
               and l.Filial_Id = r.Filial_Id
               and l.Request_Id = r.Request_Id)
     where exists (select 1
              from Htt_Leaves l
             where l.Company_Id = r.Company_Id
               and l.Filial_Id = r.Filial_Id
               and l.Request_Id = r.Request_Id);
    if sql%notfound then
      null;
    end if;
  end;

  ------------------------------------------------------------------------------------------------
  delete Htt_Request_Kinds
   where Time_Kind_Id is null;

  commit;

exception
  when others then
    rollback;
    Raise_Application_Error(-20001,
                            'timesheet requests refactoring vs request kinds fixes' || Chr(10) ||
                            b.Trimmed_Sqlerrm);
end;
/

---------------------------------------------------------------------------------------------------- 
-- htt_requests
---------------------------------------------------------------------------------------------------- 
alter table htt_requests drop constraint htt_requests_f1;

drop index htt_requests_i1;

alter table htt_requests modify request_kind_id not null;
alter table htt_requests modify begin_time not null;
alter table htt_requests modify end_time not null;
alter table htt_requests modify request_type not null;

alter table htt_requests add constraint htt_requests_f1 foreign key (company_id, request_kind_id) references htt_request_kinds(company_id, request_kind_id); 

create index htt_requests_i1 on htt_requests(company_id, request_kind_id) tablespace GWS_INDEX;

alter table htt_requests drop column request_type_id;

---------------------------------------------------------------------------------------------------- 
-- htt_request_kinds
---------------------------------------------------------------------------------------------------- 
alter table htt_request_kinds modify time_kind_id not null;
alter table htt_request_kinds modify annually_limited not null;
alter table htt_request_kinds modify day_count_type not null;

----------------------------------------------------------------------------------------------------
-- refactoring htt_timesheets
----------------------------------------------------------------------------------------------------  
alter table htt_timesheets drop constraint htt_timesheets_c7;
alter table htt_timesheets drop constraint htt_timesheets_c8;
alter table htt_timesheets drop constraint htt_timesheets_c9;

alter table htt_timesheets drop column fact_time;
alter table htt_timesheets drop column in_time;
alter table htt_timesheets drop column free_time;
alter table htt_timesheets drop column late_time;
alter table htt_timesheets drop column lack_time;
alter table htt_timesheets drop column early_time;
alter table htt_timesheets drop column leave_time;
alter table htt_timesheets drop column leave_paid_time;

alter table htt_timesheets add constraint htt_timesheets_c7 check (full_time >= 0 and plan_time >= 0 and full_time <= 1440);
alter table htt_timesheets add constraint htt_timesheets_c8 check (plan_time <= full_time);

---------------------------------------------------------------------------------------------------- 
-- drop tables
---------------------------------------------------------------------------------------------------- 
drop table htt_change_times;
drop table htt_changes;
drop table htt_request_types;
drop table htt_leaves;
drop table htt_time_types;

exec Fazo_z.Run('htt');
exec Fazo_z.Compile_Invalid_Objects;

---------------------------------------------------------------------------------------------------- 
declare  
begin
  for r in (select *
              from Htt_Timesheets)
  loop        
    Htt_Core.Gen_Timesheet_Facts(i_Company_Id   => r.Company_Id,
                                 i_Filial_Id    => r.Filial_Id,
                                 i_Timesheet_Id => r.Timesheet_Id);
  end loop;
  commit;
end;
/

prompt drop hpr_timesheet tables
drop table hpr_timesheet_facts cascade constraints;
drop table hpr_timesheet_dates cascade constraints;
drop table hpr_timesheet_staffs cascade constraints;
drop table hpr_timesheets cascade constraints;

drop sequence hpr_timesheets_sq;
drop sequence hpr_timesheet_staffs_sq;
drop sequence hpr_timesheet_dates_sq;
drop sequence hpr_timesheet_facts_sq;

create sequence hpr_timebooks_sq;
create sequence hpr_timebook_staffs_sq;
create sequence hpr_timebook_schedules_sq;
create sequence hpr_timebook_dates_sq;


----------------------------------------------------------------------------------------------------
-- timebook
----------------------------------------------------------------------------------------------------
create table hpr_timebooks(
  company_id                      number(20)        not null,
  filial_id                       number(20)        not null,
  timebook_id                     number(20)        not null,
  timebook_number                 varchar2(50 char) not null,
  timebook_date                   date              not null,
  month                           date              not null,
  division_id                     number(20),
  status                          varchar2(1)       not null,
  note                            varchar2(300 char),
  barcode                         varchar2(25)      not null,
  created_by                      number(20)        not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)        not null,
  modified_on                     timestamp with local time zone not null,
  constraint hpr_timebooks_pk primary key (company_id, filial_id, timebook_id) using index tablespace GWS_INDEX,
  constraint hpr_timebooks_u1 unique (timebook_id) using index tablespace GWS_INDEX,
  constraint hpr_timebooks_f1 foreign key (company_id, filial_id, division_id) references mhr_divisions(company_id, filial_id, division_id),
  constraint hpr_timebooks_f2 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint hpr_timebooks_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint hpr_timebooks_c1 check (decode(trim(timebook_number), timebook_number, 1, 0) = 1),
  constraint hpr_timebooks_c2 check (trunc(timebook_date) = timebook_date),
  constraint hpr_timebooks_c3 check (status in ('N', 'S', 'A', 'R')),
  constraint hpr_timebooks_c4 check (trunc(month, 'MON') = month),
  constraint hpr_timebooks_c5 check (decode(trim(barcode), barcode, 1, 0) = 1)
) tablespace GWS_DATA;

comment on column hpr_timebooks.status is '(N)ew, (S)ent, (A)ccepted, (R)eturned';

create index hpr_timebooks_i1 on hpr_timebooks(company_id, filial_id, division_id) tablespace GWS_INDEX;
create index hpr_timebooks_i2 on hpr_timebooks(company_id, created_by) tablespace GWS_INDEX;
create index hpr_timebooks_i3 on hpr_timebooks(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_timebook_staffs(
  company_id                      number(20) not null,
  staff_unit_id                   number(20) not null,
  filial_id                       number(20) not null,
  timebook_id                     number(20) not null,
  staff_id                        number(20) not null,
  constraint hpr_timebook_staffs_pk primary key (company_id, staff_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_staffs_u1 unique (staff_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_staffs_u2 unique (company_id, filial_id, timebook_id, staff_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_staffs_f1 foreign key (company_id, filial_id, timebook_id) references hpr_timebooks(company_id, filial_id, timebook_id) on delete cascade,
  constraint hpr_timebook_staffs_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id)
) tablespace GWS_DATA;

create index hpr_timebook_staffs_i1 on hpr_timebook_staffs(company_id, filial_id, staff_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_timebook_schedules(
  company_id                              number(20) not null,
  schedule_unit_id                        number(20) not null,
  staff_unit_id                           number(20) not null,
  filial_id                               number(20) not null,
  schedule_id                             number(20) not null,
  monthly_plan_time                       number(5)  not null,
  monthly_plan_days                       number(2)  not null,
  constraint hpr_timebook_schedules_pk primary key (company_id, schedule_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_schedules_u1 unique (schedule_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_schedules_u2 unique (company_id, filial_id, staff_unit_id, schedule_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_schedules_f1 foreign key (company_id, staff_unit_id) references hpr_timebook_staffs(company_id, staff_unit_id) on delete cascade,
  constraint hpr_timebook_schedules_f2 foreign key (company_id, filial_id, schedule_id) references htt_schedules(company_id, filial_id, schedule_id),
  constraint hpr_timebook_schedules_c1 check (monthly_plan_time >= 0 and  monthly_plan_days >= 0)
)tablespace GWS_DATA;

create index hpr_timebook_schedules_i1 on hpr_timebook_schedules(company_id, staff_unit_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_timebook_dates(
  company_id                      number(20)  not null,
  date_unit_id                    number(20)  not null,
  schedule_unit_id                number(20)  not null,
  date_value                      date        not null,
  day_kind                        varchar2(1) not null,
  plan_time                       number(4)   not null,
  constraint hpr_timebook_dates_pk primary key (company_id, date_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_dates_u1 unique (date_unit_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_dates_f1 foreign key (company_id, schedule_unit_id) references hpr_timebook_schedules(company_id, schedule_unit_id) on delete cascade,
  constraint hpr_timebook_dates_c1 check (trunc(date_value) = date_value),
  constraint hpr_timebook_dates_c2 check (day_kind in ('W', 'R')),
  constraint hpr_timebook_dates_c3 check (plan_time between 0 and 1440)
) tablespace GWS_DATA;

comment on column hpr_timebook_dates.day_kind is '(W)ork, (R)est';

create index hpr_timebook_dates_i1 on hpr_timebook_dates(company_id, schedule_unit_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_timebook_facts(
  company_id                      number(20) not null,
  date_unit_id                    number(20) not null,
  time_kind_id                    number(20) not null,
  fact_value                      number(4)  not null,
  constraint hpr_timebook_facts_pk primary key (company_id, date_unit_id, time_kind_id) using index tablespace GWS_INDEX,
  constraint hpr_timebook_facts_f1 foreign key (company_id, date_unit_id) references hpr_timebook_dates(company_id, date_unit_id) on delete cascade,
  constraint hpr_timebook_facts_f2 foreign key (company_id, time_kind_id) references htt_time_kinds(company_id, time_kind_id),
  constraint hpr_timebook_facts_c1 check (fact_value between 0 and 1440)
) tablespace GWS_DATA;

create index hpr_timebook_facts_i1 on hpr_timebook_facts(company_id, time_kind_id) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table hpr_timebook_locks(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  staff_id                        number(20) not null,
  month                           date       not null,
  timebook_id                     number(20) not null,
  constraint hpr_timebook_locks_pk primary key (company_id, filial_id, staff_id, month) using index tablespace GWS_INDEX,
  constraint hpr_timebook_locks_f1 foreign key (company_id, filial_id, timebook_id) references hpr_timebooks(company_id, filial_id, timebook_id),
  constraint hpr_timebook_locks_f2 foreign key (company_id, filial_id, staff_id) references href_staffs(company_id, filial_id, staff_id),
  constraint hpr_timebook_locks_c1 check (trunc(month, 'MON') = month)
) tablespace GWS_DATA;

create index hpr_timebook_locks_i1 on hpr_timebook_locks(company_id, filial_id, timebook_id) tablespace GWS_INDEX;

prompt indicators, operation groups, book types fixes
declare
  --------------------------------------------------
  Procedure Indicator
  (
    i_Name       varchar2,
    i_Short_Name varchar2,
    i_Identifier varchar2,
    i_Used       varchar2,
    i_Pcode      varchar2
  ) is
    v_Indicator_Id number;
  begin
    begin
      select Indicator_Id
        into v_Indicator_Id
        from Hpr_Indicators
       where Company_Id = Ui.Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Indicator_Id := Hpr_Next.Indicator_Id;
    end;
  
    z_Hpr_Indicators.Save_One(i_Company_Id   => Ui.Company_Id,
                              i_Indicator_Id => v_Indicator_Id,
                              i_Name         => i_Name,
                              i_Short_Name   => i_Short_Name,
                              i_Identifier   => i_Identifier,
                              i_Used         => i_Used,
                              i_State        => 'A',
                              i_Pcode        => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Operation_Group
  (
    i_Operation_Kind     varchar2,
    i_Name               varchar2,
    i_Estimation_Type    varchar2,
    i_Estimation_Formula varchar2,
    i_Pcode              varchar2
  ) is
    v_Oper_Group_Id number;
  begin
    begin
      select Oper_Group_Id
        into v_Oper_Group_Id
        from Hpr_Oper_Groups
       where Company_Id = Ui.Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Group_Id := Hpr_Next.Oper_Group_Id;
    end;
  
    z_Hpr_Oper_Groups.Save_One(i_Company_Id         => Ui.Company_Id,
                               i_Oper_Group_Id      => v_Oper_Group_Id,
                               i_Operation_Kind     => i_Operation_Kind,
                               i_Name               => i_Name,
                               i_Estimation_Type    => i_Estimation_Type,
                               i_Estimation_Formula => i_Estimation_Formula,
                               i_Pcode              => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Book_Type
  (
    i_Name  varchar2,
    i_Pcode varchar2
  ) is
    v_Book_Type_Id number;
  begin
    begin
      select Book_Type_Id
        into v_Book_Type_Id
        from Hpr_Book_Types
       where Company_Id = Ui.Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Book_Type_Id := Hpr_Next.Book_Type_Id;
    end;
  
    z_Hpr_Book_Types.Save_One(i_Company_Id   => Ui.Company_Id,
                              i_Book_Type_Id => v_Book_Type_Id,
                              i_Name         => i_Name,
                              i_Pcode        => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Book_Type_Bind
  (
    i_Book_Type_Pcode  varchar2,
    i_Oper_Group_Pcode varchar2
  ) is
    v_Book_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    select Book_Type_Id
      into v_Book_Type_Id
      from Hpr_Book_Types
     where Company_Id = Ui.Company_Id
       and Pcode = i_Book_Type_Pcode;
  
    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = Ui.Company_Id
       and Pcode = i_Oper_Group_Pcode;
  
    z_Hpr_Book_Type_Binds.Insert_Try(i_Company_Id    => Ui.Company_Id,
                                     i_Book_Type_Id  => v_Book_Type_Id,
                                     i_Oper_Group_Id => v_Oper_Group_Id);
  end;
begin
  for r in (select *
              from Md_Companies)
  loop
    Ui_Auth.Logon_As_System(r.Company_Id);
    ----------------------------------------------------------------------------------------------------
    Dbms_Output.Put_Line('==== Indicators ====');
    Indicator('Оклад',
              'Оклад',
              'Оклад',
              Hpr_Pref.c_Indicator_Used_Constantly,
              'VHR:1');
    Indicator('Доля неполного рабочего времени',
              'Доля неполн. времени',
              'ДоляНеполногоРабочегоВремени',
              null,
              'VHR:2');
    Indicator('Норма дней', 'Норма (дн.)', 'НормаДней', null, 'VHR:3');
    Indicator('Время в днях',
              'Время в днях',
              'ВремяВДнях',
              null,
              'VHR:4');
    Indicator('Норма часов',
              'Норма (часов)',
              'НормаЧасов',
              null,
              'VHR:5');
    Indicator('Время в часах',
              'Время в часах',
              'ВремяВЧасах',
              null,
              'VHR:6');
    Indicator('Бонус за эффективность',
              'Бонус за эффект.',
              'БонусЗаЭффективность',
              Hpr_Pref.c_Indicator_Used_Constantly,
              'VHR:7');
    Indicator('Дополнительный бонус за эффективность',
              'Доп. бонус за эффект.',
              'ДополнительныйБонусЗаЭффективность',
              Hpr_Pref.c_Indicator_Used_Constantly,
              'VHR:8');
    ----------------------------------------------------------------------------------------------------
    Dbms_Output.Put_Line('==== Operation groups ====');
    Operation_Group(Mpr_Pref.c_Ok_Accrual,
                    'Повременная оплата труда и надбавки',
                    Hpr_Pref.c_Estimation_Type_Formula,
                    'Оклад * ДоляНеполногоРабочегоВремени * ВремяВДнях / НормаДней',
                    'VHR:1');
    Operation_Group(Mpr_Pref.c_Ok_Accrual,
                    'Бонус за эффективность',
                    Hpr_Pref.c_Estimation_Type_Formula,
                    'БонусЗаЭффективность + ДополнительныйБонусЗаЭффективность',
                    'VHR:2');
    ----------------------------------------------------------------------------------------------------
    Dbms_Output.Put_Line('==== Book types ====');
    Book_Type('Начисление зарплаты и взносов', 'VHR:1');
    ----------------------------------------------------------------------------------------------------
    Dbms_Output.Put_Line('==== Book type binds ====');
    Book_Type_Bind('VHR:1', 'VHR:1');
    Book_Type_Bind('VHR:1', 'VHR:2');
  end loop;
  
  commit;
  
exception
  when others then
    rollback;
    Raise_Application_Error(-20001,
                            'indicators, operation groups, book types fixes' || Chr(10) ||
                            b.Trimmed_Sqlerrm);
end;
/
exec fazo_z.run('h');
exec fazo_z.Compile_Invalid_Objects;
