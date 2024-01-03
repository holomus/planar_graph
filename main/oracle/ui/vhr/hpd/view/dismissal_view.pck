create or replace package Ui_Vhr429 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Dismissal_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Post(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Cos_Response(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr429;
/
create or replace package body Ui_Vhr429 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Dismissal_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hpd_dismissals q
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
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'page_id',
                   'dismissal_reason_id',
                   'employment_source_id');
    q.Varchar2_Field('t_event', 't_source_project_code', 'base_on_doc', 'note');
    q.Date_Field('t_date', 't_timestamp', 'dismissal_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('dismissal_reason_name',
                  'dismissal_reason_id',
                  'href_dismissal_reasons',
                  'dismissal_reason_id',
                  'name',
                  'select * 
                     from href_dismissal_reasons s
                    where s.company_id = :company_id');
    q.Refer_Field('employment_source_name',
                  'employment_source_id',
                  'href_employment_sources',
                  'source_id',
                  'name',
                  'select * 
                     from href_employment_sources s
                    where s.company_id = :company_id');
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
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Post(p Hashmap) return Hashmap is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Journal_Id number := p.r_Number('journal_id');
    v_User_Id    number := Ui.User_Id;
    result       Hashmap := Hashmap();
  begin
    Hpd_Api.Journal_Post(i_Company_Id => v_Company_Id,
                         i_Filial_Id  => v_Filial_Id,
                         i_Journal_Id => v_Journal_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => v_Company_Id,
                                                                                              i_User_Id         => v_User_Id,
                                                                                              i_Journal_Type_Id => p.r_Number('journal_type_id')),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  
    Result.Put('cos_requests',
               Hisl_Util.Journal_Requests(i_Company_Id => v_Company_Id,
                                          i_Filial_Id  => v_Filial_Id,
                                          i_Journal_Id => v_Journal_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Cos_Response(p Hashmap) is
  begin
    Hisl_Api.Process_Response(i_Company_Id    => Ui.Company_Id,
                              i_Filial_Id     => Ui.Filial_Id,
                              i_Status        => p.r_Varchar2('status'),
                              i_Url           => p.r_Varchar2('url'),
                              i_Request_Body  => p.r_Varchar2('request_body'),
                              i_Response_Body => p.r_Varchar2('response_body'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_User_Id    number := Ui.User_Id;
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Id,
                           i_Journal_Id => p.r_Number('journal_id'));
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Unpost(i_Company_Id      => v_Company_Id,
                                                                                                i_User_Id         => v_User_Id,
                                                                                                i_Journal_Type_Id => p.r_Number('journal_type_id')),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Dismissals
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Hashmap is
    v_Staff_Ids  Array_Number;
    v_Periods    Array_Date;
    v_Matrix     Matrix_Varchar2;
    v_Last_Datas Arraylist := Arraylist();
    result       Hashmap := Hashmap();
  begin
    select Array_Varchar2(w.Dismissal_Date,
                          q.Staff_Id,
                          (select k.Name
                             from Mr_Natural_Persons k
                            where k.Company_Id = i_Company_Id
                              and k.Person_Id = q.Employee_Id),
                          (select k.Staff_Number
                             from Href_Staffs k
                            where k.Company_Id = i_Company_Id
                              and k.Filial_Id = i_Filial_Id
                              and k.Staff_Id = q.Staff_Id),
                          (select k.Name
                             from Href_Dismissal_Reasons k
                            where k.Company_Id = i_Company_Id
                              and k.Dismissal_Reason_Id = w.Dismissal_Reason_Id),
                          (select k.Name
                             from Href_Employment_Sources k
                            where k.Company_Id = i_Company_Id
                              and k.Source_Id = w.Employment_Source_Id),
                          w.Based_On_Doc,
                          w.Note),
           q.Staff_Id,
           w.Dismissal_Date
      bulk collect
      into v_Matrix, v_Staff_Ids, v_Periods
      from Hpd_Journal_Pages q
      join Hpd_Dismissals w
        on w.Company_Id = i_Company_Id
       and w.Filial_Id = i_Filial_Id
       and w.Page_Id = q.Page_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Journal_Id = i_Journal_Id;
  
    Result.Put('dismissals', Fazo.Zip_Matrix(v_Matrix));
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Last_Datas.Push(Uit_Hpd.Get_Staff_Last_Data(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => i_Filial_Id,
                                                    i_Staff_Id   => v_Staff_Ids(i),
                                                    i_Period     => v_Periods(i)));
    end loop;
  
    Result.Put('staff_last_datas', v_Last_Datas);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    r_Setting Hrm_Settings%rowtype;
    result    Hashmap := Hashmap();
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  
    Result.Put('journal_type_id',
               Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal));
    Result.Put('custom_fte_id', Href_Pref.c_Custom_Fte_Id);
    Result.Put_All(z_Hrm_Settings.To_Map(r_Setting,
                                         z.Position_Enable,
                                         z.Parttime_Enable,
                                         z.Rank_Enable,
                                         z.Wage_Scale_Enable));
  
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
  
    if not Hpd_Util.Is_Dismissal_Journal(i_Company_Id      => Ui.Company_Id,
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
  
    Result.Put_All(Get_Dismissals(i_Company_Id => r_Journal.Company_Id,
                                  i_Filial_Id  => r_Journal.Filial_Id,
                                  i_Journal_Id => r_Journal.Journal_Id));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Hpd_Dismissals
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
           Dismissal_Date        = null,
           Dismissal_Reason_Id   = null,
           Employment_Source_Id  = null,
           Based_On_Doc          = null,
           Note                  = null;
    update x_Hpd_Journal_Pages
       set t_Company_Id = null,
           t_Filial_Id  = null,
           Journal_Id   = null,
           Page_Id      = null;
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null;
    update Href_Employment_Sources
       set Company_Id = null,
           Source_Id  = null,
           name       = null;
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
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr429;
/
