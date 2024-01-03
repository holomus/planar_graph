create or replace package Ui_Vhr433 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Rank_Change_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr433;
/
create or replace package body Ui_Vhr433 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Rank_Change_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hpd_rank_changes  q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and exists (select 1
                               from x_hpd_journal_pages w
                              where w.t_company_id = q.t_company_id
                                and w.t_filial_id = q.t_filial_id 
                                and w.journal_id = :journal_id
                                and w.page_id = q.page_id)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'journal_id',
                                 p.r_Number('journal_id')));
  
    q.Number_Field('t_audit_id', 't_filial_id', 't_user_id', 't_context_id', 'rank_id');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_date', 't_timestamp', 'change_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('t_filial_name',
                  't_filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials s 
                    where s.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code, 
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                            from md_company_projects k
                           where k.company_id = :company_id
                             and k.project_code = s.project_code)');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select *
                     from mhr_ranks s 
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number := p.r_Number('journal_type_id');
  begin
    Hpd_Api.Journal_Post(i_Company_Id => v_Company_Id,
                         i_Filial_Id  => v_Filial_Id,
                         i_Journal_Id => v_Journal_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => v_Company_Id,
                                                                                              i_User_Id         => v_User_Id,
                                                                                              i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Pref.c_Form_Rank_Change_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number := p.r_Number('journal_type_id');
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Unpost(i_Company_Id      => v_Company_Id,
                                                                                                i_User_Id         => v_User_Id,
                                                                                                i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Pref.c_Form_Rank_Change_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Rank_Changes
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(Rc.Change_Date,
                           Rc.Employee_Name,
                           Rc.Staff_Number,
                           Rc.Old_Rank_Name,
                           case
                             when Rc.Access_To_Hidden_Salary = 'Y' then
                              Rc.Old_Wage
                             else
                              null
                           end,
                           case
                             when Rc.Access_To_Hidden_Salary = 'Y' then
                              Rc.New_Wage
                             else
                              null
                           end,
                           Rc.New_Rank_Name,
                           Rc.Access_To_Hidden_Salary)
      bulk collect
      into v_Matrix
      from (select w.Change_Date,
                   (select k.Name
                      from Mr_Natural_Persons k
                     where k.Company_Id = i_Company_Id
                       and k.Person_Id = q.Employee_Id) as Employee_Name,
                   (select k.Staff_Number
                      from Href_Staffs k
                     where k.Company_Id = i_Company_Id
                       and k.Filial_Id = i_Filial_Id
                       and k.Staff_Id = q.Staff_Id) as Staff_Number,
                   (select k.Name
                      from Mhr_Ranks k
                     where k.Company_Id = i_Company_Id
                       and k.Filial_Id = i_Filial_Id
                       and k.Rank_Id =
                           Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Staff_Id   => q.Staff_Id,
                                                        i_Period     => w.Change_Date - 1)) as Old_Rank_Name,
                   
                   Hpd_Util.Get_Closest_Wage(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Staff_Id   => q.Staff_Id,
                                             i_Period     => w.Change_Date - 1) as Old_Wage,
                   Hrm_Util.Closest_Wage(i_Company_Id    => i_Company_Id,
                                         i_Filial_Id     => i_Filial_Id,
                                         i_Wage_Scale_Id => Hpd_Util.Get_Closest_Wage_Scale_Id(i_Company_Id => i_Company_Id,
                                                                                               i_Filial_Id  => i_Filial_Id,
                                                                                               i_Staff_Id   => q.Staff_Id,
                                                                                               i_Period     => w.Change_Date),
                                         i_Period        => w.Change_Date,
                                         i_Rank_Id       => w.Rank_Id) as New_Wage,
                   (select k.Name
                      from Mhr_Ranks k
                     where k.Company_Id = i_Company_Id
                       and k.Filial_Id = w.Filial_Id
                       and k.Rank_Id = w.Rank_Id) as New_Rank_Name,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => i_Company_Id,
                                                                                                    i_Filial_Id  => i_Filial_Id,
                                                                                                    i_Staff_Id   => q.Staff_Id,
                                                                                                    i_Period     => w.Change_Date),
                                                       i_Employee_Id => q.Employee_Id) as Access_To_Hidden_Salary
              from Hpd_Journal_Pages q
              join Hpd_Rank_Changes w
                on w.Company_Id = i_Company_Id
               and w.Filial_Id = i_Filial_Id
               and w.Page_Id = q.Page_Id
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Journal_Id = i_Journal_Id) Rc;
  
    Result.Put('rank_changes', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    result    Hashmap;
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Uit_Hpd.Access_To_Journal_Sign_Document(r_Journal.Journal_Id) then
      for r in (select q.Staff_Id
                  from Hpd_Journal_Pages q
                 where q.Company_Id = r_Journal.Company_Id
                   and q.Filial_Id = r_Journal.Filial_Id
                   and q.Journal_Id = r_Journal.Journal_Id)
      loop
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r.Staff_Id, i_Self => false);
      end loop;
    end if;
  
    if not Hpd_Util.Is_Rank_Change_Journal(i_Company_Id      => Ui.Company_Id,
                                           i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := z_Hpd_Journals.To_Map(r_Journal,
                                    z.Journal_Id,
                                    z.Journal_Type_Id,
                                    z.Journal_Number,
                                    z.Journal_Date,
                                    z.Journal_Name,
                                    z.Sign_Document_Id,
                                    z.Posted,
                                    z.Created_On,
                                    z.Modified_On);
  
    Result.Put('sign_document_status',
               Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                  i_Document_Id => r_Journal.Sign_Document_Id));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Journal.Company_Id, i_User_Id => r_Journal.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Journal.Company_Id, i_User_Id => r_Journal.Modified_By).Name);
    Result.Put('rch_journal_type_id',
               Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Rank_Change));
  
    Result.Put_All(Get_Rank_Changes(i_Company_Id => r_Journal.Company_Id,
                                    i_Filial_Id  => r_Journal.Filial_Id,
                                    i_Journal_Id => r_Journal.Journal_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Hpd_Rank_Changes
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Page_Id               = null,
           Change_Date           = null,
           Rank_Id               = null;
    update x_Hpd_Journal_Pages
       set t_Company_Id = null,
           t_Filial_Id  = null,
           Journal_Id   = null,
           Page_Id      = null;
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_Company_Projects
       set Project_Code = null,
           Company_Id   = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr433;
/
