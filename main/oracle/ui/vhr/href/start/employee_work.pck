create or replace package Ui_Vhr312 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Ftes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Oper_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Reasons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Hidden_Salary_Job(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Last_Staff(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Save_Hiring(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Save_Transfer(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Save_Schedule(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Save_Salary(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Influences(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Save_Dismissal(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr312;
/
create or replace package body Ui_Vhr312 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mhr_jobs q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id    
                        and q.state = ''A''  
                        and (q.c_divisions_exist = ''N''
                            or exists (select 1
                                  from mhr_job_divisions w
                                 where w.company_id = :company_id
                                   and w.filial_id = :filial_id
                                   and w.job_id = q.job_id
                                   and w.division_id = :division_id))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_id',
                                 p.o_Number('division_id')));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Ftes return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_ftes', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('fte_id', 'order_no');
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
  Function Query_Oper_Types return Fazo_Query is
    q        Fazo_Query;
    v_Params Hashmap;
  begin
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'operation_kind',
                             Mpr_Pref.c_Ok_Accrual,
                             'hourly',
                             Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly,
                             'daily',
                             Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily,
                             'monthly',
                             Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly,
                             'summarized',
                             Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized);
  
    v_Params.Put('weighted', Hpr_Pref.c_Pcode_Oper_Type_Weighted_Turnout);
  
    q := Fazo_Query('select m.oper_type_id,
                            m.short_name as name
                       from mpr_oper_types m 
                      where m.company_id = :company_id
                        and m.operation_kind = :operation_kind
                        and m.state = ''A''
                        and m.pcode in (:hourly, :daily, :monthly, :summarized, :weighted)',
                    v_Params);
  
    q.Number_Field('oper_type_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Reasons return Fazo_Query is
    v_Matrix Matrix_Varchar2 := Href_Util.Dismissal_Reasons_Type;
    q        Fazo_Query;
  begin
    q := Fazo_Query('href_dismissal_reasons', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('dismissal_reason_id');
    q.Varchar2_Field('name', 'reason_type');
  
    q.Option_Field('reason_type_name', 'reason_type', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References(i_Employee_Id number) return Hashmap is
    r_Settings         Hrm_Settings%rowtype;
    v_Full_Time_Fte_Id number;
    v_Staff_Id         number;
    result             Hashmap := Hashmap();
  
    --------------------------------------------------
    Function Get_Division_Id return Array_Number is
      result Array_Number;
    begin
      select r.Division_Id
        bulk collect
        into result
        from Hpd_Journal_Pages p
        join Hpd_Page_Robots r
          on r.Company_Id = p.Company_Id
         and r.Filial_Id = p.Filial_Id
         and r.Page_Id = p.Page_Id
       where p.Company_Id = Ui.Company_Id
         and p.Filial_Id = Ui.Filial_Id
         and p.Staff_Id = v_Staff_Id
         and (exists (select 1
                        from Hpd_Hirings h
                       where h.Company_Id = p.Company_Id
                         and h.Filial_Id = p.Filial_Id
                         and h.Page_Id = p.Page_Id) or --
              exists (select *
                        from Hpd_Transfers t
                       where t.Company_Id = p.Company_Id
                         and t.Filial_Id = p.Filial_Id
                         and t.Page_Id = p.Page_Id))
         and exists (select *
                from Hpd_Journals j
               where j.Company_Id = p.Company_Id
                 and j.Filial_Id = p.Filial_Id
                 and j.Journal_Id = p.Journal_Id
                 and j.Posted = 'Y');
    
      return result;
    end;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => i_Employee_Id);
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Ids => Get_Division_Id)));
    Result.Put('all_org_units', Fazo.Zip_Matrix(Uit_Hrm.Org_Units));
  
    v_Full_Time_Fte_Id := Href_Util.Fte_Id(i_Company_Id => Ui.Company_Id,
                                           i_Pcode      => Href_Pref.c_Pcode_Fte_Full_Time);
  
    Result.Put('fte_id', v_Full_Time_Fte_Id);
    Result.Put('fte_name',
               z_Href_Ftes.Load(i_Company_Id => Ui.Company_Id, --
               i_Fte_Id => v_Full_Time_Fte_Id).Name);
    Result.Put('sk_flexible', Htt_Pref.c_Schedule_Kind_Flexible);
  
    r_Settings := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  
    Result.Put_All(z_Hrm_Settings.To_Map(r_Settings, --
                                         z.Advanced_Org_Structure));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staffs_Exist
  (
    i_Employee_Id number,
    i_Staff_Id    number
  ) return varchar2 is
    v_Dummy varchar2(1);
  begin
    select 'X'
      into v_Dummy
      from Href_Staffs s
     where s.Company_Id = Ui.Company_Id
       and s.Filial_Id = Ui.Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.State = 'A'
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.Staff_Id <> i_Staff_Id
       and Rownum = 1;
  
    return 'Y';
  exception
    when No_Data_Found then
      return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hidden_Salary_Job(p Hashmap) return varchar2 is
    v_Job_Id number;
  begin
    if p.Has('job_id') then
      v_Job_Id := p.o_Number('job_id');
    else
      v_Job_Id := Hpd_Util.Get_Closest_Job_Id(i_Company_Id => Ui.Company_Id,
                                              i_Filial_Id  => Ui.Filial_Id,
                                              i_Staff_Id   => p.r_Number('staff_id'),
                                              i_Period     => p.r_Date('period'));
    end if;
  
    return Uit_Hrm.Access_To_Hidden_Salary_Job(v_Job_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Last_Staff(p Hashmap) return Hashmap is
    v_Company_Id       number := Ui.Company_Id;
    v_Filial_Id        number := Ui.Filial_Id;
    v_Employee_Id      number := p.r_Number('employee_id');
    v_Staff_Id         number;
    v_Journal_Type_Id  number;
    v_Journal_Type_Ids Array_Number;
    v_Matrix           Matrix_Varchar2;
    result             Hashmap := Hashmap();
  
    ----------------------------------------------------------------------------------------------------
    Function Last_Dismissal_Date return date is
      result date;
    begin
      select max(s.Dismissal_Date)
        into result
        from Href_Staffs s
       where s.Company_Id = v_Company_Id
         and s.Filial_Id = v_Filial_Id
         and s.Employee_Id = v_Employee_Id
         and s.State = 'A'
         and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
         and s.Staff_Id <> v_Staff_Id;
    
      return result;
    end;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => v_Company_Id,
                                                 i_Filial_Id   => v_Filial_Id,
                                                 i_Employee_Id => v_Employee_Id);
  
    Result.Put('staff_id', v_Staff_Id);
    Result.Put('staffs_exist',
               Staffs_Exist(i_Employee_Id => v_Employee_Id, i_Staff_Id => v_Staff_Id));
    Result.Put('last_dismissal_date', Last_Dismissal_Date);
  
    select Array_Varchar2(q.Journal_Id,
                           q.Page_Id,
                           (select s.Staff_Number
                              from Href_Staffs s
                             where s.Company_Id = v_Company_Id
                               and s.Filial_Id = v_Filial_Id
                               and s.Staff_Id = v_Staff_Id),
                           q.Hiring_Date,
                           q.Robot_Id,
                           q.Org_Unit_Id,
                           q.Division_Id,
                           q.Job_Id,
                           (select e.Name
                              from Mhr_Jobs e
                             where e.Company_Id = v_Company_Id
                               and e.Filial_Id = v_Filial_Id
                               and e.Job_Id = q.Job_Id),
                           q.Fte_Id,
                           (select f.Name
                              from Href_Ftes f
                             where f.Company_Id = v_Company_Id
                               and f.Fte_Id = q.Fte_Id),
                           q.Schedule_Id,
                           (select e.Name
                              from Htt_Schedules e
                             where e.Company_Id = v_Company_Id
                               and e.Filial_Id = v_Filial_Id
                               and e.Schedule_Id = q.Schedule_Id),
                           case
                             when q.Access_To_Hidden_Salary_Job = 'Y' then
                              q.Oper_Type_Id
                             else
                              null
                           end, -- oper_type_id
                           case
                             when q.Access_To_Hidden_Salary_Job = 'Y' then
                              (select e.Short_Name
                                 from Mpr_Oper_Types e
                                where e.Company_Id = v_Company_Id
                                  and e.Oper_Type_Id = q.Oper_Type_Id)
                             else
                              null
                           end, -- oper_type_name
                           case
                             when q.Access_To_Hidden_Salary_Job = 'Y' then
                              (select e.Indicator_Value
                                 from Hpd_Page_Indicators e
                                where e.Company_Id = v_Company_Id
                                  and e.Filial_Id = v_Filial_Id
                                  and e.Page_Id = q.Page_Id
                                  and e.Indicator_Id = q.Indicator_Id)
                             else
                              null
                           end, -- indicator_value
                           q.Access_To_Hidden_Salary_Job)
      bulk collect
      into v_Matrix
      from (select k.Journal_Id,
                   k.Page_Id,
                   h.Hiring_Date,
                   r.Robot_Id,
                   Rb.Org_Unit_Id,
                   r.Division_Id,
                   r.Job_Id,
                   r.Fte_Id,
                   Ps.Schedule_Id,
                   Ot.Oper_Type_Id,
                   Ot.Indicator_Id,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => r.Job_Id,
                                                       i_Employee_Id => v_Employee_Id) Access_To_Hidden_Salary_Job
              from Hpd_Journal_Pages k
              join Hpd_Hirings h
                on h.Company_Id = v_Company_Id
               and h.Filial_Id = v_Filial_Id
               and h.Page_Id = k.Page_Id
              join Hpd_Page_Robots r
                on r.Company_Id = v_Company_Id
               and r.Filial_Id = v_Filial_Id
               and r.Page_Id = k.Page_Id
              left join Hpd_Page_Schedules Ps
                on Ps.Company_Id = v_Company_Id
               and Ps.Filial_Id = v_Filial_Id
               and Ps.Page_Id = k.Page_Id
              left join Hpd_Oper_Type_Indicators Ot
                on Ot.Company_Id = v_Company_Id
               and Ot.Filial_Id = v_Filial_Id
               and Ot.Page_Id = k.Page_Id
              left join Hrm_Robots Rb
                on Rb.Company_Id = v_Company_Id
               and Rb.Filial_Id = v_Filial_Id
               and Rb.Robot_Id = r.Robot_Id
             where k.Company_Id = v_Company_Id
               and k.Filial_Id = v_Filial_Id
               and k.Staff_Id = v_Staff_Id
               and exists (select 1
                      from Hpd_Journals j
                     where j.Company_Id = v_Company_Id
                       and j.Filial_Id = v_Filial_Id
                       and j.Journal_Id = k.Journal_Id
                       and j.Posted = 'Y')) q;
  
    Result.Put('hirings', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Journal_Id,
                           (select j.Posted_Order_No
                              from Hpd_Journals j
                             where j.Company_Id = v_Company_Id
                               and j.Filial_Id = v_Filial_Id
                               and j.Journal_Id = q.Journal_Id),
                           q.Page_Id,
                           q.Transfer_Begin,
                           q.Robot_Id,
                           q.Org_Unit_Id,
                           case
                             when q.Org_Unit_Id = q.Division_Id then
                              ''
                             else
                              (select e.Name
                                 from Mhr_Divisions e
                                where e.Company_Id = v_Company_Id
                                  and e.Filial_Id = v_Filial_Id
                                  and e.Division_Id = q.Org_Unit_Id)
                           end,
                           q.Division_Id,
                           (select e.Name
                              from Mhr_Divisions e
                             where e.Company_Id = v_Company_Id
                               and e.Filial_Id = v_Filial_Id
                               and e.Division_Id = q.Division_Id),
                           q.Job_Id,
                           (select e.Name
                              from Mhr_Jobs e
                             where e.Company_Id = v_Company_Id
                               and e.Filial_Id = v_Filial_Id
                               and e.Job_Id = q.Job_Id),
                           q.Fte_Id,
                           (select f.Name
                              from Href_Ftes f
                             where f.Company_Id = v_Company_Id
                               and f.Fte_Id = q.Fte_Id),
                           q.Schedule_Id,
                           (select e.Name
                              from Htt_Schedules e
                             where e.Company_Id = v_Company_Id
                               and e.Filial_Id = v_Filial_Id
                               and e.Schedule_Id = q.Schedule_Id),
                           case
                             when q.Access_To_Hidden_Salary_Job = 'Y' then
                              q.Oper_Type_Id
                             else
                              null
                           end, -- oper_type_id
                           case
                             when q.Access_To_Hidden_Salary_Job = 'Y' then
                              (select e.Short_Name
                                 from Mpr_Oper_Types e
                                where e.Company_Id = v_Company_Id
                                  and e.Oper_Type_Id = q.Oper_Type_Id)
                             else
                              null
                           end, -- oper_type_name
                           case
                             when q.Access_To_Hidden_Salary_Job = 'Y' then
                              (select e.Indicator_Value
                                 from Hpd_Page_Indicators e
                                where e.Company_Id = v_Company_Id
                                  and e.Filial_Id = v_Filial_Id
                                  and e.Page_Id = q.Page_Id
                                  and e.Indicator_Id = q.Indicator_Id)
                             else
                              null
                           end, -- indicator_value
                           q.Access_To_Hidden_Salary_Job)
      bulk collect
      into v_Matrix
      from (select k.Journal_Id,
                   k.Page_Id,
                   t.Transfer_Begin,
                   r.Robot_Id,
                   Rb.Org_Unit_Id,
                   r.Division_Id,
                   r.Job_Id,
                   r.Fte_Id,
                   Ps.Schedule_Id,
                   Ot.Oper_Type_Id,
                   Ot.Indicator_Id,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => r.Job_Id,
                                                       i_Employee_Id => v_Employee_Id) Access_To_Hidden_Salary_Job
              from Hpd_Journal_Pages k
              join Hpd_Transfers t
                on t.Company_Id = v_Company_Id
               and t.Filial_Id = v_Filial_Id
               and t.Page_Id = k.Page_Id
              join Hpd_Page_Robots r
                on r.Company_Id = v_Company_Id
               and r.Filial_Id = v_Filial_Id
               and r.Page_Id = k.Page_Id
              left join Hpd_Page_Schedules Ps
                on Ps.Company_Id = v_Company_Id
               and Ps.Filial_Id = v_Filial_Id
               and Ps.Page_Id = k.Page_Id
              left join Hpd_Oper_Type_Indicators Ot
                on Ot.Company_Id = v_Company_Id
               and Ot.Filial_Id = v_Filial_Id
               and Ot.Page_Id = k.Page_Id
              left join Hrm_Robots Rb
                on Rb.Company_Id = v_Company_Id
               and Rb.Filial_Id = v_Filial_Id
               and Rb.Robot_Id = r.Robot_Id
             where k.Company_Id = v_Company_Id
               and k.Filial_Id = v_Filial_Id
               and k.Staff_Id = v_Staff_Id
               and exists (select 1
                      from Hpd_Journals j
                     where j.Company_Id = v_Company_Id
                       and j.Filial_Id = v_Filial_Id
                       and j.Journal_Id = k.Journal_Id
                       and j.Posted = 'Y')) q;
  
    Result.Put('transfers', Fazo.Zip_Matrix(v_Matrix));
  
    v_Journal_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change);
  
    select Array_Varchar2(k.Journal_Id,
                          (select j.Posted_Order_No
                             from Hpd_Journals j
                            where j.Company_Id = v_Company_Id
                              and j.Filial_Id = v_Filial_Id
                              and j.Journal_Id = k.Journal_Id),
                          k.Page_Id,
                          Sc.Begin_Date,
                          Sc.End_Date,
                          s.Schedule_Id,
                          (select t.Name
                             from Htt_Schedules t
                            where t.Company_Id = v_Company_Id
                              and t.Filial_Id = v_Filial_Id
                              and t.Schedule_Id = s.Schedule_Id))
      bulk collect
      into v_Matrix
      from Hpd_Journal_Pages k
      join Hpd_Page_Schedules s
        on s.Company_Id = v_Company_Id
       and s.Filial_Id = v_Filial_Id
       and s.Page_Id = k.Page_Id
      join Hpd_Schedule_Changes Sc
        on Sc.Company_Id = v_Company_Id
       and Sc.Filial_Id = v_Filial_Id
       and Sc.Journal_Id = k.Journal_Id
     where k.Company_Id = v_Company_Id
       and k.Filial_Id = v_Filial_Id
       and k.Staff_Id = v_Staff_Id
       and exists (select 1
              from Hpd_Journals j
             where j.Company_Id = v_Company_Id
               and j.Filial_Id = v_Filial_Id
               and j.Journal_Id = k.Journal_Id
               and j.Journal_Type_Id = v_Journal_Type_Id
               and j.Posted = 'Y');
  
    Result.Put('schedules', Fazo.Zip_Matrix(v_Matrix));
  
    v_Journal_Type_Ids := Array_Number(Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Wage_Change),
                                       Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Wage_Change_Multiple));
  
    select Array_Varchar2(q.Journal_Id,
                           (select j.Posted_Order_No
                              from Hpd_Journals j
                             where j.Company_Id = v_Company_Id
                               and j.Filial_Id = v_Filial_Id
                               and j.Journal_Id = q.Journal_Id),
                           q.Page_Id,
                           q.Change_Date,
                           case
                             when q.Access_To_Hidden_Salary_Job = 'Y' then
                              q.Oper_Type_Id
                             else
                              null
                           end, -- oper_type_id
                           case
                             when q.Access_To_Hidden_Salary_Job = 'Y' then
                              (select e.Short_Name
                                 from Mpr_Oper_Types e
                                where e.Company_Id = v_Company_Id
                                  and e.Oper_Type_Id = q.Oper_Type_Id)
                             else
                              null
                           end, -- oper_type_name
                           case
                             when q.Access_To_Hidden_Salary_Job = 'Y' then
                              (select e.Indicator_Value
                                 from Hpd_Page_Indicators e
                                where e.Company_Id = v_Company_Id
                                  and e.Filial_Id = v_Filial_Id
                                  and e.Page_Id = q.Page_Id
                                  and e.Indicator_Id = q.Indicator_Id)
                             else
                              null
                           end, -- indicator_value
                           q.Access_To_Hidden_Salary_Job)
      bulk collect
      into v_Matrix
      from (select k.Journal_Id,
                   k.Page_Id,
                   w.Change_Date,
                   Ot.Oper_Type_Id,
                   Ot.Indicator_Id,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => v_Company_Id,
                                                                                                    i_Filial_Id  => v_Filial_Id,
                                                                                                    i_Staff_Id   => v_Staff_Id,
                                                                                                    i_Period     => w.Change_Date),
                                                       i_Employee_Id => v_Employee_Id) Access_To_Hidden_Salary_Job
              from Hpd_Journal_Pages k
              join Hpd_Wage_Changes w
                on w.Company_Id = v_Company_Id
               and w.Filial_Id = v_Filial_Id
               and w.Page_Id = k.Page_Id
              join Hpd_Oper_Type_Indicators Ot
                on Ot.Company_Id = v_Company_Id
               and Ot.Filial_Id = v_Filial_Id
               and Ot.Page_Id = k.Page_Id
             where k.Company_Id = v_Company_Id
               and k.Filial_Id = v_Filial_Id
               and k.Staff_Id = v_Staff_Id
               and exists (select 1
                      from Hpd_Journals j
                     where j.Company_Id = v_Company_Id
                       and j.Filial_Id = v_Filial_Id
                       and j.Journal_Id = k.Journal_Id
                       and j.Journal_Type_Id member of v_Journal_Type_Ids
                       and j.Posted = 'Y')) q;
  
    Result.Put('salaries', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(k.Journal_Id,
                          k.Page_Id,
                          d.Dismissal_Date,
                          d.Dismissal_Reason_Id,
                          (select Dr.Name
                             from Href_Dismissal_Reasons Dr
                            where Dr.Company_Id = v_Company_Id
                              and Dr.Dismissal_Reason_Id = d.Dismissal_Reason_Id),
                          (select Dr.Reason_Type
                             from Href_Dismissal_Reasons Dr
                            where Dr.Company_Id = v_Company_Id
                              and Dr.Dismissal_Reason_Id = d.Dismissal_Reason_Id),
                          d.Note,
                          (select e.Name
                             from Mhr_Divisions e
                            where e.Company_Id = v_Company_Id
                              and e.Filial_Id = v_Filial_Id
                              and e.Division_Id =
                                  Hpd_Util.Get_Closest_Division_Id(i_Company_Id => v_Company_Id,
                                                                   i_Filial_Id  => v_Filial_Id,
                                                                   i_Staff_Id   => v_Staff_Id,
                                                                   i_Period     => d.Dismissal_Date)),
                          (select e.Name
                             from Mhr_Jobs e
                            where e.Company_Id = v_Company_Id
                              and e.Filial_Id = v_Filial_Id
                              and e.Job_Id =
                                  Hpd_Util.Get_Closest_Job_Id(i_Company_Id => v_Company_Id,
                                                              i_Filial_Id  => v_Filial_Id,
                                                              i_Staff_Id   => v_Staff_Id,
                                                              i_Period     => d.Dismissal_Date)))
      bulk collect
      into v_Matrix
      from Hpd_Journal_Pages k
      join Hpd_Dismissals d
        on d.Company_Id = v_Company_Id
       and d.Filial_Id = v_Filial_Id
       and d.Page_Id = k.Page_Id
     where k.Company_Id = v_Company_Id
       and k.Filial_Id = v_Filial_Id
       and k.Staff_Id = v_Staff_Id
       and exists (select 1
              from Hpd_Journals j
             where j.Company_Id = v_Company_Id
               and j.Filial_Id = v_Filial_Id
               and j.Journal_Id = k.Journal_Id
               and j.Posted = 'Y');
  
    Result.Put('dismissals', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    result Hashmap := Hashmap;
  begin
    Result.Put_All(Load_Last_Staff(p));
    Result.Put('references', References(p.r_Number('employee_id')));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Staff
  (
    p       Hashmap,
    o_Staff out Href_Staffs%rowtype
  ) is
  begin
    o_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Staff_Id   => p.r_Number('staff_id'));
  
    if o_Staff.Employee_Id <> p.r_Number('employee_id') then
      b.Raise_Unauthenticated;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Prepare_Journal
  (
    p         Hashmap,
    o_Journal out Hpd_Journals%rowtype,
    o_Page_Id out number
  ) is
  begin
    if p.Has('journal_id') then
      o_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Journal_Id => p.r_Number('journal_id'));
      o_Page_Id := p.r_Number('page_id');
    
      if o_Journal.Posted = 'Y' then
        Hpd_Api.Journal_Unpost(i_Company_Id => o_Journal.Company_Id,
                               i_Filial_Id  => o_Journal.Filial_Id,
                               i_Journal_Id => o_Journal.Journal_Id,
                               i_Repost     => true);
      end if;
    else
      o_Journal.Journal_Id := Hpd_Next.Journal_Id;
      o_Page_Id            := Hpd_Next.Page_Id;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Hiring(p Hashmap) return Hashmap is
    r_Journal        Hpd_Journals%rowtype;
    r_Staff          Href_Staffs%rowtype;
    r_Page_Contract  Hpd_Page_Contracts%rowtype;
    r_Robot          Hrm_Robots%rowtype;
    r_Hiring         Hpd_Hirings%rowtype;
    r_Vacation_Limit Hpd_Page_Vacation_Limits%rowtype;
    r_Page_Robot     Hpd_Page_Robots%rowtype;
  
    p_Hiring    Hpd_Pref.Hiring_Journal_Rt;
    p_Robot     Hpd_Pref.Robot_Rt;
    p_Indicator Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
    p_Oper_Type Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    p_Contract  Hpd_Pref.Contract_Rt;
  
    v_Employee_Id       number := p.r_Number('employee_id');
    v_Page_Id           number;
    v_Robot_Id          number;
    v_Wage_Indicator_Id number;
    v_Salary_Type_Id    number;
    v_Hiring_Date       date := p.r_Date('hiring_date');
  begin
    if p.o_Number('staff_id') is not null then
      Assert_Staff(p, r_Staff);
    end if;
  
    Prepare_Journal(p => p, o_Journal => r_Journal, o_Page_Id => v_Page_Id);
  
    Hpd_Util.Hiring_Journal_New(o_Journal         => p_Hiring,
                                i_Company_Id      => Ui.Company_Id,
                                i_Filial_Id       => Ui.Filial_Id,
                                i_Journal_Id      => r_Journal.Journal_Id,
                                i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                              i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring),
                                i_Journal_Number  => r_Journal.Journal_Number,
                                i_Journal_Date    => v_Hiring_Date,
                                i_Journal_Name    => r_Journal.Journal_Name);
  
    if r_Journal.Company_Id is not null then
      v_Robot_Id := p.r_Number('robot_id');
    
      r_Robot := z_Hrm_Robots.Load(i_Company_Id => p_Hiring.Company_Id,
                                   i_Filial_Id  => p_Hiring.Filial_Id,
                                   i_Robot_Id   => v_Robot_Id);
    
      r_Page_Robot := z_Hpd_Page_Robots.Lock_Load(i_Company_Id => p_Hiring.Company_Id,
                                                  i_Filial_Id  => p_Hiring.Filial_Id,
                                                  i_Page_Id    => v_Page_Id);
    
      r_Hiring := z_Hpd_Hirings.Lock_Load(i_Company_Id => p_Hiring.Company_Id,
                                          i_Filial_Id  => p_Hiring.Filial_Id,
                                          i_Page_Id    => v_Page_Id);
    
      r_Vacation_Limit := z_Hpd_Page_Vacation_Limits.Take(i_Company_Id => p_Hiring.Company_Id,
                                                          i_Filial_Id  => p_Hiring.Filial_Id,
                                                          i_Page_Id    => v_Page_Id);
    
      r_Page_Contract := z_Hpd_Page_Contracts.Take(i_Company_Id => p_Hiring.Company_Id,
                                                   i_Filial_Id  => p_Hiring.Filial_Id,
                                                   i_Page_Id    => v_Page_Id);
    
      Hpd_Util.Contract_New(o_Contract             => p_Contract,
                            i_Contract_Number      => r_Page_Contract.Contract_Number,
                            i_Contract_Date        => r_Page_Contract.Contract_Date,
                            i_Fixed_Term           => r_Page_Contract.Fixed_Term,
                            i_Expiry_Date          => r_Page_Contract.Expiry_Date,
                            i_Fixed_Term_Base_Id   => r_Page_Contract.Fixed_Term_Base_Id,
                            i_Concluding_Term      => r_Page_Contract.Concluding_Term,
                            i_Hiring_Conditions    => r_Page_Contract.Hiring_Conditions,
                            i_Other_Conditions     => r_Page_Contract.Other_Conditions,
                            i_Workplace_Equipment  => r_Page_Contract.Workplace_Equipment,
                            i_Representative_Basis => r_Page_Contract.Representative_Basis);
    else
      v_Robot_Id := Mrf_Next.Robot_Id;
    end if;
  
    Hpd_Util.Robot_New(o_Robot           => p_Robot,
                       i_Robot_Id        => v_Robot_Id,
                       i_Division_Id     => p.r_Number('division_id'),
                       i_Org_Unit_Id     => p.o_Number('org_unit_id'),
                       i_Job_Id          => p.r_Number('job_id'),
                       i_Rank_Id         => r_Page_Robot.Rank_Id,
                       i_Wage_Scale_Id   => r_Robot.Wage_Scale_Id,
                       i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                       i_Fte_Id          => p.o_Number('fte_id'),
                       i_Fte             => r_Page_Robot.Fte);
  
    v_Salary_Type_Id := p.o_Number('salary_type_id');
  
    if v_Salary_Type_Id is not null then
      v_Wage_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => p_Hiring.Company_Id,
                                                    i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
    
      Hpd_Util.Indicator_Add(p_Indicator       => p_Indicator,
                             i_Indicator_Id    => v_Wage_Indicator_Id,
                             i_Indicator_Value => p.r_Number('salary_amount'));
    
      Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Type,
                             i_Oper_Type_Id  => v_Salary_Type_Id,
                             i_Indicator_Ids => Array_Number(v_Wage_Indicator_Id));
    end if;
  
    Hpd_Util.Journal_Add_Hiring(p_Journal              => p_Hiring,
                                i_Page_Id              => v_Page_Id,
                                i_Employee_Id          => v_Employee_Id,
                                i_Staff_Number         => p.o_Varchar2('staff_number'),
                                i_Hiring_Date          => v_Hiring_Date,
                                i_Trial_Period         => Nvl(r_Hiring.Trial_Period, 0),
                                i_Employment_Source_Id => r_Hiring.Employment_Source_Id,
                                i_Schedule_Id          => p.o_Number('schedule_id'),
                                i_Vacation_Days_Limit  => r_Vacation_Limit.Days_Limit,
                                i_Is_Booked            => 'N',
                                i_Robot                => p_Robot,
                                i_Contract             => p_Contract,
                                i_Indicators           => p_Indicator,
                                i_Oper_Types           => p_Oper_Type);
  
    Hpd_Api.Hiring_Journal_Save(p_Hiring);
    Hpd_Api.Journal_Post(i_Company_Id => p_Hiring.Company_Id,
                         i_Filial_Id  => p_Hiring.Filial_Id,
                         i_Journal_Id => p_Hiring.Journal_Id);
  
    select *
      into r_Staff
      from Href_Staffs s
     where s.Company_Id = p_Hiring.Company_Id
       and s.Filial_Id = p_Hiring.Filial_Id
       and s.Staff_Id = (select Jp.Staff_Id
                           from Hpd_Journal_Pages Jp
                          where Jp.Company_Id = p_Hiring.Company_Id
                            and Jp.Filial_Id = p_Hiring.Filial_Id
                            and Jp.Page_Id = v_Page_Id);
  
    return Fazo.Zip_Map('journal_id',
                        r_Journal.Journal_Id,
                        'page_id',
                        v_Page_Id,
                        'robot_id',
                        p_Robot.Robot_Id,
                        'staff_id',
                        r_Staff.Staff_Id,
                        'staff_number',
                        r_Staff.Staff_Number,
                        'staffs_exist',
                        Staffs_Exist(i_Employee_Id => r_Staff.Employee_Id,
                                     i_Staff_Id    => r_Staff.Staff_Id));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Save_Transfer(p Hashmap) return Hashmap is
    r_Journal    Hpd_Journals%rowtype;
    r_Staff      Href_Staffs%rowtype;
    p_Transfer   Hpd_Pref.Transfer_Journal_Rt;
    p_Robot      Hpd_Pref.Robot_Rt;
    p_Contract   Hpd_Pref.Contract_Rt;
    p_Oper_Types Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    p_Indicators Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
  
    v_Page_Id           number;
    v_Salary_Type_Id    number;
    v_Wage_Indicator_Id number;
    v_Begin_Date        date := p.r_Date('begin_date');
  
    r_Robot          Hrm_Robots%rowtype;
    r_Transfer       Hpd_Transfers%rowtype;
    r_Vacation_Limit Hpd_Page_Vacation_Limits%rowtype;
    r_Page_Contract  Hpd_Page_Contracts%rowtype;
    r_Page_Robot     Hpd_Page_Robots%rowtype;
  begin
    Assert_Staff(p, r_Staff);
    Prepare_Journal(p => p, o_Journal => r_Journal, o_Page_Id => v_Page_Id);
  
    Hpd_Util.Transfer_Journal_New(o_Journal         => p_Transfer,
                                  i_Company_Id      => r_Staff.Company_Id,
                                  i_Filial_Id       => r_Staff.Filial_Id,
                                  i_Journal_Id      => r_Journal.Journal_Id,
                                  i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => r_Staff.Company_Id,
                                                                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer),
                                  i_Journal_Number  => r_Journal.Journal_Number,
                                  i_Journal_Date    => v_Begin_Date,
                                  i_Journal_Name    => r_Journal.Journal_Name);
  
    if r_Journal.Company_Id is not null then
      r_Robot := z_Hrm_Robots.Load(i_Company_Id => p_Transfer.Company_Id,
                                   i_Filial_Id  => p_Transfer.Filial_Id,
                                   i_Robot_Id   => p.r_Number('robot_id'));
    
      r_Page_Robot := z_Hpd_Page_Robots.Lock_Load(i_Company_Id => p_Transfer.Company_Id,
                                                  i_Filial_Id  => p_Transfer.Filial_Id,
                                                  i_Page_Id    => v_Page_Id);
    
      r_Transfer := z_Hpd_Transfers.Lock_Load(i_Company_Id => p_Transfer.Company_Id,
                                              i_Filial_Id  => p_Transfer.Filial_Id,
                                              i_Page_Id    => v_Page_Id);
    
      r_Vacation_Limit := z_Hpd_Page_Vacation_Limits.Take(i_Company_Id => p_Transfer.Company_Id,
                                                          i_Filial_Id  => p_Transfer.Filial_Id,
                                                          i_Page_Id    => v_Page_Id);
    
      r_Page_Contract := z_Hpd_Page_Contracts.Take(i_Company_Id => p_Transfer.Company_Id,
                                                   i_Filial_Id  => p_Transfer.Filial_Id,
                                                   i_Page_Id    => v_Page_Id);
    
      Hpd_Util.Contract_New(o_Contract             => p_Contract,
                            i_Contract_Number      => r_Page_Contract.Contract_Number,
                            i_Contract_Date        => r_Page_Contract.Contract_Date,
                            i_Fixed_Term           => r_Page_Contract.Fixed_Term,
                            i_Expiry_Date          => r_Page_Contract.Expiry_Date,
                            i_Fixed_Term_Base_Id   => r_Page_Contract.Fixed_Term_Base_Id,
                            i_Concluding_Term      => r_Page_Contract.Concluding_Term,
                            i_Hiring_Conditions    => r_Page_Contract.Hiring_Conditions,
                            i_Other_Conditions     => r_Page_Contract.Other_Conditions,
                            i_Workplace_Equipment  => r_Page_Contract.Workplace_Equipment,
                            i_Representative_Basis => r_Page_Contract.Representative_Basis);
    else
      r_Robot.Robot_Id := Mrf_Next.Robot_Id;
    end if;
  
    Hpd_Util.Robot_New(o_Robot           => p_Robot,
                       i_Robot_Id        => r_Robot.Robot_Id,
                       i_Division_Id     => p.r_Number('division_id'),
                       i_Org_Unit_Id     => p.o_Number('org_unit_id'),
                       i_Job_Id          => p.r_Number('job_id'),
                       i_Rank_Id         => r_Page_Robot.Rank_Id,
                       i_Wage_Scale_Id   => r_Robot.Wage_Scale_Id,
                       i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                       i_Fte_Id          => p.o_Number('fte_id'),
                       i_Fte             => r_Page_Robot.Fte);
  
    v_Salary_Type_Id := p.o_Number('salary_type_id');
  
    if v_Salary_Type_Id is not null then
      v_Wage_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => p_Transfer.Company_Id,
                                                    i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
    
      Hpd_Util.Indicator_Add(p_Indicator       => p_Indicators,
                             i_Indicator_Id    => v_Wage_Indicator_Id,
                             i_Indicator_Value => p.r_Number('salary_amount'));
    
      Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Types,
                             i_Oper_Type_Id  => v_Salary_Type_Id,
                             i_Indicator_Ids => Array_Number(v_Wage_Indicator_Id));
    end if;
  
    Hpd_Util.Journal_Add_Transfer(p_Journal             => p_Transfer,
                                  i_Page_Id             => v_Page_Id,
                                  i_Transfer_Begin      => v_Begin_Date,
                                  i_Transfer_End        => r_Transfer.Transfer_End,
                                  i_Staff_Id            => r_Staff.Staff_Id,
                                  i_Schedule_Id         => p.o_Number('schedule_id'),
                                  i_Vacation_Days_Limit => r_Vacation_Limit.Days_Limit,
                                  i_Is_Booked           => 'N',
                                  i_Transfer_Reason     => r_Transfer.Transfer_Reason,
                                  i_Transfer_Base       => r_Transfer.Transfer_Base,
                                  i_Robot               => p_Robot,
                                  i_Contract            => p_Contract,
                                  i_Indicators          => p_Indicators,
                                  i_Oper_Types          => p_Oper_Types);
  
    Hpd_Api.Transfer_Journal_Save(p_Transfer);
  
    Hpd_Api.Journal_Post(i_Company_Id => p_Transfer.Company_Id,
                         i_Filial_Id  => p_Transfer.Filial_Id,
                         i_Journal_Id => p_Transfer.Journal_Id);
  
    return Fazo.Zip_Map('journal_id',
                        p_Transfer.Journal_Id,
                        'posted_order_no',
                        z_Hpd_Journals.Load(i_Company_Id => p_Transfer.Company_Id, --
                        i_Filial_Id => p_Transfer.Filial_Id, --
                        i_Journal_Id => p_Transfer.Journal_Id).Posted_Order_No,
                        'page_id',
                        v_Page_Id,
                        'robot_id',
                        p_Robot.Robot_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Save_Schedule(p Hashmap) return Hashmap is
    r_Journal         Hpd_Journals%rowtype;
    r_Staff           Href_Staffs%rowtype;
    p_Schedule        Hpd_Pref.Schedule_Change_Journal_Rt;
    v_Page_Id         number;
    v_Begin_Date      date := p.r_Date('begin_date');
    r_Schedule_Change Hpd_Schedule_Changes%rowtype;
  begin
    Assert_Staff(p, r_Staff);
    Prepare_Journal(p => p, o_Journal => r_Journal, o_Page_Id => v_Page_Id);
  
    if r_Journal.Company_Id is not null then
      r_Schedule_Change := z_Hpd_Schedule_Changes.Take(i_Company_Id => r_Staff.Company_Id,
                                                       i_Filial_Id  => r_Staff.Filial_Id,
                                                       i_Journal_Id => r_Journal.Journal_Id);
    end if;
  
    Hpd_Util.Schedule_Change_Journal_New(o_Journal        => p_Schedule,
                                         i_Company_Id     => r_Staff.Company_Id,
                                         i_Filial_Id      => r_Staff.Filial_Id,
                                         i_Journal_Id     => r_Journal.Journal_Id,
                                         i_Journal_Number => r_Journal.Journal_Number,
                                         i_Journal_Date   => v_Begin_Date,
                                         i_Journal_Name   => r_Journal.Journal_Name,
                                         i_Division_Id    => r_Schedule_Change.Division_Id,
                                         i_Begin_Date     => v_Begin_Date,
                                         i_End_Date       => p.o_Date('end_date'));
  
    Hpd_Util.Journal_Add_Schedule_Change(p_Journal     => p_Schedule,
                                         i_Page_Id     => v_Page_Id,
                                         i_Staff_Id    => r_Staff.Staff_Id,
                                         i_Schedule_Id => p.r_Number('schedule_id'));
  
    Hpd_Api.Schedule_Change_Journal_Save(p_Schedule);
  
    Hpd_Api.Journal_Post(i_Company_Id => p_Schedule.Company_Id,
                         i_Filial_Id  => p_Schedule.Filial_Id,
                         i_Journal_Id => p_Schedule.Journal_Id);
  
    return Fazo.Zip_Map('journal_id',
                        p_Schedule.Journal_Id,
                        'posted_order_no',
                        z_Hpd_Journals.Load(i_Company_Id => p_Schedule.Company_Id, --
                        i_Filial_Id => p_Schedule.Filial_Id, --
                        i_Journal_Id => p_Schedule.Journal_Id).Posted_Order_No,
                        'page_id',
                        v_Page_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Save_Salary(p Hashmap) return Hashmap is
    r_Journal           Hpd_Journals%rowtype;
    r_Staff             Href_Staffs%rowtype;
    p_Salary            Hpd_Pref.Wage_Change_Journal_Rt;
    p_Oper_Type         Href_Pref.Oper_Type_Nt;
    p_Indicator         Href_Pref.Indicator_Nt;
    v_Wage_Indicator_Id number;
    v_Page_Id           number;
    v_Begin_Date        date := p.r_Date('begin_date');
  begin
    Assert_Staff(p, r_Staff);
    Prepare_Journal(p => p, o_Journal => r_Journal, o_Page_Id => v_Page_Id);
  
    Hpd_Util.Wage_Change_Journal_New(o_Journal         => p_Salary,
                                     i_Company_Id      => r_Staff.Company_Id,
                                     i_Filial_Id       => r_Staff.Filial_Id,
                                     i_Journal_Id      => r_Journal.Journal_Id,
                                     i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => r_Staff.Company_Id,
                                                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Wage_Change),
                                     i_Journal_Number  => r_Journal.Journal_Number,
                                     i_Journal_Date    => v_Begin_Date,
                                     i_Journal_Name    => r_Journal.Journal_Name);
  
    p_Indicator         := Href_Pref.Indicator_Nt();
    v_Wage_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => p_Salary.Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
  
    if p.o_Number('salary_type_id') is not null then
      Hpd_Util.Indicator_Add(p_Indicator       => p_Indicator,
                             i_Indicator_Id    => v_Wage_Indicator_Id,
                             i_Indicator_Value => p.r_Number('salary_amount'));
    
      p_Oper_Type := Href_Pref.Oper_Type_Nt();
    
      Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Type,
                             i_Oper_Type_Id  => p.r_Number('salary_type_id'),
                             i_Indicator_Ids => Array_Number(v_Wage_Indicator_Id));
    end if;
  
    Hpd_Util.Journal_Add_Wage_Change(p_Journal     => p_Salary,
                                     i_Page_Id     => v_Page_Id,
                                     i_Staff_Id    => r_Staff.Staff_Id,
                                     i_Change_Date => v_Begin_Date,
                                     i_Indicators  => p_Indicator,
                                     i_Oper_Types  => p_Oper_Type);
  
    Hpd_Api.Wage_Change_Journal_Save(p_Salary);
  
    Hpd_Api.Journal_Post(i_Company_Id => p_Salary.Company_Id,
                         i_Filial_Id  => p_Salary.Filial_Id,
                         i_Journal_Id => p_Salary.Journal_Id);
  
    return Fazo.Zip_Map('journal_id',
                        p_Salary.Journal_Id,
                        'posted_order_no',
                        z_Hpd_Journals.Load(i_Company_Id => p_Salary.Company_Id, --
                        i_Filial_Id => p_Salary.Filial_Id, --
                        i_Journal_Id => p_Salary.Journal_Id).Posted_Order_No,
                        'page_id',
                        v_Page_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Influences(p Hashmap) return Hashmap is
  begin
    return Uit_Href.Get_Influences(i_Employee_Id         => p.r_Number('employee_id'),
                                   i_Dismissal_Reason_Id => p.o_Number('dismissal_reason_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Save_Dismissal(p Hashmap) return Hashmap is
    r_Journal        Hpd_Journals%rowtype;
    r_Staff          Href_Staffs%rowtype;
    r_Dismissal      Hpd_Dismissals%rowtype;
    p_Dismissal      Hpd_Pref.Dismissal_Journal_Rt;
    v_Page_Id        number;
    v_Dismissal_Date date := p.r_Date('dismissal_date');
  begin
    Assert_Staff(p, r_Staff);
    Prepare_Journal(p => p, o_Journal => r_Journal, o_Page_Id => v_Page_Id);
  
    Hpd_Util.Dismissal_Journal_New(o_Journal         => p_Dismissal,
                                   i_Company_Id      => r_Staff.Company_Id,
                                   i_Filial_Id       => r_Staff.Filial_Id,
                                   i_Journal_Id      => r_Journal.Journal_Id,
                                   i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => r_Staff.Company_Id,
                                                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
                                   i_Journal_Number  => r_Journal.Journal_Number,
                                   i_Journal_Date    => v_Dismissal_Date,
                                   i_Journal_Name    => r_Journal.Journal_Name);
  
    if r_Journal.Company_Id is not null then
      r_Dismissal := z_Hpd_Dismissals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Page_Id    => v_Page_Id);
    end if;
  
    Hpd_Util.Journal_Add_Dismissal(p_Journal              => p_Dismissal,
                                   i_Page_Id              => v_Page_Id,
                                   i_Staff_Id             => r_Staff.Staff_Id,
                                   i_Dismissal_Date       => v_Dismissal_Date,
                                   i_Dismissal_Reason_Id  => p.o_Number('dismissal_reason_id'),
                                   i_Employment_Source_Id => r_Dismissal.Employment_Source_Id,
                                   i_Based_On_Doc         => r_Dismissal.Based_On_Doc,
                                   i_Note                 => p.o_Varchar2('note'));
  
    Hpd_Api.Dismissal_Journal_Save(p_Dismissal);
  
    Hpd_Api.Journal_Post(i_Company_Id => p_Dismissal.Company_Id,
                         i_Filial_Id  => p_Dismissal.Filial_Id,
                         i_Journal_Id => p_Dismissal.Journal_Id);
  
    return Fazo.Zip_Map('journal_id', r_Journal.Journal_Id, 'page_id', v_Page_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    r_Journal     Hpd_Journals%rowtype;
    v_Employee_Id number := p.r_Number('employee_id');
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    for r in (select 'X' as Dummy
                from Hpd_Journal_Pages Jp
               where Jp.Company_Id = r_Journal.Company_Id
                 and Jp.Filial_Id = r_Journal.Filial_Id
                 and Jp.Journal_Id = r_Journal.Journal_Id
                 and Jp.Employee_Id <> v_Employee_Id)
    loop
      b.Raise_Unauthenticated;
    end loop;
  
    if r_Journal.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id);
    end if;
  
    Hpd_Api.Journal_Delete(i_Company_Id => r_Journal.Company_Id,
                           i_Filial_Id  => r_Journal.Filial_Id,
                           i_Journal_Id => r_Journal.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id        = null,
           Job_Id            = null,
           Filial_Id         = null,
           name              = null,
           State             = null,
           c_Divisions_Exist = null;
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Job_Id      = null,
           Division_Id = null;
    update Href_Ftes
       set Company_Id = null,
           Fte_Id     = null,
           name       = null,
           Order_No   = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           Short_Name     = null,
           State          = null,
           Pcode          = null;
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null,
           Reason_Type         = null;
  end;

end Ui_Vhr312;
/
