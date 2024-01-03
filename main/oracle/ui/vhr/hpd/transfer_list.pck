create or replace package Ui_Vhr608 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
end Ui_Vhr608;
/
create or replace package body Ui_Vhr608 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'transaction_type_robot',
                             Hpd_Pref.c_Transaction_Type_Robot,
                             'transaction_type_rank',
                             Hpd_Pref.c_Transaction_Type_Rank,
                             'transaction_type_schedule',
                             Hpd_Pref.c_Transaction_Type_Schedule);
  
    v_Query := 'select tr.*,
                       hr.robot_id from_robot_id,
                       r.division_id from_division_id,
                       r.job_id from_job_id,
                       hr.org_unit_id from_org_unit_id,
                       rnk.rank_id from_rank_id,
                       ts.schedule_id from_schedule_id
                  from (select j.journal_name,
                               j.journal_number,
                               j.journal_date,
                               j.posted,
                               j.journal_type_id,
                               q.journal_id,
                               q.page_id,
                               w.transfer_begin,
                               w.transfer_end,
                               q.employee_id,
                               t.robot_id as to_robot_id,
                               t.division_id to_division_id,
                               t.job_id to_job_id,
                               (case
                                  when hr.org_unit_id = t.division_id then
                                   null
                                  else
                                   hr.org_unit_id
                                end) to_org_unit_id,
                               m.rank_id to_rank_id,
                               s.schedule_id to_schedule_id,
                               w.transfer_reason,
                               w.transfer_base,
                               hpd_util.trans_id_by_period(i_company_id => q.company_id,
                                                           i_filial_id  => q.filial_id,
                                                           i_staff_id   => q.staff_id,
                                                           i_trans_type => :transaction_type_robot,
                                                           i_period     => w.transfer_begin - 1) robot_trans_id,
                               hpd_util.trans_id_by_period(i_company_id => q.company_id,
                                                           i_filial_id  => q.filial_id,
                                                           i_staff_id   => q.staff_id,
                                                           i_trans_type => :transaction_type_rank,
                                                           i_period     => w.transfer_begin - 1) rank_trans_id,
                               hpd_util.trans_id_by_period(i_company_id => q.company_id,
                                                           i_filial_id  => q.filial_id,
                                                           i_staff_id   => q.staff_id,
                                                           i_trans_type => :transaction_type_schedule,
                                                           i_period     => w.transfer_begin - 1) schedule_trans_id,
                               j.created_by, 
                               j.created_on, 
                               j.modified_by, 
                               j.modified_on 
                          from hpd_journals j
                          join hpd_journal_pages q
                            on q.companY_id = j.company_id
                           and q.filial_id = j.filial_id
                           and q.journal_id = j.journal_id
                          join hpd_transfers w
                            on w.company_id = q.company_id
                           and w.filial_id = q.filial_id
                           and w.page_id = q.page_id
                          left join hpd_page_robots m
                            on m.company_id = q.company_id
                           and m.filial_id = q.filial_id
                           and m.page_id = q.page_id
                          left join hpd_page_schedules s
                            on s.company_id = q.company_id
                           and s.filial_id = q.filial_id
                           and s.page_id = q.page_id
                          left join mrf_robots t
                            on t.company_id = m.company_id
                           and t.filial_id = m.filial_id
                           and t.robot_id = m.robot_id
                          left join hrm_robots hr
                            on hr.company_id = m.company_id
                           and hr.filial_id = m.filial_id
                           and hr.robot_id = m.robot_id
                         where j.company_id = :company_id
                           and j.filial_id = :filial_id';
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query || ' and not exists (select 1
                                from hpd_journal_staffs je
                                join href_staffs q
                                  on q.company_id = je.company_id
                                 and q.filial_id = je.filial_id
                                 and q.staff_id = je.staff_id
                                 and (q.employee_id = :user_id
                                  or q.org_unit_id not member of :division_ids)
                               where je.company_id = j.company_id
                                 and je.filial_id = j.filial_id
                                 and je.journal_id = j.journal_id)';
    
      v_Params.Put('division_ids', Uit_Href.Get_All_Subordinate_Divisions);
      v_Params.Put('user_id', Ui.User_Id);
    end if;
  
    v_Query := v_Query || ') tr
                  left join hpd_trans_robots r
                    on r.company_id = :company_id
                   and r.filial_id = :filial_id
                   and r.trans_id = tr.robot_trans_id
                  left join hrm_robots hr
                    on hr.company_id = r.company_id
                   and hr.filial_id = r.filial_id
                   and hr.robot_id = r.robot_id
                  left join hpd_trans_ranks rnk
                    on rnk.company_id = :company_id
                   and rnk.filial_id = :filial_id
                   and rnk.trans_id = tr.rank_trans_id
                  left join hpd_trans_schedules ts
                    on ts.company_id = :company_id
                   and ts.filial_id = :filial_id
                   and ts.trans_id = tr.schedule_trans_id';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('journal_id', 'page_id', 'journal_type_id', 'created_by', 'modified_by');
    q.Varchar2_Field('employee_id',
                     'to_robot_id',
                     'to_division_id',
                     'to_job_id',
                     'to_org_unit_id',
                     'to_rank_id',
                     'to_schedule_id',
                     'transfer_reason',
                     'transfer_base',
                     'from_division_id');
    q.Varchar2_Field('journal_name',
                     'journal_number',
                     'from_robot_id',
                     'from_job_id',
                     'from_org_unit_id',
                     'from_rank_id',
                     'from_schedule_id',
                     'posted');
    q.Date_Field('transfer_begin', 'transfer_end', 'journal_date', 'created_on', 'modified_on');
  
    q.Refer_Field('employee_name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons w
                    where w.company_id = :company_id
                      and exists (select 1
                             from href_staffs s
                            where s.company_id = w.company_id
                              and s.filial_id = :filial_id
                              and s.employee_id = w.person_id)');
    q.Refer_Field('to_robot_name',
                  'to_robot_id',
                  'mrf_robots',
                  'robot_id',
                  'name',
                  'select *
                     from mrf_robots w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('from_robot_name',
                  'from_robot_id',
                  'mrf_robots',
                  'robot_id',
                  'name',
                  'select *
                     from mrf_robots w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('to_division_name',
                  'to_division_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('from_division_name',
                  'from_division_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('to_job_name',
                  'to_job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('from_job_name',
                  'from_job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('to_org_unit_name',
                  'to_org_unit_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false));
    q.Refer_Field('from_org_unit_name',
                  'from_org_unit_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false));
    q.Refer_Field('to_rank_name',
                  'to_rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select *
                     from mhr_ranks w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('from_rank_name',
                  'from_rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select *
                     from mhr_ranks w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('to_schedule_name',
                  'to_schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select *
                     from htt_schedules w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('from_schedule_name',
                  'from_schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select *
                     from htt_schedules w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
  
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('transfer_jt_id',
                        Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer),
                        'transfer_multiple_jt_id',
                        Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpd_Journal_Pages
       set Company_Id = null,
           Filial_Id  = null,
           Journal_Id = null,
           Page_Id    = null,
           Staff_Id   = null;
    update Hpd_Journals
       set Company_Id     = null,
           Filial_Id      = null,
           Journal_Id     = null,
           Journal_Number = null,
           Journal_Date   = null,
           Journal_Name   = null,
           Posted         = null;
    update Hpd_Transfers
       set Company_Id      = null,
           Filial_Id       = null,
           Page_Id         = null,
           Transfer_Begin  = null,
           Transfer_End    = null,
           Transfer_Reason = null,
           Transfer_Base   = null;
    update Hpd_Page_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Page_Id    = null,
           Robot_Id   = null,
           Rank_Id    = null;
    update Hpd_Page_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Page_Id     = null,
           Schedule_Id = null;
    update Mrf_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           name        = null,
           Division_Id = null,
           Job_Id      = null;
    update Hrm_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Org_Unit_Id = null,
           Rank_Id     = null;
    update Hpd_Trans_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Trans_Id    = null,
           Robot_Id    = null,
           Division_Id = null,
           Job_Id      = null;
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
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Hpd_Journal_Staffs
       set Company_Id = null,
           Filial_Id  = null,
           Journal_Id = null,
           Staff_Id   = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Staff_Id    = null,
           Employee_Id = null,
           Org_Unit_Id = null;
  
    Uie.x(Hpd_Util.Trans_Id_By_Period(i_Company_Id => null,
                                      i_Filial_Id  => null,
                                      i_Staff_Id   => null,
                                      i_Trans_Type => null,
                                      i_Period     => null));
  end;

end Ui_Vhr608;
/
