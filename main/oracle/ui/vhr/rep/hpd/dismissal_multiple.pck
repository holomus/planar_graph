create or replace package Ui_Vhr110 is
  ----------------------------------------------------------------------------------------------------
  Function Definitions return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr110;
/
create or replace package body Ui_Vhr110 is
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
  
    return b.Translate('UI-VHR110:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    Put(v_Page_List, 'dismissal_reason_name', t('dismissal reason name'));
    Put(v_Page_List, 'based_on_doc', t('based on doc'));
    Put(v_Page_List, 'note', t('note'));
    Put(v_Page_List, 'dismissal_date', t('dismissal date'));
    Put(v_Page_List, 'employee_name', t('employee name'));
    Put(v_Page_List, 'staff_number', t('staff number'));
    Put(v_Page_List, 'division_name', t('division name'));
    Put(v_Page_List, 'robot_name', t('robot name'));
    Put(v_Page_List, 'job_name', t('job name'));
    Put(v_Page_List, 'schedule_name', t('schedule name'));
    Put(v_Page_List, 'employment_type_name', t('employment type name'));
    Put(v_Page_List, 'labor_function_name', t('labor function name'));
    Put(v_Page_List, 'rank_name', t('rank name'));
    Put(v_Page_List, 'quantity', t('quantity'));
    Put(v_Page_List, 'contract_number', t('contract number'));
    Put(v_Page_List, 'contract_date', t('contract date'));
    Put(v_Page_List, 'fixed_term', t('fixed term'));
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
    Put(result, 'dismissals', t('dismissals'), v_Page_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Report(p Hashmap) return Gmap is
    r_Journal          Hpd_Journals%rowtype;
    r_Legal_Person     Mr_Legal_Persons%rowtype;
    r_Staff            Href_Staffs%rowtype;
    r_Closest_Robot    Hpd_Trans_Robots%rowtype;
    r_Hr_Robot         Hrm_Robots%rowtype;
    r_Mr_Robot         Mrf_Robots%rowtype;
    r_Closest_Contract Hpd_Page_Contracts%rowtype;
    v_Schedule_Id      number;
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
                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple) then
      b.Raise_Not_Implemented;
    end if;
  
    Put(result,
        'filial_name',
        z_Md_Filials.Load(i_Company_Id => r_Journal.Company_Id, i_Filial_Id => r_Journal.Filial_Id).Name);
  
    r_Legal_Person := z_Mr_Legal_Persons.Load(i_Company_Id => r_Journal.Company_Id,
                                              i_Person_Id  => r_Journal.Filial_Id);
  
    r_Staff := z_Href_Staffs.Take(i_Company_Id => r_Journal.Company_Id,
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
  
    Put(result, 'journal_number', r_Journal.Journal_Number);
    Put(result, 'journal_date', r_Journal.Journal_Date);
    Put(result, 'journal_name', r_Journal.Journal_Name);
  
    for r in (select q.Company_Id,
                     q.Filial_Id,
                     q.Staff_Id,
                     (select k.Name
                        from Href_Dismissal_Reasons k
                       where k.Company_Id = w.Company_Id
                         and k.Dismissal_Reason_Id = w.Dismissal_Reason_Id) Dismissal_Reason_Name,
                     w.Based_On_Doc,
                     w.Note,
                     w.Dismissal_Date,
                     (select k.Name
                        from Mr_Natural_Persons k
                       where k.Company_Id = q.Company_Id
                         and k.Person_Id = q.Employee_Id) Employee_Name,
                     (select k.Staff_Number
                        from Href_Staffs k
                       where k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Staff_Id = q.Staff_Id) Staff_Number
                from Hpd_Journal_Pages q
                join Hpd_Dismissals w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Page_Id = q.Page_Id
               where q.Company_Id = r_Journal.Company_Id
                 and q.Filial_Id = r_Journal.Filial_Id
                 and q.Journal_Id = r_Journal.Journal_Id)
    loop
      v_Page_Map := Gmap;
    
      v_Schedule_Id      := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => r.Company_Id,
                                                             i_Filial_Id  => r.Filial_Id,
                                                             i_Staff_Id   => r.Staff_Id,
                                                             i_Period     => r.Dismissal_Date);
      r_Closest_Robot    := Hpd_Util.Closest_Robot(i_Company_Id => r.Company_Id,
                                                   i_Filial_Id  => r.Filial_Id,
                                                   i_Staff_Id   => r.Staff_Number,
                                                   i_Period     => r.Dismissal_Date);
      r_Mr_Robot         := Hpd_Util.Get_Closest_Robot(i_Company_Id => r.Company_Id,
                                                       i_Filial_Id  => r.Filial_Id,
                                                       i_Staff_Id   => r.Staff_Id,
                                                       i_Period     => r.Dismissal_Date);
      r_Hr_Robot         := z_Hrm_Robots.Take(i_Company_Id => r.Company_Id,
                                              i_Filial_Id  => r.Filial_Id,
                                              i_Robot_Id   => r_Mr_Robot.Robot_Id);
      r_Closest_Contract := Hpd_Util.Get_Closest_Contract(i_Company_Id => r.Company_Id,
                                                          i_Filial_Id  => r.Filial_Id,
                                                          i_Staff_Id   => r.Staff_Id,
                                                          i_Period     => r.Dismissal_Date);
    
      Put(v_Page_Map, 'dismissal_reason_name', r.Dismissal_Reason_Name);
      Put(v_Page_Map, 'based_on_doc', r.Based_On_Doc);
      Put(v_Page_Map, 'note', r.Note);
      Put(v_Page_Map, 'dismissal_date', r.Dismissal_Date);
      Put(v_Page_Map, 'employee_name', r.Employee_Name);
      Put(v_Page_Map, 'staff_number', r.Staff_Number);
      Put(v_Page_Map,
          'division_name',
          z_Mhr_Divisions.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Division_Id => r_Mr_Robot.Division_Id).Name);
      Put(v_Page_Map, 'robot_name', r_Mr_Robot.Name);
      Put(v_Page_Map,
          'job_name',
          z_Mhr_Jobs.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Job_Id => r_Mr_Robot.Job_Id).Name);
      Put(v_Page_Map,
          'schedule_name',
          z_Htt_Schedules.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Schedule_Id => v_Schedule_Id).Name);
      Put(v_Page_Map,
          'employment_type_name',
          Hpd_Util.t_Employment_Type(r_Closest_Robot.Employment_Type));
      Put(v_Page_Map,
          'labor_function_name',
          z_Href_Labor_Functions.Take(i_Company_Id => r.Company_Id, i_Labor_Function_Id => r_Hr_Robot.Labor_Function_Id).Name);
      Put(v_Page_Map,
          'rank_name',
          z_Mhr_Ranks.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Rank_Id => r_Hr_Robot.Rank_Id).Name);
      Put(v_Page_Map, 'quantity', r_Closest_Robot.Fte);
      Put(v_Page_Map, 'contract_number', r_Closest_Contract.Contract_Number);
      Put(v_Page_Map, 'contract_date', r_Closest_Contract.Contract_Date);
      Put(v_Page_Map, 'expiry_date', r_Closest_Contract.Expiry_Date);
      Put(v_Page_Map,
          'fixed_term',
          Md_Util.Decode(r_Closest_Contract.Fixed_Term, 'Y', t('yes'), 'N', t('no'), t('no')));
      Put(v_Page_Map,
          'fixed_term_base_name',
          z_Href_Fixed_Term_Bases.Take(i_Company_Id => r.Company_Id, i_Fixed_Term_Base_Id => r_Closest_Contract.Fixed_Term_Base_Id).Name);
      Put(v_Page_Map, 'concluding_term', r_Closest_Contract.Concluding_Term);
      Put(v_Page_Map, 'hiring_conditions', r_Closest_Contract.Hiring_Conditions);
      Put(v_Page_Map, 'other_conditions', r_Closest_Contract.Other_Conditions);
      Put(v_Page_Map, 'workplace_equipment', r_Closest_Contract.Workplace_Equipment);
      Put(v_Page_Map, 'representative_basis', r_Closest_Contract.Representative_Basis);
    
      v_Page_List.Push(v_Page_Map.Val);
    end loop;
  
    Result.Put('dismissals', v_Page_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
  begin
    Uit_Ker.Run_Report(i_Template_Id => p.r_Number('template_id'), --
                       i_Data        => Report(p));
  end;

end Ui_Vhr110;
/
