create or replace package Ui_Vhr571 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Job return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Funnel return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Langs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Lang_Levels return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Vacancy_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Recruiters return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Olx_Categories return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Exams return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Attributes(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Edit(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Head_Hunter_Response_Load_Data(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------   
  Function Save_And_Publish_Head_Hunter(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------     
  Function Olx_Response_Load_Data(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Save_And_Publish_Olx(p Hashmap) return Runtime_Service;
end Ui_Vhr571;
/
create or replace package body Ui_Vhr571 is
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
  Function Query_Job return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Funnel return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_funnels', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('funnel_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Langs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_langs', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('lang_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Lang_Levels return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_lang_levels',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('lang_level_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Vacancy_Types(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_vacancy_types',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'vacancy_group_id',
                                 p.r_Number('vacancy_group_id'),
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('vacancy_type_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Recruiters return Fazo_Query is
    v_Recruiter_Role_Id number := Md_Util.Role_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Role_Recruiter);
    q                   Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from md_users q
                      where q.company_id = :company_id
                        and q.state = ''A''
                        and exists (select 1
                               from md_user_filials w
                              where w.company_id = q.company_id
                                and w.filial_id = :filial_id
                                and w.user_id = q.user_id)
                        and exists (select 1
                               from md_user_roles r
                              where r.company_id = q.company_id
                                and r.filial_id = :filial_id
                                and r.user_id = q.user_id
                                and r.role_id = :recruiter_role_id)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'recruiter_role_id',
                                 v_Recruiter_Role_Id));
  
    q.Number_Field('user_id');
    q.Varchar2_Field('name');
  
    return q;
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
  Function Query_Exams return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select * 
                       from hln_exams q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = ''A''
                        and q.for_recruitment = ''Y''',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('exam_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Attributes(p Hashmap) return Hashmap is
  begin
    return Uit_Hrec.Get_Olx_Attributes(p.r_Number('category_code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function References(i_Division_Id number := null) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    Result.Put('divisions',
               Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id  => i_Division_Id,
                                                 i_Check_Access => false)));
    Result.Put('vacancy_types', Fazo.Zip_Matrix(Hrec_Util.Head_Hunter_Vacancy_Types));
    Result.Put('billing_types', Fazo.Zip_Matrix(Hrec_Util.Head_Hunter_Billing_Types));
    Result.Put('olx_advertiser_types', Fazo.Zip_Matrix(Hrec_Util.Olx_Advertiser_Types));
  
    select Array_Varchar2(q.Region_Id, q.Name, q.Parent_Id)
      bulk collect
      into v_Matrix
      from Md_Regions q
     where q.Company_Id = Ui.Company_Id
       and q.State = 'A';
  
    Result.Put('regions', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Vacancy_Group_Id, q.Name, q.Is_Required, q.Multiple_Select)
      bulk collect
      into v_Matrix
      from Hrec_Vacancy_Groups q
     where q.Company_Id = Ui.Company_Id
       and q.State = 'A'
     order by q.Order_No;
  
    Result.Put('vacancy_groups', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('opened_date',
                           Trunc(sysdate),
                           'scope',
                           'A',
                           'urgent',
                           'N',
                           'published_head_hunter',
                           'N',
                           'published_olx',
                           'N');
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    v_Matrix        Matrix_Varchar2;
    v_Hh_Published  varchar2(1) := 'N';
    v_Olx_Published varchar2(1) := 'N';
    r_Vacancy       Hrec_Vacancies%rowtype;
    v_Group         Hashmap;
    v_Groups        Arraylist := Arraylist();
    result          Hashmap := Hashmap();
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
                                      z.Division_Id,
                                      z.Job_Id,
                                      z.Funnel_Id,
                                      z.Region_Id,
                                      z.Schedule_Id,
                                      z.Exam_Id,
                                      z.Quantity,
                                      z.Scope,
                                      z.Urgent,
                                      z.Wage_From,
                                      z.Wage_To,
                                      z.Description,
                                      z.Description_In_Html,
                                      z.Status,
                                      z.Note);
  
    Result.Put('exam_name',
               z_Hln_Exams.Take(i_Company_Id => r_Vacancy.Company_Id, i_Filial_Id => r_Vacancy.Filial_Id, i_Exam_Id => r_Vacancy.Exam_Id).Name);
    Result.Put('job_name',
               z_Mhr_Jobs.Load(i_Company_Id => r_Vacancy.Company_Id, i_Filial_Id => r_Vacancy.Filial_Id, i_Job_Id => r_Vacancy.Job_Id).Name);
    Result.Put('funnel_name',
               z_Hrec_Funnels.Load(i_Company_Id => r_Vacancy.Company_Id, i_Funnel_Id => r_Vacancy.Funnel_Id).Name);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Vacancy.Company_Id, i_Filial_Id => r_Vacancy.Filial_Id, i_Schedule_Id => r_Vacancy.Schedule_Id).Name);
    Result.Put('references', References(r_Vacancy.Division_Id));
  
    if z_Hrec_Hh_Published_Vacancies.Exist(i_Company_Id => r_Vacancy.Company_Id,
                                           i_Filial_Id  => r_Vacancy.Filial_Id,
                                           i_Vacancy_Id => r_Vacancy.Vacancy_Id) then
      v_Hh_Published := 'Y';
    end if;
  
    Result.Put('published_head_hunter', v_Hh_Published);
  
    if z_Hrec_Olx_Published_Vacancies.Exist(i_Company_Id => r_Vacancy.Company_Id,
                                            i_Filial_Id  => r_Vacancy.Filial_Id,
                                            i_Vacancy_Id => r_Vacancy.Vacancy_Id) then
      v_Olx_Published := 'Y';
    end if;
  
    Result.Put('published_olx', v_Olx_Published);
  
    -- recruiters
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
  
    -- langs
    select Array_Varchar2(q.Lang_Id,
                          (select w.Name
                             from Href_Langs w
                            where w.Company_Id = q.Company_Id
                              and w.Lang_Id = q.Lang_Id),
                          q.Lang_Level_Id,
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
  
    for r in (select q.Vacancy_Group_Id
                from Hrec_Vacancy_Type_Binds q
               where q.Company_Id = r_Vacancy.Company_Id
                 and q.Filial_Id = r_Vacancy.Filial_Id
                 and q.Vacancy_Id = r_Vacancy.Vacancy_Id
               group by q.Vacancy_Group_Id)
    loop
      v_Matrix := Matrix_Varchar2();
      v_Group  := Hashmap();
    
      v_Group.Put('vacancy_group_id', r.Vacancy_Group_Id);
      v_Group.Put('multiple_select',
                  z_Hrec_Vacancy_Groups.Load(i_Company_Id => r_Vacancy.Company_Id, i_Vacancy_Group_Id => r.Vacancy_Group_Id).Multiple_Select);
    
      select Array_Varchar2(w.Vacancy_Type_Id,
                            (select t.Name
                               from Hrec_Vacancy_Types t
                              where t.Company_Id = w.Company_Id
                                and t.Vacancy_Type_Id = w.Vacancy_Type_Id))
        bulk collect
        into v_Matrix
        from Hrec_Vacancy_Type_Binds w
       where w.Company_Id = r_Vacancy.Company_Id
         and w.Filial_Id = r_Vacancy.Filial_Id
         and w.Vacancy_Id = r_Vacancy.Vacancy_Id
         and w.Vacancy_Group_Id = r.Vacancy_Group_Id;
    
      v_Group.Put('types', Fazo.Zip_Matrix(v_Matrix));
    
      v_Groups.Push(v_Group);
    end loop;
  
    Result.Put('vacancy_groups', v_Groups);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function save
  (
    p             Hashmap,
    i_Vacancy_Id  number,
    i_Closed_Date date := null
  ) return Hashmap is
    v_Vacancy Hrec_Pref.Vacancy_Rt;
    v_Langs   Arraylist := p.o_Arraylist('langs');
    v_Groups  Arraylist := p.o_Arraylist('vacancy_groups');
    v_Hashmap Hashmap;
  begin
    Hrec_Util.Vacancy_New(o_Vacancy             => v_Vacancy,
                          i_Company_Id          => Ui.Company_Id,
                          i_Filial_Id           => Ui.Filial_Id,
                          i_Vacancy_Id          => i_Vacancy_Id,
                          i_Name                => p.r_Varchar2('name'),
                          i_Division_Id         => p.r_Number('division_id'),
                          i_Job_Id              => p.r_Number('job_id'),
                          i_Application_Id      => p.o_Number('application_id'),
                          i_Quantity            => p.r_Number('quantity'),
                          i_Opened_Date         => p.r_Date('opened_date'),
                          i_Closed_Date         => i_Closed_Date,
                          i_Scope               => p.r_Varchar2('scope'),
                          i_Urgent              => p.r_Varchar2('urgent'),
                          i_Funnel_Id           => p.r_Number('funnel_id'),
                          i_Region_Id           => p.o_Number('region_id'),
                          i_Schedule_Id         => p.o_Number('schedule_id'),
                          i_Exam_Id             => p.o_Number('exam_id'),
                          i_Deadline            => p.o_Date('deadline'),
                          i_Wage_From           => p.o_Number('wage_from'),
                          i_Wage_To             => p.o_Number('wage_to'),
                          i_Description         => p.o_Varchar2('description'),
                          i_Description_In_Html => p.o_Varchar2('description_in_html'),
                          i_Status              => Hrec_Pref.c_Vacancy_Status_Open,
                          i_Recruiter_Ids       => p.o_Array_Number('recruiter_id'));
  
    for i in 1 .. v_Langs.Count
    loop
      v_Hashmap := Treat(v_Langs.r_Hashmap(i) as Hashmap);
    
      Hrec_Util.Vacancy_Add_Lang(o_Vacancy       => v_Vacancy,
                                 i_Lang_Id       => v_Hashmap.r_Number('lang_id'),
                                 i_Lang_Level_Id => v_Hashmap.r_Number('lang_level_id'));
    end loop;
  
    for i in 1 .. v_Groups.Count
    loop
      v_Hashmap := Treat(v_Groups.r_Hashmap(i) as Hashmap);
    
      Hrec_Util.Vacancy_Add_Vacancy_Types(o_Vacancy          => v_Vacancy,
                                          i_Vacancy_Group_Id => v_Hashmap.r_Number('vacancy_group_id'),
                                          i_Vacancy_Type_Ids => v_Hashmap.r_Array_Number('vacancy_type_ids'));
    end loop;
  
    Hrec_Api.Vacancy_Save(v_Vacancy);
  
    return Fazo.Zip_Map('vacancy_id', i_Vacancy_Id, 'name', v_Vacancy.Name);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Hrec_Next.Vacancy_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Edit(p Hashmap) return Hashmap is
    r_Vacancy Hrec_Vacancies%rowtype;
  begin
    r_Vacancy := z_Hrec_Vacancies.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Vacancy_Id => p.r_Number('vacancy_id'));
  
    return save(p, r_Vacancy.Vacancy_Id, r_Vacancy.Closed_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Head_Hunter_Response_Load_Data(p Hashmap) return Hashmap is
    r_Vacancy Hrec_Vacancies%rowtype;
  begin
    Hrec_Util.Process_Auth_Response_Errors(p);
  
    Hrec_Api.Hh_Published_Vacancy_Save(i_Company_Id   => Ui.Company_Id,
                                       i_Filial_Id    => Ui.Filial_Id,
                                       i_Vacancy_Id   => g_Vacancy_Id,
                                       i_Vacancy_Code => p.r_Varchar2('id'),
                                       i_Billing_Type => g_Billing_Type,
                                       i_Vacancy_Type => g_Vacancy_Type);
  
    r_Vacancy := z_Hrec_Vacancies.Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Vacancy_Id => g_Vacancy_Id);
  
    return Fazo.Zip_Map('vacancy_id', r_Vacancy.Vacancy_Id, 'name', r_Vacancy.Name);
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Save_And_Publish_Head_Hunter(p Hashmap) return Runtime_Service is
    v_Vacancy_Id   number := Coalesce(p.o_Number('vacancy_id'), Hrec_Next.Vacancy_Id);
    v_Billing_Type varchar2(50) := p.r_Varchar2('billing_type');
    v_Vacancy_Type varchar2(50) := p.r_Varchar2('vacancy_type');
    v_Result       Hashmap;
    v_Data         Gmap;
  begin
    -- save
    v_Result := save(p, v_Vacancy_Id);
  
    -- publish
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
                                            i_Responce_Procedure => 'Ui_Vhr571.Head_Hunter_Response_Load_Data',
                                            i_Data               => v_Data);
  end;

  ----------------------------------------------------------------------------------------------------     
  Function Olx_Response_Load_Data(p Hashmap) return Hashmap is
    v_Arraylist         Arraylist;
    v_Data              Hashmap;
    v_Result            Hashmap;
    r_Vacancy           Hrec_Vacancies%rowtype;
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
  
    r_Vacancy := z_Hrec_Vacancies.Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Vacancy_Id => g_Vacancy_Id);
  
    return Fazo.Zip_Map('vacancy_id', r_Vacancy.Vacancy_Id, 'name', r_Vacancy.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_And_Publish_Olx(p Hashmap) return Runtime_Service is
    v_Vacancy_Id number := Coalesce(p.o_Number('vacancy_id'), Hrec_Next.Vacancy_Id);
    v_Attributes Arraylist := p.r_Arraylist('attributes');
    v_Attribute  Hashmap := Hashmap();
    v_Result     Hashmap;
    v_Data       Gmap := Gmap();
    v_Arraylist  Glist := Glist();
    v_Dummy      Gmap;
  begin
    if z_Hrec_Olx_Published_Vacancies.Exist(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Vacancy_Id => v_Vacancy_Id) then
      Hrec_Error.Raise_027(p.r_Varchar2('name'));
    end if;
  
    -- save
    v_Result := save(p, v_Vacancy_Id);
  
    -- publish
    Init_Globals(i_Vacancy_Id => v_Vacancy_Id, i_Category_Code => p.r_Number('category_code'));
  
    v_Data.Put('title', p.r_Varchar2('name'));
    v_Data.Put('description', p.r_Varchar2('description_in_html'));
    v_Data.Put('category_id', p.r_Number('category_code'));
    v_Data.Put('advertiser_type', p.r_Varchar2('advertiser_type'));
  
    v_Dummy := Gmap();
    v_Dummy.Put('value_from', p.r_Number('wage_from'));
    v_Dummy.Put('type', Hrec_Pref.c_Olx_Salary_Type_Monthly);
  
    v_Data.Put('salary', v_Dummy);
  
    v_Dummy := Gmap();
    v_Dummy.Put('name',
                z_Md_Users.Load(i_Company_Id => Ui.Company_Id, i_User_Id => Ui.User_Id).Name);
    v_Dummy.Put('phone',
                z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => Ui.User_Id).Phone);
  
    v_Data.Put('contact', v_Dummy);
    v_Data.Put('location', Uit_Hrec.Get_Olx_City_Code(p.r_Number('region_id')));
  
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
                                        i_Responce_Procedure => 'Ui_Vhr571.Olx_Response_Load_Data',
                                        i_Data               => v_Data);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Href_Langs
       set Company_Id = null,
           Lang_Id    = null,
           name       = null,
           State      = null;
    update Href_Lang_Levels
       set Company_Id    = null,
           Lang_Level_Id = null,
           name          = null,
           State         = null;
    update Hrec_Vacancy_Types
       set Company_Id       = null,
           Vacancy_Type_Id  = null,
           Vacancy_Group_Id = null,
           name             = null,
           State            = null;
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
    update Hrec_Funnels
       set Company_Id = null,
           Funnel_Id  = null,
           name       = null,
           State      = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null,
           State      = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
    update Md_User_Roles
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null,
           Role_Id    = null;
    update Hrec_Olx_Job_Categories
       set Company_Id    = null,
           Category_Code = null,
           name          = null;
    update Hln_Exams
       set Company_Id = null,
           Filial_Id  = null,
           Exam_Id    = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr571;
/
