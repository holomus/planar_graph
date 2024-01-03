create or replace package Ui_Vhr570 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Olx_Categories return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Attributes(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Head_Hunter_Response_Load_Data(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Function Publish_Head_Hunter(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------     
  Procedure Olx_Response_Load_Data(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Publish_Olx(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr570;
/
create or replace package body Ui_Vhr570 is
  ----------------------------------------------------------------------------------------------------  
  g_Vacancy_Id    number;
  g_Billing_Type  varchar2(50 char);
  g_Vacancy_Type  varchar2(50 char);
  g_Category_Code number;
  ----------------------------------------------------------------------------------------------------  
  Procedure Init_Globals
  (
    i_Vacancy_Id    number,
    i_Billing_Type  varchar2 := null,
    i_Vacancy_Type  varchar2 := null,
    i_Category_Code number := null
  ) is
  begin
    g_Vacancy_Id    := i_Vacancy_Id;
    g_Billing_Type  := i_Billing_Type;
    g_Vacancy_Type  := i_Vacancy_Type;
    g_Category_Code := i_Category_Code;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Olx_Categories return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_olx_job_categories', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('category_code');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select vc.*,
                            case
                             when exists (select ps.vacancy_code
                                     from hrec_hh_published_vacancies ps
                                    where ps.company_id = vc.company_id
                                      and ps.filial_id = vc.filial_id
                                      and ps.vacancy_id = vc.vacancy_id) then
                              ''Y''
                             else
                              ''N''
                            end as published_head_hunter,
                            case
                              when exists (select ps.vacancy_code
                                      from hrec_olx_published_vacancies ps
                                     where ps.company_id = vc.company_id
                                       and ps.filial_id = vc.filial_id
                                       and ps.vacancy_id = vc.vacancy_id) then
                               ''Y''
                              else
                               ''N''
                            end as published_olx
                       from hrec_vacancies vc
                      where vc.company_id = :company_id
                        and vc.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('vacancy_id',
                   'application_id',
                   'division_id',
                   'job_id',
                   'funnel_id',
                   'region_id',
                   'quantity',
                   'created_by',
                   'modified_by');
    q.Number_Field('wage_from', 'wage_to', 'schedule_id', 'exam_id');
    q.Varchar2_Field('name',
                     'scope',
                     'urgent',
                     'status',
                     'description',
                     'description_in_html',
                     'published_head_hunter',
                     'published_olx');
    q.Date_Field('opened_date', 'closed_date', 'deadline', 'created_on', 'modified_on');
  
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select *
                     from htt_schedules t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('exam_name',
                  'exam_id',
                  'hln_exams',
                  'exam_id',
                  'name',
                  'select *
                     from hln_exams t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('application_number',
                  'application_id',
                  'hrec_applications',
                  'application_id',
                  'application_number',
                  'select *
                     from hrec_applications t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select * 
                     from mhr_jobs w 
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('funnel_name',
                  'funnel_id',
                  'hrec_funnels',
                  'funnel_id',
                  'name',
                  'select * 
                     from hrec_funnels w 
                    where w.company_id = :company_id');
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select *
                     from md_regions w
                    where w.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select s.* 
                     from md_users s 
                    where s.company_id = :company_id
                      and exists (select 1 
                             from md_user_filials w
                            where w.company_id = :company_id
                              and w.user_id = s.user_id
                              and w.filial_id = :filial_id)');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select s.* 
                     from md_users s 
                    where s.company_id = :company_id
                    and exists (select 1 
                           from md_user_filials w
                          where w.company_id = :company_id
                            and w.user_id = s.user_id
                            and w.filial_id = :filial_id)');
  
    v_Matrix := Hrec_Util.Vacancy_Scopes;
  
    q.Option_Field('scope_name', 'scope', v_Matrix(1), v_Matrix(2));
    q.Option_Field('urgent_name',
                   'urgent',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('published_head_hunter_name',
                   'published_head_hunter',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('published_olx_name',
                   'published_olx',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    v_Matrix := Hrec_Util.Vacancy_Statuses;
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('vacancy_types', Fazo.Zip_Matrix(Hrec_Util.Head_Hunter_Vacancy_Types));
    Result.Put('billing_types', Fazo.Zip_Matrix(Hrec_Util.Head_Hunter_Billing_Types));
    Result.Put('olx_advertiser_types', Fazo.Zip_Matrix(Hrec_Util.Olx_Advertiser_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Attributes(p Hashmap) return Hashmap is
  begin
    return Uit_Hrec.Get_Olx_Attributes(p.r_Number('category_code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Head_Hunter_Response_Load_Data(p Hashmap) is
  begin
    Hrec_Util.Process_Auth_Response_Errors(p);
  
    Hrec_Api.Hh_Published_Vacancy_Save(i_Company_Id   => Ui.Company_Id,
                                       i_Filial_Id    => Ui.Filial_Id,
                                       i_Vacancy_Id   => g_Vacancy_Id,
                                       i_Vacancy_Code => p.r_Varchar2('id'),
                                       i_Billing_Type => g_Billing_Type,
                                       i_Vacancy_Type => g_Vacancy_Type);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Publish_Head_Hunter(p Hashmap) return Runtime_Service is
    v_Vacancy_Id   number := p.r_Number('vacancy_id');
    v_Billing_Type varchar2(50) := p.r_Varchar2('billing_type');
    v_Vacancy_Type varchar2(50) := p.r_Varchar2('vacancy_type');
    v_Data         Gmap;
  begin
    Init_Globals(i_Vacancy_Id   => v_Vacancy_Id,
                 i_Billing_Type => v_Billing_Type,
                 i_Vacancy_Type => v_Vacancy_Type);
  
    v_Data := Uit_Hrec.Prepare_Publish_Hh_Data(i_Vacancy_Id   => v_Vacancy_Id,
                                               i_Billing_Type => v_Billing_Type,
                                               i_Vacancy_Type => v_Vacancy_Type);
  
    return Hrec_Api.Vacancy_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                            i_User_Id            => Ui.User_Id,
                                            i_Host_Uri           => Hrec_Pref.c_Head_Hunter_Api_Url,
                                            i_Api_Uri            => Hrec_Pref.c_Save_Vacancy_Url,
                                            i_Api_Method         => Href_Pref.c_Http_Method_Post,
                                            i_Responce_Procedure => 'Ui_Vhr570.Head_Hunter_Response_Load_Data',
                                            i_Data               => v_Data,
                                            i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------     
  Procedure Olx_Response_Load_Data(p Hashmap) is
    v_Arraylist         Arraylist;
    v_Data              Hashmap;
    v_Result            Hashmap;
    v_Published_Vacancy Hrec_Pref.Olx_Published_Vacancy_Rt;
    v_Attribute         Hrec_Pref.Olx_Vacancy_Attributes_Rt;
  begin
    Uit_Hrec.Check_Responce_Error(p);
  
    v_Result    := p.r_Hashmap('data');
    v_Arraylist := v_Result.r_Arraylist('attributes');
  
    v_Published_Vacancy.Company_Id   := Ui.Company_Id;
    v_Published_Vacancy.Filial_Id    := Ui.Filial_Id;
    v_Published_Vacancy.Vacancy_Id   := g_Vacancy_Id;
    v_Published_Vacancy.Vacancy_Code := v_Result.r_Number('id');
    v_Published_Vacancy.Attributes   := Hrec_Pref.Olx_Vacancy_Attributes_Nt();
  
    for i in 1 .. v_Arraylist.Count
    loop
      v_Data := Treat(v_Arraylist.r_Hashmap(i) as Hashmap);
    
      v_Attribute               := Hrec_Pref.Olx_Vacancy_Attributes_Rt();
      v_Attribute.Category_Code := g_Category_Code;
      v_Attribute.Code          := v_Data.r_Varchar2('code');
      v_Attribute.Value         := v_Data.r_Varchar2('value');
    
      v_Published_Vacancy.Attributes.Extend;
      v_Published_Vacancy.Attributes(v_Published_Vacancy.Attributes.Count) := v_Attribute;
    end loop;
  
    Hrec_Api.Olx_Published_Vacancy_Save(v_Published_Vacancy);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Publish_Olx(p Hashmap) return Runtime_Service is
    v_Vacancy_Id number := p.r_Number('vacancy_id');
    v_Attributes Arraylist := p.r_Arraylist('attributes');
    v_Attribute  Hashmap := Hashmap();
    v_Data       Gmap := Gmap();
    v_Arraylist  Glist := Glist();
    v_Dummy      Gmap;
    r_Vacancy    Hrec_Vacancies%rowtype;
  begin
    r_Vacancy := z_Hrec_Vacancies.Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Vacancy_Id => v_Vacancy_Id);
  
    if z_Hrec_Olx_Published_Vacancies.Exist(i_Company_Id => r_Vacancy.Company_Id,
                                            i_Filial_Id  => r_Vacancy.Filial_Id,
                                            i_Vacancy_Id => r_Vacancy.Vacancy_Id) then
      Hrec_Error.Raise_029(r_Vacancy.Name);
    end if;
  
    -- publish
    Init_Globals(i_Vacancy_Id => v_Vacancy_Id, i_Category_Code => p.r_Number('category_code'));
  
    v_Data.Put('title', r_Vacancy.Name);
    v_Data.Put('description', r_Vacancy.Description_In_Html);
    v_Data.Put('category_id', p.r_Number('category_code'));
    v_Data.Put('advertiser_type', p.r_Varchar2('advertiser_type'));
  
    v_Dummy := Gmap();
    v_Dummy.Put('value_from', r_Vacancy.Wage_From);
    v_Dummy.Put('type', Hrec_Pref.c_Olx_Salary_Type_Monthly);
  
    v_Data.Put('salary', v_Dummy);
  
    v_Dummy := Gmap();
    v_Dummy.Put('name',
                z_Md_Users.Load(i_Company_Id => Ui.Company_Id, i_User_Id => Ui.User_Id).Name);
    v_Dummy.Put('phone',
                z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => Ui.User_Id).Phone);
  
    v_Data.Put('contact', v_Dummy);
    v_Data.Put('location', Uit_Hrec.Get_Olx_City_Code(r_Vacancy.Region_Id));
  
    for i in 1 .. v_Attributes.Count
    loop
      v_Attribute := Treat(v_Attributes.r_Hashmap(i) as Hashmap);
      v_Dummy     := Gmap();
    
      v_Dummy.Put('code', v_Attribute.r_Varchar2('attribute_code'));
      v_Dummy.Put('value', v_Attribute.r_Varchar2('value_code'));
    
      v_Arraylist.Push(v_Dummy.Val);
    end loop;
  
    v_Data.Put('attributes', v_Arraylist);
  
    return Hrec_Api.Olx_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                        i_User_Id            => Ui.User_Id,
                                        i_Host_Uri           => Hrec_Pref.c_Olx_Api_Url,
                                        i_Api_Uri            => Hrec_Pref.c_Olx_Post_Adverts_Url,
                                        i_Api_Method         => Href_Pref.c_Http_Method_Post,
                                        i_Responce_Procedure => 'Ui_Vhr570.Olx_Response_Load_Data',
                                        i_Data               => v_Data,
                                        i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Vacancy_Ids Array_Number := Fazo.Sort(p.r_Array_Number('vacancy_id'));
  begin
    for i in 1 .. v_Vacancy_Ids.Count
    loop
      Hrec_Api.Vacancy_Delete(i_Company_Id => v_Company_Id,
                              i_Filial_Id  => v_Filial_Id,
                              i_Vacancy_Id => v_Vacancy_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hrec_Vacancies
       set Company_Id          = null,
           Filial_Id           = null,
           Vacancy_Id          = null,
           name                = null,
           Opened_Date         = null,
           Closed_Date         = null,
           Deadline            = null,
           Division_Id         = null,
           Job_Id              = null,
           Funnel_Id           = null,
           Region_Id           = null,
           Schedule_Id         = null,
           Exam_Id             = null,
           Quantity            = null,
           Scope               = null,
           Urgent              = null,
           Wage_From           = null,
           Wage_To             = null,
           Status              = null,
           Description         = null,
           Description_In_Html = null,
           Created_By          = null,
           Created_On          = null,
           Modified_By         = null,
           Modified_On         = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null;
    update Hrec_Funnels
       set Company_Id = null,
           Funnel_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
    update Hrec_Hh_Published_Vacancies
       set Company_Id   = null,
           Filial_Id    = null,
           Vacancy_Id   = null,
           Vacancy_Code = null;
    update Hrec_Olx_Published_Vacancies
       set Company_Id   = null,
           Filial_Id    = null,
           Vacancy_Id   = null,
           Vacancy_Code = null;
    update Hrec_Olx_Job_Categories
       set Company_Id    = null,
           Category_Code = null,
           name          = null;
    update Hln_Exams
       set Company_Id = null,
           Filial_Id  = null,
           Exam_Id    = null,
           name       = null;
  end;

end Ui_Vhr570;
/
