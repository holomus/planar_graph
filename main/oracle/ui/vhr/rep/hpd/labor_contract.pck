create or replace package Ui_Vhr146 is
  ----------------------------------------------------------------------------------------------------
  Function Definitions return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr146;
/
create or replace package body Ui_Vhr146 is
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
    return b.Translate('UI-VHR146:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Definitions return Arraylist is
    v_Indicator_List Arraylist := Arraylist;
    v_Page_List      Arraylist := Arraylist;
    result           Arraylist := Arraylist;
  
    -----------------------------------------
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
    Put(v_Indicator_List, 'indicator_name', t('indicator name'));
    Put(v_Indicator_List, 'indicator_value', t('indicator value'));
  
    Put(v_Page_List, 'filial_name', t('filial name'));
    Put(v_Page_List, 'concluding_term', t('concluding term'));
    Put(v_Page_List, 'employee_address', t('employee address'));
    Put(v_Page_List, 'tin', t('tin'));
    Put(v_Page_List, 'npin', t('npin'));
    Put(v_Page_List, 'iapa', t('iapa'));
    Put(v_Page_List, 'director_name', t('director name'));
    Put(v_Page_List, 'journal_number', t('journal number'));
    Put(v_Page_List, 'journal_date', t('journal date'));
    Put(v_Page_List, 'journal_name', t('journal name'));
    Put(v_Page_List, 'hiring_date', t('hiring date'));
    Put(v_Page_List, 'employee_name', t('employee name'));
    Put(v_Page_List, 'robot_name', t('robot name'));
    Put(v_Page_List, 'division_name', t('division name'));
    Put(v_Page_List, 'job_name', t('job name'));
    Put(v_Page_List, 'employment_type_name', t('employment type name'));
    Put(v_Page_List, 'trial_period_name', t('trial period name'));
    Put(v_Page_List, 'trial_period_days', t('trial period days'));
    Put(v_Page_List, 'quantity', t('quantity'));
    Put(v_Page_List, 'wage_amount', t('wage amount'));
    Put(v_Page_List, 'working_day', t('working day'));
    Put(v_Page_List, 'contract_number', t('contract number'));
    Put(v_Page_List, 'contract_date', t('contract date'));
    Put(v_Page_List, 'contract_year', t('contract year'));
    Put(v_Page_List, 'expiry_date', t('expiry date'));
    Put(v_Page_List, 'hiring_conditions', t('hiring conditions'));
    Put(v_Page_List, 'region_name', t('region name'));
    Put(v_Page_List, 'indicators', t('indicators'), v_Indicator_List);
  
    Put(result, 'labor_contracts', t('labor contracts'), v_Page_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Report(p Hashmap) return Gmap is
    r_Journal        Hpd_Journals%rowtype;
    r_Legal_Person   Mr_Legal_Persons%rowtype;
    r_Person_Details Mr_Person_Details%rowtype;
    v_Indicator_Id   number;
    v_Wage_Amount    number;
    v_Working_Day    number;
    v_Indicator_List Glist;
    v_Page_List      Glist := Glist;
    v_Page_Map       Gmap := Gmap;
    v_Indicator_Map  Gmap;
    result           Gmap := Gmap;
    --------------------------------------------
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
       r_Journal.Journal_Type_Id not in
       (Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring),
        Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple)) then
      b.Raise_Not_Implemented;
    end if;
  
    r_Legal_Person := z_Mr_Legal_Persons.Take(i_Company_Id => Ui.Company_Id,
                                              i_Person_Id  => Ui.Filial_Id);
  
    r_Person_Details := z_Mr_Person_Details.Take(i_Company_Id => Ui.Company_Id,
                                                 i_Person_Id  => Ui.Filial_Id);
  
    Put(v_Page_Map,
        'filial_name',
        z_Md_Filials.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Name);
    Put(v_Page_Map,
        'director_name',
        z_Mr_Natural_Persons.Take(i_Company_Id => r_Journal.Company_Id, i_Person_Id => r_Legal_Person.Primary_Person_Id).Name);
    Put(v_Page_Map,
        'director_address',
        z_Mr_Person_Details.Take(i_Company_Id => r_Journal.Company_Id, i_Person_Id => r_Legal_Person.Primary_Person_Id).Address);
    Put(v_Page_Map,
        'region_name',
        z_Md_Regions.Take(i_Company_Id => Ui.Company_Id, i_Region_Id => r_Person_Details.Region_Id).Name);
  
    Put(v_Page_Map, 'journal_number', r_Journal.Journal_Number);
    Put(v_Page_Map, 'journal_date', r_Journal.Journal_Date);
    Put(v_Page_Map, 'journal_name', r_Journal.Journal_Name);
  
    v_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => r_Journal.Company_Id,
                                             i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
  
    for r in (select q.Page_Id,
                     w.Hiring_Date,
                     (select k.Name
                        from Mr_Natural_Persons k
                       where k.Company_Id = q.Company_Id
                         and k.Person_Id = q.Employee_Id) Employee_Name,
                     h.Address Employee_Address,
                     h.Tin,
                     j.Npin,
                     j.Iapa,
                     (select k.Name
                        from Mrf_Robots k
                       where k.Company_Id = m.Company_Id
                         and k.Filial_Id = m.Filial_Id
                         and k.Robot_Id = m.Robot_Id) Robot_Name,
                     (select k.Name
                        from Mhr_Divisions k
                       where k.Company_Id = m.Company_Id
                         and k.Filial_Id = m.Filial_Id
                         and k.Division_Id = m.Division_Id) Division_Name,
                     (select k.Name
                        from Mhr_Jobs k
                       where k.Company_Id = m.Company_Id
                         and k.Filial_Id = m.Filial_Id
                         and k.Job_Id = m.Job_Id) Job_Name,
                     s.Schedule_Id,
                     Hpd_Util.t_Employment_Type(m.Employment_Type) Employment_Type_Name,
                     Nvl2(Nullif(w.Trial_Period, 0), 'Y', 'N') Trial_Period,
                     Nullif(w.Trial_Period, 0) Trial_Period_Days,
                     m.Fte,
                     c.Concluding_Term,
                     c.Contract_Number,
                     c.Contract_Date,
                     to_char(c.Contract_Date, 'YYYY') Contract_Year,
                     c.Expiry_Date,
                     c.Hiring_Conditions
                from Hpd_Journal_Pages q
                join Hpd_Hirings w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Page_Id = q.Page_Id
                join Mr_Person_Details h
                  on h.Company_Id = q.Company_Id
                 and h.Person_Id = q.Employee_Id
                join Href_Person_Details j
                  on j.Company_Id = q.Company_Id
                 and j.Person_Id = q.Employee_Id
                left join Hpd_Page_Robots m
                  on m.Company_Id = q.Company_Id
                 and m.Filial_Id = q.Filial_Id
                 and m.Page_Id = q.Page_Id
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
               order by q.Page_Id)
    loop
      Put(v_Page_Map, 'employee_address', r.Employee_Address);
      Put(v_Page_Map, 'tin', r.Tin);
      Put(v_Page_Map, 'npin', r.Npin);
      Put(v_Page_Map, 'iapa', r.Iapa);
      Put(v_Page_Map, 'hiring_date', r.Hiring_Date);
      Put(v_Page_Map, 'employee_name', r.Employee_Name);
      Put(v_Page_Map, 'robot_name', r.Robot_Name);
      Put(v_Page_Map, 'division_name', r.Division_Name);
      Put(v_Page_Map, 'job_name', r.Job_Name);
      Put(v_Page_Map, 'employment_type_name', r.Employment_Type_Name);
      Put(v_Page_Map, 'trial_period_name', Hpd_Util.t_Trial_Period(r.Trial_Period));
      Put(v_Page_Map, 'trial_period_days', r.Trial_Period_Days);
      Put(v_Page_Map, 'quantity', r.Fte);
      Put(v_Page_Map, 'concluding_term', r.Concluding_Term);
    
      v_Wage_Amount := z_Hpd_Page_Indicators.Take(i_Company_Id => r_Journal.Company_Id, --
                       i_Filial_Id => r_Journal.Filial_Id, --
                       i_Page_Id => r.Page_Id, --
                       i_Indicator_Id => v_Indicator_Id).Indicator_Value;
    
      Put(v_Page_Map, 'wage_amount', Nullif(v_Wage_Amount, 0));
    
      v_Indicator_List := Glist;
    
      for i in (select name, Indicator_Value
                  from Hpd_Page_Indicators q
                  join Href_Indicators w
                    on q.Indicator_Id = w.Indicator_Id
                 where q.Indicator_Id <> v_Indicator_Id
                   and q.Company_Id = r_Journal.Company_Id
                   and q.Filial_Id = r_Journal.Filial_Id
                   and q.Page_Id = r.Page_Id)
      loop
        v_Indicator_Map := Gmap;
      
        Put(v_Indicator_Map, 'indicator_name', i.Name);
        Put(v_Indicator_Map, 'indicator_value', i.Indicator_Value);
      
        v_Indicator_List.Push(v_Indicator_Map.Val);
      end loop;
    
      if v_Indicator_List.Count <> 0 then
        v_Page_Map.Put('indicators', v_Indicator_List);
      else
        -- todo remove
        v_Indicator_Map := Gmap;
      
        Put(v_Indicator_Map, 'indicator_name', null);
        Put(v_Indicator_Map, 'indicator_value', null);
      
        v_Indicator_List.Push(v_Indicator_Map.Val);
      
        v_Page_Map.Put('indicators', v_Indicator_List);
      end if;
    
      select max(q.Plan_Time)
        into v_Working_Day
        from Htt_Schedule_Days q
       where q.Company_Id = r_Journal.Company_Id
         and q.Schedule_Id = r.Schedule_Id
         and q.Schedule_Date between Trunc(r.Hiring_Date, 'iw') and Trunc(r.Hiring_Date, 'iw') + 6;
    
      Put(v_Page_Map, 'working_day', Round(Nullif(v_Working_Day, 0) / 60, 1));
      Put(v_Page_Map, 'contract_number', r.Contract_Number);
      Put(v_Page_Map, 'contract_date', r.Contract_Date);
      Put(v_Page_Map, 'contract_year', r.Contract_Year);
      Put(v_Page_Map, 'expiry_date', r.Expiry_Date);
      Put(v_Page_Map, 'hiring_conditions', r.Hiring_Conditions);
    
      v_Page_List.Push(v_Page_Map.Val);
    end loop;
  
    Result.Put('labor_contracts', v_Page_List);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Run(p Hashmap) is
  begin
    Uit_Ker.Run_Report(i_Template_Id => p.r_Number('template_id'), i_Data => Report(p));
  end;

end Ui_Vhr146;
/
