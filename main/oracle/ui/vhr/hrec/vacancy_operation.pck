create or replace package Ui_Vhr576 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Reject_Reasons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Candidate_Ids(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Candidates(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Candidate_Operations(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add_Candidate(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Operation(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Delete_Operation(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Change_Hh_Stage(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Hh_Stage_Response(i_Data Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Load_Hh_Vacation_Candidates(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Load_Hh_Vacation_Candidates_Response(i_Data Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------    
  Procedure Load_Olx_Candidate_Response(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Load_Olx_Candidate_Info(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Load_Olx_Candidates_Response(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Olx_Vacation_Candidates(p Hashmap) return Runtime_Service;
end Ui_Vhr576;
/
create or replace package body Ui_Vhr576 is
  g_Vacancy_Code   varchar2(250);
  g_Vacancy_Id     number;
  g_Stage_Id       number;
  g_Candidate_Code number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals
  (
    i_Vacancy_Id     number := null,
    i_Vacancy_Code   varchar2 := null,
    i_Stage_Id       number := null,
    i_Candidate_Code number := null
  ) is
  begin
    g_Vacancy_Id     := i_Vacancy_Id;
    g_Vacancy_Code   := i_Vacancy_Code;
    g_Stage_Id       := i_Stage_Id;
    g_Candidate_Code := i_Candidate_Code;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Reject_Reasons return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_reject_reasons',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('reject_reason_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  
    --------------------------------------------------
    Function Stage(i_Pcode varchar2) return Hashmap is
      v_Stage_Id number;
      v_Stage    Hashmap;
    begin
      v_Stage_Id := Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => Ui.Company_Id, i_Pcode => i_Pcode);
    
      v_Stage := Fazo.Zip_Map('stage_id',
                              v_Stage_Id,
                              'name',
                              z_Hrec_Stages.Load(i_Company_Id => Ui.Company_Id, i_Stage_Id => v_Stage_Id).Name,
                              'pcode',
                              i_Pcode);
      return v_Stage;
    end;
  begin
    result := Fazo.Zip_Map('pg_female', Md_Pref.c_Pg_Female);
  
    -- stages
    Result.Put('stage_todo', Stage(Hrec_Pref.c_Pcode_Stage_Todo));
    Result.Put('stage_accepted', Stage(Hrec_Pref.c_Pcode_Stage_Accepted));
    Result.Put('stage_rejected', Stage(Hrec_Pref.c_Pcode_Stage_Rejected));
  
    -- operation kind
    Result.Put('operation_kind_action', Hrec_Pref.c_Operation_Kind_Action);
    Result.Put('operation_kind_comment', Hrec_Pref.c_Operation_Kind_Comment);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Hh_Vacancy         Hrec_Hh_Published_Vacancies%rowtype;
    r_Olx_Vacancy        Hrec_Olx_Published_Vacancies%rowtype;
    r_Vacancy            Hrec_Vacancies%rowtype;
    v_System_Funnel_Id   number := Hrec_Util.Funnel_Id_By_Pcode(i_Company_Id => Ui.Company_Id,
                                                                i_Pcode      => Hrec_Pref.c_Pcode_Funnel_All);
    v_Candidate_Id       number := p.o_Number('candidate_id');
    v_Candidate_Stage_Id number;
    v_Matrix             Matrix_Varchar2;
    result               Hashmap := Hashmap();
  
    --------------------------------------------------
    Function Access_To_Publish(i_Vacancy_Id number) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Hrec_Olx_Published_Vacancies q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Vacancy_Id = i_Vacancy_Id
         and q.Created_By = Ui.User_Id;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  
  begin
    r_Vacancy    := z_Hrec_Vacancies.Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Vacancy_Id => p.r_Number('vacancy_id'));
    r_Hh_Vacancy := z_Hrec_Hh_Published_Vacancies.Take(i_Company_Id => Ui.Company_Id,
                                                       i_Filial_Id  => Ui.Filial_Id,
                                                       i_Vacancy_Id => r_Vacancy.Vacancy_Id);
  
    Result.Put('vacancy_id', r_Vacancy.Vacancy_Id);
    Result.Put('hh_vacancy_code', r_Hh_Vacancy.Vacancy_Code);
  
    if Access_To_Publish(r_Vacancy.Vacancy_Id) then
      r_Olx_Vacancy := z_Hrec_Olx_Published_Vacancies.Take(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id,
                                                           i_Vacancy_Id => r_Vacancy.Vacancy_Id);
    
      Result.Put('olx_vacancy_code', r_Olx_Vacancy.Vacancy_Code);
    else
      Result.Put('olx_vacancy_code', -1);
    end if;
  
    select Array_Varchar2(t.Stage_Id,
                          t.Name,
                          t.Pcode,
                          (select count(1)
                             from Hrec_Vacancy_Candidates q
                            where q.Company_Id = r_Vacancy.Company_Id
                              and q.Filial_Id = r_Vacancy.Filial_Id
                              and q.Vacancy_Id = r_Vacancy.Vacancy_Id
                              and q.Stage_Id = t.Stage_Id))
      bulk collect
      into v_Matrix
      from Hrec_Stages t
     where t.Company_Id = Ui.Company_Id
       and t.State = 'A'
       and (r_Vacancy.Funnel_Id = v_System_Funnel_Id or exists
            (select 1
               from Hrec_Funnel_Stages q
              where q.Company_Id = t.Company_Id
                and q.Funnel_Id = r_Vacancy.Funnel_Id
                and q.Stage_Id = t.Stage_Id))
     order by t.Order_No;
  
    Result.Put('stages', Fazo.Zip_Matrix(v_Matrix));
  
    -- candidate_id & candidate_stage_id are for:
    -- immediately opening particular candidate in kanban (optional)
    if v_Candidate_Id is not null then
      begin
        select t.Stage_Id
          into v_Candidate_Stage_Id
          from Hrec_Vacancy_Candidates t
         where t.Company_Id = Ui.Company_Id
           and t.Filial_Id = Ui.Filial_Id
           and t.Vacancy_Id = r_Vacancy.Vacancy_Id
           and t.Candidate_Id = v_Candidate_Id;
      exception
        when No_Data_Found then
          null;
      end;
    end if;
  
    Result.Put('candidate_id', v_Candidate_Id);
    Result.Put('candidate_stage_id', v_Candidate_Stage_Id);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  -- for extracting these candidate ids while adding new candidates
  ----------------------------------------------------------------------------------------------------
  Function Get_Candidate_Ids(p Hashmap) return Hashmap is
    v_Candidate_Ids Array_Number;
    result          Hashmap := Hashmap();
  begin
    select t.Candidate_Id
      bulk collect
      into v_Candidate_Ids
      from Hrec_Vacancy_Candidates t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and t.Vacancy_Id = p.r_Number('vacancy_id');
  
    Result.Put('candidate_ids', v_Candidate_Ids);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Candidate_Kind(i_Candidate_Id number) return varchar2 is
    r_Employee Mhr_Employees%rowtype;
    r_Staff    Href_Staffs%rowtype;
    v_Sysdate  date := Trunc(sysdate);
  begin
    if not z_Mhr_Employees.Exist(i_Company_Id  => Ui.Company_Id,
                                 i_Filial_Id   => Ui.Filial_Id,
                                 i_Employee_Id => i_Candidate_Id,
                                 o_Row         => r_Employee) then
      return Href_Pref.c_Candidate_Kind_New;
    end if;
  
    r_Staff.Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                       i_Filial_Id   => Ui.Filial_Id,
                                                       i_Employee_Id => i_Candidate_Id);
  
    if z_Href_Staffs.Exist(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Staff_Id   => r_Staff.Staff_Id,
                           o_Row        => r_Staff) then
    
      if r_Staff.Hiring_Date is null or r_Staff.Hiring_Date > v_Sysdate then
        return Href_Pref.c_Staff_Status_Unknown;
      
      elsif r_Staff.Dismissal_Date < v_Sysdate then
        return Href_Pref.c_Staff_Status_Dismissed;
      end if;
    
      return Href_Pref.c_Staff_Status_Working;
    end if;
  
    return Href_Pref.c_Staff_Status_Unknown;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Candidates(p Hashmap) return Hashmap is
    v_Vacancy_Id     number := p.r_Number('vacancy_id');
    v_Stage_Id       number := p.r_Number('stage_id');
    v_Row            Hashmap;
    v_List           Arraylist := Arraylist();
    v_Candidate_Kind varchar2(1);
    result           Hashmap := Hashmap();
  begin
    for r in (select (select Op.Created_On
                        from Hrec_Operations Op
                       where Op.Company_Id = q.Company_Id
                         and Op.Filial_Id = q.Filial_Id
                         and Op.Vacancy_Id = q.Vacancy_Id
                         and Op.Candidate_Id = q.Candidate_Id
                       order by Op.Created_On desc
                       fetch first 1 row only) Last_Created_On,
                     q.Candidate_Id,
                     k.Name,
                     k.Gender,
                     k.Birthday,
                     w.Email,
                     w.Phone,
                     w.Photo_Sha,
                     (select Listagg(Jb.Name, ', ')
                        from Mhr_Jobs Jb
                       where Jb.Company_Id = q.Company_Id
                         and Jb.Filial_Id = q.Filial_Id
                         and exists (select 1
                                from Href_Candidate_Jobs Cj
                               where Cj.Company_Id = Jb.Company_Id
                                 and Cj.Filial_Id = Jb.Filial_Id
                                 and Cj.Candidate_Id = q.Candidate_Id
                                 and Cj.Job_Id = Jb.Job_Id)) Jobs,
                     (select Ca.Cv_Sha
                        from Href_Candidates Ca
                       where Ca.Company_Id = q.Company_Id
                         and Ca.Filial_Id = q.Filial_Id
                         and Ca.Candidate_Id = q.Candidate_Id) Cv_Sha
                from Hrec_Vacancy_Candidates q
                join Mr_Natural_Persons k
                  on k.Company_Id = q.Company_Id
                 and k.Person_Id = q.Candidate_Id
                join Md_Persons w
                  on w.Company_Id = q.Company_Id
                 and w.Person_Id = q.Candidate_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Vacancy_Id = v_Vacancy_Id
                 and q.Stage_Id = v_Stage_Id
               order by 1 desc)
    loop
      v_Row := Fazo.Zip_Map('candidate_id',
                            r.Candidate_Id,
                            'name',
                            r.Name,
                            'gender',
                            r.Gender,
                            'gender_name',
                            Md_Util.t_Person_Gender(r.Gender),
                            'birthday',
                            r.Birthday,
                            'email',
                            r.Email);
    
      v_Row.Put('phone', r.Phone);
      v_Row.Put('photo_sha', r.Photo_Sha);
      v_Row.Put('jobs', r.Jobs);
      v_Row.Put('cv_sha', r.Cv_Sha);
    
      v_Candidate_Kind := Get_Candidate_Kind(r.Candidate_Id);
    
      v_Row.Put('candidate_kind', v_Candidate_Kind);
    
      if v_Candidate_Kind = Href_Pref.c_Candidate_Kind_New then
        v_Row.Put('candidate_kind_name',
                  Href_Util.t_Candidate_Kind(Href_Pref.c_Candidate_Kind_New));
      else
        v_Row.Put('candidate_kind_name', Href_Util.t_Staff_Status(v_Candidate_Kind));
      end if;
    
      v_List.Push(v_Row);
    end loop;
  
    Result.Put('candidates', v_List);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Candidate_Operations(p Hashmap) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    /*[
       'operation_id', 'operation_kind', 'operation_kind_name', 'candidate_id', 'candidate_name', 'from_stage_id', 'from_stage_name', 'from_stage_pcode',
       'to_stage_id', 'to_stage_name', 'to_stage_pcode', 'reject_reason_id', 'reject_reason_name', 'note', 'created_by_name', 'created_on'
    ]*/
    select Array_Varchar2(q.Operation_Id,
                          q.Operation_Kind,
                          Hrec_Util.t_Operation_Kind(q.Operation_Kind),
                          q.Candidate_Id,
                          (select w.Name
                             from Mr_Natural_Persons w
                            where w.Company_Id = q.Company_Id
                              and w.Person_Id = q.Candidate_Id),
                          q.From_Stage_Id,
                          (select w.Name
                             from Hrec_Stages w
                            where w.Company_Id = q.Company_Id
                              and w.Stage_Id = q.From_Stage_Id),
                          (select w.Pcode
                             from Hrec_Stages w
                            where w.Company_Id = q.Company_Id
                              and w.Stage_Id = q.From_Stage_Id),
                          q.To_Stage_Id,
                          (select w.Name
                             from Hrec_Stages w
                            where w.Company_Id = q.Company_Id
                              and w.Stage_Id = q.To_Stage_Id),
                          (select w.Pcode
                             from Hrec_Stages w
                            where w.Company_Id = q.Company_Id
                              and w.Stage_Id = q.To_Stage_Id),
                          q.Reject_Reason_Id,
                          (select w.Name
                             from Hrec_Reject_Reasons w
                            where w.Company_Id = q.Company_Id
                              and w.Reject_Reason_Id = q.Reject_Reason_Id),
                          q.Note,
                          (select Us.Name
                             from Md_Users Us
                            where Us.Company_Id = q.Company_Id
                              and Us.User_Id = q.Created_By),
                          to_char(q.Created_On, Href_Pref.c_Date_Format_Minute))
      bulk collect
      into v_Matrix
      from Hrec_Operations q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Vacancy_Id = p.r_Number('vacancy_id')
       and q.Candidate_Id = p.r_Number('candidate_id')
     order by q.Created_On desc;
  
    Result.Put('operations', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add_Candidate(p Hashmap) is
    r_Candidate     Hrec_Vacancy_Candidates%rowtype;
    v_Candidate_Ids Array_Number := p.r_Array_Number('candidate_ids');
  begin
    r_Candidate.Company_Id := Ui.Company_Id;
    r_Candidate.Filial_Id  := Ui.Filial_Id;
    r_Candidate.Vacancy_Id := p.r_Number('vacancy_id');
  
    for i in 1 .. v_Candidate_Ids.Count
    loop
      r_Candidate.Candidate_Id := v_Candidate_Ids(i);
    
      Hrec_Api.Vacancy_Add_Candidate(r_Candidate);
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Operation(p Hashmap) is
    v_Operation Hrec_Pref.Candidate_Operation_Rt;
  begin
    Hrec_Util.Candidate_Operation_Fill(o_Operation        => v_Operation,
                                       i_Company_Id       => Ui.Company_Id,
                                       i_Filial_Id        => Ui.Filial_Id,
                                       i_Operation_Id     => Coalesce(p.o_Number('operation_id'),
                                                                      Hrec_Next.Operation_Id),
                                       i_Vacancy_Id       => p.r_Number('vacancy_id'),
                                       i_Candidate_Id     => p.r_Number('candidate_id'),
                                       i_Operation_Kind   => p.r_Varchar2('operation_kind'),
                                       i_To_Stage_Id      => p.o_Number('to_stage_id'),
                                       i_Reject_Reason_Id => p.o_Number('reject_reason_id'),
                                       i_Note             => p.o_Varchar2('note'));
  
    Hrec_Api.Candidate_Operation_Save(v_Operation);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Delete_Operation(p Hashmap) is
  begin
    Hrec_Api.Candidate_Operation_Delete(i_Company_Id   => Ui.Company_Id,
                                        i_Filial_Id    => Ui.Filial_Id,
                                        i_Operation_Id => p.r_Number('operation_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Change_Hh_Stage(p Hashmap) return Runtime_Service is
    r_Stage       Hrec_Hh_Integration_Stages%rowtype;
    v_Resume_Code varchar2(100);
    v_Topic_Code  varchar2(100);
  begin
    if not z_Hrec_Hh_Integration_Stages.Exist(i_Company_Id => Ui.Company_Id,
                                              i_Stage_Id   => p.o_Number('to_stage_id'),
                                              o_Row        => r_Stage) then
      return null;
    end if;
  
    v_Resume_Code := Hrec_Util.Resume_Code(i_Company_Id   => Ui.Company_Id,
                                           i_Filial_Id    => Ui.Filial_Id,
                                           i_Candidate_Id => p.r_Number('candidate_id'));
  
    v_Topic_Code := Hrec_Util.Topic_Code(i_Company_Id   => Ui.Company_Id,
                                         i_Filial_Id    => Ui.Filial_Id,
                                         i_Vacancy_Code => p.o_Varchar2('vacancy_code'),
                                         i_Resume_Code  => v_Resume_Code);
  
    if v_Topic_Code is null then
      return null;
    end if;
  
    if r_Stage.Stage_Id =
       Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => Ui.Company_Id,
                                   i_Pcode      => Hrec_Pref.c_Pcode_Stage_Todo) then
      return null;
    end if;
  
    return Hrec_Api.Vacancy_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                            i_User_Id            => Ui.User_Id,
                                            i_Host_Uri           => Hrec_Pref.c_Head_Hunter_Api_Url,
                                            i_Api_Uri            => Hrec_Pref.c_Negotiations_Url || '/' ||
                                                                    r_Stage.Stage_Code || '/' ||
                                                                    v_Topic_Code,
                                            i_Api_Method         => Href_Pref.c_Http_Method_Put,
                                            i_Responce_Procedure => 'ui_vhr576.change_hh_stage_response',
                                            i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Hh_Stage_Response(i_Data Hashmap) is
  begin
    Hrec_Util.Process_Auth_Response_Errors(i_Data);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Hh_Vacation_Candidates(p Hashmap) return Runtime_Service is
    r_Stage            Hrec_Hh_Integration_Stages%rowtype;
    v_Query_Parameters Gmap := Gmap();
  begin
    Init_Globals(i_Vacancy_Id   => p.r_Number('vacancy_id'),
                 i_Vacancy_Code => p.r_Varchar2('vacancy_code'),
                 i_Stage_Id     => p.o_Number('stage_id'));
  
    if not z_Hrec_Hh_Integration_Stages.Exist(i_Company_Id => Ui.Company_Id,
                                              i_Stage_Id   => g_Stage_Id,
                                              o_Row        => r_Stage) or g_Vacancy_Code is null then
      return null;
    end if;
  
    v_Query_Parameters.Put('vacancy_id', g_Vacancy_Code);
    v_Query_Parameters.Put('per_page', Hrec_Pref.c_Hh_Default_Page_Limit);
    v_Query_Parameters.Put('page', Nvl(p.o_Number('page_num'), 0));
  
    return Hrec_Api.Vacancy_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                            i_User_Id            => Ui.User_Id,
                                            i_Host_Uri           => Hrec_Pref.c_Head_Hunter_Api_Url,
                                            i_Api_Uri            => Hrec_Pref.c_Negotiations_Url || '/' ||
                                                                    r_Stage.Stage_Code,
                                            i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                            i_Uri_Query_Params   => v_Query_Parameters,
                                            i_Responce_Procedure => 'ui_vhr576.load_hh_vacation_candidates_response');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Hh_Vacation_Candidates_Response(i_Data Hashmap) return Hashmap is
    v_Negotiations    Arraylist;
    v_Negotiation_Map Hashmap;
    v_Resume          Hashmap;
    v_Area_Map        Hashmap;
    v_Gender_Map      Hashmap;
    v_Contact         Hashmap;
    v_Contact_Type    Hashmap;
    v_Contact_Value   Hashmap;
    v_Contacts        Arraylist;
  
    v_Gender       varchar2(1);
    v_Phone_Number varchar2(50);
    v_Email        varchar2(50);
  
    v_Candidate Href_Pref.Candidate_Rt;
    v_Operation Hrec_Pref.Candidate_Operation_Rt;
  
    r_Resume    Hrec_Hh_Resumes%rowtype;
    r_Candidate Hrec_Vacancy_Candidates%rowtype;
  begin
    Hrec_Util.Process_Auth_Response_Errors(i_Data);
  
    v_Negotiations := i_Data.r_Arraylist('items');
  
    for i in 1 .. v_Negotiations.Count
    loop
      v_Negotiation_Map := Treat(v_Negotiations.r_Hashmap(i) as Hashmap);
    
      continue when not v_Negotiation_Map.Has('resume') or not v_Negotiation_Map.Is_Hashmap('resume');
    
      v_Resume := v_Negotiation_Map.r_Hashmap('resume');
    
      if not z_Hrec_Hh_Resumes.Exist(i_Company_Id  => Ui.Company_Id,
                                     i_Filial_Id   => Ui.Filial_Id,
                                     i_Resume_Code => v_Resume.r_Varchar2('id'),
                                     o_Row         => r_Resume) then
        v_Gender_Map := v_Resume.o_Hashmap('gender');
        v_Area_Map   := v_Resume.o_Hashmap('area');
        v_Contacts   := v_Resume.o_Arraylist('contact');
      
        v_Gender := case
                      when v_Gender_Map.o_Varchar2('id') = Hrec_Pref.c_Hh_Gender_Female then
                       Md_Pref.c_Pg_Female
                      else
                       Md_Pref.c_Pg_Male
                    end;
      
        if v_Contacts is not null then
          for j in 1 .. v_Contacts.Count
          loop
            v_Contact := Treat(v_Contacts.r_Hashmap(j) as Hashmap);
          
            v_Contact_Type := v_Contact.r_Hashmap('type');
          
            if v_Contact_Type.o_Varchar2('id') = Hrec_Pref.c_Hh_Contact_Type_Phone then
              v_Contact_Value := v_Contact.r_Hashmap('value');
            
              v_Phone_Number := v_Contact_Value.o_Varchar2('formatted');
            elsif v_Contact_Type.o_Varchar2('id') = Hrec_Pref.c_Hh_Contact_Type_Email then
              v_Email := v_Contact.r_Varchar2('value');
            end if;
          end loop;
        end if;
      
        Href_Util.Candidate_New(o_Candidate        => v_Candidate,
                                i_Company_Id       => Ui.Company_Id,
                                i_Filial_Id        => Ui.Filial_Id,
                                i_Candidate_Id     => Md_Next.Person_Id,
                                i_Person_Type_Id   => null,
                                i_Candidate_Kind   => Href_Pref.c_Candidate_Kind_New,
                                i_First_Name       => trim(v_Resume.r_Varchar2('first_name')),
                                i_Last_Name        => trim(v_Resume.o_Varchar2('last_name')),
                                i_Middle_Name      => trim(v_Resume.o_Varchar2('middle_name')),
                                i_Gender           => v_Gender,
                                i_Birthday         => v_Resume.o_Date('birth_date', 'yyyy-mm-dd'),
                                i_Photo_Sha        => null,
                                i_Region_Id        => Hrec_Util.Region_Id(i_Company_Id => Ui.Company_Id,
                                                                          i_Area_Code  => v_Area_Map.o_Varchar2('id')),
                                i_Main_Phone       => v_Phone_Number,
                                i_Extra_Phone      => null,
                                i_Email            => v_Email,
                                i_Address          => null,
                                i_Legal_Address    => null,
                                i_Source_Id        => null,
                                i_Wage_Expectation => null,
                                i_Cv_Sha           => null,
                                i_Note             => null,
                                i_Edu_Stages       => Array_Number(),
                                i_Candidate_Jobs   => Array_Number());
      
        Href_Api.Candidate_Save(v_Candidate);
      
        Hrec_Api.Hh_Resume_Save(i_Company_Id    => v_Candidate.Company_Id,
                                i_Filial_Id     => v_Candidate.Filial_Id,
                                i_Resume_Code   => v_Resume.r_Varchar2('id'),
                                i_Candidate_Id  => v_Candidate.Person.Person_Id,
                                i_First_Name    => v_Candidate.Person.First_Name,
                                i_Last_Name     => v_Candidate.Person.Last_Name,
                                i_Middle_Name   => v_Candidate.Person.Middle_Name,
                                i_Gender_Code   => v_Gender_Map.o_Varchar2('id'),
                                i_Date_Of_Birth => v_Resume.o_Date('birth_date', 'yyyy-mm-dd'),
                                i_Extra_Data    => Substr(v_Resume.Json, 0, 3500));
      
        z_Hrec_Hh_Resumes.Init(p_Row          => r_Resume,
                               i_Company_Id   => v_Candidate.Company_Id,
                               i_Filial_Id    => v_Candidate.Filial_Id,
                               i_Resume_Code  => v_Resume.r_Varchar2('id'),
                               i_Candidate_Id => v_Candidate.Person.Person_Id);
      end if;
    
      if not z_Hrec_Vacancy_Candidates.Exist(i_Company_Id   => Ui.Company_Id,
                                             i_Filial_Id    => Ui.Filial_Id,
                                             i_Vacancy_Id   => g_Vacancy_Id,
                                             i_Candidate_Id => r_Resume.Candidate_Id,
                                             o_Row          => r_Candidate) then
        z_Hrec_Vacancy_Candidates.Init(p_Row              => r_Candidate,
                                       i_Company_Id       => Ui.Company_Id,
                                       i_Filial_Id        => Ui.Filial_Id,
                                       i_Vacancy_Id       => g_Vacancy_Id,
                                       i_Candidate_Id     => r_Resume.Candidate_Id,
                                       i_Stage_Id         => g_Stage_Id,
                                       i_Reject_Reason_Id => null);
      
        Hrec_Api.Vacancy_Add_Candidate(r_Candidate);
      end if;
    
      if r_Candidate.Stage_Id <> g_Stage_Id and
         g_Stage_Id <>
         Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => Ui.Company_Id,
                                     i_Pcode      => Hrec_Pref.c_Pcode_Stage_Todo) then
        Hrec_Util.Candidate_Operation_Fill(o_Operation        => v_Operation,
                                           i_Company_Id       => Ui.Company_Id,
                                           i_Filial_Id        => Ui.Filial_Id,
                                           i_Operation_Id     => Hrec_Next.Operation_Id,
                                           i_Vacancy_Id       => g_Vacancy_Id,
                                           i_Candidate_Id     => r_Resume.Candidate_Id,
                                           i_Operation_Kind   => Hrec_Pref.c_Operation_Kind_Action,
                                           i_To_Stage_Id      => g_Stage_Id,
                                           i_Reject_Reason_Id => null,
                                           i_Note             => null);
      
        Hrec_Api.Candidate_Operation_Save(v_Operation);
      end if;
    
      if not z_Hrec_Hh_Negotiations.Exist(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Topic_Code => v_Negotiation_Map.r_Varchar2('id')) then
        Hrec_Api.Hh_Negotiation_Save(i_Company_Id       => Ui.Company_Id,
                                     i_Filial_Id        => Ui.Filial_Id,
                                     i_Topic_Code       => v_Negotiation_Map.r_Varchar2('id'),
                                     i_Event_Code       => null,
                                     i_Negotiation_Date => null,
                                     i_Vacancy_Code     => g_Vacancy_Code,
                                     i_Resume_Code      => v_Resume.r_Varchar2('id'));
      end if;
    end loop;
  
    return Fazo.Zip_Map('total_pages', i_Data.r_Number('pages'));
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Load_Olx_Candidate_Response(p Hashmap) is
    v_Data          Hashmap;
    v_Person_Id     number;
    v_Candidate     Href_Pref.Candidate_Rt;
    r_Candidate     Hrec_Vacancy_Candidates%rowtype;
    r_Olx_Candidate Hrec_Olx_Vacancy_Candidates%rowtype;
  begin
    if p.o_Hashmap('error') is not null then
      Hrec_Error.Raise_033;
    end if;
  
    v_Data := p.o_Hashmap('data');
  
    if v_Data.o_Varchar2('name') is not null then
      r_Olx_Candidate := z_Hrec_Olx_Vacancy_Candidates.Load(i_Company_Id     => Ui.Company_Id,
                                                            i_Filial_Id      => Ui.Filial_Id,
                                                            i_Vacancy_Id     => g_Vacancy_Id,
                                                            i_Candidate_Code => g_Candidate_Code);
    
      if r_Olx_Candidate.Candidate_Id is null then
        v_Person_Id := Md_Next.Person_Id;
      else
        v_Person_Id := r_Olx_Candidate.Candidate_Id;
      end if;
    
      Href_Util.Candidate_New(o_Candidate        => v_Candidate,
                              i_Company_Id       => Ui.Company_Id,
                              i_Filial_Id        => Ui.Filial_Id,
                              i_Candidate_Id     => v_Person_Id,
                              i_Person_Type_Id   => null,
                              i_Candidate_Kind   => Href_Pref.c_Candidate_Kind_New,
                              i_First_Name       => trim(v_Data.r_Varchar2('name')),
                              i_Last_Name        => null,
                              i_Middle_Name      => null,
                              i_Gender           => Md_Pref.c_Pg_Male,
                              i_Birthday         => null,
                              i_Photo_Sha        => null,
                              i_Region_Id        => null,
                              i_Main_Phone       => null,
                              i_Extra_Phone      => null,
                              i_Email            => null,
                              i_Address          => null,
                              i_Legal_Address    => null,
                              i_Source_Id        => null,
                              i_Wage_Expectation => null,
                              i_Cv_Sha           => null,
                              i_Note             => null,
                              i_Edu_Stages       => Array_Number(),
                              i_Candidate_Jobs   => Array_Number());
    
      Href_Api.Candidate_Save(v_Candidate);
    
      if not z_Hrec_Vacancy_Candidates.Exist(i_Company_Id   => Ui.Company_Id,
                                             i_Filial_Id    => Ui.Filial_Id,
                                             i_Vacancy_Id   => g_Vacancy_Id,
                                             i_Candidate_Id => v_Person_Id) then
        z_Hrec_Vacancy_Candidates.Init(p_Row              => r_Candidate,
                                       i_Company_Id       => Ui.Company_Id,
                                       i_Filial_Id        => Ui.Filial_Id,
                                       i_Vacancy_Id       => g_Vacancy_Id,
                                       i_Candidate_Id     => v_Person_Id,
                                       i_Stage_Id         => Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => Ui.Company_Id,
                                                                                         i_Pcode      => Hrec_Pref.c_Pcode_Stage_Todo),
                                       i_Reject_Reason_Id => null);
      
        Hrec_Api.Vacancy_Add_Candidate(r_Candidate);
      end if;
    
      if r_Olx_Candidate.Candidate_Id is null then
        Hrec_Api.Olx_Vacancy_Candidate_Save(i_Company_Id     => Ui.Company_Id,
                                            i_Filial_Id      => Ui.Filial_Id,
                                            i_Vacancy_Id     => g_Vacancy_Id,
                                            i_Candidate_Code => g_Candidate_Code,
                                            i_Candidate_Id   => v_Person_Id);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Olx_Candidate_Info(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Vacancy_Id     => p.r_Number('vacancy_id'),
                 i_Candidate_Code => p.r_Number('candidate_code'));
  
    return Hrec_Api.Olx_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                        i_User_Id            => Ui.User_Id,
                                        i_Host_Uri           => Hrec_Pref.c_Olx_Api_Url,
                                        i_Api_Uri            => Hrec_Pref.v_Olx_Get_Users_Url || '/' ||
                                                                p.r_Number('candidate_code'),
                                        i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                        i_Responce_Procedure => 'Ui_Vhr576.Load_Olx_Candidate_Response',
                                        i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Olx_Candidates_Response(p Hashmap) return Hashmap is
    v_Candidate_Codes Array_Number := Array_Number();
    v_Datas           Arraylist;
    v_Data            Hashmap;
    result            Hashmap := Hashmap();
  begin
    if p.o_Arraylist('data') is null then
      Hrec_Error.Raise_032;
    end if;
  
    v_Datas := p.o_Arraylist('data');
    v_Candidate_Codes.Extend(v_Datas.Count);
  
    for i in 1 .. v_Datas.Count
    loop
      v_Data := Treat(v_Datas.r_Hashmap(i) as Hashmap);
      v_Candidate_Codes(i) := v_Data.r_Number('interlocutor_id');
    end loop;
  
    Hrec_Api.Olx_Vacancy_Candidates_Save(i_Company_Id      => Ui.Company_Id,
                                         i_Filial_Id       => Ui.Filial_Id,
                                         i_Vacancy_Id      => g_Vacancy_Id,
                                         i_Candidate_Codes => v_Candidate_Codes);
  
    Result.Put('candidate_codes', v_Candidate_Codes);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Olx_Vacation_Candidates(p Hashmap) return Runtime_Service is
    v_Query_Parameters Gmap := Gmap();
  begin
    Init_Globals(i_Vacancy_Id => p.r_Number('vacancy_id'));
  
    v_Query_Parameters.Put('advert_id', p.r_Number('olx_vacancy_code'));
  
    return Hrec_Api.Olx_Runtime_Service(i_Company_Id         => Ui.Company_Id,
                                        i_User_Id            => Ui.User_Id,
                                        i_Host_Uri           => Hrec_Pref.c_Olx_Api_Url,
                                        i_Api_Uri            => Hrec_Pref.c_Olx_Get_Thread_Url,
                                        i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                        i_Uri_Query_Params   => v_Query_Parameters,
                                        i_Responce_Procedure => 'ui_vhr576.Load_Olx_Candidates_Response');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hrec_Reject_Reasons
       set Company_Id       = null,
           Reject_Reason_Id = null,
           name             = null,
           State            = null,
           Order_No         = null;
  end;

end Ui_Vhr576;
/
