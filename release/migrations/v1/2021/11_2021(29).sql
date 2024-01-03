prompt migr 29.11.2021
----------------------------------------------------------------------------------------------------    
create table href_sick_leave_reasons(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  reason_id                       number(20)         not null,
  name                            varchar2(100 char) not null,
  coefficient                     number(7,6)        not null,
  state                           varchar2(1)        not null,
  code                            varchar2(50 char),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,  
  constraint href_sick_leave_reasons_pk primary key (company_id, filial_id, reason_id) using index tablespace GWS_INDEX,
  constraint href_sick_leave_reasons_u1 unique (reason_id) using index tablespace GWS_INDEX,
  constraint href_sick_leave_reasons_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint href_sick_leave_reasons_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint href_sick_leave_reasons_c1 check (decode(trim(name), name, 1, 0) = 1),
  constraint href_sick_leave_reasons_c2 check (decode(trim(code), code, 1, 0) = 1),
  constraint href_sick_leave_reasons_c4 check (coefficient between 0 and 1),
  constraint href_sick_leave_reasons_c6 check (state in ('A', 'P'))
) tablespace GWS_DATA;

comment on column href_sick_leave_reasons.state is '(A)ctive, (P)assive';

create unique index href_sick_leave_reasons_u2 on href_sick_leave_reasons(nvl2(code, company_id, null), code) tablespace GWS_INDEX;

create index href_sick_leave_reasons_i1 on href_sick_leave_reasons(company_id, created_by) tablespace GWS_INDEX;
create index href_sick_leave_reasons_i2 on href_sick_leave_reasons(company_id, modified_by) tablespace GWS_INDEX;

---------------------------------------------------------------------------------------------------- 
create sequence href_sick_leave_reasons_sq;

---------------------------------------------------------------------------------------------------- 
create table htt_calendars(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  calendar_id                     number(20)         not null,
  name                            varchar2(100 char) not null,
  code                            varchar2(50),
  pcode                           varchar2(20),
  created_by                      number(20)         not null,
  created_on                      timestamp with local time zone not null,
  modified_by                     number(20)         not null,
  modified_on                     timestamp with local time zone not null,
  constraint htt_calendars_pk primary key (company_id, filial_id, calendar_id) using index tablespace GWS_INDEX,
  constraint htt_calendars_u1 unique (calendar_id) using index tablespace GWS_INDEX,
  constraint htt_calendars_f1 foreign key (company_id, created_by) references md_users(company_id, user_id),
  constraint htt_calendars_f2 foreign key (company_id, modified_by) references md_users(company_id, user_id),
  constraint htt_calendars_c1 check (decode(trim(name), name, 1, 0) = 1)
) tablespace GWS_DATA;

comment on table htt_calendars is 'Keeps business calendars (Производственный календарь)';

create unique index htt_calendars_u2 on htt_calendars(company_id, filial_id, lower(name)) tablespace GWS_INDEX;
create unique index htt_calendars_u3 on htt_calendars(nvl2(code, company_id, null), nvl2(code, filial_id, null), code) tablespace GWS_INDEX;
create unique index htt_calendars_u4 on htt_calendars(nvl2(pcode, company_id, null), nvl2(pcode, filial_id, null), pcode) tablespace GWS_INDEX;
create index htt_calendars_i1 on htt_calendars(company_id, created_by) tablespace GWS_INDEX;
create index htt_calendars_i2 on htt_calendars(company_id, modified_by) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
create table htt_calendar_rest_days(
  company_id                      number(20) not null,
  filial_id                       number(20) not null,
  calendar_id                     number(20) not null,
  week_day_no                     number(1)  not null,
  constraint htt_calendar_rest_days_pk primary key (company_id, filial_id, calendar_id, week_day_no) using index tablespace GWS_INDEX,
  constraint htt_calendar_rest_days_f1 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id) on delete cascade,
  constraint htt_calendar_rest_days_c1 check (week_day_no between 1 and 7)
) tablespace GWS_DATA;

comment on table htt_calendar_rest_days is 'Keeps official rest week days in calendar';

comment on column htt_calendar_rest_days.week_day_no is 'ISO week day number (1 - Monday, 7 - Sunday)';

