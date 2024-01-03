create or replace package Ui_Vhr614 is
  ----------------------------------------------------------------------------------------------------
  Function Query_System_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Hh_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_System_Regions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Hh_Regions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_System_Stages return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Function Query_Hh_Langs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Function Query_System_Langs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Function Query_Hh_Lang_Levels return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Function Query_System_Lang_Levels return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Function Query_Hh_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Function Query_System_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Function Query_Hh_Experiences return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Function Query_Hh_Employments return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Function Query_Hh_Driver_Licences return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_System_Vacancy_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Load_Response_Regions(p Arraylist);
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Jobs(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Load_Response_Languages(p Arraylist);
  ----------------------------------------------------------------------------------------------------  
  Procedure Load_Responce_Dictionaries(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Function Sync_Jobs return Runtime_Service;
  ----------------------------------------------------------------------------------------------------  
  Function Sync_Regions return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Sync_Langs return Runtime_Service;
  ----------------------------------------------------------------------------------------------------  
  Function Sync_Dictionaries return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Data_Map(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Save_Auth_Credentials(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Auth_Credentials;
  ----------------------------------------------------------------------------------------------------  
  Procedure Load_Response_Webhook_Subscribe(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Webhook_Unsubscribe(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Webhook_Subscribe(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------  
  Function Webhook_Unsubscribe return Runtime_Service;
end Ui_Vhr614;
/
create or replace package body Ui_Vhr614 is
  ----------------------------------------------------------------------------------------------------
  Function Query_System_Jobs return Fazo_Query is
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
  Function Query_Hh_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_head_hunter_jobs', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('code');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_System_Regions return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('md_regions', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('region_id', 'parent_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Hh_Regions return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_head_hunter_regions', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('code', 'parent_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_System_Stages return Fazo_Query is
    v_Todo_Stage_Id number := Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => Ui.Company_Id,
                                                          i_Pcode      => Hrec_Pref.c_Pcode_Stage_Todo);
    q               Fazo_Query;
  begin
    q := Fazo_Query('select w.*
                       from hrec_stages w
                      where w.company_id = :company_id
                        and w.stage_id <> :todo_stage_id
                        and w.state = :state',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'state',
                                 'A',
                                 'todo_stage_id',
                                 v_Todo_Stage_Id));
  
    q.Number_Field('stage_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Query_Hh_Langs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_hh_langs', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Varchar2_Field('code', 'name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Query_System_Langs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_langs', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('lang_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Query_Hh_Lang_Levels return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_hh_lang_levels', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Varchar2_Field('code', 'name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Query_System_Lang_Levels return Fazo_Query is
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
  Function Query_Hh_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_hh_schedules', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Varchar2_Field('code', 'name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Query_System_Schedules return Fazo_Query is
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
  Function Query_Hh_Experiences return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_hh_experiences', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Varchar2_Field('code', 'name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Query_Hh_Employments return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_hh_employments', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Varchar2_Field('name', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Query_Hh_Driver_Licences return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_hh_driver_licences', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Varchar2_Field('name', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_System_Vacancy_Types(p Hashmap) return Fazo_Query is
    v_Vacancy_Group_Id number := Hrec_Util.Vacancy_Group_Id_By_Pcode(i_Company_Id => Ui.Company_Id,
                                                                     i_Pcode      => p.r_Varchar2('pcode'));
    q                  Fazo_Query;
  begin
    q := Fazo_Query('hrec_vacancy_types',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'vacancy_group_id',
                                 v_Vacancy_Group_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('vacancy_type_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    v_Company_Id  number := Ui.Company_Id;
    v_Matrix      Matrix_Varchar2;
    v_Count       number;
    v_Jobs        Arraylist := Arraylist();
    v_Job         Hashmap;
    v_Subscribed  varchar2(1) := 'N';
    r_Credentials Hes_Oauth2_Credentials%rowtype;
    result        Hashmap := Hashmap();
  begin
    if not Ui.Is_Filial_Head then
      for r in (select q.Job_Code,
                       (select w.Name
                          from Hrec_Head_Hunter_Jobs w
                         where w.Company_Id = q.Company_Id
                           and w.Code = q.Job_Code) as Hh_Job_Name
                  from Hrec_Hh_Integration_Jobs q
                 where q.Company_Id = v_Company_Id
                   and q.Filial_Id = Ui.Filial_Id
                 group by q.Company_Id, q.Filial_Id, q.Job_Code)
      loop
        v_Job := Hashmap();
        v_Job.Put('job_code', r.Job_Code);
        v_Job.Put('hh_job_name', r.Hh_Job_Name);
      
        select Array_Varchar2(t.Job_Id,
                              (select w.Name
                                 from Mhr_Jobs w
                                where w.Company_Id = t.Company_Id
                                  and w.Filial_Id = t.Filial_Id
                                  and w.Job_Id = t.Job_Id))
          bulk collect
          into v_Matrix
          from Hrec_Hh_Integration_Jobs t
         where t.Company_Id = v_Company_Id
           and t.Filial_Id = Ui.Filial_Id
           and t.Job_Code = r.Job_Code;
      
        v_Job.Put('jobs', Fazo.Zip_Matrix(v_Matrix));
      
        v_Jobs.Push(v_Job);
      end loop;
    
      Result.Put('integrate_jobs', v_Jobs);
    end if;
  
    select Array_Varchar2(q.Region_Id,
                          (select w.Name
                             from Md_Regions w
                            where w.Company_Id = q.Company_Id
                              and w.Region_Id = q.Region_Id),
                          q.Region_Code,
                          (select w.Name
                             from Hrec_Head_Hunter_Regions w
                            where w.Company_Id = q.Company_Id
                              and w.Code = q.Region_Code))
      bulk collect
      into v_Matrix
      from Hrec_Hh_Integration_Regions q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('integrate_regions', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Lang_Id,
                          (select w.Name
                             from Href_Langs w
                            where w.Company_Id = q.Company_Id
                              and w.Lang_Id = q.Lang_Id),
                          q.Lang_Code,
                          (select w.Name
                             from Hrec_Hh_Langs w
                            where w.Company_Id = q.Company_Id
                              and w.Code = q.Lang_Code))
      bulk collect
      into v_Matrix
      from Hrec_Hh_Integration_Langs q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('integrate_langs', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Lang_Level_Id,
                          (select w.Name
                             from Href_Lang_Levels w
                            where w.Company_Id = q.Company_Id
                              and w.Lang_Level_Id = q.Lang_Level_Id),
                          q.Lang_Level_Code,
                          (select w.Name
                             from Hrec_Hh_Lang_Levels w
                            where w.Company_Id = q.Company_Id
                              and w.Code = q.Lang_Level_Code))
      bulk collect
      into v_Matrix
      from Hrec_Hh_Integration_Lang_Levels q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('integrate_lang_levels', Fazo.Zip_Matrix(v_Matrix));
  
    if not Ui.Is_Filial_Head then
      select Array_Varchar2(q.Schedule_Id,
                            (select w.Name
                               from Htt_Schedules w
                              where w.Company_Id = q.Company_Id
                                and w.Filial_Id = q.Filial_Id
                                and w.Schedule_Id = q.Schedule_Id),
                            q.Schedule_Code,
                            (select w.Name
                               from Hrec_Hh_Schedules w
                              where w.Company_Id = q.Company_Id
                                and w.Code = q.Schedule_Code))
        bulk collect
        into v_Matrix
        from Hrec_Hh_Integration_Schedules q
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = Ui.Filial_Id;
    
      Result.Put('integrate_schedules', Fazo.Zip_Matrix(v_Matrix));
    end if;
  
    select Array_Varchar2(q.Vacancy_Type_Id,
                          (select w.Name
                             from Hrec_Vacancy_Types w
                            where w.Company_Id = q.Company_Id
                              and w.Vacancy_Type_Id = q.Vacancy_Type_Id),
                          q.Experience_Code,
                          (select w.Name
                             from Hrec_Hh_Experiences w
                            where w.Company_Id = q.Company_Id
                              and w.Code = q.Experience_Code))
      bulk collect
      into v_Matrix
      from Hrec_Hh_Integration_Experiences q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('integrate_experiences', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Vacancy_Type_Id,
                          (select w.Name
                             from Hrec_Vacancy_Types w
                            where w.Company_Id = q.Company_Id
                              and w.Vacancy_Type_Id = q.Vacancy_Type_Id),
                          q.Employment_Code,
                          (select w.Name
                             from Hrec_Hh_Employments w
                            where w.Company_Id = q.Company_Id
                              and w.Code = q.Employment_Code))
      bulk collect
      into v_Matrix
      from Hrec_Hh_Integration_Employments q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('integrate_employments', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Vacancy_Type_Id,
                          (select w.Name
                             from Hrec_Vacancy_Types w
                            where w.Company_Id = q.Company_Id
                              and w.Vacancy_Type_Id = q.Vacancy_Type_Id),
                          q.Licence_Code,
                          (select w.Name
                             from Hrec_Hh_Driver_Licences w
                            where w.Company_Id = q.Company_Id
                              and w.Code = q.Licence_Code))
      bulk collect
      into v_Matrix
      from Hrec_Hh_Integration_Driver_Licences q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('integrate_driver_licences', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Stage_Id,
                          (select w.Name
                             from Hrec_Stages w
                            where w.Company_Id = q.Company_Id
                              and w.Stage_Id = q.Stage_Id),
                          q.Stage_Code)
      bulk collect
      into v_Matrix
      from Hrec_Hh_Integration_Stages q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('integrate_stages', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Code, q.Name)
      bulk collect
      into v_Matrix
      from Hrec_Head_Hunter_Stages q
     where q.Code <> Hrec_Pref.c_Hh_Todo_Stage_Code;
  
    Result.Put('hh_stages', Fazo.Zip_Matrix(v_Matrix));
  
    select count(*)
      into v_Count
      from Hrec_Head_Hunter_Jobs q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('head_hunter_job_count', v_Count);
  
    select count(*)
      into v_Count
      from Hrec_Head_Hunter_Regions q
     where q.Company_Id = v_Company_Id;
  
    Result.Put('head_hunter_region_count', v_Count);
  
    if z_Hrec_Hh_Subscriptions.Exist(v_Company_Id) then
      v_Subscribed := 'Y';
    end if;
  
    Result.Put('webhook_subscribed', v_Subscribed);
  
    -- pcode groups
    select Array_Varchar2(q.Name, q.Pcode, q.State)
      bulk collect
      into v_Matrix
      from Hrec_Vacancy_Groups q
     where q.Company_Id = v_Company_Id
       and q.Pcode is not null;
  
    Result.Put('vacancy_groups', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('pcode_experience', Hrec_Pref.c_Pcode_Vacancy_Group_Experience);
    Result.Put('pcode_employments', Hrec_Pref.c_Pcode_Vacancy_Group_Employments);
    Result.Put('pcode_driver_licences', Hrec_Pref.c_Pcode_Vacancy_Group_Driver_Licences);
  
    -- credetials
    r_Credentials := z_Hes_Oauth2_Credentials.Take(i_Company_Id  => v_Company_Id,
                                                   i_Provider_Id => Hes_Pref.c_Provider_Hh_Id);
  
    Result.Put('client_id', r_Credentials.Client_Id);
    Result.Put('client_secret', r_Credentials.Client_Secret);
    Result.Put('employer_id', z_Hrec_Hh_Employer_Ids.Take(v_Company_Id).Employer_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Load_Response_Regions(p Arraylist) is
    v_Company_Id number := Ui.Company_Id;
    v_Region     Hashmap;
    v_Areas      Arraylist;
    v_Area       Hashmap;
    v_Provinces  Arraylist;
    v_Province   Hashmap;
  begin
    -- clear old data
    Hrec_Api.Head_Hunter_Region_Clear(v_Company_Id);
  
    for i in 1 .. p.Count
    loop
      v_Region := Treat(p.r_Hashmap(i) as Hashmap);
    
      Hrec_Api.Head_Hunter_Region_Save(i_Company_Id => v_Company_Id,
                                       i_Code       => v_Region.r_Number('id'),
                                       i_Name       => v_Region.r_Varchar2('name'),
                                       i_Parent_Id  => null);
    
      v_Areas := v_Region.o_Arraylist('areas');
    
      for j in 1 .. v_Areas.Count
      loop
        v_Area := Treat(v_Areas.r_Hashmap(j) as Hashmap);
      
        Hrec_Api.Head_Hunter_Region_Save(i_Company_Id => v_Company_Id,
                                         i_Code       => v_Area.r_Number('id'),
                                         i_Name       => v_Area.r_Varchar2('name'),
                                         i_Parent_Id  => v_Area.r_Number('parent_id'));
      
        v_Provinces := v_Area.o_Arraylist('areas');
      
        for k in 1 .. v_Provinces.Count
        loop
          v_Province := Treat(v_Provinces.r_Hashmap(k) as Hashmap);
        
          Hrec_Api.Head_Hunter_Region_Save(i_Company_Id => v_Company_Id,
                                           i_Code       => v_Province.r_Number('id'),
                                           i_Name       => v_Province.r_Varchar2('name'),
                                           i_Parent_Id  => v_Province.r_Number('parent_id'));
        
        end loop;
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Jobs(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Categories Arraylist := p.o_Arraylist('categories');
    v_Roles      Arraylist;
    v_Category   Hashmap;
    v_Role       Hashmap;
  begin
    -- clear old data
    Hrec_Api.Head_Hunter_Jobs_Clear(v_Company_Id);
  
    for i in 1 .. v_Categories.Count
    loop
      v_Category := Treat(v_Categories.r_Hashmap(i) as Hashmap);
      v_Roles    := v_Category.o_Arraylist('roles');
    
      for j in 1 .. v_Roles.Count
      loop
        v_Role := Treat(v_Roles.r_Hashmap(j) as Hashmap);
      
        Hrec_Api.Head_Hunter_Job_Save(i_Company_Id => v_Company_Id,
                                      i_Code       => v_Role.r_Number('id'),
                                      i_Name       => v_Role.r_Varchar2('name'));
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Load_Response_Languages(p Arraylist) is
    v_Company_Id number := Ui.Company_Id;
    v_Data       Hashmap;
  begin
    -- clear old data
    Hrec_Api.Hh_Lang_Clear(v_Company_Id);
  
    for i in 1 .. p.Count
    loop
      v_Data := Treat(p.r_Hashmap(i) as Hashmap);
    
      Hrec_Api.Hh_Lang_Save(i_Company_Id => v_Company_Id,
                            i_Code       => v_Data.r_Varchar2('id'),
                            i_Name       => v_Data.r_Varchar2('name'));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Load_Responce_Dictionaries(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Arraylist  Arraylist;
    v_Data       Hashmap;
  begin
    if p.Has(Hrec_Pref.c_Dictionary_Employment_Key) then
      -- clear old Data
      Hrec_Api.Hh_Employments_Clear(v_Company_Id);
    
      v_Arraylist := p.r_Arraylist(Hrec_Pref.c_Dictionary_Employment_Key);
    
      for i in 1 .. v_Arraylist.Count
      loop
        v_Data := Treat(v_Arraylist.r_Hashmap(i) as Hashmap);
      
        Hrec_Api.Hh_Employments_Save(i_Company_Id => v_Company_Id,
                                     i_Code       => v_Data.r_Varchar2('id'),
                                     i_Name       => v_Data.r_Varchar2('name'));
      end loop;
    end if;
  
    if p.Has(Hrec_Pref.c_Dictionary_Experience_Key) then
      -- clear old Data
      Hrec_Api.Hh_Experience_Clear(v_Company_Id);
    
      v_Arraylist := p.r_Arraylist(Hrec_Pref.c_Dictionary_Experience_Key);
    
      for i in 1 .. v_Arraylist.Count
      loop
        v_Data := Treat(v_Arraylist.r_Hashmap(i) as Hashmap);
      
        Hrec_Api.Hh_Experience_Save(i_Company_Id => v_Company_Id,
                                    i_Code       => v_Data.r_Varchar2('id'),
                                    i_Name       => v_Data.r_Varchar2('name'));
      end loop;
    end if;
  
    if p.Has(Hrec_Pref.c_Dictionary_Lang_Level_Key) then
      -- clear old Data
      Hrec_Api.Hh_Lang_Level_Clear(v_Company_Id);
    
      v_Arraylist := p.r_Arraylist(Hrec_Pref.c_Dictionary_Lang_Level_Key);
    
      for i in 1 .. v_Arraylist.Count
      loop
        v_Data := Treat(v_Arraylist.r_Hashmap(i) as Hashmap);
      
        Hrec_Api.Hh_Lang_Level_Save(i_Company_Id => v_Company_Id,
                                    i_Code       => v_Data.r_Varchar2('id'),
                                    i_Name       => v_Data.r_Varchar2('name'));
      end loop;
    end if;
  
    if p.Has(Hrec_Pref.c_Dictionary_Schedule_Key) then
      -- clear old Data
      Hrec_Api.Hh_Schedule_Clear(v_Company_Id);
    
      v_Arraylist := p.r_Arraylist(Hrec_Pref.c_Dictionary_Schedule_Key);
    
      for i in 1 .. v_Arraylist.Count
      loop
        v_Data := Treat(v_Arraylist.r_Hashmap(i) as Hashmap);
      
        Hrec_Api.Hh_Schedule_Save(i_Company_Id => v_Company_Id,
                                  i_Code       => v_Data.r_Varchar2('id'),
                                  i_Name       => v_Data.r_Varchar2('name'));
      end loop;
    end if;
  
    if p.Has(Hrec_Pref.c_Dictionary_Driver_Licence) then
      -- clear old Data
      Hrec_Api.Hh_Driver_Licence_Clear(v_Company_Id);
    
      v_Arraylist := p.r_Arraylist(Hrec_Pref.c_Dictionary_Driver_Licence);
    
      for i in 1 .. v_Arraylist.Count
      loop
        v_Data := Treat(v_Arraylist.r_Hashmap(i) as Hashmap);
      
        Hrec_Api.Hh_Driver_Licence_Save(i_Company_Id => v_Company_Id,
                                        i_Code       => v_Data.r_Varchar2('id'),
                                        i_Name       => v_Data.r_Varchar2('id'));
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Sync_Jobs return Runtime_Service is
  begin
    return Hrec_Api.Vacancy_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                            i_User_Id            => Ui.User_Id,
                                            i_Host_Uri           => Hrec_Pref.c_Head_Hunter_Api_Url,
                                            i_Api_Uri            => Hrec_Pref.c_Get_Jobs_Url,
                                            i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                            i_Responce_Procedure => 'Ui_Vhr614.Load_Response_Jobs',
                                            i_Action_Out         => null,
                                            i_Use_Access_Token   => false);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Sync_Regions return Runtime_Service is
  begin
    return Hrec_Api.Vacancy_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                            i_User_Id            => Ui.User_Id,
                                            i_Host_Uri           => Hrec_Pref.c_Head_Hunter_Api_Url,
                                            i_Api_Uri            => Hrec_Pref.c_Get_Regions_Url,
                                            i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                            i_Responce_Procedure => 'Ui_Vhr614.Load_Response_Regions',
                                            i_Action_In          => Biruni_Pref.c_Rs_Action_In_Out_Arraylist,
                                            i_Action_Out         => null,
                                            i_Use_Access_Token   => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sync_Langs return Runtime_Service is
  begin
    return Hrec_Api.Vacancy_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                            i_User_Id            => Ui.User_Id,
                                            i_Host_Uri           => Hrec_Pref.c_Head_Hunter_Api_Url,
                                            i_Api_Uri            => Hrec_Pref.c_Get_Languages_Url,
                                            i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                            i_Responce_Procedure => 'Ui_Vhr614.Load_Response_Languages',
                                            i_Action_In          => Biruni_Pref.c_Rs_Action_In_Out_Arraylist,
                                            i_Action_Out         => null,
                                            i_Use_Access_Token   => false);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Sync_Dictionaries return Runtime_Service is
  begin
    return Hrec_Api.Vacancy_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                            i_User_Id            => Ui.User_Id,
                                            i_Host_Uri           => Hrec_Pref.c_Head_Hunter_Api_Url,
                                            i_Api_Uri            => Hrec_Pref.c_Get_General_References_Url,
                                            i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                            i_Responce_Procedure => 'Ui_Vhr614.Load_Responce_Dictionaries',
                                            i_Action_Out         => null,
                                            i_Use_Access_Token   => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Data_Map(p Hashmap) is
    v_Company_Id                number := Ui.Company_Id;
    v_Data                      Hashmap;
    v_Integrate_Jobs            Arraylist := p.r_Arraylist('integrate_jobs');
    v_Integrate_Regions         Arraylist := p.r_Arraylist('integrate_regions');
    v_Integrate_Langs           Arraylist := p.r_Arraylist('integrate_langs');
    v_Integrate_Lang_Levels     Arraylist := p.r_Arraylist('integrate_lang_levels');
    v_Integrate_Schedules       Arraylist := p.r_Arraylist('integrate_schedules');
    v_Integrate_Experiences     Arraylist := p.r_Arraylist('integrate_experiences');
    v_Integrate_Employments     Arraylist := p.r_Arraylist('integrate_employments');
    v_Integrate_Driver_Licences Arraylist := p.r_Arraylist('integrate_driver_licences');
    v_Integrate_Stages          Arraylist := p.o_Arraylist('integrate_stages');
  
    v_Integration_Jobs            Hrec_Pref.Hh_Integration_Job_Nt := Hrec_Pref.Hh_Integration_Job_Nt();
    v_Integration_Job             Hrec_Pref.Hh_Integration_Job_Rt;
    v_Integration_Regions         Hrec_Pref.Hh_Integration_Region_Nt := Hrec_Pref.Hh_Integration_Region_Nt();
    v_Integration_Region          Hrec_Pref.Hh_Integration_Region_Rt;
    v_Integration_Langs           Hrec_Pref.Hh_Integration_Lang_Nt := Hrec_Pref.Hh_Integration_Lang_Nt();
    v_Integration_Lang            Hrec_Pref.Hh_Integration_Lang_Rt;
    v_Integration_Lang_Levels     Hrec_Pref.Hh_Integration_Lang_Level_Nt := Hrec_Pref.Hh_Integration_Lang_Level_Nt();
    v_Integration_Lang_Level      Hrec_Pref.Hh_Integration_Lang_Level_Rt;
    v_Integration_Schedules       Hrec_Pref.Hh_Integration_Schedule_Nt := Hrec_Pref.Hh_Integration_Schedule_Nt();
    v_Integration_Schedule        Hrec_Pref.Hh_Integration_Schedule_Rt;
    v_Integration_Experiences     Hrec_Pref.Hh_Integration_Experience_Nt := Hrec_Pref.Hh_Integration_Experience_Nt();
    v_Integration_Experience      Hrec_Pref.Hh_Integration_Experience_Rt;
    v_Integration_Employments     Hrec_Pref.Hh_Integration_Employments_Nt := Hrec_Pref.Hh_Integration_Employments_Nt();
    v_Integration_Employment      Hrec_Pref.Hh_Integration_Employments_Rt;
    v_Integration_Driver_Licences Hrec_Pref.Hh_Integration_Driver_Licence_Nt := Hrec_Pref.Hh_Integration_Driver_Licence_Nt();
    v_Integration_Driver_Licence  Hrec_Pref.Hh_Integration_Driver_Licence_Rt;
    v_Integration_Stages          Hrec_Pref.Hh_Integration_Stage_Nt := Hrec_Pref.Hh_Integration_Stage_Nt();
    v_Integration_Stage           Hrec_Pref.Hh_Integration_Stage_Rt;
  begin
    -- Jobs
    if not Ui.Is_Filial_Head then
      for i in 1 .. v_Integrate_Jobs.Count
      loop
        v_Data := Treat(v_Integrate_Jobs.r_Hashmap(i) as Hashmap);
      
        v_Integration_Job.Job_Code := v_Data.r_Number('job_code');
        v_Integration_Job.Job_Ids  := v_Data.r_Array_Number('job_ids');
      
        v_Integration_Jobs.Extend();
        v_Integration_Jobs(v_Integration_Jobs.Count) := v_Integration_Job;
      end loop;
    
      Hrec_Api.Hh_Integration_Job_Save(i_Company_Id      => v_Company_Id,
                                       i_Filial_Id       => Ui.Filial_Id,
                                       i_Integration_Job => v_Integration_Jobs);
    end if;
  
    -- Regions
    for i in 1 .. v_Integrate_Regions.Count
    loop
      v_Data := Treat(v_Integrate_Regions.r_Hashmap(i) as Hashmap);
    
      v_Integration_Region.Region_Id   := v_Data.r_Number('region_id');
      v_Integration_Region.Region_Code := v_Data.r_Number('region_code');
    
      v_Integration_Regions.Extend();
      v_Integration_Regions(v_Integration_Regions.Count) := v_Integration_Region;
    end loop;
  
    Hrec_Api.Hh_Integration_Region_Save(i_Company_Id         => v_Company_Id,
                                        i_Integration_Region => v_Integration_Regions);
  
    -- Langs
    for i in 1 .. v_Integrate_Langs.Count
    loop
      v_Data := Treat(v_Integrate_Langs.r_Hashmap(i) as Hashmap);
    
      v_Integration_Lang.Lang_Code := v_Data.r_Varchar2('lang_code');
      v_Integration_Lang.Lang_Id   := v_Data.r_Varchar2('lang_id');
    
      v_Integration_Langs.Extend();
      v_Integration_Langs(v_Integration_Langs.Count) := v_Integration_Lang;
    end loop;
  
    Hrec_Api.Hh_Integration_Lang_Save(i_Company_Id => v_Company_Id, i_Lang => v_Integration_Langs);
  
    -- Lang levels
    for i in 1 .. v_Integrate_Lang_Levels.Count
    loop
      v_Data := Treat(v_Integrate_Lang_Levels.r_Hashmap(i) as Hashmap);
    
      v_Integration_Lang_Level.Lang_Level_Code := v_Data.r_Varchar2('lang_level_code');
      v_Integration_Lang_Level.Lang_Level_Id   := v_Data.r_Varchar2('lang_level_id');
    
      v_Integration_Lang_Levels.Extend();
      v_Integration_Lang_Levels(v_Integration_Lang_Levels.Count) := v_Integration_Lang_Level;
    end loop;
  
    Hrec_Api.Hh_Integration_Lang_Level_Save(i_Company_Id => v_Company_Id,
                                            i_Lang_Level => v_Integration_Lang_Levels);
  
    -- Schedules
    if not Ui.Is_Filial_Head then
      for i in 1 .. v_Integrate_Schedules.Count
      loop
        v_Data := Treat(v_Integrate_Schedules.r_Hashmap(i) as Hashmap);
      
        v_Integration_Schedule.Schedule_Code := v_Data.r_Varchar2('schedule_code');
        v_Integration_Schedule.Schedule_Id   := v_Data.r_Varchar2('schedule_id');
      
        v_Integration_Schedules.Extend();
        v_Integration_Schedules(v_Integration_Schedules.Count) := v_Integration_Schedule;
      end loop;
    
      Hrec_Api.Hh_Integration_Schedule_Save(i_Company_Id => v_Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Schedule   => v_Integration_Schedules);
    end if;
  
    -- Experiences
    for i in 1 .. v_Integrate_Experiences.Count
    loop
      v_Data := Treat(v_Integrate_Experiences.r_Hashmap(i) as Hashmap);
    
      v_Integration_Experience.Experience_Code := v_Data.r_Varchar2('experience_code');
      v_Integration_Experience.Vacancy_Type_Id := v_Data.r_Varchar2('vacancy_type_id');
    
      v_Integration_Experiences.Extend();
      v_Integration_Experiences(v_Integration_Experiences.Count) := v_Integration_Experience;
    end loop;
  
    Hrec_Api.Hh_Integration_Experience_Save(i_Company_Id => v_Company_Id,
                                            i_Experience => v_Integration_Experiences);
  
    -- Employments
    for i in 1 .. v_Integrate_Employments.Count
    loop
      v_Data := Treat(v_Integrate_Employments.r_Hashmap(i) as Hashmap);
    
      v_Integration_Employment.Employment_Code := v_Data.r_Varchar2('employment_code');
      v_Integration_Employment.Vacancy_Type_Id := v_Data.r_Varchar2('vacancy_type_id');
    
      v_Integration_Employments.Extend();
      v_Integration_Employments(v_Integration_Employments.Count) := v_Integration_Employment;
    end loop;
  
    Hrec_Api.Hh_Integration_Employments_Save(i_Company_Id => v_Company_Id,
                                             i_Employment => v_Integration_Employments);
  
    -- Driver Licences
    for i in 1 .. v_Integrate_Driver_Licences.Count
    loop
      v_Data := Treat(v_Integrate_Driver_Licences.r_Hashmap(i) as Hashmap);
    
      v_Integration_Driver_Licence.Licence_Code    := v_Data.r_Varchar2('driver_licence_code');
      v_Integration_Driver_Licence.Vacancy_Type_Id := v_Data.r_Varchar2('vacancy_type_id');
    
      v_Integration_Driver_Licences.Extend();
      v_Integration_Driver_Licences(v_Integration_Driver_Licences.Count) := v_Integration_Driver_Licence;
    end loop;
  
    Hrec_Api.Hh_Integration_Driver_Licence_Save(i_Company_Id => v_Company_Id,
                                                i_Licences   => v_Integration_Driver_Licences);
  
    -- Stages
    for i in 1 .. v_Integrate_Stages.Count
    loop
      v_Data := Treat(v_Integrate_Stages.r_Hashmap(i) as Hashmap);
    
      v_Integration_Stage.Stage_Code := v_Data.r_Varchar2('stage_code');
      v_Integration_Stage.Stage_Ids  := v_Data.r_Array_Number('stage_ids');
    
      v_Integration_Stages.Extend();
      v_Integration_Stages(v_Integration_Stages.Count) := v_Integration_Stage;
    end loop;
  
    Hrec_Api.Hh_Integration_Stage_Save(i_Company_Id => v_Company_Id,
                                       i_Stage      => v_Integration_Stages);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Save_Auth_Credentials(p Hashmap) is
    r_Credentials    Hes_Oauth2_Credentials%rowtype;
    r_Hh_Employer_Id Hrec_Hh_Employer_Ids%rowtype;
  begin
    r_Credentials.Company_Id    := Ui.Company_Id;
    r_Credentials.Provider_Id   := Hes_Pref.c_Provider_Hh_Id;
    r_Credentials.Client_Id     := p.r_Varchar2('client_id');
    r_Credentials.Client_Secret := p.r_Varchar2('client_secret');
  
    Hes_Api.Save_Oauth2_Credentials(r_Credentials);
  
    r_Hh_Employer_Id.Company_Id  := Ui.Company_Id;
    r_Hh_Employer_Id.Employer_Id := p.r_Varchar2('employer_id');
  
    Hrec_Api.Hh_Employer_Id_Save(r_Hh_Employer_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Auth_Credentials is
  begin
    Hes_Api.Delete_Oauth2_Credentials(i_Company_Id  => Ui.Company_Id,
                                      i_Provider_Id => Hes_Pref.c_Provider_Hh_Id);
    Hrec_Api.Hh_Employer_Id_Delete(Ui.Company_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Load_Response_Webhook_Subscribe(p Hashmap) is
  begin
    Hrec_Util.Process_Auth_Response_Errors(p);
  
    Hrec_Api.Hh_Subscription_Save(i_Company_Id        => Ui.Company_Id,
                                  i_Subscription_Code => p.r_Number('id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Response_Webhook_Unsubscribe(p Hashmap) is
  begin
    Hrec_Util.Process_Auth_Response_Errors(p);
  
    Hrec_Api.Hh_Subscription_Delete(Ui.Company_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Webhook_Subscribe(p Hashmap) return Runtime_Service is
    v_Data      Gmap := Gmap();
    v_Dummy     Gmap := Gmap();
    v_Arraylist Glist := Glist();
    v_Event_Url varchar2(300) := p.r_Varchar2('url') || Hrec_Pref.c_Hh_Event_Receiver_Path;
  begin
    v_Dummy.Put('type', Hrec_Pref.c_Hh_Event_Type_New_Negotiation);
    v_Arraylist.Push(v_Dummy.Val);
    v_Data.Put('actions', v_Arraylist);
    v_Data.Put('url', v_Event_Url);
  
    return Hrec_Api.Vacancy_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                            i_User_Id            => Ui.User_Id,
                                            i_Host_Uri           => Hrec_Pref.c_Head_Hunter_Api_Url,
                                            i_Api_Uri            => Hrec_Pref.c_Webhook_Subscriptions_Url,
                                            i_Api_Method         => Href_Pref.c_Http_Method_Post,
                                            i_Responce_Procedure => 'Ui_Vhr614.Load_Response_Webhook_Subscribe',
                                            i_Data               => v_Data,
                                            i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Webhook_Unsubscribe return Runtime_Service is
    v_Subscription_Url varchar2(300);
  begin
    v_Subscription_Url := Hrec_Pref.c_Webhook_Subscriptions_Url || '/' || --
                          z_Hrec_Hh_Subscriptions.Load(Ui.Company_Id).Subscription_Code;
  
    return Hrec_Api.Vacancy_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                            i_User_Id            => Ui.User_Id,
                                            i_Host_Uri           => Hrec_Pref.c_Head_Hunter_Api_Url,
                                            i_Api_Uri            => v_Subscription_Url,
                                            i_Api_Method         => Href_Pref.c_Http_Method_Delete,
                                            i_Responce_Procedure => 'Ui_Vhr614.Load_Response_Webhook_Unsubscribe',
                                            i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
    update Hrec_Head_Hunter_Jobs
       set Company_Id = null,
           Code       = null,
           name       = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           Parent_Id  = null,
           name       = null;
    update Hrec_Head_Hunter_Regions
       set Company_Id = null,
           Code       = null,
           name       = null,
           Parent_Id  = null;
    update Hrec_Stages
       set Company_Id = null,
           Stage_Id   = null,
           name       = null,
           State      = null;
    update Hrec_Hh_Langs
       set Company_Id = null,
           Code       = null,
           name       = null;
    update Href_Langs
       set Company_Id = null,
           Lang_Id    = null,
           name       = null,
           State      = null;
    update Hrec_Hh_Lang_Levels
       set Company_Id = null,
           Code       = null,
           name       = null;
    update Href_Lang_Levels
       set Company_Id    = null,
           Lang_Level_Id = null,
           name          = null,
           State         = null;
    update Hrec_Hh_Schedules
       set Company_Id = null,
           Code       = null,
           name       = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Hrec_Hh_Experiences
       set Company_Id = null,
           Code       = null,
           name       = null;
    update Hrec_Hh_Employments
       set Company_Id = null,
           Code       = null,
           name       = null;
    update Hrec_Hh_Driver_Licences
       set Company_Id = null,
           Code       = null,
           name       = null;
    update Hrec_Vacancy_Types
       set Company_Id       = null,
           Vacancy_Type_Id  = null,
           Vacancy_Group_Id = null,
           name             = null,
           State            = null;
  end;

end Ui_Vhr614;
/
