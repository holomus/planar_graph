create or replace package Ui_Vhr350 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Reasons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Dismissal_Data(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Dismissal(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Dismissal(p Hashmap);
end Ui_Vhr350;
/
create or replace package body Ui_Vhr350 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Reasons return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_dismissal_reasons', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('dismissal_reason_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Query   varchar2(32767);
    v_Params  Hashmap := Hashmap();
    v_Matrix  Matrix_Varchar2;
    v_Is_User boolean := not Ui.Is_User_Admin;
    q         Fazo_Query;
  
    --------------------------------------------------
    Function User_Filials return Array_Number is
      result Array_Number;
    begin
      select u.Filial_Id
        bulk collect
        into result
        from Md_User_Filials u
       where u.Company_Id = Ui.Company_Id
         and u.User_Id = Ui.User_Id;
    
      return result;
    end;
  begin
    v_Params.Put('company_id', Ui.Company_Id);
    v_Params.Put('filial_head', Md_Pref.Filial_Head(Ui.Company_Id));
    v_Params.Put('month_begin', Trunc(sysdate, 'mon'));
    v_Params.Put('month_end', Last_Day(Trunc(sysdate)));
    v_Params.Put('max_date', Href_Pref.c_Max_Date);
    v_Params.Put('today', Trunc(sysdate));
    v_Params.Put('sk_primary', Href_Pref.c_Staff_Kind_Primary);
    v_Params.Put('jt_dismissal_ids',
                 Array_Number(Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                       i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
                              Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                       i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple)));
  
    v_Query := 'select s.*,
                       (select p.photo_sha
                          from md_persons p
                         where p.company_id = :company_id
                           and p.person_id = s.employee_id) as photo_sha,
                       (select p.name
                          from mr_natural_persons p
                         where p.company_id = :company_id
                           and p.person_id = s.employee_id) as name,
                       (select p.gender
                          from mr_natural_persons p
                         where p.company_id = :company_id
                           and p.person_id = s.employee_id) as gender,
                       case
                         when s.hiring_date <= :month_end and nvl(s.dismissal_date, :month_begin) >= :month_begin then
                           ''Y''
                         else
                           ''N''
                       end as this_month_working
                  from mhr_employees q
                  join href_staffs s
                    on s.company_id = :company_id
                   and s.filial_id = q.filial_id
                   and s.employee_id = q.employee_id
                   and s.staff_kind = :sk_primary
                   and s.state = ''A''
                   and s.hiring_date = (select max(s1.hiring_date)
                                          from href_staffs s1
                                         where s1.company_id = :company_id
                                           and s1.filial_id = q.filial_id
                                           and s1.employee_id = q.employee_id
                                           and s1.staff_kind = :sk_primary
                                           and s1.state = ''A'')
                 where q.company_id = :company_id';
  
    if v_Is_User then
      v_Query := v_Query || --
                 ' and q.filial_id member of :filial_ids';
    
      v_Params.Put('filial_ids', User_Filials);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('filial_id',
                   'staff_id',
                   'employee_id',
                   'division_id',
                   'job_id',
                   'schedule_id',
                   'dismissal_reason_id');
    q.Varchar2_Field('staff_number',
                     'dismissal_note',
                     'photo_sha',
                     'name',
                     'gender',
                     'this_month_working');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    v_Matrix := Md_Util.Person_Genders;
  
    q.Option_Field('gender_name', 'gender', v_Matrix(1), v_Matrix(2));
    q.Option_Field('this_month_working_name',
                   'this_month_working',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    -- filial
    v_Query := 'select * 
                  from md_filials q 
                 where q.company_id = :company_id
                   and q.filial_id <> :filial_head';
  
    if v_Is_User then
      v_Query := v_Query || --
                 ' and q.filial_id member of :filial_ids';
    end if;
  
    q.Refer_Field('filial_name', 'filial_id', 'md_filials', 'filial_id', 'name', v_Query);
  
    -- division
    v_Query := Uit_Hrm.Departments_Query(i_Current_Filial => false);
  
    if v_Is_User then
      v_Query := v_Query || --
                 ' and q.filial_id member of :filial_ids';
    end if;
  
    q.Refer_Field('division_name', 'division_id', 'mhr_divisions', 'division_id', 'name', v_Query);
  
    -- job
    v_Query := 'select * 
                  from mhr_jobs q 
                 where q.company_id = :company_id';
  
    if v_Is_User then
      v_Query := v_Query || --
                 ' and q.filial_id member of :filial_ids';
    end if;
  
    q.Refer_Field('job_name', 'job_id', 'mhr_jobs', 'job_id', 'name', v_Query);
  
    -- schedule
    v_Query := 'select * 
                  from htt_schedules q 
                 where q.company_id = :company_id';
  
    if v_Is_User then
      v_Query := v_Query || --
                 ' and q.filial_id member of :filial_ids';
    end if;
  
    q.Refer_Field('schedule_name', 'schedule_id', 'htt_schedules', 'schedule_id', 'name', v_Query);
  
    -- dismissal reason
    q.Refer_Field('dismissal_reason_name',
                  'dismissal_reason_id',
                  'href_dismissal_reasons',
                  'dismissal_reason_id',
                  'name',
                  'select *
                     from href_dismissal_reasons q
                    where q.company_id = :company_id');
  
    -- dismissal journal id
    q.Map_Field('journal_id',
                'select jp.journal_id
                    from hpd_journal_pages jp
                   where jp.company_id = :company_id
                     and jp.filial_id = $filial_id
                     and jp.staff_id = $staff_id
                     and exists (select 1
                            from hpd_journals j
                           where j.company_id = :company_id
                             and j.filial_id = jp.filial_id
                             and j.journal_id = jp.journal_id
                             and j.journal_type_id member of :jt_dismissal_ids
                             and j.posted = ''Y'')');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Dismissal_Data(p Hashmap) return Hashmap is
    r_Journal    Hpd_Journals%rowtype;
    r_Dissmissal Hpd_Dismissals%rowtype;
    v_Staff_Id   number := p.r_Number('staff_id');
    v_Page_Id    number;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => p.r_Number('filial_id'),
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    select Jp.Page_Id
      into v_Page_Id
      from Hpd_Journal_Pages Jp
     where Jp.Company_Id = r_Journal.Company_Id
       and Jp.Filial_Id = r_Journal.Filial_Id
       and Jp.Journal_Id = r_Journal.Journal_Id
       and Jp.Staff_Id = v_Staff_Id;
  
    r_Dissmissal := z_Hpd_Dismissals.Load(i_Company_Id => r_Journal.Company_Id,
                                          i_Filial_Id  => r_Journal.Filial_Id,
                                          i_Page_Id    => v_Page_Id);
  
    return Fazo.Zip_Map('dismissal_date',
                        r_Dissmissal.Dismissal_Date,
                        'dismissal_reason_id',
                        r_Dissmissal.Dismissal_Reason_Id,
                        'dismissal_reason_name',
                        z_Href_Dismissal_Reasons.Take(i_Company_Id => r_Dissmissal.Company_Id, --
                        i_Dismissal_Reason_Id => r_Dissmissal.Dismissal_Reason_Id).Name,
                        'note',
                        r_Dissmissal.Note);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Dismissal(p Hashmap) is
    r_Journal        Hpd_Journals%rowtype;
    r_Dismissal      Hpd_Dismissals%rowtype;
    p_Journal        Hpd_Pref.Dismissal_Journal_Rt;
    v_Filial_Id      number := p.r_Number('filial_id');
    v_Staff_Id       number := p.r_Number('staff_id');
    v_Dismissal_Date date := p.r_Date('dismissal_date');
  begin
    if z_Hpd_Journals.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => v_Filial_Id,
                                 i_Journal_Id => p.o_Number('journal_id'),
                                 o_Row        => r_Journal) then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id,
                             i_Repost     => true);
    else
      r_Journal.Journal_Id      := Hpd_Next.Journal_Id;
      r_Journal.Journal_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                            i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
      r_Journal.Journal_Date    := v_Dismissal_Date;
    end if;
  
    Hpd_Util.Dismissal_Journal_New(o_Journal         => p_Journal,
                                   i_Company_Id      => Ui.Company_Id,
                                   i_Filial_Id       => v_Filial_Id,
                                   i_Journal_Id      => r_Journal.Journal_Id,
                                   i_Journal_Type_Id => r_Journal.Journal_Type_Id,
                                   i_Journal_Number  => r_Journal.Journal_Number,
                                   i_Journal_Date    => r_Journal.Journal_Date,
                                   i_Journal_Name    => r_Journal.Journal_Name);
  
    if r_Journal.Company_Id is not null then
      for r in (select Jp.Staff_Id, d.*
                  from Hpd_Journal_Pages Jp
                  join Hpd_Dismissals d
                    on d.Company_Id = p_Journal.Company_Id
                   and d.Filial_Id = p_Journal.Filial_Id
                   and d.Page_Id = Jp.Page_Id
                 where Jp.Company_Id = p_Journal.Company_Id
                   and Jp.Filial_Id = p_Journal.Filial_Id
                   and Jp.Journal_Id = p_Journal.Journal_Id)
      loop
        if r.Staff_Id = v_Staff_Id then
          z_Hpd_Dismissals.Init(p_Row                  => r_Dismissal,
                                i_Page_Id              => r.Page_Id,
                                i_Employment_Source_Id => r.Employment_Source_Id,
                                i_Based_On_Doc         => r.Based_On_Doc);
        
          continue;
        end if;
      
        Hpd_Util.Journal_Add_Dismissal(p_Journal              => p_Journal,
                                       i_Page_Id              => r.Page_Id,
                                       i_Staff_Id             => r.Staff_Id,
                                       i_Dismissal_Date       => r.Dismissal_Date,
                                       i_Dismissal_Reason_Id  => r.Dismissal_Reason_Id,
                                       i_Employment_Source_Id => r.Employment_Source_Id,
                                       i_Based_On_Doc         => r.Based_On_Doc,
                                       i_Note                 => r.Note);
      end loop;
    else
      r_Dismissal.Page_Id := Hpd_Next.Page_Id;
    end if;
  
    Hpd_Util.Journal_Add_Dismissal(p_Journal              => p_Journal,
                                   i_Page_Id              => r_Dismissal.Page_Id,
                                   i_Staff_Id             => v_Staff_Id,
                                   i_Dismissal_Date       => v_Dismissal_Date,
                                   i_Dismissal_Reason_Id  => p.o_Number('dismissal_reason_id'),
                                   i_Employment_Source_Id => r_Dismissal.Employment_Source_Id,
                                   i_Based_On_Doc         => r_Dismissal.Based_On_Doc,
                                   i_Note                 => p.o_Varchar2('note'));
  
    Hpd_Api.Dismissal_Journal_Save(p_Journal);
    Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                         i_Filial_Id  => p_Journal.Filial_Id,
                         i_Journal_Id => p_Journal.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Dismissal(p Hashmap) is
    r_Journal  Hpd_Journals%rowtype;
    v_Staff_Id number := p.r_Number('staff_id');
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => p.r_Number('filial_id'),
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    for r in (select 'X'
                from Hpd_Journal_Pages Jp
               where Jp.Company_Id = r_Journal.Company_Id
                 and Jp.Filial_Id = r_Journal.Filial_Id
                 and Jp.Journal_Id = r_Journal.Journal_Id
                 and Jp.Staff_Id <> v_Staff_Id)
    loop
      b.Raise_Not_Implemented;
    end loop;
  
    Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                           i_Filial_Id  => r_Journal.Filial_Id,
                           i_Journal_Id => r_Journal.Journal_Id);
  
    Hpd_Api.Journal_Delete(i_Company_Id => r_Journal.Company_Id,
                           i_Filial_Id  => r_Journal.Filial_Id,
                           i_Journal_Id => r_Journal.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null;
  
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
  
    update Href_Staffs
       set Company_Id          = null,
           Filial_Id           = null,
           Staff_Id            = null,
           Staff_Number        = null,
           Staff_Kind          = null,
           Employee_Id         = null,
           Hiring_Date         = null,
           Dismissal_Date      = null,
           Division_Id         = null,
           Job_Id              = null,
           Schedule_Id         = null,
           Dismissal_Reason_Id = null,
           Dismissal_Note      = null,
           State               = null;
  
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           Photo_Sha  = null;
  
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           Gender     = null;
  
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null;
  
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null,
           Parent_Id   = null;
  
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null;
  
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null;
  
    update Hpd_Journal_Pages
       set Company_Id = null,
           Filial_Id  = null,
           Journal_Id = null,
           Page_Id    = null,
           Staff_Id   = null;
  
    update Hpd_Journals
       set Company_Id      = null,
           Filial_Id       = null,
           Journal_Id      = null,
           Journal_Type_Id = null,
           Posted          = null;
  end;

end Ui_Vhr350;
/
