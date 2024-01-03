create or replace package Ui_Vhr573 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Olx_Categories return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Attributes(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Head_Hunter_Response_Load_Data(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Function Publish_Head_Hunter(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------     
  Procedure Olx_Response_Load_Data(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Publish_Olx(p Hashmap) return Runtime_Service;
end Ui_Vhr573;
/
create or replace package body Ui_Vhr573 is
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
  Function Get_Attributes(p Hashmap) return Hashmap is
  begin
    return Uit_Hrec.Get_Olx_Attributes(p.r_Number('category_code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('vacancy_types', Fazo.Zip_Matrix(Hrec_Util.Head_Hunter_Vacancy_Types));
    Result.Put('billing_types', Fazo.Zip_Matrix(Hrec_Util.Head_Hunter_Billing_Types));
    Result.Put('olx_advertiser_types', Fazo.Zip_Matrix(Hrec_Util.Olx_Advertiser_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Vacancy         Hrec_Vacancies%rowtype;
    v_Accept_Stage_Id number := Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => Ui.Company_Id,
                                                            i_Pcode      => Hrec_Pref.c_Pcode_Stage_Accepted);
    v_Count           number;
    v_Published       varchar2(1) := 'N';
    v_Matrix          Matrix_Varchar2;
    result            Hashmap := Hashmap();
  begin
    r_Vacancy := z_Hrec_Vacancies.Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Vacancy_Id => p.r_Number('vacancy_id'));
  
    result := z_Hrec_Vacancies.To_Map(r_Vacancy,
                                      z.Vacancy_Id,
                                      z.Name,
                                      z.Opened_Date,
                                      z.Closed_Date,
                                      z.Deadline,
                                      z.Quantity,
                                      z.Urgent,
                                      z.Wage_From,
                                      z.Wage_To,
                                      z.Description_In_Html,
                                      z.Status,
                                      z.Created_On,
                                      z.Modified_On);
  
    Result.Put('application_number',
               z_Hrec_Applications.Take(i_Company_Id => r_Vacancy.Company_Id, i_Filial_Id => r_Vacancy.Filial_Id, i_Application_Id => r_Vacancy.Application_Id).Application_Number);
    Result.Put('division_name',
               z_Mhr_Divisions.Load(i_Company_Id => r_Vacancy.Company_Id, i_Filial_Id => r_Vacancy.Filial_Id, i_Division_Id => r_Vacancy.Division_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Vacancy.Company_Id, i_Filial_Id => r_Vacancy.Filial_Id, i_Job_Id => r_Vacancy.Job_Id).Name);
    Result.Put('funnel_name',
               z_Hrec_Funnels.Load(i_Company_Id => r_Vacancy.Company_Id, i_Funnel_Id => r_Vacancy.Funnel_Id).Name);
    Result.Put('region_name',
               z_Md_Regions.Take(i_Company_Id => r_Vacancy.Company_Id, i_Region_Id => r_Vacancy.Region_Id).Name);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Vacancy.Company_Id, i_Filial_Id => r_Vacancy.Filial_Id, i_Schedule_Id => r_Vacancy.Schedule_Id).Name);
    Result.Put('exam_name',
               z_Hln_Exams.Take(i_Company_Id => r_Vacancy.Company_Id, i_Filial_Id => r_Vacancy.Filial_Id, i_Exam_Id => r_Vacancy.Exam_Id).Name);
    Result.Put('scope_name', Hrec_Util.t_Vacancy_Scope(r_Vacancy.Scope));
    Result.Put('urgent_name', Md_Util.Decode(r_Vacancy.Urgent, 'Y', Ui.t_Yes, 'N', Ui.t_No));
    Result.Put('status_name', Hrec_Util.t_Vacancy_Status(r_Vacancy.Status));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Vacancy.Company_Id, i_User_Id => r_Vacancy.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Vacancy.Company_Id, i_User_Id => r_Vacancy.Modified_By).Name);
  
    select count(*)
      into v_Count
      from Hrec_Vacancy_Candidates q
     where q.Company_Id = r_Vacancy.Company_Id
       and q.Filial_Id = r_Vacancy.Filial_Id
       and q.Vacancy_Id = r_Vacancy.Vacancy_Id
       and q.Stage_Id = v_Accept_Stage_Id;
  
    Result.Put('accepted_count', v_Count);
  
    -- published vacancies   
    if z_Hrec_Hh_Published_Vacancies.Exist(i_Company_Id => r_Vacancy.Company_Id,
                                           i_Filial_Id  => r_Vacancy.Filial_Id,
                                           i_Vacancy_Id => r_Vacancy.Vacancy_Id) then
      v_Published := 'Y';
    end if;
  
    Result.Put('head_hunter_published', v_Published);
  
    v_Published := 'N';
    if z_Hrec_Olx_Published_Vacancies.Exist(i_Company_Id => r_Vacancy.Company_Id,
                                            i_Filial_Id  => r_Vacancy.Filial_Id,
                                            i_Vacancy_Id => r_Vacancy.Vacancy_Id) then
      v_Published := 'Y';
    end if;
  
    Result.Put('olx_published', v_Published);
  
    -- Recruiters 
    select Array_Varchar2(q.User_Id,
                          (select w.Name
                             from Md_Users w
                            where w.Company_Id = q.Company_Id
                              and w.User_Id = q.User_Id))
      bulk collect
      into v_Matrix
      from Hrec_Vacancy_Recruiters q
     where q.Company_Id = r_Vacancy.Company_Id
       and q.Filial_Id = r_Vacancy.Filial_Id
       and q.Vacancy_Id = r_Vacancy.Vacancy_Id;
  
    Result.Put('recruiters', Fazo.Zip_Matrix(v_Matrix));
  
    -- lang levels
    select Array_Varchar2((select w.Name
                            from Href_Langs w
                           where w.Company_Id = q.Company_Id
                             and w.Lang_Id = q.Lang_Id),
                          (select w.Name
                             from Href_Lang_Levels w
                            where w.Company_Id = q.Company_Id
                              and w.Lang_Level_Id = q.Lang_Level_Id))
      bulk collect
      into v_Matrix
      from Hrec_Vacancy_Langs q
     where q.Company_Id = r_Vacancy.Company_Id
       and q.Filial_Id = r_Vacancy.Filial_Id
       and q.Vacancy_Id = r_Vacancy.Vacancy_Id;
  
    Result.Put('langs', Fazo.Zip_Matrix(v_Matrix));
  
    -- vacancy types
    select Array_Varchar2((select w.Name
                            from Hrec_Vacancy_Groups w
                           where w.Company_Id = q.Company_Id
                             and w.Vacancy_Group_Id = q.Vacancy_Group_Id),
                          (select Listagg(t.Name, ', ')
                             from Hrec_Vacancy_Types t
                            where t.Company_Id = q.Company_Id
                              and t.Vacancy_Type_Id in
                                  (select r.Vacancy_Type_Id
                                     from Hrec_Vacancy_Type_Binds r
                                    where r.Company_Id = q.Company_Id
                                      and r.Vacancy_Id = q.Vacancy_Id
                                      and r.Vacancy_Group_Id = q.Vacancy_Group_Id)))
      bulk collect
      into v_Matrix
      from Hrec_Vacancy_Type_Binds q
     where q.Company_Id = r_Vacancy.Company_Id
       and q.Filial_Id = r_Vacancy.Filial_Id
       and q.Vacancy_Id = r_Vacancy.Vacancy_Id
     group by q.Company_Id, q.Vacancy_Id, q.Vacancy_Group_Id;
  
    Result.Put('types', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('references', References);
  
    return result;
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
                                            i_Responce_Procedure => 'Ui_Vhr573.Head_Hunter_Response_Load_Data',
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
      Hrec_Error.Raise_031(r_Vacancy.Name);
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
                                        i_Responce_Procedure => 'Ui_Vhr573.Olx_Response_Load_Data',
                                        i_Data               => v_Data,
                                        i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Validation is
  begin
    update Hrec_Olx_Job_Categories
       set Company_Id    = null,
           Category_Code = null,
           name          = null;
  end;

end Ui_Vhr573;
/
