create or replace package Ui_Vhr438 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Blocked_Staffs(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Period_Info(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr438;
/
create or replace package body Ui_Vhr438 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Query   varchar2(32767);
    v_Paramas Hashmap;
  
    q                      Fazo_Query;
    v_Period_Begin         date := p.r_Date('period_begin');
    v_Period_End           date := p.r_Date('period_end');
    v_Division_Ids         Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
  begin
    v_Query := 'select *
                  from (select s.*,
                               case
                                  when :access_all_employees = ''N'' or :division_id is not null then
                                   hpd_util.get_closest_org_unit_id(s.company_id,
                                                                    s.filial_id,
                                                                    s.staff_id,
                                                                    least(:period_end,
                                                                          nvl(s.dismissal_date, :period_end)))
                                  else
                                   null
                                end cur_division_id
                          from href_staffs s
                         where s.company_id = :company_id
                           and s.filial_id = :filial_id
                           and s.staff_kind = :primary_kind
                           and s.state = ''A''
                           and s.hiring_date <= :period_end
                           and (s.dismissal_date is null or s.dismissal_date >= :period_begin)
                           and uit_hrm.access_to_hidden_salary_job(i_job_id      => hpd_util.get_closest_job_id(s.company_id,
                                                                                                                s.filial_id,
                                                                                                                s.staff_id,
                                                                                                                least(:period_end,
                                                                                                                      nvl(s.dismissal_date,
                                                                                                                          :period_end))),
                                                                   i_employee_id => s.employee_id) = ''Y''
                           and not exists (select 1
                                  from href_util.staff_licensed_period(:company_id,
                                                                       :filial_id,
                                                                       s.staff_id,
                                                                       :period_begin,
                                                                       :period_end) lp
                                 where lp.licensed = ''N'')) st
                 where (:division_id is null or st.cur_division_id member of :division_id)';
  
    v_Paramas := Fazo.Zip_Map('company_id',
                              Ui.Company_Id,
                              'filial_id',
                              Ui.Filial_Id,
                              'period_begin',
                              v_Period_Begin,
                              'period_end',
                              v_Period_End,
                              'primary_kind',
                              Href_Pref.c_Staff_Kind_Primary);
  
    if v_Division_Ids.Count = 0 then
      v_Division_Ids := null;
    end if;
  
    v_Paramas.Put('division_id', v_Division_Ids);
    v_Paramas.Put('access_all_employees', v_Access_All_Employees);
  
    if v_Access_All_Employees = 'N' then
      v_Query := v_Query || --
                 'and (st.employee_id = :user_id or
                       st.cur_division_id member of :division_ids)';
    
      v_Paramas.Put('division_ids', Uit_Href.Get_All_Subordinate_Divisions);
      v_Paramas.Put('user_id', Ui.User_Id);
    end if;
  
    q := Fazo_Query(v_Query, v_Paramas);
  
    q.Number_Field('staff_id', 'employee_id', 'division_id');
    q.Varchar2_Field('staff_number');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select r.name
                   from mr_natural_persons r
                  where r.company_id = :company_id
                    and r.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Blocked_Staffs(p Hashmap) return Hashmap is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
    v_Array        Array_Number;
    result         Hashmap := Hashmap();
  begin
    select s.Staff_Id
      bulk collect
      into v_Array
      from Href_Staffs s
     where s.Company_Id = v_Company_Id
       and s.Filial_Id = v_Filial_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
       and s.Hiring_Date <= v_Period_End
       and Nvl(s.Dismissal_Date, v_Period_Begin) >= v_Period_Begin
       and (Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => s.Company_Id,
                                                                                             i_Filial_Id  => s.Filial_Id,
                                                                                             i_Staff_Id   => s.Staff_Id,
                                                                                             i_Period     => Least(Nvl(s.Dismissal_Date,
                                                                                                                       v_Period_End),
                                                                                                                   v_Period_End)),
                                                i_Employee_Id => s.Employee_Id) = 'N' or --
           exists (select 1
                     from Href_Util.Staff_Licensed_Period(i_Company_Id   => v_Company_Id,
                                                          i_Filial_Id    => v_Filial_Id,
                                                          i_Staff_Id     => s.Staff_Id,
                                                          i_Period_Begin => v_Period_Begin,
                                                          i_Period_End   => v_Period_End) Lp
                    where Lp.Licensed = 'N'));
  
    Result.Put('staff_ids', v_Array);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Staff_Ids
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Division_Ids Array_Number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Array_Number is
    v_Division_Count      number := i_Division_Ids.Count;
    v_Access_All_Employee varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Division_Id         Array_Number;
    result                Array_Number;
  begin
    if v_Access_All_Employee = 'N' then
      v_Division_Id := Uit_Href.Get_All_Subordinate_Divisions;
    end if;
  
    select St.Staff_Id
      bulk collect
      into result
      from (select s.Staff_Id,
                   s.Employee_Id,
                   case
                      when v_Access_All_Employee = 'N' or v_Division_Count > 0 then
                       Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => s.Company_Id,
                                                        i_Filial_Id  => s.Filial_Id,
                                                        i_Staff_Id   => s.Staff_Id,
                                                        i_Period     => Least(i_Period_End,
                                                                              Nvl(s.Dismissal_Date,
                                                                                  i_Period_End)))
                      else
                       null
                    end Division_Id
              from Href_Staffs s
             where s.Company_Id = i_Company_Id
               and s.Filial_Id = i_Filial_Id
               and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
               and s.State = 'A'
               and s.Hiring_Date <= i_Period_End
               and (s.Dismissal_Date is null or s.Dismissal_Date >= i_Period_Begin)
               and Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => s.Company_Id,
                                                                                                    i_Filial_Id  => s.Filial_Id,
                                                                                                    i_Staff_Id   => s.Staff_Id,
                                                                                                    i_Period     => Least(i_Period_End,
                                                                                                                          Nvl(s.Dismissal_Date,
                                                                                                                              i_Period_End))),
                                                       i_Employee_Id => s.Employee_Id) = 'Y'
               and exists (select 1
                      from Href_Util.Staff_Licensed_Period(i_Company_Id   => i_Company_Id,
                                                           i_Filial_Id    => i_Filial_Id,
                                                           i_Staff_Id     => s.Staff_Id,
                                                           i_Period_Begin => i_Period_Begin,
                                                           i_Period_End   => i_Period_End) Lp
                     where Lp.Licensed = 'Y')) St
     where (v_Division_Count = 0 or St.Division_Id member of i_Division_Ids)
       and (v_Access_All_Employee = 'Y' or --
           St.Employee_Id = Ui.User_Id or --
           St.Division_Id member of v_Division_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Period_Info(p Hashmap) return Arraylist is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
  
    v_Staff_Ids    Array_Number := Nvl(p.o_Array_Number('staff_ids'), Array_Number());
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
  
    result Arraylist := Arraylist();
  
    --------------------------------------------------
    Procedure Push_Sheet_Staff
    (
      p_Staffs_List in out nocopy Arraylist,
      i_Staff_Id    number
    ) is
      r_Staff        Href_Staffs%rowtype;
      r_Robot        Mrf_Robots%rowtype;
      v_Schedule_Id  number;
      v_Desired_Date date;
      v_Staff        Hashmap;
    begin
      r_Staff := z_Href_Staffs.Load(i_Company_Id => v_Company_Id,
                                    i_Filial_Id  => v_Filial_Id,
                                    i_Staff_Id   => i_Staff_Id);
    
      Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r_Staff.Employee_Id);
    
      v_Desired_Date := Least(v_Period_End, Nvl(r_Staff.Dismissal_Date, v_Period_End));
    
      r_Robot := Hpd_Util.Get_Closest_Robot(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => v_Filial_Id,
                                            i_Staff_Id   => i_Staff_Id,
                                            i_Period     => v_Desired_Date);
    
      v_Schedule_Id := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => v_Company_Id,
                                                        i_Filial_Id  => v_Filial_Id,
                                                        i_Staff_Id   => i_Staff_Id,
                                                        i_Period     => v_Desired_Date);
    
      v_Staff := Fazo.Zip_Map('staff_id',
                              i_Staff_Id,
                              'division_id',
                              r_Robot.Division_Id,
                              'job_id',
                              r_Robot.Job_Id,
                              'schedule_id',
                              v_Schedule_Id);
    
      v_Staff.Put('staff_name',
                  Href_Util.Staff_Name(i_Company_Id => v_Company_Id,
                                       i_Filial_Id  => v_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id));
      v_Staff.Put('division_name',
                  z_Mhr_Divisions.Load(i_Company_Id => v_Company_Id, --
                  i_Filial_Id => v_Filial_Id, --
                  i_Division_Id => r_Robot.Division_Id).Name);
      v_Staff.Put('job_name',
                  z_Mhr_Jobs.Load(i_Company_Id => v_Company_Id, --
                  i_Filial_Id => v_Filial_Id, --
                  i_Job_Id => r_Robot.Job_Id).Name);
      v_Staff.Put('schedule_name',
                  z_Htt_Schedules.Take(i_Company_Id => v_Company_Id, --
                  i_Filial_Id => v_Filial_Id, --
                  i_Schedule_Id => v_Schedule_Id).Name);
    
      v_Staff.Put('access_to_hidden_salary',
                  Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => r_Robot.Job_Id,
                                                      i_Employee_Id => r_Staff.Employee_Id));
    
      p_Staffs_List.Push(v_Staff);
    end;
  begin
    if v_Staff_Ids.Count = 0 then
      v_Staff_Ids := Load_Staff_Ids(i_Company_Id   => v_Company_Id,
                                    i_Filial_Id    => v_Filial_Id,
                                    i_Division_Ids => v_Division_Ids,
                                    i_Period_Begin => v_Period_Begin,
                                    i_Period_End   => v_Period_End);
    end if;
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      Push_Sheet_Staff(result, v_Staff_Ids(i));
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id Array_Number := Array_Number()) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    v_Period_Begin date := Trunc(sysdate, 'mon');
    v_Period_End   date := Last_Day(v_Period_Begin);
    result         Hashmap;
  begin
    result := Fazo.Zip_Map('sheet_date', --
                           Trunc(sysdate),
                           'period_kind',
                           Hpr_Pref.c_Period_Full_Month,
                           'month',
                           to_char(v_Period_Begin, Href_Pref.c_Date_Format_Month),
                           'period_begin',
                           to_char(v_Period_Begin, Href_Pref.c_Date_Format_Day),
                           'period_end',
                           to_char(v_Period_End, Href_Pref.c_Date_Format_Day));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Sheet        Hpr_Wage_Sheets%rowtype;
    v_Sheet_Staffs Matrix_Varchar2;
    v_Division_Ids Array_Number;
    v_Sheet_Id     number := p.r_Number('sheet_id');
    result         Hashmap;
  begin
    r_Sheet := z_Hpr_Wage_Sheets.Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Sheet_Id   => v_Sheet_Id);
  
    Uit_Hpr.Assert_Access_To_Wage_Sheet(i_Sheet_Id   => v_Sheet_Id,
                                        i_Sheet_Kind => Hpr_Pref.c_Wage_Sheet_Onetime);
  
    result := z_Hpr_Wage_Sheets.To_Map(r_Sheet,
                                       z.Sheet_Id,
                                       z.Sheet_Number,
                                       z.Sheet_Date,
                                       z.Period_Kind,
                                       z.Status,
                                       z.Note,
                                       z.Posted);
  
    select q.Division_Id
      bulk collect
      into v_Division_Ids
      from Hpr_Wage_Sheet_Divisions q
     where q.Company_Id = r_Sheet.Company_Id
       and q.Filial_Id = r_Sheet.Filial_Id
       and q.Sheet_Id = r_Sheet.Sheet_Id;
  
    Result.Put('division_ids', v_Division_Ids);
    Result.Put('month', to_char(r_Sheet.Month, Href_Pref.c_Date_Format_Month));
    Result.Put('period_begin', to_char(r_Sheet.Period_Begin, Href_Pref.c_Date_Format_Day));
    Result.Put('period_end', to_char(r_Sheet.Period_End, Href_Pref.c_Date_Format_Day));
  
    select Array_Varchar2(Sh.Staff_Id,
                           Sh.Staff_Name,
                           Sh.Division_Id,
                           Sh.Division_Name,
                           Sh.Job_Id,
                           Sh.Job_Name,
                           Sh.Schedule_Id,
                           Sh.Schedule_Name,
                           (case
                             when Sh.Access_To_Hidden_Salary = 'Y' then
                              Sh.Accrual_Amount
                             else
                              -1
                           end),
                           (case
                             when Sh.Access_To_Hidden_Salary = 'Y' then
                              Sh.Penalty_Amount
                             else
                              -1
                           end),
                           (case
                             when Sh.Access_To_Hidden_Salary = 'Y' then
                              Sh.Total_Amount
                             else
                              -1
                           end),
                           Sh.Access_To_Hidden_Salary)
      bulk collect
      into v_Sheet_Staffs
      from (select q.Staff_Id,
                   (select Np.Name
                      from Mr_Natural_Persons Np
                     where Np.Company_Id = q.Company_Id
                       and Np.Person_Id = St.Employee_Id) Staff_Name,
                   q.Division_Id,
                   (select m.Name
                      from Mhr_Divisions m
                     where m.Company_Id = q.Company_Id
                       and m.Filial_Id = q.Filial_Id
                       and m.Division_Id = q.Division_Id) Division_Name,
                   q.Job_Id,
                   (select j.Name
                      from Mhr_Jobs j
                     where j.Company_Id = q.Company_Id
                       and j.Filial_Id = q.Filial_Id
                       and j.Job_Id = q.Job_Id) Job_Name,
                   q.Schedule_Id,
                   (select s.Name
                      from Htt_Schedules s
                     where s.Company_Id = q.Company_Id
                       and s.Filial_Id = q.Filial_Id
                       and s.Schedule_Id = q.Schedule_Id) Schedule_Name,
                   Nullif(q.Accrual_Amount, 0) Accrual_Amount,
                   Nullif(q.Penalty_Amount, 0) Penalty_Amount,
                   Nullif(q.Total_Amount, 0) Total_Amount,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => q.Job_Id,
                                                       i_Employee_Id => St.Employee_Id) Access_To_Hidden_Salary
              from Hpr_Onetime_Sheet_Staffs q
              join Href_Staffs St
                on St.Company_Id = q.Company_Id
               and St.Filial_Id = q.Filial_Id
               and St.Staff_Id = q.Staff_Id
             where q.Company_Id = r_Sheet.Company_Id
               and q.Filial_Id = r_Sheet.Filial_Id
               and q.Sheet_Id = r_Sheet.Sheet_Id) Sh;
  
    Result.Put('sheet_staffs', Fazo.Zip_Matrix(v_Sheet_Staffs));
    Result.Put('references', References(v_Division_Ids));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Sheet_Id number,
    p          Hashmap
  ) return Hashmap is
    v_Staff          Hashmap;
    v_Sheet_Staffs   Arraylist := p.r_Arraylist('sheet_staffs');
    v_Wage_Sheet     Hpr_Pref.Wage_Sheet_Rt;
    v_Posted         boolean := p.r_Varchar2('posted') = 'Y';
    v_Accrual_Amount number;
    v_Penalty_Amount number;
    v_Staff_Id       number;
    r_Sheet_Staff    Hpr_Onetime_Sheet_Staffs%rowtype;
  begin
    Hpr_Util.Wage_Sheet_New(o_Wage_Sheet   => v_Wage_Sheet,
                            i_Company_Id   => Ui.Company_Id,
                            i_Filial_Id    => Ui.Filial_Id,
                            i_Sheet_Id     => i_Sheet_Id,
                            i_Sheet_Number => p.o_Varchar2('sheet_number'),
                            i_Sheet_Date   => p.r_Date('sheet_date'),
                            i_Period_Begin => p.r_Date('period_begin'),
                            i_Period_End   => p.r_Date('period_end'),
                            i_Period_Kind  => p.r_Varchar2('period_kind'),
                            i_Note         => p.o_Varchar2('note'),
                            i_Division_Ids => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
                            i_Sheet_Kind   => Hpr_Pref.c_Wage_Sheet_Onetime);
  
    for i in 1 .. v_Sheet_Staffs.Count
    loop
      v_Staff    := Treat(v_Sheet_Staffs.r_Hashmap(i) as Hashmap);
      v_Staff_Id := v_Staff.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Employee(Href_Util.Get_Employee_Id(i_Company_Id => v_Wage_Sheet.Company_Id,
                                                                   i_Filial_Id  => v_Wage_Sheet.Filial_Id,
                                                                   i_Staff_Id   => v_Staff_Id));
    
      v_Accrual_Amount := v_Staff.o_Number('accrual_amount');
      v_Penalty_Amount := v_Staff.o_Number('penalty_amount');
    
      if v_Accrual_Amount = -1 then
        if not z_Hpr_Onetime_Sheet_Staffs.Exist(i_Company_Id => v_Wage_Sheet.Company_Id,
                                                i_Filial_Id  => v_Wage_Sheet.Filial_Id,
                                                i_Sheet_Id   => i_Sheet_Id,
                                                i_Staff_Id   => v_Staff_Id,
                                                o_Row        => r_Sheet_Staff) then
          continue;
        end if;
      
        v_Accrual_Amount := r_Sheet_Staff.Accrual_Amount;
        v_Penalty_Amount := r_Sheet_Staff.Penalty_Amount;
      end if;
    
      Hpr_Util.Onetime_Sheet_Staff_Add(p_Staffs         => v_Wage_Sheet.Sheet_Staffs,
                                       i_Staff_Id       => v_Staff_Id,
                                       i_Accrual_Amount => v_Accrual_Amount,
                                       i_Penalty_Amount => v_Penalty_Amount);
    end loop;
  
    Hpr_Api.Wage_Sheet_Save(i_Wage_Sheet => v_Wage_Sheet);
  
    if v_Posted then
      Hpr_Api.Wage_Sheet_Post(i_Company_Id => v_Wage_Sheet.Company_Id,
                              i_Filial_Id  => v_Wage_Sheet.Filial_Id,
                              i_Sheet_Id   => v_Wage_Sheet.Sheet_Id);
    end if;
  
    return Fazo.Zip_Map('sheet_id',
                        v_Wage_Sheet.Sheet_Id,
                        'sheet_number',
                        v_Wage_Sheet.Sheet_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hpr_Next.Wage_Sheet_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Sheet Hpr_Wage_Sheets%rowtype;
  begin
    r_Sheet := z_Hpr_Wage_Sheets.Lock_Load(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Sheet_Id   => p.r_Number('sheet_id'));
  
    if r_Sheet.Posted = 'Y' then
      Hpr_Api.Wage_Sheet_Unpost(i_Company_Id => r_Sheet.Company_Id,
                                i_Filial_Id  => r_Sheet.Filial_Id,
                                i_Sheet_Id   => r_Sheet.Sheet_Id);
    end if;
  
    return save(r_Sheet.Sheet_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
    v_Dummy varchar2(1);
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Staff_Kind     = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Hpr_Wage_Sheets
       set Company_Id = null,
           Filial_Id  = null,
           Sheet_Id   = null,
           Posted     = null;
    update Hpr_Sheet_Parts
       set Company_Id = null,
           Filial_Id  = null,
           Part_Begin = null,
           Part_End   = null,
           Staff_Id   = null;
    Uie.x(Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => null,
                                           i_Filial_Id  => null,
                                           i_Staff_Id   => null,
                                           i_Period     => null));
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => null, i_Employee_Id => null));
    Uie.x(Hpd_Util.Get_Closest_Job_Id(i_Company_Id => null,
                                      i_Filial_Id  => null,
                                      i_Staff_Id   => null,
                                      i_Period     => null));
  
    select 'X'
      into v_Dummy
      from Href_Util.Staff_Licensed_Period(i_Company_Id   => null,
                                           i_Filial_Id    => null,
                                           i_Staff_Id     => null,
                                           i_Period_Begin => null,
                                           i_Period_End   => null);
  end;

end Ui_Vhr438;
/
