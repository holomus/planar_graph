create or replace package Ui_Vhr669 is
  ----------------------------------------------------------------------------------------------------
  Function Definitions return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr669;
/
create or replace package body Ui_Vhr669 is
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
  
    return b.Translate('UI-VHR669:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    Put(v_Page_List, 'employee_name', t('employee name'));
    Put(v_Page_List, 'sick_leave_number', t('sick leave number'));
    Put(v_Page_List, 'begin_date', t('begin date'));
    Put(v_Page_List, 'end_date', t('end date'));
    Put(v_Page_List, 'reason_name', t('reason name'));
    Put(v_Page_List, 'coefficient', t('coefficient'));
  
    Put(result, 'filial_name', t('filial name'));
    Put(result, 'director_name', t('director name'));
    Put(result, 'director_job_name', t('director job name'));
    Put(result, 'journal_number', t('journal number'));
    Put(result, 'journal_date', t('journal date'));
    Put(result, 'journal_name', t('journal name'));
    Put(result, 'sick_leaves', t('sick_leaves'), v_Page_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Report(p Hashmap) return Gmap is
    r_Journal      Hpd_Journals%rowtype;
    r_Legal_Person Mr_Legal_Persons%rowtype;
    r_Staff        Href_Staffs%rowtype;
    v_Page_Map     Gmap;
    v_Page_List    Glist := Glist;
    result         Gmap := Gmap;
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
                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave_Multiple) then
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
  
    for r in (select q.Timeoff_Id, --
                     q.Staff_Id,
                     (select Np.Name
                        from Mr_Natural_Persons Np
                       where Np.Company_Id = q.Company_Id
                         and Np.Person_Id = (select St.Employee_Id
                                               from Href_Staffs St
                                              where St.Company_Id = q.Company_Id
                                                and St.Filial_Id = q.Filial_Id
                                                and St.Staff_Id = q.Staff_Id)) Staff_Name,
                     q.Begin_Date,
                     q.End_Date,
                     w.Reason_Id,
                     (select r.Name
                        from Href_Sick_Leave_Reasons r
                       where r.Company_Id = w.Company_Id
                         and r.Filial_Id = w.Filial_Id
                         and r.Reason_Id = w.Reason_Id) Reason_Name,
                     w.Coefficient,
                     w.Sick_Leave_Number
                from Hpd_Journal_Timeoffs q
                join Hpd_Sick_Leaves w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Timeoff_Id = q.Timeoff_Id
               where q.Company_Id = r_Journal.Company_Id
                 and q.Filial_Id = r_Journal.Filial_Id
                 and q.Journal_Id = r_Journal.Journal_Id)
    loop
      v_Page_Map := Gmap;
    
      Put(v_Page_Map, 'sick_leave_number', r.Sick_Leave_Number);
      Put(v_Page_Map, 'employee_name', r.Staff_Name);
      Put(v_Page_Map, 'begin_date', r.Begin_Date);
      Put(v_Page_Map, 'end_date', r.End_Date);
      Put(v_Page_Map, 'reason_name', r.Reason_Name);
      Put(v_Page_Map, 'coefficient', r.Coefficient);
    
      v_Page_List.Push(v_Page_Map.Val);
    end loop;
  
    Result.Put('sick_leaves', v_Page_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
  begin
    Uit_Ker.Run_Report(i_Template_Id => p.r_Number('template_id'), --
                       i_Data        => Report(p));
  end;

end Ui_Vhr669;
/