----------------------------------------------------------------------------------------------------
create table htt_calendar_days(
  company_id                      number(20)         not null,
  filial_id                       number(20)         not null,
  calendar_id                     number(20)         not null,
  calendar_date                   date               not null,
  name                            varchar2(100 char) not null,
  day_type                        varchar2(1)        not null,
  swapped_date                    date,
  constraint htt_calendar_days_pk primary key (company_id, filial_id, calendar_id, calendar_date) using index tablespace GWS_INDEX,
  constraint htt_calendar_days_f1 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id) on delete cascade,
  constraint htt_calendar_days_c1 check (trunc(calendar_date) = calendar_date),
  constraint htt_calendar_days_c2 check (decode(trim(name), name, 1, 0) = 1),
  constraint htt_calendar_days_c3 check (day_type in ('H', 'N', 'S')),
  constraint htt_calendar_days_c4 check (decode(day_type, 'S', 1, 0) = nvl2(swapped_date, 1, 0)),
  constraint htt_calendar_days_c5 check (calendar_date <> swapped_date),
  constraint htt_calendar_days_c6 check (trunc(swapped_date) = swapped_date)
) tablespace GWS_DATA;

comment on table htt_calendar_days is 'Keeps only special days in calendar';

comment on column htt_calendar_days.day_type     is '(H)oliday, (N)on-Working, Rest (S)wapped day';
comment on column htt_calendar_days.swapped_date is 'Works only for day type Rest (S)wapped day, only when calendar day is rest and swapped is work day';

create unique index htt_calendar_days_u1 on htt_calendar_days(nvl2(swapped_date, company_id, null), 
                                                              nvl2(swapped_date, filial_id, null), 
                                                              nvl2(swapped_date, calendar_id, null),
                                                              swapped_date) tablespace GWS_INDEX;
create index htt_calendar_days_i1 on htt_calendar_days(company_id, filial_id, calendar_id, extract(year from calendar_date)) tablespace GWS_INDEX;

