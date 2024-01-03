prompt migr from 07.05.2022
----------------------------------------------------------------------------------------------------
create table migr_new_staffs(
  company_id                      number(20)  not null,
  filial_id                       number(20)  not null,
  staff_id                        number(20)  not null,
  new_staff_id                    number(20)  not null,
  hiring_date                     date        not null,
  dismissal_date                  date,
  hiring_page_id                  number(20)  not null,
  dismissal_page_id               number(20),
  staff_kind                      varchar2(1) not null,
  posted                          varchar2(1),
  constraint migr_new_staffs_pk primary key (company_id, filial_id, staff_id, new_staff_id) using index tablespace GWS_INDEX
);

create index migr_new_staffs_i1 on migr_new_staffs(company_id, filial_id, hiring_page_id);

----------------------------------------------------------------------------------------------------
prompt disable some constraints of htt_timesheet_locks, htt_change_days tables
alter table htt_timesheet_locks disable constraint htt_timesheet_locks_f1;
alter table htt_change_days     disable constraint htt_change_days_f3;

alter table hpr_timebook_facts     disable constraint hpr_timebook_facts_f1;
alter table hpr_timesheet_locks    disable constraint hpr_timesheet_locks_f1;
alter table hpr_timebook_intervals disable constraint hpr_timebook_intervals_f1;

prompt migr data fixing staffs
declare
  r_Staff        Href_Staffs%rowtype;
  r_Line         Hpd_Staff_Lines%rowtype;
  r_Dismissal    Hpd_Dismissals%rowtype;
  v_Staff_Number Href_Staffs.Staff_Number%type;
  v_Ids          Array_Number;
  v_Staff_Id     number;
  v_Date         date := Trunc(sysdate);
  v_Status       varchar2(1);
  v_Dummy        varchar2(1);
