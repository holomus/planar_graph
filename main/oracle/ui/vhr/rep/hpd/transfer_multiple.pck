create or replace package Ui_Vhr111 is
  ----------------------------------------------------------------------------------------------------
  Function Definitions return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr111;
/
create or replace package body Ui_Vhr111 is
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
  
    return b.Translate('UI-VHR111:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Definitions return Arraylist is
    v_Page_List Arraylist := Arraylist;
    result      Arraylist := Arraylist;
  
    --------------------------------------------------
    Procedure Put
    (
      p_List       in out nocopy Arraylist,
      i_Key        varchar2,
      i_Definition varchar2,
      i_Items      Arraylist := null
    ) is
      v_Map Hashmap;
    begin
      v_Map := Fazo.Zip_Map('key', i_Key, 'definition', i_Definition);
    
      if i_Items is not null then
        v_Map.Put('items', i_Items);
      end if;
    
      p_List.Push(v_Map);
    end;
  begin
    Put(v_Page_List, 'transfer_kind_name', t('transfer kind name'));
    Put(v_Page_List, 'transfer_begin', t('transfer begin'));
    Put(v_Page_List, 'transfer_end', t('transfer end'));
    Put(v_Page_List, 'transfer_reason', t('transfer reason'));
    Put(v_Page_List, 'transfer_base', t('transfer base'));
    Put(v_Page_List, 'employee_name', t('employee name'));
    Put(v_Page_List, 'old_staff_number', t('old staff number'));
    Put(v_Page_List, 'staff_number', t('staff number'));
    Put(v_Page_List, 'old_division_name', t('old division name'));
    Put(v_Page_List, 'division_name', t('division name'));
    Put(v_Page_List, 'old_robot_name', t('old_robot name'));
    Put(v_Page_List, 'robot_name', t('robot name'));
    Put(v_Page_List, 'old_job_name', t('old job name'));
    Put(v_Page_List, 'job_name', t('job name'));
    Put(v_Page_List, 'old_schedule_name', t('old schedule name'));
    Put(v_Page_List, 'schedule_name', t('schedule name'));
    Put(v_Page_List, 'employment_type', t('employment type name'));
    Put(v_Page_List, 'labor_function_name', t('labor function name'));
    Put(v_Page_List, 'old_rank_name', t('old rank name'));
    Put(v_Page_List, 'rank_name', t('rank name'));
    Put(v_Page_List, 'quantity', t('quantity'));
    Put(v_Page_List, 'old_wage_amount', t('old wage amount'));
    Put(v_Page_List, 'wage_amount', t('wage amount'));
    Put(v_Page_List, 'working_day', t('working day'));
    Put(v_Page_List, 'old_working_day', t('old working day'));
    Put(v_Page_List, 'working_week', t('working week'));
    Put(v_Page_List, 'old_working_week', t('old working week'));
    Put(v_Page_List, 'contract_number', t('contract number'));
    Put(v_Page_List, 'contract_date', t('contract date'));
    Put(v_Page_List, 'fixed_term', t('fixed term'));
    Put(v_Page_List, 'contract_term', t('contract term'));
    Put(v_Page_List, 'expiry_date', t('expiry date'));
    Put(v_Page_List, 'fixed_term_base_name', t('fixed term base name'));
    Put(v_Page_List, 'concluding_term', t('concluding term'));
    Put(v_Page_List, 'hiring_conditions', t('hiring conditions'));
    Put(v_Page_List, 'other_conditions', t('other conditions'));
    Put(v_Page_List, 'workplace_equipment', t('workplace equipment'));
    Put(v_Page_List, 'representative_basis', t('representative basis'));
  
    Put(result, 'filial_name', t('filial name'));
    Put(result, 'director_name', t('director name'));
    Put(result, 'director_job_name', t('director job name'));
    Put(result, 'journal_number', t('journal number'));
    Put(result, 'journal_date', t('journal date'));
    Put(result, 'journal_name', t('journal name'));
    Put(result, 'transfers', t('transfers'), v_Page_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Report(p Hashmap) return Gmap is
    r_Journal          Hpd_Journals%rowtype;
    r_Legal_Person     Mr_Legal_Persons%rowtype;
    r_Staff            Href_Staffs%rowtype;
    r_Closest_Schedule Hpd_Trans_Schedules%rowtype;
    r_Closest_Rank     Hpd_Trans_Ranks%rowtype;
    r_Closest_Robot    Hpd_Trans_Robots%rowtype;
    r_Closest_Trans    Hpd_Transactions%rowtype;
    r_Robot            Mrf_Robots%rowtype;
    v_Indicator_Id     number;
    v_Trans_Id         number;
    v_Wage_Amount      number;
    v_Working_Day      number;
    v_Working_Week     number;
    v_Page_Map         Gmap;
    v_Page_List        Glist := Glist;
    result             Gmap := Gmap;
    --------------------------------------------------
    Procedure Put
    (
      p_Map in out Gmap,
      i_Key varchar2,
      i_Val varchar2
    ) is
    begin
      p_Map.Put(i_Key, Nvl(i_Val, ''));
    end;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if r_Journal.Posted <> 'Y' or
       r_Journal.Journal_Type_Id <>
       Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple) then
      b.Raise_Not_Implemented;
    end if;
  
    Put(result,
        'filial_name',
        z_Md_Filials.Load(i_Company_Id => r_Journal.Company_Id, i_Filial_Id => r_Journal.Filial_Id).Name);
    Put(result, 'journal_number', r_Journal.Journal_Number);
    Put(result, 'journal_date', r_Journal.Journal_Date);
    Put(result, 'journal_name', r_Journal.Journal_Name);
  
    r_Legal_Person := z_Mr_Legal_Persons.Load(i_Company_Id => r_Journal.Company_Id,
                                              i_Person_Id  => r_Journal.Filial_Id);
    r_Staff        := z_Href_Staffs.Take(i_Company_Id => r_Journal.Company_Id,
                                         i_Filial_Id  => r_Journal.Filial_Id,
                                         i_Staff_Id   => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => r_Journal.Company_Id,
                                                                                        i_Filial_Id   => r_Journal.Filial_Id,
                                                                                        i_Employee_Id => r_Legal_Person.Primary_Person_Id,
                                                                                        i_Date        => Trunc(sysdate)));
  
    Put(result,
        'director_name',
        z_Mr_Natural_Persons.Take(i_Company_Id => r_Journal.Company_Id, --
        i_Person_Id => r_Legal_Person.Primary_Person_Id).Name);
    Put(result,
        'director_job_name',
        z_Mhr_Jobs.Take(i_Company_Id => r_Journal.Company_Id, --
        i_Filial_Id => r_Journal.Filial_Id, --
        i_Job_Id => r_Staff.Job_Id).Name);
  
    v_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => r_Journal.Company_Id,
                                             i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
  
    for r in (select w.Transfer_Begin,
                     w.Transfer_End,
                     w.Transfer_Reason,
                     w.Transfer_Base,
                     (select k.Name
                        from Mr_Natural_Persons k
                       where k.Company_Id = q.Company_Id
                         and k.Person_Id = q.Employee_Id) Employee_Name,
                     q.Staff_Id,
                     q.Page_Id,
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
                     n.Schedule_Id,
                     (select k.Name
                        from Htt_Schedules k
                       where k.Company_Id = n.Company_Id
                         and k.Filial_Id = n.Filial_Id
                         and k.Schedule_Id = n.Schedule_Id) Schedule_Name,
                     Hpd_Util.t_Employment_Type(m.Employment_Type) Employment_Type,
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
                     r.Contract_Number,
                     r.Contract_Date,
                     r.Expiry_Date,
                     (select k.Name
                        from Href_Fixed_Term_Bases k
                       where k.Company_Id = r.Company_Id
                         and k.Fixed_Term_Base_Id = r.Fixed_Term_Base_Id) Fixed_Term_Base_Name,
                     r.Concluding_Term,
                     r.Hiring_Conditions,
                     r.Other_Conditions,
                     r.Workplace_Equipment,
                     r.Representative_Basis
                from Hpd_Journal_Pages q
                join Hpd_Transfers w
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
                left join Hpd_Page_Schedules n
                  on n.Company_Id = q.Company_Id
                 and n.Filial_Id = q.Filial_Id
                 and n.Page_Id = q.Page_Id
                left join Hpd_Page_Contracts r
                  on r.Company_Id = q.Company_Id
                 and r.Filial_Id = q.Filial_Id
                 and r.Page_Id = q.Page_Id
               where q.Company_Id = r_Journal.Company_Id
                 and q.Filial_Id = r_Journal.Filial_Id
                 and q.Journal_Id = r_Journal.Journal_Id)
    loop
      v_Page_Map := Gmap;
    
      Put(v_Page_Map,
          'transfer_kind_name',
          Hpd_Util.t_Transfer_Kind(Hpd_Util.Transfer_Kind(r.Transfer_End)));
      Put(v_Page_Map, 'transfer_begin', r.Transfer_Begin);
      Put(v_Page_Map, 'transfer_end', r.Transfer_End);
      Put(v_Page_Map, 'transfer_reason', r.Transfer_Reason);
      Put(v_Page_Map, 'transfer_base', r.Transfer_Base);
      Put(v_Page_Map, 'employee_name', r.Employee_Name);
      Put(v_Page_Map, 'staff_number', r.Staff_Number);
      Put(v_Page_Map, 'division_name', r.Division_Name);
      Put(v_Page_Map, 'robot_name', r.Robot_Name);
      Put(v_Page_Map, 'job_name', r.Job_Name);
      Put(v_Page_Map, 'schedule_name', r.Schedule_Name);
      Put(v_Page_Map, 'employment_type', r.Employment_Type);
      Put(v_Page_Map, 'labor_function_name', r.Labor_Function_Name);
      Put(v_Page_Map, 'rank_name', r.Rank_Name);
      Put(v_Page_Map, 'quantity', r.Fte);
      Put(v_Page_Map, 'contract_number', r.Contract_Number);
      Put(v_Page_Map, 'contract_date', r.Contract_Date);
      Put(v_Page_Map, 'expiry_date', r.Expiry_Date);
      Put(v_Page_Map, 'fixed_term_base_name', r.Fixed_Term_Base_Name);
      Put(v_Page_Map, 'concluding_term', r.Concluding_Term);
      Put(v_Page_Map, 'hiring_conditions', r.Hiring_Conditions);
      Put(v_Page_Map, 'other_conditions', r.Other_Conditions);
      Put(v_Page_Map, 'workplace_equipment', r.Workplace_Equipment);
      Put(v_Page_Map, 'representative_basis', r.Representative_Basis);
    
      v_Wage_Amount := z_Hpd_Page_Indicators.Take(i_Company_Id => r_Journal.Company_Id, --
                       i_Filial_Id => r_Journal.Filial_Id, --
                       i_Page_Id => r.Page_Id, --
                       i_Indicator_Id => v_Indicator_Id).Indicator_Value;
    
      Put(v_Page_Map, 'wage_amount', Nullif(v_Wage_Amount, 0));
    
      select max(q.Plan_Time), sum(q.Plan_Time)
        into v_Working_Day, v_Working_Week
        from Htt_Schedule_Days q
       where q.Company_Id = r_Journal.Company_Id
         and q.Filial_Id = r_Journal.Filial_Id
         and q.Schedule_Id = r.Schedule_Id
         and q.Schedule_Date between Trunc(r.Transfer_Begin, 'iw') and
             Trunc(r.Transfer_Begin, 'iw') + 6;
    
      Put(v_Page_Map, 'working_day', Round(Nullif(v_Working_Day, 0) / 60, 1));
      Put(v_Page_Map, 'working_week', Round(Nullif(v_Working_Week, 0) / 60, 1));
    
      -- old
    
      Put(v_Page_Map, 'old_staff_number', r.Staff_Number);
    
      r_Closest_Robot := Hpd_Util.Closest_Robot(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Staff_Id   => r.Staff_Id,
                                                i_Period     => r.Transfer_Begin - 1);
    
      r_Robot := z_Mrf_Robots.Load(i_Company_Id => r_Closest_Robot.Company_Id,
                                   i_Filial_Id  => r_Closest_Robot.Filial_Id,
                                   i_Robot_Id   => r_Closest_Robot.Robot_Id);
    
      r_Closest_Rank := Hpd_Util.Closest_Rank(i_Company_Id => Ui.Company_Id,
                                              i_Filial_Id  => Ui.Filial_Id,
                                              i_Staff_Id   => r.Staff_Id,
                                              i_Period     => r.Transfer_Begin - 1);
    
      Put(v_Page_Map,
          'old_division_name',
          z_Mhr_Divisions.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => r_Robot.Division_Id).Name);
      Put(v_Page_Map, 'old_robot_name', r_Robot.Name);
      Put(v_Page_Map,
          'old_job_name',
          z_Mhr_Jobs.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Job_Id => r_Robot.Job_Id).Name);
      Put(v_Page_Map,
          'old_rank_name',
          z_Mhr_Ranks.Take(i_Company_Id => Ui.Company_Id, --
          i_Filial_Id => Ui.Filial_Id, --
          i_Rank_Id => z_Hrm_Robots.Take(i_Company_Id => r_Robot.Company_Id, --
          i_Filial_Id => r_Robot.Filial_Id, --
          i_Robot_Id => r_Robot.Robot_Id).Rank_Id).Name);
    
      v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Staff_Id   => r.Staff_Id,
                                                i_Trans_Type => Hpd_Pref.c_Transaction_Type_Schedule,
                                                i_Period     => r.Transfer_Begin - 1);
    
      r_Closest_Trans := z_Hpd_Transactions.Take(i_Company_Id => Ui.Company_Id,
                                                 i_Filial_Id  => Ui.Filial_Id,
                                                 i_Trans_Id   => v_Trans_Id);
    
      r_Closest_Schedule := z_Hpd_Trans_Schedules.Take(i_Company_Id => r_Closest_Trans.Company_Id,
                                                       i_Filial_Id  => r_Closest_Trans.Filial_Id,
                                                       i_Trans_Id   => r_Closest_Trans.Trans_Id);
      Put(v_Page_Map,
          'old_schedule_name',
          z_Htt_Schedules.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Schedule_Id => r_Closest_Schedule.Schedule_Id).Name);
    
      select max(q.Plan_Time), sum(q.Plan_Time)
        into v_Working_Day, v_Working_Week
        from Htt_Schedule_Days q
       where q.Company_Id = r_Journal.Company_Id
         and q.Filial_Id = r_Journal.Filial_Id
         and q.Schedule_Id = r_Closest_Schedule.Schedule_Id
         and q.Schedule_Date between Trunc(r_Closest_Trans.Begin_Date, 'iw') and
             Trunc(r_Closest_Trans.Begin_Date, 'iw') + 6;
    
      Put(v_Page_Map, 'old_working_day', Round(Nullif(v_Working_Day, 0) / 60, 1));
      Put(v_Page_Map, 'old_working_week', Round(Nullif(v_Working_Week, 0) / 60, 1));
    
      v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Staff_Id   => r.Staff_Id,
                                                i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                                i_Period     => r.Transfer_Begin - 1);
    
      v_Wage_Amount := z_Hpd_Trans_Indicators.Take(i_Company_Id => r_Journal.Company_Id, --
                       i_Filial_Id => r_Journal.Filial_Id, --
                       i_Trans_Id => v_Trans_Id, --
                       i_Indicator_Id => v_Indicator_Id).Indicator_Value;
    
      Put(v_Page_Map, 'old_wage_amount', Nullif(v_Wage_Amount, 0));
    
      v_Page_List.Push(v_Page_Map.Val);
    end loop;
  
    Result.Put('transfers', v_Page_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
  begin
    Uit_Ker.Run_Report(i_Template_Id => p.r_Number('template_id'), --
                       i_Data        => Report(p));
  end;

end Ui_Vhr111;
/
