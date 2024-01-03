create or replace package Ui_Vhr262 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Primary_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Secondary_Staffs(p Hashmap) return Fazo_Query;
end Ui_Vhr262;
/
create or replace package body Ui_Vhr262 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    select Array_Varchar2(s.Staff_Id, s.Staff_Number)
      bulk collect
      into v_Matrix
      from Href_Staffs s
     where s.Company_Id = Ui.Company_Id
       and s.Filial_Id = Ui.Filial_Id
       and s.Employee_Id = v_Person_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Secondary
       and s.State = 'A';
  
    Result.Put('secondary_staffs', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('pcode_hiring', Hpd_Pref.c_Pcode_Journal_Type_Hiring);
    Result.Put('pcode_hiring_multiple', Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple);
    Result.Put('pcode_transfer', Hpd_Pref.c_Pcode_Journal_Type_Transfer);
    Result.Put('pcode_transfer_multiple', Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple);
    Result.Put('pcode_dismissal', Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
    Result.Put('pcode_dismissal_multiple', Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple);
    Result.Put('pcode_wage_change', Hpd_Pref.c_Pcode_Journal_Type_Wage_Change);
    Result.Put('pcode_rank_change', Hpd_Pref.c_Pcode_Journal_Type_Rank_Change);
    Result.Put('pcode_rank_change_multiple', Hpd_Pref.c_Pcode_Journal_Type_Rank_Change_Multiple);
    Result.Put('pcode_schedule_change', Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change);
    Result.Put('pcode_vacation_limit_change', Hpd_Pref.c_Pcode_Journal_Type_Limit_Change);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query
  (
    p            Hashmap,
    i_Staff_Kind varchar2
  ) return Fazo_Query is
    q                      Fazo_Query;
    v_Wage_Indicator_Id    number := Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                            i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
    v_Journal_Types        Matrix_Varchar2 := Hpd_Util.Journal_Types;
    v_Param                Hashmap;
    v_Salary_Journal_Types Array_Number;
  
    -------------------------------------------------- 
    Procedure Get_Journal_Type is
    begin
      select j.Journal_Type_Id
        bulk collect
        into v_Salary_Journal_Types
        from Hpd_Journal_Types j
       where j.Company_Id = Ui.Company_Id
         and j.Pcode in (Hpd_Pref.c_Pcode_Journal_Type_Hiring,
                         Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple,
                         Hpd_Pref.c_Pcode_Journal_Type_Transfer,
                         Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple,
                         Hpd_Pref.c_Pcode_Journal_Type_Wage_Change,
                         Hpd_Pref.c_Pcode_Journal_Type_Wage_Change_Multiple);
    end;
  begin
    Get_Journal_Type;
  
    v_Param := Fazo.Zip_Map('company_id',
                            Ui.Company_Id,
                            'filial_id',
                            Ui.Filial_Id,
                            'indicator_id',
                            v_Wage_Indicator_Id,
                            'employee_id',
                            p.r_Number('person_id'),
                            'staff_kind',
                            i_Staff_Kind,
                            'tt_robot',
                            Hpd_Pref.c_Transaction_Type_Robot);
  
    v_Param.Put('user_id', Ui.User_Id);
    v_Param.Put('salary_journal_types', v_Salary_Journal_Types);
    v_Param.Put('staff_id', p.o_Number('staff_id'));
  
    q := Fazo_Query('with p_staff as
                      (select k.staff_id
                         from href_staffs k
                        where k.company_id = :company_id
                          and k.filial_id = :filial_id
                          and k.staff_kind = :staff_kind
                          and k.employee_id = :employee_id
                          and (:staff_id is null or k.staff_id = :staff_id))
                     select doc.journal_id,
                            doc.journal_type,
                            doc.journal_type_id,
                            doc.journal_date,
                            doc.journal_number,
                            doc.journal_name,
                            doc.begin_date,
                            doc.end_date,
                            doc.robot_id,
                            doc.schedule_id,
                            doc.division_id,
                            doc.job_id,
                            doc.rank_id,
                            doc.vacation_limit,
                            case
                               when doc.journal_type_id not member of :salary_journal_types or
                                    doc.access_to_hidden_salary_job = ''Y'' then
                                doc.wage
                               else
                                -1
                             end wage,
                            doc.order_no
                       from (select t.journal_id,
                                    uit_hpd.get_journal_type(max(j.journal_type_id)) journal_type,
                                    max(j.journal_type_id) journal_type_id,
                                    max(j.journal_date) journal_date,
                                    max(j.journal_number) journal_number,
                                    max(journal_name) journal_name,
                                    max(t.begin_date) begin_date,
                                    max(t.end_date) end_date,
                                    max(w.robot_id) robot_id,
                                    max(q.schedule_id) schedule_id,
                                    max(mr.division_id) division_id,
                                    max(mr.job_id) job_id,
                                    max(k.rank_id) rank_id,
                                    max(vl.days_limit) vacation_limit,
                                    decode(max(coalesce(w.contractual_wage,
                                                        (select max(tr.contractual_wage) keep(dense_rank last order by tt.begin_date, tt.order_no)
                                                           from hpd_transactions tt
                                                           join hpd_trans_robots tr
                                                             on tr.company_id = tt.company_id
                                                            and tr.filial_id = tt.filial_id
                                                            and tr.trans_id = tt.trans_id
                                                          where tt.company_id = t.company_id
                                                            and tt.filial_id = t.filial_id
                                                            and tt.staff_id = t.staff_id
                                                            and tt.begin_date <= t.begin_date
                                                            and (tt.end_date is null or tt.end_date >= t.begin_date)))),
                                           ''Y'',
                                           max(h.indicator_value),
                                           ''N'',
                                           hrm_util.closest_wage(t.company_id,
                                                                 t.filial_id,
                                                                 max(w.wage_scale_id),
                                                                 max(t.begin_date),
                                                                 max(k.rank_id))) wage,
                                    case
                                       when :user_id = :employee_id or
                                            uit_hrm.access_to_hidden_salary_job(i_job_id => (hpd_util.get_closest_job_id(i_company_id => t.company_id,
                                                                                                                         i_filial_id  => t.filial_id,
                                                                                                                         i_staff_id   => max(t.staff_id),
                                                                                                                         i_period     => max(t.begin_date)))) = ''Y'' then
                                        ''Y''
                                       else
                                        ''N''
                                     end access_to_hidden_salary_job,
                                    max(t.order_no) order_no
                               from (select tr.company_id,
                                            tr.filial_id,
                                            tr.trans_id,
                                            tr.staff_id,
                                            tr.begin_date,
                                            tr.end_date,
                                            tr.order_no,
                                            tr.journal_id,
                                            tr.page_id
                                       from hpd_transactions tr
                                      where tr.company_id = :company_id
                                        and tr.filial_id = :filial_id
                                        and tr.staff_id in (select k.staff_id
                                                              from p_staff k)
                                     union
                                     select dt.company_id,
                                            dt.filial_id,
                                            null trans_id,
                                            dt.staff_id,
                                            dt.dismissal_date - 1 begin_date,
                                            null end_date,
                                            null order_no,
                                            dt.journal_id,
                                            dt.page_id
                                       from hpd_dismissal_transactions dt
                                      where dt.company_id = :company_id
                                        and dt.filial_id = :filial_id
                                        and dt.staff_id in (select k.staff_id
                                                              from p_staff k)) t
                               join hpd_journals j
                                 on j.company_id = t.company_id
                                and j.filial_id = t.filial_id
                                and j.journal_id = t.journal_id
                               left join hpd_trans_robots w
                                 on t.company_id = w.company_id
                                and t.filial_id = w.filial_id
                                and t.trans_id = w.trans_id
                               left join mrf_robots mr
                                 on mr.company_id = t.company_id
                                and mr.filial_id = t.filial_id
                                and mr.robot_id = w.robot_id
                               left join hpd_trans_ranks k
                                 on k.company_id = t.company_id
                                and k.filial_id = t.filial_id
                                and k.trans_id = t.trans_id
                               left join hpd_trans_schedules q
                                 on q.company_id = t.company_id
                                and q.filial_id = t.filial_id
                                and q.trans_id = t.trans_id
                               left join hpd_trans_vacation_limits vl
                                 on vl.company_id = t.company_id
                                and vl.filial_id = t.filial_id
                                and vl.trans_id = t.trans_id
                               left join hpd_trans_indicators h
                                 on h.company_id = t.company_id
                                and h.filial_id = t.filial_id
                                and h.trans_id = t.trans_id
                                and h.indicator_id = :indicator_id
                             group by t.company_id, t.filial_id, t.journal_id, t.page_id) doc',
                    v_Param);
  
    q.Number_Field('journal_type_id',
                   'division_id',
                   'schedule_id',
                   'job_id',
                   'rank_id',
                   'robot_id',
                   'wage',
                   'order_no',
                   'vacation_limit',
                   'journal_id');
    q.Date_Field('begin_date', 'end_date', 'journal_date');
    q.Varchar2_Field('journal_type', 'journal_name', 'journal_number');
  
    q.Refer_Field('division_name',
                  'division_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select w.*
                     from htt_schedules w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select w.*
                     from mhr_jobs w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select w.*
                     from mhr_ranks w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('robot_name',
                  'robot_id',
                  'mrf_robots',
                  'robot_id',
                  'name',
                  'select w.*
                     from mrf_robots w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id
                      and exists (select 1
                            from hrm_robots hr
                           where hr.company_id = w.company_id
                             and hr.filial_id = w.filial_id
                             and hr.robot_id = w.robot_id)');
    q.Refer_Field('pcode',
                  'journal_type_id',
                  'hpd_journal_types',
                  'journal_type_id',
                  'pcode',
                  'select *
                     from hpd_journal_types s
                    where s.company_id = :company_id');
  
    q.Option_Field('journal_type_name', 'journal_type', v_Journal_Types(1), v_Journal_Types(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Primary_Staffs(p Hashmap) return Fazo_Query is
  begin
    return Query(p, Href_Pref.c_Staff_Kind_Primary);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Secondary_Staffs(p Hashmap) return Fazo_Query is
  begin
    return Query(p, Href_Pref.c_Staff_Kind_Secondary);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpd_Transactions
       set Company_Id = null,
           Filial_Id  = null,
           Trans_Id   = null,
           Staff_Id   = null,
           Journal_Id = null,
           Page_Id    = null,
           Order_No   = null;
    update Hpd_Journals
       set Company_Id      = null,
           Filial_Id       = null,
           Journal_Id      = null,
           Journal_Type_Id = null;
    update Hpd_Journal_Types
       set Company_Id      = null,
           Journal_Type_Id = null,
           name            = null;
    update Hpd_Trans_Robots
       set Company_Id       = null,
           Filial_Id        = null,
           Trans_Id         = null,
           Robot_Id         = null,
           Wage_Scale_Id    = null,
           Contractual_Wage = null;
    update Hpd_Trans_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Trans_Id   = null,
           Rank_Id    = null;
    update Hpd_Trans_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Trans_Id    = null,
           Schedule_Id = null;
    update Hpd_Trans_Indicators
       set Company_Id      = null,
           Filial_Id       = null,
           Trans_Id        = null,
           Indicator_Id    = null,
           Indicator_Value = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
    update Mrf_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Division_Id = null,
           Job_Id      = null,
           name        = null;
    update Hrm_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null;
    update Hpd_Dismissal_Transactions
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Dismissal_Date = null,
           Journal_Id     = null,
           Page_Id        = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Staff_Id    = null,
           Staff_Kind  = null,
           Employee_Id = null;
    Uie.x(Uit_Hpd.Get_Journal_Type(i_Journal_Type_Id => null));
    Uie.x(Hrm_Util.Closest_Wage(i_Company_Id    => null,
                                i_Filial_Id     => null,
                                i_Wage_Scale_Id => null,
                                i_Period        => null,
                                i_Rank_Id       => null));
    Uie.x(Hpd_Util.Get_Closest_Job_Id(i_Company_Id => null,
                                      i_Filial_Id  => null,
                                      i_Staff_Id   => null,
                                      i_Period     => null));
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => null, i_Employee_Id => null));
  
  end;

end Ui_Vhr262;
/
