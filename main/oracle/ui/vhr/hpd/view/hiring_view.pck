create or replace package Ui_Vhr399 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Hiring_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Post(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Cos_Response(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr399;
/
create or replace package body Ui_Vhr399 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Hiring_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_hpd_hirings q
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
                   'trial_period',
                   'employment_source_id');
    q.Varchar2_Field('t_event', 't_source_project_code');
    q.Date_Field('t_date', 't_timestamp', 'hiring_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('source_name',
                  'employment_source_id',
                  'href_employment_sources',
                  'source_od',
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
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_User_Id         number := Ui.User_Id;
    v_Journal_Id      number := p.r_Number('journal_id');
    v_Journal_Type_Id number := p.r_Number('journal_type_id');
    result            Hashmap := Hashmap();
  begin
    Hpd_Api.Journal_Post(i_Company_Id => v_Company_Id,
                         i_Filial_Id  => v_Filial_Id,
                         i_Journal_Id => v_Journal_Id);
  
    Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                i_Filial_Id     => v_Filial_Id,
                                i_Title         => Hpd_Util.t_Notification_Title_Journal_Post(i_Company_Id      => v_Company_Id,
                                                                                              i_User_Id         => v_User_Id,
                                                                                              i_Journal_Type_Id => v_Journal_Type_Id),
                                i_Uri           => Hpd_Pref.c_Form_Hiring_Journal_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
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
                              i_Response_Body => p.r_Varchar2('response_body'),
                              i_User_Id       => p.o_Number('user_id'));
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
                                i_Uri           => Hpd_Pref.c_Form_Hiring_Journal_View,
                                i_Uri_Param     => Fazo.Zip_Map('journal_id',
                                                                v_Journal_Id,
                                                                'journal_type_id',
                                                                v_Journal_Type_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Hirings
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Journal_Id number
  ) return Hashmap is
    v_Page_Ids        Array_Number;
    v_Matrix          Matrix_Varchar2;
    v_Custom_Fte_Name varchar2(32767) := Href_Util.t_Custom_Fte_Name;
    result            Hashmap := Hashmap();
  begin
    select Array_Varchar2(Hir.Page_Id,
                           Hir.Hiring_Date,
                           Hir.Source_Name,
                           Hir.Employee_Id,
                           Hir.Staff_Number,
                           Hir.Employee_Name,
                           Hir.Robot_Name,
                           Hir.Schedule_Name,
                           case
                             when Hir.Access_To_Hidden_Salary = 'Y' then
                              Hir.Currency_Name
                             else
                              null
                           end,
                           Hir.Days_Limit,
                           Hir.Employment_Type,
                           Hir.Trial_Period,
                           Hir.Contractual_Wage,
                           Hir.Org_Unit_Name,
                           Hir.Division_Name,
                           Hir.Job_Name,
                           Hir.Rank_Name,
                           Hir.Fte_Id,
                           Hir.Fte_Name,
                           Hir.Fte,
                           case
                             when Hir.Access_To_Hidden_Salary = 'Y' then
                              Hir.Wage_Scale_Name
                             else
                              null
                           end,
                           Hir.Contract_Number,
                           Hir.Contract_Date,
                           Hir.Fixed_Term,
                           Hir.Expiry_Date,
                           Hir.Fixed_Term_Base,
                           Hir.Concluding_Term,
                           Hir.Hiring_Conditions,
                           Hir.Other_Conditions,
                           Hir.Workplace_Equipment,
                           Hir.Representative_Basis,
                           Hir.Access_To_Hidden_Salary,
                           Hir.Is_Booked,
                           Hir.Is_Booked_Name),
           case
             when Hir.Access_To_Hidden_Salary = 'Y' then
              Hir.Page_Id
             else
              null
           end
      bulk collect
      into v_Matrix, v_Page_Ids
      from (select q.Page_Id,
                   w.Hiring_Date,
                   (select k.Name
                      from Href_Employment_Sources k
                     where k.Company_Id = i_Company_Id
                       and k.Source_Id = w.Employment_Source_Id) as Source_Name,
                   q.Employee_Id,
                   (select s.Staff_Number
                      from Href_Staffs s
                     where s.Company_Id = i_Company_Id
                       and s.Filial_Id = i_Filial_Id
                       and s.Staff_Id = q.Staff_Id) as Staff_Number,
                   (select k.Name
                      from Mr_Natural_Persons k
                     where k.Company_Id = i_Company_Id
                       and k.Person_Id = q.Employee_Id) as Employee_Name,
                   t.Name as Robot_Name,
                   (select k.Name
                      from Htt_Schedules k
                     where k.Company_Id = i_Company_Id
                       and k.Filial_Id = i_Filial_Id
                       and k.Schedule_Id = s.Schedule_Id) as Schedule_Name,
                   (select Cr.Name
                      from Mk_Currencies Cr
                     where Cr.Company_Id = Pc.Company_Id
                       and Cr.Currency_Id = Pc.Currency_Id) as Currency_Name,
                   Pl.Days_Limit,
                   Hpd_Util.t_Employment_Type(m.Employment_Type) as Employment_Type,
                   Nullif(w.Trial_Period, 0) as Trial_Period,
                   Hr.Contractual_Wage,
                   (case
                      when Hr.Org_Unit_Id = t.Division_Id then
                       null
                      else
                       (select d.Name
                          from Mhr_Divisions d
                         where d.Company_Id = i_Company_Id
                           and d.Filial_Id = i_Filial_Id
                           and d.Division_Id = Hr.Org_Unit_Id)
                    end) as Org_Unit_Name,
                   (select d.Name
                      from Mhr_Divisions d
                     where d.Company_Id = i_Company_Id
                       and d.Filial_Id = i_Filial_Id
                       and d.Division_Id = t.Division_Id) as Division_Name,
                   (select k.Name
                      from Mhr_Jobs k
                     where k.Company_Id = i_Company_Id
                       and k.Filial_Id = i_Filial_Id
                       and k.Job_Id = t.Job_Id) as Job_Name,
                   (select k.Name
                      from Mhr_Ranks k
                     where k.Company_Id = i_Company_Id
                       and k.Filial_Id = i_Filial_Id
                       and k.Rank_Id = Nvl(m.Rank_Id, Hr.Rank_Id)) as Rank_Name,
                   Nvl(m.Fte_Id, Href_Pref.c_Custom_Fte_Id) as Fte_Id,
                   Nvl((select Hf.Name
                         from Href_Ftes Hf
                        where Hf.Company_Id = i_Company_Id
                          and Hf.Fte_Id = m.Fte_Id),
                       v_Custom_Fte_Name) as Fte_Name,
                   m.Fte,
                   m.Is_Booked,
                   Decode(m.Is_Booked, 'Y', Ui.t_Yes, 'N', Ui.t_No) Is_Booked_Name,
                   (select k.Name
                      from Hrm_Wage_Scales k
                     where k.Company_Id = Hr.Company_Id
                       and k.Filial_Id = Hr.Filial_Id
                       and k.Wage_Scale_Id = Hr.Wage_Scale_Id) as Wage_Scale_Name,
                   c.Contract_Number,
                   c.Contract_Date,
                   c.Fixed_Term,
                   c.Expiry_Date,
                   (select k.Name
                      from Href_Fixed_Term_Bases k
                     where k.Company_Id = i_Company_Id
                       and k.Fixed_Term_Base_Id = c.Fixed_Term_Base_Id) as Fixed_Term_Base,
                   c.Concluding_Term,
                   c.Hiring_Conditions,
                   c.Other_Conditions,
                   c.Workplace_Equipment,
                   c.Representative_Basis,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => t.Job_Id,
                                                       i_Employee_Id => q.Employee_Id) as Access_To_Hidden_Salary
              from Hpd_Journal_Pages q
              join Hpd_Hirings w
                on w.Company_Id = i_Company_Id
               and w.Filial_Id = i_Filial_Id
               and w.Page_Id = q.Page_Id
              left join Hpd_Page_Robots m
                on m.Company_Id = i_Company_Id
               and m.Filial_Id = i_Filial_Id
               and m.Page_Id = q.Page_Id
              left join Hpd_Page_Schedules s
                on s.Company_Id = i_Company_Id
               and s.Filial_Id = i_Filial_Id
               and s.Page_Id = q.Page_Id
              left join Hpd_Page_Currencies Pc
                on Pc.Company_Id = q.Company_Id
               and Pc.Filial_Id = q.Filial_Id
               and Pc.Page_Id = q.Page_Id
              left join Hpd_Page_Vacation_Limits Pl
                on Pl.Company_Id = i_Company_Id
               and Pl.Filial_Id = i_Filial_Id
               and Pl.Page_Id = q.Page_Id
              left join Hpd_Page_Contracts c
                on c.Company_Id = i_Company_Id
               and c.Filial_Id = i_Filial_Id
               and c.Page_Id = q.Page_Id
              left join Mrf_Robots t
                on t.Company_Id = i_Company_Id
               and t.Filial_Id = i_Filial_Id
               and t.Robot_Id = m.Robot_Id
              left join Hrm_Robots Hr
                on Hr.Company_Id = i_Company_Id
               and Hr.Filial_Id = i_Filial_Id
               and Hr.Robot_Id = m.Robot_Id
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Journal_Id = i_Journal_Id) Hir;
  
    Result.Put('hirings', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Page_Id, q.Oper_Type_Id, w.Name)
      bulk collect
      into v_Matrix
      from Hpd_Page_Oper_Types q
      join Mpr_Oper_Types w
        on w.Company_Id = i_Company_Id
       and w.Oper_Type_Id = q.Oper_Type_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Page_Id in (select *
                           from table(v_Page_Ids)
                          where Column_Value is not null)
     order by w.Name;
  
    Result.Put('oper_types', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Page_Id,
                          q.Oper_Type_Id,
                          w.Indicator_Id,
                          w.Name,
                          (select w.Indicator_Value
                             from Hpd_Page_Indicators w
                            where w.Company_Id = i_Company_Id
                              and w.Filial_Id = i_Filial_Id
                              and w.Page_Id = q.Page_Id
                              and w.Indicator_Id = q.Indicator_Id))
      bulk collect
      into v_Matrix
      from Hpd_Oper_Type_Indicators q
      join Href_Indicators w
        on w.Company_Id = i_Company_Id
       and w.Indicator_Id = q.Indicator_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Page_Id in (select *
                           from table(v_Page_Ids)
                          where Column_Value is not null)
     order by w.Name;
  
    Result.Put('oper_type_indicators', Fazo.Zip_Matrix(v_Matrix));
  
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
                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring));
    Result.Put('custom_fte_id', Href_Pref.c_Custom_Fte_Id);
    Result.Put_All(z_Hrm_Settings.To_Map(r_Setting,
                                         z.Position_Enable,
                                         z.Position_Booking,
                                         z.Parttime_Enable,
                                         z.Rank_Enable,
                                         z.Wage_Scale_Enable,
                                         z.Advanced_Org_Structure));
  
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
  
    if not Hpd_Util.Is_Hiring_Journal(i_Company_Id      => Ui.Company_Id,
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
  
    Result.Put_All(Get_Hirings(i_Company_Id => r_Journal.Company_Id,
                               i_Filial_Id  => r_Journal.Filial_Id,
                               i_Journal_Id => r_Journal.Journal_Id));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Hpd_Hirings
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
           Hiring_Date           = null,
           Trial_Period          = null,
           Employment_Source_Id  = null;
    update x_Hpd_Journal_Pages
       set t_Company_Id = null,
           t_Filial_Id  = null,
           Journal_Id   = null,
           Page_Id      = null;
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

end Ui_Vhr399;
/
