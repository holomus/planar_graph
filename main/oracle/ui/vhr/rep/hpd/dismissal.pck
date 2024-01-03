create or replace package Ui_Vhr109 is
  ----------------------------------------------------------------------------------------------------  
  Function Definitions return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap);
end Ui_Vhr109;
/
create or replace package body Ui_Vhr109 is
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
    return b.Translate('UI-VHR109:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    Put(result, 'journal_name', t('journal_name'));
    Put(result, 'dismissal_reason_name', t('dismissal reason name'));
    Put(result, 'based_on_doc', t('based on doc'));
    Put(result, 'note', t('note'));
    Put(result, 'dismissal_date', t('dismissal date'));
    Put(result, 'employee_name', t('employee name'));
    Put(result, 'staff_number', t('staff number'));
    Put(result, 'division_name', t('division name'));
    Put(result, 'robot_name', t('robot name'));
    Put(result, 'job_name', t('job name'));
    Put(result, 'schedule_name', t('schedule name'));
    Put(result, 'employment_type_name', t('employment type name'));
    Put(result, 'labor_function_name', t('labor function name'));
    Put(result, 'rank_name', t('rank name'));
    Put(result, 'quantity', t('quantity'));
    Put(result, 'contract_number', t('contract number'));
    Put(result, 'contract_date', t('contract date'));
    Put(result, 'expiry_date', t('expiry date'));
    Put(result, 'fixed_term', t('fixed term'));
    Put(result, 'fixed_term_base_name', t('fixed term base name'));
    Put(result, 'concluding_term', t('concluding term'));
    Put(result, 'hiring_conditions', t('hiring conditions'));
    Put(result, 'other_conditions', t('other conditions'));
    Put(result, 'workplace_equipment', t('workplace equipment'));
    Put(result, 'representative_basis', t('representative basis'));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Report(p Hashmap) return Gmap is
    r_Journal       Hpd_Journals%rowtype;
    r_Legal_Person  Mr_Legal_Persons%rowtype;
    r_Staff         Href_Staffs%rowtype;
    r_Mr_Robot      Mrf_Robots%rowtype;
    r_Hr_Robot      Hrm_Robots%rowtype;
    r_Page_Contract Hpd_Page_Contracts%rowtype;
    r_Closest_Robot Hpd_Trans_Robots%rowtype;
    v_Page_Id       number;
    v_Schedule_Id   number;
    result          Gmap := Gmap;
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
       Hpd_Util.Journal_Type_Id(i_Company_Id => r_Journal.Company_Id,
                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal) then
      b.Raise_Not_Implemented;
    end if;
  
    Put('filial_name',
        z_Md_Filials.Load(i_Company_Id => r_Journal.Company_Id, i_Filial_Id => r_Journal.Filial_Id).Name);
  
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
  
    select q.Page_Id
      into v_Page_Id
      from Hpd_Journal_Pages q
     where q.Company_Id = r_Journal.Company_Id
       and q.Filial_Id = r_Journal.Filial_Id
       and q.Journal_Id = r_Journal.Journal_Id;
  
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
                 and q.Journal_Id = r_Journal.Journal_Id
                 and q.Page_Id = v_Page_Id
                 and Rownum = 1)
    loop
      v_Schedule_Id   := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => r.Company_Id,
                                                          i_Filial_Id  => r.Filial_Id,
                                                          i_Staff_Id   => r.Staff_Id,
                                                          i_Period     => r.Dismissal_Date);
      r_Closest_Robot := Hpd_Util.Closest_Robot(i_Company_Id => r.Company_Id,
                                                i_Filial_Id  => r.Filial_Id,
                                                i_Staff_Id   => r.Staff_Id,
                                                i_Period     => r.Dismissal_Date);
      r_Mr_Robot      := Hpd_Util.Get_Closest_Robot(i_Company_Id => r.Company_Id,
                                                    i_Filial_Id  => r.Filial_Id,
                                                    i_Staff_Id   => r.Staff_Id,
                                                    i_Period     => r.Dismissal_Date);
      r_Hr_Robot      := z_Hrm_Robots.Take(i_Company_Id => r.Company_Id,
                                           i_Filial_Id  => r.Filial_Id,
                                           i_Robot_Id   => r_Mr_Robot.Robot_Id);
      r_Page_Contract := Hpd_Util.Get_Closest_Contract(i_Company_Id => r.Company_Id,
                                                       i_Filial_Id  => r.Filial_Id,
                                                       i_Staff_Id   => r.Staff_Id,
                                                       i_Period     => r.Dismissal_Date);
    
      Put('dismissal_reason_name', r.Dismissal_Reason_Name);
      Put('based_on_doc', r.Based_On_Doc);
      Put('note', r.Note);
      Put('dismissal_date', r.Dismissal_Date);
      Put('employee_name', r.Employee_Name);
      Put('staff_number', r.Staff_Number);
      Put('division_name',
          z_Mhr_Divisions.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Division_Id => r_Mr_Robot.Division_Id).Name);
      Put('robot_name', r_Mr_Robot.Name);
      Put('job_name',
          z_Mhr_Jobs.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Job_Id => r_Mr_Robot.Job_Id).Name);
      Put('schedule_name',
          z_Htt_Schedules.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Schedule_Id => v_Schedule_Id).Name);
      Put('employment_type_name', Hpd_Util.t_Employment_Type(r_Closest_Robot.Employment_Type));
      Put('labor_function_name',
          z_Href_Labor_Functions.Take(i_Company_Id => r.Company_Id, i_Labor_Function_Id => r_Hr_Robot.Labor_Function_Id).Name);
      Put('rank_name',
          z_Mhr_Ranks.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Rank_Id => r_Hr_Robot.Rank_Id).Name);
      Put('quantity', r_Closest_Robot.Fte);
      Put('contract_number', r_Page_Contract.Contract_Number);
      Put('contract_date', r_Page_Contract.Contract_Date);
      Put('expiry_date', r_Page_Contract.Expiry_Date);
      Put('fixed_term',
          Md_Util.Decode(r_Page_Contract.Fixed_Term, 'Y', t('yes'), 'N', t('no'), t('no')));
      Put('fixed_term_base_name',
          z_Href_Fixed_Term_Bases.Take(i_Company_Id => r.Company_Id, i_Fixed_Term_Base_Id => r_Page_Contract.Fixed_Term_Base_Id).Name);
      Put('concluding_term', r_Page_Contract.Concluding_Term);
      Put('hiring_conditions', r_Page_Contract.Hiring_Conditions);
      Put('other_conditions', r_Page_Contract.Other_Conditions);
      Put('workplace_equipment', r_Page_Contract.Workplace_Equipment);
      Put('representative_basis', r_Page_Contract.Representative_Basis);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
  begin
    Uit_Ker.Run_Report(i_Template_Id => p.r_Number('template_id'), --
                       i_Data        => Report(p));
  end;

end Ui_Vhr109;
/
