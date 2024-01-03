create or replace package Ui_Vhr106 is
  ----------------------------------------------------------------------------------------------------
  Function Definitions return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr106;
/
create or replace package body Ui_Vhr106 is
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
    return b.Translate('UI-VHR106:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Definitions return Arraylist is
    result Arraylist := Arraylist;
  
    --------------------------------------------------
    Procedure Put
    (
      p_List       in out nocopy Arraylist,
      i_Key        varchar2,
      i_Definition varchar2
    ) is
    begin
      p_List.Push(Fazo.Zip_Map('key', i_Key, 'definition', i_Definition));
    end;
  begin
    Put(result, 'filial_name', t('filial name'));
    Put(result, 'director_name', t('director name'));
    Put(result, 'director_job_name', t('director job name'));
    Put(result, 'journal_number', t('journal number'));
    Put(result, 'journal_date', t('journal date'));
    Put(result, 'journal_name', t('journal name'));
    Put(result, 'hiring_date', t('hiring date'));
    Put(result, 'employee_name', t('employee name'));
    Put(result, 'staff_number', t('staff number'));
    Put(result, 'division_name', t('division name'));
    Put(result, 'robot_name', t('robot name'));
    Put(result, 'job_name', t('job name'));
    Put(result, 'schedule_name', t('schedule name'));
    Put(result, 'employment_type_name', t('employment type name'));
    Put(result, 'trial_period_name', t('trial period name'));
    Put(result, 'trial_period_days', t('trial period days'));
    Put(result, 'trial_period_months', t('trial period months'));
    Put(result, 'labor_function_name', t('labor function name'));
    Put(result, 'rank_name', t('rank name'));
    Put(result, 'quantity', t('quantity'));
    Put(result, 'wage_amount', t('wage amount'));
    Put(result, 'working_day', t('working day'));
    Put(result, 'working_week', t('working week'));
    Put(result, 'contract_number', t('contract number'));
    Put(result, 'contract_date', t('contract date'));
    Put(result, 'expiry_date', t('expiry date'));
    Put(result, 'fixed_term_base_name', t('fixed term base name'));
    Put(result, 'concluding_term_name', t('concluding term name'));
    Put(result, 'hiring_conditions', t('hiring conditions'));
    Put(result, 'other_conditions', t('other conditions'));
    Put(result, 'workplace_equipment', t('workplace equipment'));
    Put(result, 'representative_basis', t('representative basis'));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Report(p Hashmap) return Gmap is
    r_Journal      Hpd_Journals%rowtype;
    r_Legal_Person Mr_Legal_Persons%rowtype;
    r_Staff        Href_Staffs%rowtype;
    v_Page_Id      number;
    v_Indicator_Id number;
    v_Wage_Amount  number;
    v_Working_Day  number;
    v_Working_Week number;
    result         Gmap := Gmap;
    --------------------------------------------------
    Procedure Put
    (
      i_Key varchar2,
      i_Val varchar2
    ) is
    begin
      Result.Put(i_Key, Nvl(i_Val, ''));
    end;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if r_Journal.Posted <> 'Y' or
       r_Journal.Journal_Type_Id <>
       Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring) then
      b.Raise_Not_Implemented;
    end if;
  
    Put('filial_name',
        z_Md_Filials.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Name);
  
    r_Legal_Person := z_Mr_Legal_Persons.Load(i_Company_Id => r_Journal.Company_Id,
                                              i_Person_Id  => r_Journal.Filial_Id);
  
    r_Staff := z_Href_Staffs.Take(i_Company_Id => r_Journal.Company_Id,
                                  i_Filial_Id  => r_Journal.Filial_Id,
                                  i_Staff_Id   => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => r_Journal.Company_Id,
                                                                                 i_Filial_Id   => r_Journal.Filial_Id,
                                                                                 i_Employee_Id => r_Legal_Person.Primary_Person_Id,
                                                                                 i_Date        => Trunc(sysdate)));
  
    Put('director_name',
        z_Mr_Natural_Persons.Take(i_Company_Id => r_Journal.Company_Id, --
        i_Person_Id => r_Legal_Person.Primary_Person_Id).Name);
    Put('director_job_name',
        z_Mhr_Jobs.Take(i_Company_Id => r_Journal.Company_Id, --
        i_Filial_Id => r_Journal.Filial_Id, --
        i_Job_Id => r_Staff.Job_Id).Name);
  
    Put('journal_number', r_Journal.Journal_Number);
    Put('journal_date', r_Journal.Journal_Date);
    Put('journal_name', r_Journal.Journal_Name);
  
    v_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => r_Journal.Company_Id,
                                             i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
  
    select q.Page_Id
      into v_Page_Id
      from Hpd_Journal_Pages q
     where q.Company_Id = r_Journal.Company_Id
       and q.Filial_Id = r_Journal.Filial_Id
       and q.Journal_Id = r_Journal.Journal_Id;
  
    for r in (select w.Hiring_Date,
                     (select k.Name
                        from Mr_Natural_Persons k
                       where k.Company_Id = q.Company_Id
                         and k.Person_Id = q.Employee_Id) Employee_Name,
                     (select k.Staff_Number
                        from Href_Staffs k
                       where k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Staff_Id = q.Staff_Id) Staff_Number,
                     (select k.Name
                        from Mhr_Divisions k
                       where k.Company_Id = l.Company_Id
                         and k.Filial_Id = l.Filial_Id
                         and k.Division_Id = l.Division_Id) Division_Name,
                     l.Name Robot_Name,
                     (select k.Name
                        from Mhr_Jobs k
                       where k.Company_Id = l.Company_Id
                         and k.Filial_Id = l.Filial_Id
                         and k.Job_Id = l.Job_Id) Job_Name,
                     s.Schedule_Id,
                     (select k.Name
                        from Htt_Schedules k
                       where k.Company_Id = s.Company_Id
                         and k.Filial_Id = s.Filial_Id
                         and k.Schedule_Id = s.Schedule_Id) Schedule_Name,
                     Hpd_Util.t_Employment_Type(m.Employment_Type) Employment_Type_Name,
                     Nvl2(Nullif(w.Trial_Period, 0), 'Y', 'N') Trial_Period,
                     Nullif(w.Trial_Period, 0) Trial_Period_Days,
                     (select k.Name
                        from Href_Labor_Functions k
                       where k.Company_Id = Hr.Company_Id
                         and k.Labor_Function_Id = Hr.Labor_Function_Id) Labor_Function_Name,
                     (select k.Name
                        from Mhr_Ranks k
                       where k.Company_Id = m.Company_Id
                         and k.Filial_Id = m.Filial_Id
                         and k.Rank_Id = m.Rank_Id) Rank_Name,
                     m.Fte,
                     c.Contract_Number,
                     c.Contract_Date,
                     c.Expiry_Date,
                     (select k.Name
                        from Href_Fixed_Term_Bases k
                       where k.Company_Id = c.Company_Id
                         and k.Fixed_Term_Base_Id = c.Fixed_Term_Base_Id) Fixed_Term_Base_Name,
                     c.Concluding_Term,
                     c.Hiring_Conditions,
                     c.Other_Conditions,
                     c.Workplace_Equipment,
                     c.Representative_Basis
                from Hpd_Journal_Pages q
                join Hpd_Hirings w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Page_Id = q.Page_Id
                left join Hpd_Page_Robots m
                  on m.Company_Id = q.Company_Id
                 and m.Filial_Id = q.Filial_Id
                 and m.Page_Id = q.Page_Id
                left join Mrf_Robots l
                  on l.Company_Id = m.Company_Id
                 and l.Filial_Id = m.Filial_Id
                 and l.Robot_Id = m.Robot_Id
                left join Hrm_Robots Hr
                  on Hr.Company_Id = l.Company_Id
                 and Hr.Filial_Id = l.Filial_Id
                 and Hr.Robot_Id = l.Robot_Id
                left join Hpd_Page_Schedules s
                  on s.Company_Id = q.Company_Id
                 and s.Filial_Id = q.Filial_Id
                 and s.Page_Id = q.Page_Id
                left join Hpd_Page_Contracts c
                  on c.Company_Id = q.Company_Id
                 and c.Filial_Id = q.Filial_Id
                 and c.Page_Id = q.Page_Id
               where q.Company_Id = r_Journal.Company_Id
                 and q.Filial_Id = r_Journal.Filial_Id
                 and q.Journal_Id = r_Journal.Journal_Id
                 and q.Page_Id = v_Page_Id
                 and Rownum = 1)
    loop
      Put('hiring_date', r.Hiring_Date);
      Put('employee_name', r.Employee_Name);
      Put('staff_number', r.Staff_Number);
      Put('division_name', r.Division_Name);
      Put('robot_name', r.Robot_Name);
      Put('job_name', r.Job_Name);
      Put('schedule_name', r.Schedule_Name);
      Put('employment_type_name', r.Employment_Type_Name);
      Put('trial_period_name', Hpd_Util.t_Trial_Period(r.Trial_Period));
      Put('trial_period_days', r.Trial_Period_Days);
      Put('trial_period_months', Round(r.Trial_Period_Days / 30, 1));
      Put('labor_function_name', r.Labor_Function_Name);
      Put('rank_name', r.Rank_Name);
      Put('quantity', r.Fte);
    
      v_Wage_Amount := z_Hpd_Page_Indicators.Take(i_Company_Id => r_Journal.Company_Id, --
                       i_Filial_Id => r_Journal.Filial_Id, --
                       i_Page_Id => v_Page_Id, --
                       i_Indicator_Id => v_Indicator_Id).Indicator_Value;
    
      Put('wage_amount', Nullif(v_Wage_Amount, 0));
    
      select max(q.Plan_Time), sum(q.Plan_Time)
        into v_Working_Day, v_Working_Week
        from Htt_Schedule_Days q
       where q.Company_Id = r_Journal.Company_Id
         and q.Filial_Id = r_Journal.Filial_Id
         and q.Schedule_Id = r.Schedule_Id
         and q.Schedule_Date between Trunc(r.Hiring_Date, 'iw') and Trunc(r.Hiring_Date, 'iw') + 6;
    
      Put('working_day', Round(Nullif(v_Working_Day, 0) / 60, 1));
      Put('working_week', Round(Nullif(v_Working_Week, 0) / 60, 1));
    
      Put('contract_number', r.Contract_Number);
      Put('contract_date', r.Contract_Date);
      Put('expiry_date', r.Expiry_Date);
      Put('fixed_term_base_name', r.Fixed_Term_Base_Name);
      Put('concluding_term', r.Concluding_Term);
      Put('hiring_conditions', r.Hiring_Conditions);
      Put('other_conditions', r.Other_Conditions);
      Put('workplace_equipment', r.Workplace_Equipment);
      Put('representative_basis', r.Representative_Basis);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
  begin
    Uit_Ker.Run_Report(i_Template_Id => p.r_Number('template_id'), --
                       i_Data        => Report(p));
  end;

end Ui_Vhr106;
/