----------------------------------------------------------------------------------------------------
alter table htt_schedules add calendar_id     number(20);
alter table htt_schedules add take_holidays   varchar2(1);
alter table htt_schedules add take_nonworking varchar2(1);
----------------------------------------------------------------------------------------------------
drop index htt_schedules_i1;
drop index htt_schedules_i2;
----------------------------------------------------------------------------------------------------
alter table htt_schedules drop constraint htt_schedules_f1;
alter table htt_schedules drop constraint htt_schedules_f2;
alter table htt_schedules drop constraint htt_schedules_c5;
----------------------------------------------------------------------------------------------------
alter table htt_schedules add constraint htt_schedules_f1 foreign key (company_id, filial_id, calendar_id) references htt_calendars(company_id, filial_id, calendar_id);
alter table htt_schedules add constraint htt_schedules_f2 foreign key (company_id, created_by) references md_users(company_id, user_id);
alter table htt_schedules add constraint htt_schedules_f3 foreign key (company_id, modified_by) references md_users(company_id, user_id);
alter table htt_schedules add constraint htt_schedules_c5 check (take_holidays in ('Y', 'N'));
alter table htt_schedules add constraint htt_schedules_c6 check (take_nonworking in ('Y', 'N'));
alter table htt_schedules add constraint htt_schedules_c7 check (nvl2(calendar_id, 2, 0) = nvl2(take_holidays, 1, 0) + nvl2(take_nonworking, 1, 0));
alter table htt_schedules add constraint htt_schedules_c8 check (state in ('A', 'P'));
----------------------------------------------------------------------------------------------------
create index htt_schedules_i1 on htt_schedules(company_id, filial_id, calendar_id) tablespace GWS_INDEX;
create index htt_schedules_i2 on htt_schedules(company_id, created_by) tablespace GWS_INDEX;
create index htt_schedules_i3 on htt_schedules(company_id, modified_by) tablespace GWS_INDEX;
----------------------------------------------------------------------------------------------------
comment on column htt_schedules.take_holidays     is '(Y)es, (N)o, when yes takes holidays from calendar';
comment on column htt_schedules.take_nonworking   is '(Y)es, (N)o, when yes takes nonworking days from calendar';
----------------------------------------------------------------------------------------------------
create sequence htt_calendars_sq;
----------------------------------------------------------------------------------------------------
exec fazo_z.run('htt_calendar');
---------------------------------------------------------------------------------------------------- 
declare
  Procedure Calendar
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2,
    i_Code       varchar2,
    i_Pcode      varchar2
  ) is
    v_Calendar_Id number;
  begin
    begin
      select Calendar_Id
        into v_Calendar_Id
        from Htt_Calendars c
       where c.Company_Id = i_Company_Id
         and c.Filial_Id = i_Filial_Id
         and c.Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Calendar_Id := Htt_Calendars_Sq.Nextval;
    end;
  
    z_Htt_Calendars.Save_One(i_Company_Id  => i_Company_Id,
                             i_Filial_Id   => i_Filial_Id,
                             i_Calendar_Id => v_Calendar_Id,
                             i_Name        => i_Name,
                             i_Code        => i_Code,
                             i_Pcode       => i_Pcode);
  end;
  
  -------------------------------------------------- 
  Procedure Time_Kind
  (
    i_Company_Id   number,
    i_Name         varchar2,
    i_Letter_Code  varchar2,
    i_Digital_Code varchar2 := null,
    i_Parent_Pcode varchar2 := null,
    i_Plan_Load    varchar2,
    i_Requestable  varchar2,
    i_Bg_Color     varchar2 := null,
    i_Color        varchar2 := null,
    i_Pcode        varchar2
  ) is
    v_Time_Kind_Id number;
    v_Parent_Id    number;
  begin
    begin
      select Time_Kind_Id
        into v_Time_Kind_Id
        from Htt_Time_Kinds
       where Company_Id = i_Company_Id
         and (Pcode = i_Pcode or --
             name = i_Name or -- 
             Letter_Code = i_Letter_Code);
    exception
      when No_Data_Found then
        v_Time_Kind_Id := Htt_Next.Time_Kind_Id;
    end;
  
    begin
      select Time_Kind_Id
        into v_Parent_Id
        from Htt_Time_Kinds
       where Company_Id = i_Company_Id
         and Pcode = i_Parent_Pcode;
    exception
      when No_Data_Found then
        v_Parent_Id := null;
    end;
  
    z_Htt_Time_Kinds.Save_One(i_Company_Id   => i_Company_Id,
                              i_Time_Kind_Id => v_Time_Kind_Id,
                              i_Name         => i_Name,
                              i_Letter_Code  => i_Letter_Code,
                              i_Digital_Code => i_Digital_Code,
                              i_Parent_Id    => v_Parent_Id,
                              i_Plan_Load    => i_Plan_Load,
                              i_Requestable  => i_Requestable,
                              i_Bg_Color     => i_Bg_Color,
                              i_Color        => i_Color,
                              i_State        => 'A',
                              i_Pcode        => i_Pcode);
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
  Table_Record_Setting('HTT_CALENDARS', 'NAME');
  
  -------------------------------------------------- 
  for r in (select *
              from Md_Companies q
             where Md_Util.Any_Project(q.Company_Id) is not null
               and q.State = 'A')
  loop
    Ui_Auth.Logon_As_System(i_Company_Id => r.Company_Id);
    ---------------------------------------------------------------------------------------------------- 
    Time_Kind(r.Company_Id, 'Рабочая Встреча', 'РВ', null, Htt_Pref.c_Pcode_Time_Kind_Turnout, 'P', 'Y', null, null, 'VHR:13'); 
    Time_Kind(r.Company_Id, 'Праздник', 'П', null, Htt_Pref.c_Pcode_Time_Kind_Rest, 'F', 'N', '#50C878', '#fff', 'VHR:14');
    Time_Kind(r.Company_Id, 'Нерабочий день', 'НД', null, Htt_Pref.c_Pcode_Time_Kind_Rest, 'F', 'N', 'FFD300', '#000', 'VHR:15');
  end loop;
  
  -------------------------------------------------- 
  for r in (select *
              from Md_Filials f
             where f.State = 'A'
               and (f.Company_Id = Md_Pref.Company_Head or
                   f.Filial_Id <> Md_Pref.Filial_Head(f.Company_Id))
               and exists (select 1
                      from Md_Companies c
                     where c.Company_Id = f.Company_Id
                       and c.State = 'A'
                       and Md_Util.Any_Project(c.Company_Id) is not null))
  loop
    Ui_Auth.Logon_As_System(i_Company_Id => r.Company_Id);
    -------------------------------------------------- 
    Calendar(r.Company_Id, r.Filial_Id, 'Производственный календарь', null, 'VHR:1');
  end loop;
  
  commit;
end;
/