begin
  for Cmp in (select *
                from Md_Company_Infos q)
  loop
    for Fil in (select *
                  from Md_Filials q
                 where q.Company_Id = Cmp.Company_Id
                   and q.Filial_Id <> Cmp.Filial_Head)
    loop
      Ui_Context.Init_Migr(i_Company_Id   => Fil.Company_Id,
                           i_Filial_Id    => Fil.Filial_Id,
                           i_User_Id      => Cmp.User_System,
                           i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
    
      for Doc in (select q.*,
                         Jp.Staff_Id,
                         (select Decode(Pj.Employment_Type, 'I', 'S', 'P')
                            from Hpd_Page_Jobs Pj
                           where Pj.Company_Id = Fil.Company_Id
                             and Pj.Filial_Id = Fil.Filial_Id
                             and Pj.Page_Id = Jp.Page_Id) as Staff_Kind,
                         (select j.Posted
                            from Hpd_Journals j
                           where j.Company_Id = Fil.Company_Id
                             and j.Filial_Id = Fil.Filial_Id
                             and j.Journal_Id = Jp.Journal_Id) as Posted
                    from Hpd_Hirings q
                    join Hpd_Journal_Pages Jp
                      on Jp.Company_Id = Fil.Company_Id
                     and Jp.Filial_Id = Fil.Filial_Id
                     and Jp.Page_Id = q.Page_Id
                   where q.Company_Id = Fil.Company_Id
                     and q.Filial_Id = Fil.Filial_Id
                     and not exists (select 1
                            from Migr_New_Staffs Mns
                           where Mns.Company_Id = Fil.Company_Id
                             and Mns.Filial_Id = Fil.Filial_Id
                             and Mns.Hiring_Page_Id = q.Page_Id)
                   order by q.Hiring_Date)
      loop
        -- dismissal date
        begin
          select Sl.*
            into r_Line
            from Hpd_Staff_Lines Sl
           where Sl.Company_Id = Doc.Company_Id
             and Sl.Filial_Id = Doc.Filial_Id
             and Sl.Staff_Id = Doc.Staff_Id
             and Sl.Hiring_Page_Id = Doc.Page_Id;
        exception
          when No_Data_Found then
            r_Line := null;
        end;
      
        begin
          select 'X'
            into v_Dummy
            from Migr_New_Staffs q
           where q.Company_Id = Doc.Company_Id
             and q.Filial_Id = Doc.Filial_Id
             and q.Staff_Id = Doc.Staff_Id
             and q.New_Staff_Id = Doc.Staff_Id;
        
          insert into Migr_New_Staffs
            (Company_Id,
             Filial_Id,
             Staff_Id,
             New_Staff_Id,
             Hiring_Date,
             Dismissal_Date,
             Hiring_Page_Id,
             Dismissal_Page_Id,
             Staff_Kind,
             Posted)
          values
            (Doc.Company_Id,
             Doc.Filial_Id,
             Doc.Staff_Id,
             Href_Next.Staff_Id,
             Doc.Hiring_Date,
             r_Line.Dismissal_Date,
             Doc.Page_Id,
             r_Line.Dismissal_Page_Id,
             Doc.Staff_Kind,
             Doc.Posted);
        exception
          when No_Data_Found then
            insert into Migr_New_Staffs
              (Company_Id,
               Filial_Id,
               Staff_Id,
               New_Staff_Id,
               Hiring_Date,
               Dismissal_Date,
               Hiring_Page_Id,
               Dismissal_Page_Id,
               Staff_Kind,
               Posted)
            values
              (Doc.Company_Id,
               Doc.Filial_Id,
               Doc.Staff_Id,
               Doc.Staff_Id,
               Doc.Hiring_Date,
               r_Line.Dismissal_Date,
               Doc.Page_Id,
               r_Line.Dismissal_Page_Id,
               Doc.Staff_Kind,
               Doc.Posted);
        end;
      
        commit;
      end loop;
    
      for Ns in (select s.*
                   from Migr_New_Staffs s
                  where s.Company_Id = Fil.Company_Id
                    and s.Filial_Id = Fil.Filial_Id
                    and not exists
                  (select 1
                           from Href_Staffs Hs
                          where Hs.Company_Id = Fil.Company_Id
                            and Hs.Filial_Id = Fil.Filial_Id
                            and Hs.Staff_Id = s.New_Staff_Id
                            and Hs.Hiring_Date = s.Hiring_Date
                            and (s.Dismissal_Date is null or Hs.Dismissal_Date = s.Dismissal_Date))
                  order by s.Staff_Id, s.New_Staff_Id)
      loop
        if Ns.Staff_Id <> r_Staff.Staff_Id or r_Staff.Staff_Id is null then
          r_Staff := z_Href_Staffs.Load(i_Company_Id => Ns.Company_Id,
                                        i_Filial_Id  => Ns.Filial_Id,
                                        i_Staff_Id   => Ns.Staff_Id);
        end if;
      
        if Ns.Staff_Id = Ns.New_Staff_Id then
          v_Staff_Number := r_Staff.Staff_Number;
        else
          v_Staff_Number := Mkr_Core.Gen_Document_Number(i_Company_Id => r_Staff.Company_Id,
                                                         i_Filial_Id  => r_Staff.Filial_Id,
                                                         i_Table      => Zt.Mhr_Employees,
                                                         i_Column     => z.Employee_Number);
        end if;
      
        if Ns.Posted = 'N' then
          v_Status := 'U';
        elsif Ns.Dismissal_Date < v_Date then
          v_Status := 'T';
        else
          v_Status := Ns.Staff_Kind;
        end if;
      
        r_Dismissal := z_Hpd_Dismissals.Take(i_Company_Id => Ns.Company_Id,
                                             i_Filial_Id  => Ns.Filial_Id,
                                             i_Page_Id    => Ns.Dismissal_Page_Id);
      
        z_Href_Staffs.Save_One(i_Company_Id          => r_Staff.Company_Id,
                               i_Filial_Id           => r_Staff.Filial_Id,
                               i_Staff_Id            => Ns.New_Staff_Id,
                               i_Staff_Number        => v_Staff_Number,
                               i_Employee_Id         => r_Staff.Employee_Id,
                               i_Status              => v_Status,
                               i_Hiring_Date         => Ns.Hiring_Date,
                               i_Dismissal_Date      => Ns.Dismissal_Date,
                               i_Position_Id         => r_Staff.Position_Id,
                               i_Division_Id         => r_Staff.Division_Id,
                               i_Job_Id              => r_Staff.Job_Id,
                               i_Quantity            => r_Staff.Quantity,
                               i_Rank_Id             => r_Staff.Rank_Id,
                               i_Schedule_Id         => r_Staff.Schedule_Id,
                               i_Dismissal_Reason_Id => r_Dismissal.Dismissal_Reason_Id,
                               i_Dismissal_Note      => r_Dismissal.Note);
      
        continue when Ns.Staff_Id = Ns.New_Staff_Id;
      
        -- hpd
        if Ns.Posted = 'N' then
          update Hpd_Journal_Pages w
             set w.Staff_Id = Ns.New_Staff_Id
           where w.Company_Id = Ns.Company_Id
             and w.Filial_Id = Ns.Filial_Id
             and w.Page_Id = Ns.Hiring_Page_Id;
        
          continue;
        end if;
      
        update Hpd_Journal_Pages w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and (exists (select 1
                          from Hpd_Hirings Wp
                         where Wp.Company_Id = w.Company_Id
                           and Wp.Filial_Id = w.Filial_Id
                           and Wp.Page_Id = w.Page_Id
                           and Ns.Hiring_Date <= Wp.Hiring_Date
                           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= Wp.Hiring_Date)) or
                exists (select 1
                          from Hpd_Transfers Wp
                         where Wp.Company_Id = w.Company_Id
                           and Wp.Filial_Id = w.Filial_Id
                           and Wp.Page_Id = w.Page_Id
                           and Ns.Hiring_Date <= Wp.Transfer_Begin
                           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= Wp.Transfer_Begin)) or
                exists (select 1
                          from Hpd_Dismissals Wp
                         where Wp.Company_Id = w.Company_Id
                           and Wp.Filial_Id = w.Filial_Id
                           and Wp.Page_Id = w.Page_Id
                           and Ns.Hiring_Date <= Wp.Dismissal_Date
                           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= Wp.Dismissal_Date)) or
                exists (select 1
                          from Hpd_Wage_Changes Wp
                         where Wp.Company_Id = w.Company_Id
                           and Wp.Filial_Id = w.Filial_Id
                           and Wp.Page_Id = w.Page_Id
                           and Ns.Hiring_Date <= Wp.Change_Date
                           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= Wp.Change_Date)) or
                exists
                (select 1
                   from Hpd_Schedule_Changes Wp
                  where Wp.Company_Id = w.Company_Id
                    and Wp.Filial_Id = w.Filial_Id
                    and Wp.Journal_Id = w.Journal_Id
                    and Ns.Hiring_Date <= Wp.Begin_Date
                    and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= Wp.Begin_Date)));
      
        update Hpd_Journal_Timeoffs w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and Ns.Hiring_Date <= w.End_Date
           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= w.Begin_Date)
        returning w.Timeoff_Id bulk collect into v_Ids;
      
        forall i in 1 .. v_Ids.Count
          update Hpd_Timeoff_Days w
             set w.Staff_Id = Ns.New_Staff_Id
           where w.Company_Id = Ns.Company_Id
             and w.Filial_Id = Ns.Filial_Id
             and w.Timeoff_Id = v_Ids(i);
      
        update Hpd_Lock_Intervals w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and Ns.Hiring_Date <= w.End_Date
           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= w.Begin_Date);
      
        update Hpd_Staff_Lines w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and Ns.Hiring_Date = w.Hiring_Date;
      
        update Hpd_Staff_Line_Transactions w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and Ns.Hiring_Date <= Nvl(w.End_Date, w.Begin_Date)
           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= w.Begin_Date);
      
        -- htt
        update Htt_Requests w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and Ns.Hiring_Date <= w.End_Time
           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= w.Begin_Time)
        returning w.Request_Id bulk collect into v_Ids;
      
        forall i in 1 .. v_Ids.Count
          update Htt_Request_Helpers w
             set w.Staff_Id = Ns.New_Staff_Id
           where w.Company_Id = Ns.Company_Id
             and w.Filial_Id = Ns.Filial_Id
             and w.Request_Id = v_Ids(i);
      
        update Htt_Timesheets w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and Ns.Hiring_Date <= w.Timesheet_Date
           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= w.Timesheet_Date)
        returning w.Timesheet_Id bulk collect into v_Ids;
      
        forall i in 1 .. v_Ids.Count
          update Htt_Timesheet_Helpers w
             set w.Staff_Id = Ns.New_Staff_Id
           where w.Company_Id = Ns.Company_Id
             and w.Filial_Id = Ns.Filial_Id
             and w.Timesheet_Id = v_Ids(i);
      
        update Htt_Plan_Changes w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and exists
         (select 1
                  from Htt_Change_Days Wd
                 where Wd.Company_Id = w.Company_Id
                   and Wd.Filial_Id = w.Filial_Id
                   and Wd.Change_Id = w.Change_Id
                   and Ns.Hiring_Date <= Wd.Change_Date
                   and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= Wd.Change_Date));
      
        update Htt_Timesheet_Locks w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and Ns.Hiring_Date <= w.Timesheet_Date
           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= w.Timesheet_Date);
      
        update Htt_Change_Days w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and Ns.Hiring_Date <= w.Change_Date
           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= w.Change_Date);
      
        -- hpr
        update Hpr_Timebook_Staffs w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and exists
         (select 1
                  from Hpr_Timebooks Wt
                 where Wt.Company_Id = Ns.Company_Id
                   and Wt.Filial_Id = Ns.Filial_Id
                   and Wt.Timebook_Id = w.Timebook_Id
                   and Ns.Hiring_Date <= Last_Day(Wt.Month)
                   and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= Wt.Month));
      
        update Hpr_Book_Operations w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and exists
         (select 1
                  from Hpr_Charges Ch
                 where Ch.Company_Id = Ns.Company_Id
                   and Ch.Filial_Id = Ns.Filial_Id
                   and Ch.Charge_Id = w.Charge_Id
                   and Ns.Hiring_Date <= Ch.End_Date
                   and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= Ch.Begin_Date));
      
        update Hpr_Timebook_Facts w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and exists
         (select 1
                  from Hpr_Timebooks Wt
                 where Wt.Company_Id = Ns.Company_Id
                   and Wt.Filial_Id = Ns.Filial_Id
                   and Wt.Timebook_Id = w.Timebook_Id
                   and Ns.Hiring_Date <= Last_Day(Wt.Month)
                   and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= Wt.Month));
      
        update Hpr_Timesheet_Locks w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and Ns.Hiring_Date <= w.Timesheet_Date
           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= w.Timesheet_Date);
      
        update Hpr_Timebook_Intervals w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and exists
         (select 1
                  from Hpr_Timebooks Wt
                 where Wt.Company_Id = Ns.Company_Id
                   and Wt.Filial_Id = Ns.Filial_Id
                   and Wt.Timebook_Id = w.Timebook_Id
                   and Ns.Hiring_Date <= Last_Day(Wt.Month)
                   and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= Wt.Month));
      
        -- hper
        update Hper_Staff_Plans w
           set w.Staff_Id = Ns.New_Staff_Id
         where w.Company_Id = Ns.Company_Id
           and w.Filial_Id = Ns.Filial_Id
           and w.Staff_Id = Ns.Staff_Id
           and Ns.Hiring_Date <= w.End_Date
           and (Ns.Dismissal_Date is null or Ns.Dismissal_Date >= w.Begin_Date);
      
        commit;
      end loop;
    end loop;
  end loop;
end;
/

prompt enable disabled constraints of htt_timesheet_locks, htt_change_days tables
alter table htt_timesheet_locks enable constraint htt_timesheet_locks_f1;
alter table htt_change_days     enable constraint htt_change_days_f3;

alter table hpr_timebook_facts     enable constraint hpr_timebook_facts_f1;
alter table hpr_timesheet_locks    enable constraint hpr_timesheet_locks_f1;
alter table hpr_timebook_intervals enable constraint hpr_timebook_intervals_f1;
