create or replace package Uit_Hpd is
  ----------------------------------------------------------------------------------------------------
  Function Get_Journal_Type(i_Journal_Type_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Fte_Id(i_Fte number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Page_Id(i_Journal_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Robot_Id(i_Page_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Overtime_Id(i_Journal_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Last_Wage
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Last_Data
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Application_Grant_Has
  (
    i_Grant     varchar2,
    i_Filial_Id number := Ui.Filial_Id
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Assert_Grant
  (
    i_Grant     varchar2,
    i_Filial_Id number := Ui.Filial_Id
  );
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Wage_With_Access
  (
    i_Staff_Id number,
    i_Period   date,
    i_User_Id  number
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Las_Hiring_Journal_Id(i_Staff_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fill_Hiring_Data
  (
    i_Journal_Id  number,
    i_Staff_Id    number,
    i_Hiring_Date date,
    i_Division_Id number,
    i_Job_Id      number,
    i_Schedule_Id number
  ) return Hpd_Pref.Hiring_Journal_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Load_Overtime_Blocked_Staffs
  (
    i_Month_Begin   date,
    i_Month_End     date,
    i_Min_Free_Time number,
    i_Max_Free_Time number
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------           
  Procedure Check_Access_To_Edit_Journal
  (
    i_Document_Status varchar2,
    i_Posted          varchar2,
    i_Journal_Number  varchar2
  );
  ----------------------------------------------------------------------------------------------------           
  Function Access_To_Journal_Sign_Document(i_Journal_Id number) return boolean;
end Uit_Hpd;
/
create or replace package body Uit_Hpd is
  ----------------------------------------------------------------------------------------------------
  Function Get_Journal_Type(i_Journal_Type_Id number) return varchar2 is
    result  varchar2(1);
    v_Pcode varchar2(100);
  begin
    select j.Pcode
      into v_Pcode
      from Hpd_Journal_Types j
     where j.Company_Id = Ui.Company_Id
       and j.Journal_Type_Id = i_Journal_Type_Id;
  
    if v_Pcode member of Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Hiring,
                      Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple) then
      result := Hpd_Pref.c_Journal_Type_Hiring;
    elsif v_Pcode member of Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Transfer,
                         Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple) then
      result := Hpd_Pref.c_Journal_Type_Transfer;
    elsif v_Pcode member of Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Dismissal,
                         Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple) then
      result := Hpd_Pref.c_Journal_Type_Dismissal;
    elsif v_Pcode = Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change then
      result := Hpd_Pref.c_Journal_Type_Schedule_Change;
    elsif v_Pcode in (Hpd_Pref.c_Pcode_Journal_Type_Wage_Change,
                      Hpd_Pref.c_Pcode_Journal_Type_Wage_Change_Multiple) then
      result := Hpd_Pref.c_Journal_Type_Wage_Change;
    elsif v_Pcode member of Array_Varchar2(Hpd_Pref.c_Pcode_Journal_Type_Rank_Change,
                         Hpd_Pref.c_Pcode_Journal_Type_Rank_Change_Multiple) then
      result := Hpd_Pref.c_Journal_Type_Rank_Change;
    elsif v_Pcode = Hpd_Pref.c_Pcode_Journal_Type_Limit_Change then
      result := Hpd_Pref.c_Journal_Type_Limit_Change;
    else
      result := null;
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Fte_Id(i_Fte number) return number is
    v_Fte_Kind Href_Ftes.Pcode%type;
  begin
    case i_Fte
      when 1 then
        v_Fte_Kind := Href_Pref.c_Pcode_Fte_Full_Time;
      when 0.5 then
        v_Fte_Kind := Href_Pref.c_Pcode_Fte_Part_Time;
      when 0.25 then
        v_Fte_Kind := Href_Pref.c_Pcode_Fte_Quarter_Time;
      else
        null;
    end case;
  
    if v_Fte_Kind is null then
      return Href_Pref.c_Custom_Fte_Id;
    end if;
  
    return Href_Util.Fte_Id(i_Company_Id => Ui.Company_Id, i_Pcode => v_Fte_Kind);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Page_Id(i_Journal_Id number) return number is
    v_Page_Id number;
  begin
    select t.Page_Id
      into v_Page_Id
      from Hpd_Journal_Pages t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and t.Journal_Id = i_Journal_Id;
  
    return v_Page_Id;
  exception
    when No_Data_Found then
      return null;
    when Too_Many_Rows then
      Hpd_Error.Raise_048;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Overtime_Id(i_Journal_Id number) return number is
    v_Overtime_Id number;
  begin
    select q.Overtime_Id
      into v_Overtime_Id
      from Hpd_Journal_Overtimes q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Journal_Id = i_Journal_Id;
  
    return v_Overtime_Id;
  exception
    when No_Data_Found then
      return null;
    when Too_Many_Rows then
      Hpd_Error.Raise_051;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Robot_Id(i_Page_Id number) return number is
    v_Robot_Id number;
  begin
    select t.Robot_Id
      into v_Robot_Id
      from Hpd_Page_Robots t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and t.Page_Id = i_Page_Id;
  
    return v_Robot_Id;
  exception
    when No_Data_Found then
      return Mrf_Next.Robot_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Last_Wage
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hashmap is
    r_Currencies               Mk_Currencies%rowtype;
    v_Trans_Id                 number;
    v_Wage_Id                  number := Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                                i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
    v_Wage                     number;
    v_Matrix                   Matrix_Varchar2;
    v_Access_Hidden_Salary_Job varchar2(1);
    result                     Hashmap := Hashmap();
  begin
    v_Access_Hidden_Salary_Job := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => i_Company_Id,
                                                                                                                   i_Filial_Id  => i_Filial_Id,
                                                                                                                   i_Staff_Id   => i_Staff_Id,
                                                                                                                   i_Period     => i_Period),
                                                                      i_Employee_Id => Href_Util.Get_Employee_Id(i_Company_Id => i_Company_Id,
                                                                                                                 i_Filial_Id  => i_Filial_Id,
                                                                                                                 i_Staff_Id   => i_Staff_Id));
  
    if v_Access_Hidden_Salary_Job = 'N' then
      return result;
    end if;
  
    v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => i_Filial_Id,
                                              i_Staff_Id   => i_Staff_Id,
                                              i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                              i_Period     => i_Period);
  
    v_Wage := Hpd_Util.Get_Closest_Wage(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Staff_Id   => i_Staff_Id,
                                        i_Period     => i_Period);
  
    select Array_Varchar2(q.Oper_Type_Id, w.Name)
      bulk collect
      into v_Matrix
      from Hpd_Trans_Oper_Types q
      join Mpr_Oper_Types w
        on w.Company_Id = i_Company_Id
       and w.Oper_Type_Id = q.Oper_Type_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Trans_Id = v_Trans_Id
     order by w.Name;
  
    Result.Put('oper_types', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Oper_Type_Id,
                           w.Indicator_Id,
                           w.Name,
                           case
                             when q.Indicator_Id = v_Wage_Id then
                              v_Wage
                             else
                              (select w.Indicator_Value
                                 from Hpd_Trans_Indicators w
                                where w.Company_Id = i_Company_Id
                                  and w.Filial_Id = i_Filial_Id
                                  and w.Trans_Id = v_Trans_Id
                                  and w.Indicator_Id = q.Indicator_Id)
                           end)
      bulk collect
      into v_Matrix
      from Hpd_Trans_Oper_Type_Indicators q
      join Href_Indicators w
        on w.Company_Id = i_Company_Id
       and w.Indicator_Id = q.Indicator_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Trans_Id = v_Trans_Id
     order by w.Name;
  
    Result.Put('oper_type_indicators', Fazo.Zip_Matrix(v_Matrix));
  
    r_Currencies := z_Mk_Currencies.Take(i_Company_Id  => i_Company_Id,
                                         i_Currency_Id => Hpd_Util.Get_Closest_Currency_Id(i_Company_Id => i_Company_Id,
                                                                                           i_Filial_Id  => i_Filial_Id,
                                                                                           i_Staff_Id   => i_Staff_Id,
                                                                                           i_Period     => i_Period));
  
    Result.Put_All(z_Mk_Currencies.To_Map(r_Currencies,
                                          z.Currency_Id,
                                          z.Name,
                                          i_Name => 'currency_name'));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Last_Data
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hashmap is
    r_Trans                    Hpd_Transactions%rowtype;
    r_Trans_Robot              Hpd_Trans_Robots%rowtype;
    r_Trans_Rank               Hpd_Trans_Ranks%rowtype;
    r_Trans_Schedule           Hpd_Trans_Schedules%rowtype;
    r_Page_Contract            Hpd_Page_Contracts%rowtype;
    v_Changed_Date             date;
    v_Access_Hidden_Salary_Job varchar2(1);
    v_Org_Unit_Id              number;
    v_Page_Id                  number;
    v_Is_Booked                varchar2(1);
    result                     Hashmap := Hashmap();
  begin
    select max(a.Period)
      into v_Changed_Date
      from Hpd_Agreements a
     where a.Company_Id = i_Company_Id
       and a.Filial_Id = i_Filial_Id
       and a.Staff_Id = i_Staff_Id
       and a.Period <= i_Period;
  
    Result.Put('staff_id', i_Staff_Id);
    Result.Put('change_date', v_Changed_Date);
  
    r_Trans_Robot := Hpd_Util.Closest_Robot(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Staff_Id   => i_Staff_Id,
                                            i_Period     => i_Period);
  
    v_Page_Id := z_Hpd_Transactions.Take(i_Company_Id => r_Trans_Robot.Company_Id, --
                 i_Filial_Id => r_Trans_Robot.Filial_Id, --
                 i_Trans_Id => r_Trans_Robot.Trans_Id).Page_Id;
  
    v_Is_Booked := z_Hpd_Page_Robots.Take(i_Company_Id => r_Trans_Robot.Company_Id, --
                   i_Filial_Id => r_Trans_Robot.Filial_Id, --
                   i_Page_Id => v_Page_Id).Is_Booked;
  
    v_Access_Hidden_Salary_Job := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => r_Trans_Robot.Job_Id,
                                                                      i_Employee_Id => Href_Util.Get_Employee_Id(i_Company_Id => i_Company_Id,
                                                                                                                 i_Filial_Id  => i_Filial_Id,
                                                                                                                 i_Staff_Id   => i_Staff_Id));
  
    Result.Put('robot_id', r_Trans_Robot.Robot_Id);
  
    v_Org_Unit_Id := z_Hrm_Robots.Take(i_Company_Id => i_Company_Id, --
                     i_Filial_Id => i_Filial_Id, --
                     i_Robot_Id => r_Trans_Robot.Robot_Id).Org_Unit_Id;
  
    Result.Put('is_booked', v_Is_Booked);
    Result.Put('is_booked_name', Md_Util.Decode(v_Is_Booked, 'Y', Ui.t_Yes, 'N', Ui.t_No));
    Result.Put('org_unit_name',
               z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, --
               i_Filial_Id => i_Filial_Id, --
               i_Division_Id => v_Org_Unit_Id).Name);
    Result.Put('robot_name',
               z_Mrf_Robots.Take(i_Company_Id => i_Company_Id, --
               i_Filial_Id => i_Filial_Id, --
               i_Robot_Id => r_Trans_Robot.Robot_Id).Name);
    Result.Put('division_id', r_Trans_Robot.Division_Id);
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, --
               i_Filial_Id => i_Filial_Id, --
               i_Division_Id => r_Trans_Robot.Division_Id).Name);
    Result.Put('job_id', r_Trans_Robot.Job_Id);
    Result.Put('job_name',
               z_Mhr_Jobs.Take(i_Company_Id => i_Company_Id, --
               i_Filial_Id => i_Filial_Id, --
               i_Job_Id => r_Trans_Robot.Job_Id).Name);
  
    r_Trans_Rank := Hpd_Util.Closest_Rank(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Staff_Id   => i_Staff_Id,
                                          i_Period     => i_Period);
  
    Result.Put('rank_id', r_Trans_Rank.Rank_Id);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => i_Company_Id, --
               i_Filial_Id => i_Filial_Id, --
               i_Rank_Id => r_Trans_Rank.Rank_Id).Name);
  
    r_Trans_Schedule := Hpd_Util.Closest_Schedule(i_Company_Id => i_Company_Id,
                                                  i_Filial_Id  => i_Filial_Id,
                                                  i_Staff_Id   => i_Staff_Id,
                                                  i_Period     => i_Period);
  
    Result.Put('schedule_id', r_Trans_Schedule.Schedule_Id);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => i_Company_Id, --
               i_Filial_Id => i_Filial_Id, --
               i_Schedule_Id => r_Trans_Schedule.Schedule_Id).Name);
    Result.Put('vacation_days_limit',
               Hpd_Util.Get_Closest_Vacation_Days_Limit(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Staff_Id   => i_Staff_Id,
                                                        i_Period     => i_Period));
    Result.Put('employment_type', r_Trans_Robot.Employment_Type);
    Result.Put('employment_type_name', Hpd_Util.t_Employment_Type(r_Trans_Robot.Employment_Type));
    Result.Put_All(Uit_Href.Get_Fte(r_Trans_Robot.Fte));
  
    r_Trans         := z_Hpd_Transactions.Take(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Trans_Id   => r_Trans_Robot.Trans_Id);
    r_Page_Contract := z_Hpd_Page_Contracts.Take(i_Company_Id => i_Company_Id,
                                                 i_Filial_Id  => i_Filial_Id,
                                                 i_Page_Id    => r_Trans.Page_Id);
  
    Result.Put_All(z_Hpd_Page_Contracts.To_Map(r_Page_Contract,
                                               z.Contract_Number,
                                               z.Contract_Date,
                                               z.Fixed_Term,
                                               z.Expiry_Date,
                                               z.Fixed_Term_Base_Id,
                                               z.Concluding_Term,
                                               z.Hiring_Conditions,
                                               z.Other_Conditions,
                                               z.Workplace_Equipment,
                                               z.Representative_Basis));
    Result.Put('fixed_term_base_name',
               z_Href_Fixed_Term_Bases.Take(i_Company_Id => i_Company_Id, --
               i_Fixed_Term_Base_Id => r_Page_Contract.Fixed_Term_Base_Id).Name);
    Result.Put('access_to_hidden_salary_job', v_Access_Hidden_Salary_Job);
  
    if v_Access_Hidden_Salary_Job = 'Y' then
      Result.Put('contractual_wage',
                 z_Hrm_Robots.Take(i_Company_Id => i_Company_Id, --
                 i_Filial_Id => i_Filial_Id, --
                 i_Robot_Id => r_Trans_Robot.Robot_Id).Contractual_Wage);
      Result.Put('wage_scale_id', r_Trans_Robot.Wage_Scale_Id);
      Result.Put('wage_scale_name',
                 z_Hrm_Wage_Scales.Take(i_Company_Id => i_Company_Id, --
                 i_Filial_Id => i_Filial_Id, --
                 i_Wage_Scale_Id => r_Trans_Robot.Wage_Scale_Id).Name);
    
      Result.Put_All(Get_Last_Wage(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Staff_Id   => i_Staff_Id,
                                   i_Period     => i_Period));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Grant_Has
  (
    i_Grant     varchar2,
    i_Filial_Id number := Ui.Filial_Id
  ) return varchar2 is
  begin
    if Md_Util.Grant_Has(i_Company_Id   => Ui.Company_Id,
                         i_Project_Code => Verifix.Project_Code,
                         i_Filial_Id    => i_Filial_Id,
                         i_User_Id      => Ui.User_Id,
                         i_Form         => Hpd_Pref.c_Form_Application_List,
                         i_Action_Key   => i_Grant) then
      return 'Y';
    end if;
  
    return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Assert_Grant
  (
    i_Grant     varchar2,
    i_Filial_Id number := Ui.Filial_Id
  ) is
  begin
    if Application_Grant_Has(i_Grant => i_Grant, i_Filial_Id => i_Filial_Id) <> 'Y' then
      b.Raise_Unauthorized;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Wage_With_Access
  (
    i_Staff_Id number,
    i_Period   date,
    i_User_Id  number -- used for self check in hidden salary, self check currently removed for Makro company
  ) return number is
  begin
    if Uit_Hrm.Has_Access_To_Hidden_Salary_Job(Hpd_Util.Get_Closest_Job_Id(i_Company_Id => Ui.Company_Id,
                                                                           i_Filial_Id  => Ui.Filial_Id,
                                                                           i_Staff_Id   => i_Staff_Id,
                                                                           i_Period     => i_Period)) then
      return Hpd_Util.Get_Closest_Wage(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Staff_Id   => i_Staff_Id,
                                       i_Period     => i_Period);
    else
      return - 1;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Las_Hiring_Journal_Id(i_Staff_Id number) return number is
    v_Journal_Type_Ids Array_Number;
    result             number;
  begin
    v_Journal_Type_Ids := Array_Number(Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring),
                                       Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple));
  
    select q.Journal_Id
      into result
      from Hpd_Journals q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Posted = 'Y'
       and q.Journal_Type_Id member of v_Journal_Type_Ids
       and exists (select 1
              from Hpd_Journal_Pages w
             where w.Company_Id = Ui.Company_Id
               and w.Filial_Id = Ui.Filial_Id
               and w.Journal_Id = q.Journal_Id
               and w.Staff_Id = i_Staff_Id);
  
    return result;
  exception
    when No_Data_Found then
      Hpd_Error.Raise_073(i_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fill_Hiring_Data
  (
    i_Journal_Id  number,
    i_Staff_Id    number,
    i_Hiring_Date date,
    i_Division_Id number,
    i_Job_Id      number,
    i_Schedule_Id number
  ) return Hpd_Pref.Hiring_Journal_Rt is
    v_Robot_Id      number;
    v_Division_Id   number;
    v_Job_Id        number;
    v_Schedule_Id   number;
    v_Hiring_Date   date;
    v_Indicator_Ids Array_Number;
  
    p_Hiring    Hpd_Pref.Hiring_Journal_Rt;
    p_Robot     Hpd_Pref.Robot_Rt;
    p_Indicator Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
    p_Oper_Type Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    p_Contract  Hpd_Pref.Contract_Rt;
  
    r_Journal        Hpd_Journals%rowtype;
    r_Staff          Href_Staffs%rowtype;
    r_Hiring         Hpd_Hirings%rowtype;
    r_Vacation_Limit Hpd_Page_Vacation_Limits%rowtype;
    r_Page_Contract  Hpd_Page_Contracts%rowtype;
    r_Page_Robot     Hpd_Page_Robots%rowtype;
    r_Page_Schedule  Hpd_Page_Schedules%rowtype;
    r_Robot          Hrm_Robots%rowtype;
    r_Mrf_Robot      Mrf_Robots%rowtype;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => i_Journal_Id);
  
    -- fill new hiring 
    Hpd_Util.Hiring_Journal_New(o_Journal         => p_Hiring,
                                i_Company_Id      => r_Journal.Company_Id,
                                i_Filial_Id       => r_Journal.Filial_Id,
                                i_Journal_Id      => r_Journal.Journal_Id,
                                i_Journal_Type_Id => r_Journal.Journal_Type_Id,
                                i_Journal_Number  => r_Journal.Journal_Number,
                                i_Journal_Date    => r_Journal.Journal_Date,
                                i_Journal_Name    => r_Journal.Journal_Name);
  
    for Page in (select *
                   from Hpd_Journal_Pages q
                  where q.Company_Id = r_Journal.Company_Id
                    and q.Filial_Id = r_Journal.Filial_Id
                    and q.Journal_Id = r_Journal.Journal_Id)
    loop
      -- schedule
      r_Page_Schedule := z_Hpd_Page_Schedules.Take(i_Company_Id => Page.Company_Id,
                                                   i_Filial_Id  => Page.Filial_Id,
                                                   i_Page_Id    => Page.Page_Id);
    
      -- hiring 
      r_Hiring := z_Hpd_Hirings.Take(i_Company_Id => Page.Company_Id,
                                     i_Filial_Id  => Page.Filial_Id,
                                     i_Page_Id    => Page.Page_Id);
    
      -- staff
      r_Staff := z_Href_Staffs.Take(i_Company_Id => Page.Company_Id,
                                    i_Filial_Id  => Page.Filial_Id,
                                    i_Staff_Id   => Page.Staff_Id);
    
      -- vacation day limit 
      r_Vacation_Limit := z_Hpd_Page_Vacation_Limits.Take(i_Company_Id => Page.Company_Id,
                                                          i_Filial_Id  => Page.Filial_Id,
                                                          i_Page_Id    => Page.Page_Id);
    
      -- contract 
      r_Page_Contract := z_Hpd_Page_Contracts.Take(i_Company_Id => Page.Company_Id,
                                                   i_Filial_Id  => Page.Filial_Id,
                                                   i_Page_Id    => Page.Page_Id);
    
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
    
      -- oper type and indicators 
      p_Indicator := Href_Pref.Indicator_Nt();
    
      for r in (select *
                  from Hpd_Page_Indicators q
                 where q.Company_Id = Page.Company_Id
                   and q.Filial_Id = Page.Filial_Id
                   and q.Page_Id = Page.Page_Id)
      loop
        Hpd_Util.Indicator_Add(p_Indicator       => p_Indicator,
                               i_Indicator_Id    => r.Indicator_Id,
                               i_Indicator_Value => r.Indicator_Value);
      end loop;
    
      p_Oper_Type := Href_Pref.Oper_Type_Nt();
    
      for r in (select *
                  from Hpd_Page_Oper_Types q
                 where q.Company_Id = Page.Company_Id
                   and q.Filial_Id = Page.Filial_Id
                   and q.Page_Id = Page.Page_Id)
      loop
        select w.Indicator_Id
          bulk collect
          into v_Indicator_Ids
          from Hpd_Oper_Type_Indicators w
         where w.Company_Id = r.Company_Id
           and w.Filial_Id = r.Filial_Id
           and w.Page_Id = r.Page_Id
           and w.Oper_Type_Id = r.Oper_Type_Id;
      
        Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Type,
                               i_Oper_Type_Id  => r.Oper_Type_Id,
                               i_Indicator_Ids => v_Indicator_Ids);
      end loop;
    
      -- robot
      r_Page_Robot := z_Hpd_Page_Robots.Load(i_Company_Id => Page.Company_Id,
                                             i_Filial_Id  => Page.Filial_Id,
                                             i_Page_Id    => Page.Page_Id);
    
      r_Robot := z_Hrm_Robots.Load(i_Company_Id => r_Page_Robot.Company_Id,
                                   i_Filial_Id  => r_Page_Robot.Filial_Id,
                                   i_Robot_Id   => r_Page_Robot.Robot_Id);
    
      r_Mrf_Robot := z_Mrf_Robots.Load(i_Company_Id => r_Page_Robot.Company_Id,
                                       i_Filial_Id  => r_Page_Robot.Filial_Id,
                                       i_Robot_Id   => r_Page_Robot.Robot_Id);
    
      if Page.Staff_Id = i_Staff_Id then
        v_Schedule_Id := i_Schedule_Id;
        v_Hiring_Date := i_Hiring_Date;
        v_Division_Id := i_Division_Id;
        v_Job_Id      := i_Job_Id;
        v_Robot_Id    := r_Mrf_Robot.Robot_Id;
      else
        v_Schedule_Id := r_Page_Schedule.Schedule_Id;
        v_Hiring_Date := r_Hiring.Hiring_Date;
        v_Robot_Id    := r_Mrf_Robot.Robot_Id;
        v_Division_Id := r_Mrf_Robot.Division_Id;
        v_Job_Id      := r_Mrf_Robot.Job_Id;
      end if;
    
      Hpd_Util.Robot_New(o_Robot           => p_Robot,
                         i_Robot_Id        => v_Robot_Id,
                         i_Division_Id     => v_Division_Id,
                         i_Job_Id          => v_Job_Id,
                         i_Rank_Id         => r_Page_Robot.Rank_Id,
                         i_Wage_Scale_Id   => r_Robot.Wage_Scale_Id,
                         i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                         i_Fte_Id          => r_Page_Robot.Fte_Id,
                         i_Fte             => r_Page_Robot.Fte);
    
      Hpd_Util.Journal_Add_Hiring(p_Journal              => p_Hiring,
                                  i_Page_Id              => Page.Page_Id,
                                  i_Employee_Id          => Page.Employee_Id,
                                  i_Staff_Number         => r_Staff.Staff_Number,
                                  i_Hiring_Date          => v_Hiring_Date,
                                  i_Trial_Period         => r_Hiring.Trial_Period,
                                  i_Employment_Source_Id => r_Hiring.Employment_Source_Id,
                                  i_Schedule_Id          => v_Schedule_Id,
                                  i_Vacation_Days_Limit  => r_Vacation_Limit.Days_Limit,
                                  i_Is_Booked            => 'N',
                                  i_Robot                => p_Robot,
                                  i_Contract             => p_Contract,
                                  i_Indicators           => p_Indicator,
                                  i_Oper_Types           => p_Oper_Type);
    end loop;
  
    return p_Hiring;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Overtime_Blocked_Staffs
  (
    i_Month_Begin   date,
    i_Month_End     date,
    i_Min_Free_Time number,
    i_Max_Free_Time number
  ) return Array_Number is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Free_Id    number;
    v_Staff_Ids  Array_Number;
  begin
    v_Free_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
  
    select q.Staff_Id
      bulk collect
      into v_Staff_Ids
      from Href_Staffs q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.State = 'A'
       and (q.Employee_Id = Ui.User_Id or -- 
           not exists (select 1
                         from Htt_Timesheets t
                        where t.Company_Id = q.Company_Id
                          and t.Filial_Id = q.Filial_Id
                          and t.Staff_Id = q.Staff_Id
                          and t.Timesheet_Date between i_Month_Begin and i_Month_End
                          and Nvl((select sum(Tf.Fact_Value)
                                    from Htt_Timesheet_Facts Tf
                                   where Tf.Company_Id = t.Company_Id
                                     and Tf.Filial_Id = t.Filial_Id
                                     and Tf.Timesheet_Id = t.Timesheet_Id
                                     and Tf.Time_Kind_Id in
                                         (select Tk.Time_Kind_Id
                                            from Htt_Time_Kinds Tk
                                           where Tk.Company_Id = v_Company_Id
                                             and Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) = v_Free_Id)),
                                  0) between i_Min_Free_Time and i_Max_Free_Time
                          and not exists (select 1
                                 from Hpd_Overtime_Days d
                                 join Hpd_Journal_Overtimes Jo
                                   on Jo.Company_Id = d.Company_Id
                                  and Jo.Filial_Id = d.Filial_Id
                                  and Jo.Overtime_Id = d.Overtime_Id
                                 join Hpd_Journals j
                                   on j.Company_Id = Jo.Company_Id
                                  and j.Filial_Id = Jo.Filial_Id
                                  and j.Journal_Id = Jo.Journal_Id
                                where t.Company_Id = d.Company_Id
                                  and t.Filial_Id = d.Filial_Id
                                  and t.Staff_Id = d.Staff_Id
                                  and t.Timesheet_Date = d.Overtime_Date
                                  and j.Posted = 'Y')));
  
    return v_Staff_Ids;
  end;

  ----------------------------------------------------------------------------------------------------           
  Procedure Check_Access_To_Edit_Journal
  (
    i_Document_Status varchar2,
    i_Posted          varchar2,
    i_Journal_Number  varchar2
  ) is
  begin
    if i_Document_Status <> Mdf_Pref.c_Ds_Draft or i_Posted = 'Y' then
      Hpd_Error.Raise_090(i_Document_Status => Mdf_Pref.t_Document_Status(i_Document_Status),
                          i_Journal_Number  => i_Journal_Number);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------           
  Function Access_To_Journal_Sign_Document(i_Journal_Id number) return boolean is
    v_Dummy number;
  begin
    select 1
      into v_Dummy
      from Hpd_Journals q
      join Mdf_Sign_Document_Persons w
        on w.Company_Id = q.Company_Id
       and w.Document_Id = q.Sign_Document_Id
       and w.Person_Id = Ui.User_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Journal_Id = i_Journal_Id
       and Rownum = 1;
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

end Uit_Hpd;
/
