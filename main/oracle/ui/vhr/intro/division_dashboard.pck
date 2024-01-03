create or replace package Ui_Vhr458 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Divisions(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Hybrid_Chart_Stats(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Xy_Chart_Stats(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr458;
/
create or replace package body Ui_Vhr458 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR458:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_division_groups',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('division_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Divisions(p Hashmap) return Fazo_Query is
    v_Params Hashmap := Hashmap();
    v_Query  varchar2(32767);
    v_Period date := p.r_Date('period');
    v_Ids    Array_Number;
    q        Fazo_Query;
  begin
    v_Params.Put('company_id', Ui.Company_Id);
    v_Params.Put('filial_id', Ui.Filial_Id);
    v_Params.Put('period', v_Period);
    v_Params.Put('merge_datetime', case when Trunc(sysdate) = v_Period then sysdate else null end);
    v_Params.Put('late', t('factor: late'));
    v_Params.Put('early', t('factor: early'));
    v_Params.Put('lack', t('factor: lack'));
    v_Params.Put('not_opened', t('factor: not opened'));
    v_Params.Put('not_closed', t('factor: not closed'));
    v_Params.Put('format', Href_Pref.c_Time_Format_Minute);
    v_Params.Put('unnormal', Uit_Htt.c_Status_Unnormal);
    v_Params.Put('os_not_opened', Uit_Htt.c_Open_Status_Not_Opened);
    v_Params.Put('cs_not_closed', Uit_Htt.c_Close_Status_Not_Closed);
  
    v_Query := 'select q.*,
                       s.schedule_id,
                       to_char(f.opened_date, :format) as opened_time,
                       to_char(f.closed_date, :format) as closed_time,
                       uit_htt.to_time_seconds_text(f.intime) as intime,
                       uit_htt.to_time_seconds_text(f.fact_time) as fact_time,
                       f.status,
                       case when f.late_time > 0 then ''Y'' else ''N'' end as is_late,
                       case when f.early_time > 0 then ''Y'' else ''N'' end as is_early,
                       case when f.lack_time > 0 then ''Y'' else ''N'' end as is_lack,
                       case 
                         when f.status = :unnormal and f.open_status = :os_not_opened then 
                           ''Y'' 
                         else 
                           ''N'' 
                       end as is_not_opened,
                       case 
                         when f.status = :unnormal and f.close_status = :cs_not_closed then 
                           ''Y'' 
                         else 
                           ''N'' 
                       end as is_not_closed,
                       (select listagg(d.factor, '', '')
                          from (select :late as factor
                                  from dual
                                 where f.late_time > 0
                                 union
                                select :early
                                  from dual
                                 where f.early_time > 0
                                 union
                                select :lack
                                  from dual
                                 where f.lack_time > 0
                                 union
                                select :not_opened
                                  from dual
                                 where f.status = :unnormal and f.open_status = :os_not_opened
                                 union
                                select :not_closed
                                  from dual
                                 where f.status = :unnormal and f.close_status = :cs_not_closed) d) as factors
                  from mhr_divisions q
                  join hrm_divisions dv
                    on dv.company_id = q.company_id
                   and dv.filial_id = q.filial_id
                   and dv.division_id = q.division_id
                   and dv.is_department = ''Y''
                  left join hrm_division_schedules s
                    on s.company_id = :company_id
                   and s.filial_id = :filial_id
                   and s.division_id = q.division_id
                  join uit_htt.division_infos(i_company_id     => :company_id,
                                              i_filial_id      => :filial_id,
                                              i_period         => :period,
                                              i_merge_datetime => :merge_datetime) f
                    on f.company_id = :company_id
                   and f.filial_id = :filial_id
                   and f.division_id = q.division_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.state = ''A''';
  
    -- division group
    v_Ids := Nvl(p.o_Array_Number('division_group_ids'), Array_Number());
  
    if v_Ids.Count > 0 then
      v_Params.Put('division_group_ids', v_Ids);
    
      v_Query := v_Query || ' and q.division_group_id member of :division_group_ids';
    end if;
  
    -- schedule
    v_Ids := Nvl(p.o_Array_Number('schedule_ids'), Array_Number());
  
    if v_Ids.Count > 0 then
      v_Params.Put('schedule_ids', v_Ids);
    
      v_Query := v_Query || ' and s.schedule_id member of :schedule_ids';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('division_id', 'division_group_id', 'schedule_id');
    q.Varchar2_Field('name',
                     'code',
                     'opened_time',
                     'closed_time',
                     'intime',
                     'fact_time',
                     'status',
                     'is_late',
                     'is_early',
                     'is_lack');
    q.Varchar2_Field('factors', 'is_not_opened', 'is_not_closed');
  
    q.Refer_Field('division_group_name',
                  'division_group_id',
                  'mhr_division_groups',
                  'division_group_id',
                  'name',
                  'select *
                     from mhr_division_groups d
                    where d.company_id = :company_id');
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select *
                     from htt_schedules d
                    where d.company_id = :company_id
                      and d.filial_id = :filial_id');
  
    q.Option_Field('status_name',
                   'status',
                   Array_Varchar2(Uit_Htt.c_Status_Normal,
                                  Uit_Htt.c_Status_Unnormal,
                                  Uit_Htt.c_Status_No_Timesheet,
                                  Uit_Htt.c_Status_Rest_Day,
                                  Uit_Htt.c_Status_Not_Begin),
                   Array_Varchar2(t('status: normal'),
                                  t('status: unnormal'),
                                  t('status: no timesheet'),
                                  t('status: rest day'),
                                  t('status: not begin')));
    q.Option_Field('is_late_name',
                   'is_late',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('is_early_name',
                   'is_early',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('is_lack_name',
                   'is_lack',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('is_not_opened_name',
                   'is_not_opened',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('is_not_closed_name',
                   'is_not_closed',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('period_begin', Trunc(sysdate), 'period_end', Trunc(sysdate));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Hybrid_Chart_Stats(p Hashmap) return Hashmap is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Division_Group_Ids Array_Number := Nvl(p.o_Array_Number('division_group_ids'), Array_Number());
    v_Division_Group_Cnt number := v_Division_Group_Ids.Count;
    v_Schedule_Ids       Array_Number := Nvl(p.o_Array_Number('schedule_ids'), Array_Number());
    v_Schedule_Cnt       number := v_Schedule_Ids.Count;
    v_Period             date := p.r_Date('period');
    v_Merge_Datetime     date;
  
    v_Normal_Cnt       number;
    v_Unnormal_Cnt     number;
    v_No_Timesheet_Cnt number;
    v_Rest_Day_Cnt     number;
    v_Not_Begin_Cnt    number;
  
    v_Late_Cnt       number;
    v_Early_Cnt      number;
    v_Lack_Cnt       number;
    v_Not_Opened_Cnt number;
    v_Not_Closed_Cnt number;
  
    result Hashmap := Hashmap();
  begin
    if v_Period = Trunc(sysdate) then
      v_Merge_Datetime := sysdate;
    end if;
  
    select sum(Decode(q.Status, Uit_Htt.c_Status_Normal, 1, 0)),
           sum(Decode(q.Status, Uit_Htt.c_Status_Unnormal, 1, 0)),
           sum(Decode(q.Status, Uit_Htt.c_Status_No_Timesheet, 1, 0)),
           sum(Decode(q.Status, Uit_Htt.c_Status_Rest_Day, 1, 0)),
           sum(Decode(q.Status, Uit_Htt.c_Status_Not_Begin, 1, 0)),
           count(Nullif(q.Late_Time, 0)),
           count(Nullif(q.Early_Time, 0)),
           count(Nullif(q.Lack_Time, 0)),
           count(case
                    when q.Status = Uit_Htt.c_Status_Unnormal and
                         q.Open_Status = Uit_Htt.c_Open_Status_Not_Opened then
                     1
                    else
                     null
                  end),
           count(case
                    when q.Status = Uit_Htt.c_Status_Unnormal and
                         q.Close_Status = Uit_Htt.c_Close_Status_Not_Closed then
                     1
                    else
                     null
                  end)
      into v_Normal_Cnt,
           v_Unnormal_Cnt,
           v_No_Timesheet_Cnt,
           v_Rest_Day_Cnt,
           v_Not_Begin_Cnt,
           v_Late_Cnt,
           v_Early_Cnt,
           v_Lack_Cnt,
           v_Not_Opened_Cnt,
           v_Not_Closed_Cnt
      from Uit_Htt.Division_Infos(i_Company_Id     => v_Company_Id,
                                  i_Filial_Id      => v_Filial_Id,
                                  i_Period         => v_Period,
                                  i_Merge_Datetime => v_Merge_Datetime) q
      join Mhr_Divisions d
        on d.Company_Id = v_Company_Id
       and d.Filial_Id = v_Filial_Id
       and d.Division_Id = q.Division_Id
       and d.State = 'A'
      join Hrm_Divisions Dv
        on Dv.Company_Id = v_Company_Id
       and Dv.Filial_Id = v_Filial_Id
       and Dv.Division_Id = q.Division_Id
       and Dv.Is_Department = 'Y'
     where (v_Division_Group_Cnt = 0 or d.Division_Group_Id member of v_Division_Group_Ids)
       and (v_Schedule_Cnt = 0 or exists
            (select 1
               from Hrm_Division_Schedules s
              where s.Company_Id = v_Company_Id
                and s.Filial_Id = v_Filial_Id
                and s.Division_Id = q.Division_Id
                and s.Schedule_Id member of v_Schedule_Ids));
  
    -- status
    Result.Put('normal_cnt', v_Normal_Cnt);
    Result.Put('unnormal_cnt', v_Unnormal_Cnt);
    Result.Put('no_timesheet_cnt', v_No_Timesheet_Cnt);
    Result.Put('rest_day_cnt', v_Rest_Day_Cnt);
    Result.Put('not_begin_cnt', v_Not_Begin_Cnt);
  
    -- factor
    Result.Put('late_cnt', v_Late_Cnt);
    Result.Put('early_cnt', v_Early_Cnt);
    Result.Put('lack_cnt', v_Lack_Cnt);
    Result.Put('not_opened_cnt', v_Not_Opened_Cnt);
    Result.Put('not_closed_cnt', v_Not_Closed_Cnt);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Xy_Chart_Stats(p Hashmap) return Hashmap is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Division_Group_Ids Array_Number := Nvl(p.o_Array_Number('division_group_ids'), Array_Number());
    v_Division_Group_Cnt number := v_Division_Group_Ids.Count;
    v_Schedule_Ids       Array_Number := Nvl(p.o_Array_Number('schedule_ids'), Array_Number());
    v_Schedule_Cnt       number := v_Schedule_Ids.Count;
    v_Period_Begin       date := p.r_Date('period_begin');
    v_Period_End         date := p.r_Date('period_end');
  
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    Uit_Htt.Enable_Division_Cache(i_Company_Id   => v_Company_Id,
                                  i_Filial_Id    => v_Filial_Id,
                                  i_Period_Begin => v_Period_Begin,
                                  i_Period_End   => v_Period_End);
  
    select Array_Varchar2(q.Period,
                          q.Total,
                          q.Normal,
                          Round(q.Normal / q.Total * 100, 2),
                          q.Unnormal,
                          Round(q.Unnormal / q.Total * 100, 2),
                          q.Late,
                          Round(q.Late / q.Total * 100, 2),
                          q.Early,
                          Round(q.Early / q.Total * 100, 2),
                          q.Lack,
                          Round(q.Lack / q.Total * 100, 2),
                          q.Not_Opened,
                          Round(q.Not_Opened / q.Total * 100, 2),
                          q.Not_Closed,
                          Round(q.Not_Closed / q.Total * 100, 2))
      bulk collect
      into v_Matrix
      from (select q.Period,
                   count(*) as Total,
                   count(Decode(q.Status, Uit_Htt.c_Status_Normal, 1, null)) as Normal,
                   count(Decode(q.Status, Uit_Htt.c_Status_Unnormal, 1, null)) as Unnormal,
                   count(Nullif(q.Late_Time, 0)) as Late,
                   count(Nullif(q.Early_Time, 0)) as Early,
                   count(Nullif(q.Lack_Time, 0)) as Lack,
                   count(case
                            when q.Status = Uit_Htt.c_Status_Unnormal and
                                 q.Open_Status = Uit_Htt.c_Open_Status_Not_Opened then
                             1
                            else
                             null
                          end) as Not_Opened,
                   count(case
                            when q.Status = Uit_Htt.c_Status_Unnormal and
                                 q.Close_Status = Uit_Htt.c_Close_Status_Not_Closed then
                             1
                            else
                             null
                          end) as Not_Closed
              from Uit_Htt.Division_Infos(i_Company_Id   => v_Company_Id,
                                          i_Filial_Id    => v_Filial_Id,
                                          i_Period_Begin => v_Period_Begin,
                                          i_Period_End   => v_Period_End) q
              join Mhr_Divisions d
                on d.Company_Id = v_Company_Id
               and d.Filial_Id = v_Filial_Id
               and d.Division_Id = q.Division_Id
               and d.State = 'A'
              join Hrm_Divisions Dv
                on Dv.Company_Id = v_Company_Id
               and Dv.Filial_Id = v_Filial_Id
               and Dv.Division_Id = q.Division_Id
               and Dv.Is_Department = 'Y'
             where q.Status in
                   (Uit_Htt.c_Status_Normal, Uit_Htt.c_Status_Unnormal, Uit_Htt.c_Status_Not_Begin)
               and (v_Division_Group_Cnt = 0 or d.Division_Group_Id member of v_Division_Group_Ids)
               and (v_Schedule_Cnt = 0 or exists
                    (select 1
                       from Hrm_Division_Schedules s
                      where s.Company_Id = v_Company_Id
                        and s.Filial_Id = v_Filial_Id
                        and s.Division_Id = q.Division_Id
                        and s.Schedule_Id member of v_Schedule_Ids))
             group by q.Period
            having count(*) > 0) q
     order by q.Period;
  
    Result.Put('data', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
  begin
    Ui_Vhr459.Run(p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
    v_Dummy Array_Varchar2;
  begin
    update Mhr_Division_Groups
       set Company_Id        = null,
           Division_Group_Id = null,
           name              = null,
           State             = null;
  
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
  
    update Mhr_Divisions
       set Company_Id        = null,
           Division_Id       = null,
           Filial_Id         = null,
           name              = null,
           Division_Group_Id = null,
           State             = null,
           Code              = null;
  
    update Hrm_Divisions
       set Company_Id    = null,
           Filial_Id     = null,
           Division_Id   = null,
           Is_Department = null;
  
    update Hrm_Division_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Schedule_Id = null;
  
    select Array_Varchar2(q.Company_Id,
                          q.Filial_Id,
                          q.Division_Id,
                          q.Opened_Date,
                          q.Closed_Date,
                          q.Status,
                          q.Open_Status,
                          q.Close_Status,
                          q.Plan_Time,
                          q.Intime,
                          q.Fact_Time,
                          q.Late_Time,
                          q.Early_Time,
                          q.Lack_Time)
      into v_Dummy
      from Uit_Htt.Division_Infos(i_Company_Id     => null,
                                  i_Filial_Id      => null,
                                  i_Period         => null,
                                  i_Merge_Datetime => null) q;
  
    Uie.x(Uit_Htt.To_Time_Seconds_Text(null));
  end;

end Ui_Vhr458;
/
