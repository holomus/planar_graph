create or replace package Ui_Vhr318 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
end Ui_Vhr318;
/
create or replace package body Ui_Vhr318 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Params Hashmap := Hashmap();
    q        Fazo_Query;
  begin
    if Ui.Company_Id <> Md_Pref.c_Company_Head then
      b.Raise_Unauthenticated;
    end if;
  
    v_Params.Put('company_head', Md_Pref.c_Company_Head);
    v_Params.Put('sk_primary', Href_Pref.c_Staff_Kind_Primary);
    v_Params.Put('day_kind_work', Htt_Pref.c_Day_Kind_Work);
    v_Params.Put('curr_date', Trunc(sysdate));
    v_Params.Put('min_begin_date',
                 Least(Trunc(sysdate) - 30, Trunc(Add_Months(sysdate, -1), 'mm')));
    v_Params.Put('last_month_begin', Trunc(Add_Months(sysdate, -1), 'mm'));
    v_Params.Put('last_month_end', Trunc(Last_Day(Add_Months(sysdate, -1)), 'mm'));
  
    q := Fazo_Query('with active_employee_count as
                      (select s.company_id,
                              t.timesheet_date,
                              count(case
                                       when t.day_kind <> :day_kind_work
                                          or exists (select 1
                                                       from htt_tracks ht
                                                      where ht.company_id = s.company_id
                                                        and ht.filial_id = s.filial_id
                                                        and ht.person_id = s.employee_id
                                                        and ht.track_date = t.timesheet_date) then
                                        1
                                       else
                                        null
                                     end) as employee_count
                         from href_staffs s
                         join htt_timesheets t
                           on t.company_id = s.company_id
                          and t.filial_id = s.filial_id
                          and t.staff_id = s.staff_id
                          and t.timesheet_date between :min_begin_date and :curr_date
                        where s.company_id <> :company_head
                          and s.state = ''A''
                          and s.staff_kind = :sk_primary
                          and s.hiring_date <= :curr_date
                          and (s.dismissal_date is null or s.dismissal_date >= :min_begin_date)
                        group by s.company_id, t.timesheet_date)
                     select q.*,
                            round(today_active_count / q.employee_count, 2) * 100 as today_active_perc,
                            round(yesterday_active_count / q.employee_count, 2) * 100 as yesterday_active_perc,
                            round(last_3_days_avg_active_count / q.employee_count, 2) * 100 as last_3_days_avg_active_perc,
                            round(last_7_days_avg_active_count / q.employee_count, 2) * 100 as last_7_days_avg_active_perc,
                            round(last_15_days_avg_active_count / q.employee_count, 2) * 100 as last_15_days_avg_active_perc,
                            round(last_month_avg_active_count / q.employee_count, 2) * 100 as last_month_avg_active_perc
                       from (select c.*,
                                    (select ci.phone
                                       from md_company_infos ci
                                      where ci.company_id = c.company_id) as phone,
                                    (select ci.email
                                       from md_company_infos ci
                                      where ci.company_id = c.company_id) as email,
                                    (select count(*)
                                       from mhr_employees e
                                      where e.company_id = c.company_id
                                        and exists (select 1
                                               from href_staffs s
                                              where s.company_id = c.company_id
                                                and s.filial_id = e.filial_id
                                                and s.employee_id = e.employee_id
                                                and s.state = ''A''
                                                and s.hiring_date <= :curr_date
                                                and (s.dismissal_date is null 
                                                 or s.dismissal_date >= :curr_date))) as employee_count,
                                    (select max(ae.employee_count)
                                       from active_employee_count ae
                                      where ae.company_id = c.company_id
                                        and ae.timesheet_date between (:curr_date - 30) and :curr_date - 1) as last_30_days_max_active_count,
                                    (select ae.employee_count
                                       from active_employee_count ae
                                      where ae.company_id = c.company_id
                                        and ae.timesheet_date = :curr_date) as today_active_count,
                                    (select ae.employee_count
                                       from active_employee_count ae
                                      where ae.company_id = c.company_id
                                        and ae.timesheet_date = :curr_date - 1) as yesterday_active_count,
                                    (select round(avg(ae.employee_count))
                                       from active_employee_count ae
                                      where ae.company_id = c.company_id
                                        and ae.timesheet_date between (:curr_date - 3) and :curr_date - 1) as last_3_days_avg_active_count,
                                    (select round(avg(ae.employee_count))
                                       from active_employee_count ae
                                      where ae.company_id = c.company_id
                                        and ae.timesheet_date between (:curr_date - 7) and :curr_date - 1) as last_7_days_avg_active_count,
                                    (select round(avg(ae.employee_count))
                                       from active_employee_count ae
                                      where ae.company_id = c.company_id
                                        and ae.timesheet_date between (:curr_date - 15) and :curr_date - 1) as last_15_days_avg_active_count,
                                    (select round(avg(ae.employee_count))
                                       from active_employee_count ae
                                      where ae.company_id = c.company_id
                                        and ae.timesheet_date between :last_month_begin and :last_month_end) as last_month_avg_active_count
                               from md_companies c
                              where c.company_id <> :company_head
                                and c.state = ''A'') q',
                    v_Params);
  
    q.Number_Field('company_id',
                   'rownum',
                   'employee_count',
                   'last_30_days_max_active_count',
                   'today_active_count',
                   'yesterday_active_count',
                   'last_3_days_avg_active_count',
                   'last_7_days_avg_active_count',
                   'last_15_days_avg_active_count',
                   'last_month_avg_active_count');
    q.Number_Field('today_active_perc',
                   'yesterday_active_perc',
                   'last_3_days_avg_active_perc',
                   'last_7_days_avg_active_perc',
                   'last_15_days_avg_active_perc',
                   'last_month_avg_active_perc');
    q.Varchar2_Field('name', 'code', 'phone', 'email');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Companies
       set Company_Id = null,
           name       = null,
           Code       = null,
           State      = null;
    update Md_Company_Infos
       set Company_Id = null,
           Phone      = null,
           Email      = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Kind     = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Htt_Timesheets
       set Company_Id     = null,
           Filial_Id      = null,
           Timesheet_Id   = null,
           Timesheet_Date = null,
           Staff_Id       = null,
           Day_Kind       = null;
    update Htt_Tracks
       set Company_Id = null,
           Filial_Id  = null,
           Track_Date = null,
           Person_Id  = null;
  end;

end Ui_Vhr318;
/
