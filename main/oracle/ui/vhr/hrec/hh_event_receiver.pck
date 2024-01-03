create or replace package Ui_Vhr618 is
  ----------------------------------------------------------------------------------------------------
  Procedure Resume_Handler(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Event_Handler(p Hashmap) return Runtime_Service;
end Ui_Vhr618;
/
create or replace package body Ui_Vhr618 is
  ----------------------------------------------------------------------------------------------------
  g_Company_Id  number(20);
  g_Filial_Id   number(20);
  g_Vacancy_Id  number(20);
  g_Resume_Code varchar2(100);

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Global
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Vacancy_Id  number,
    i_Resume_Code varchar2
  ) is
  begin
    g_Company_Id  := i_Company_Id;
    g_Filial_Id   := i_Filial_Id;
    g_Vacancy_Id  := i_Vacancy_Id;
    g_Resume_Code := i_Resume_Code;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Phone(p Hashmap) return varchar2 is
    v_List    Arraylist := Nvl(p.o_Arraylist('contact'), Arraylist());
    v_Contact Hashmap;
    v_Type    Hashmap;
    v_Value   Hashmap;
  begin
    for i in 1 .. v_List.Count
    loop
      v_Contact := Treat(v_List.r_Hashmap(i) as Hashmap);
      v_Type    := v_Contact.r_Hashmap('type');
    
      continue when v_Type.r_Varchar2('id') <> Hrec_Pref.c_Hh_Contact_Type_Phone;
    
      v_Value := v_Contact.r_Hashmap('value');
    
      return v_Value.r_Varchar2('formatted');
    end loop;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Email(p Hashmap) return varchar2 is
    v_List    Arraylist := Nvl(p.o_Arraylist('contact'), Arraylist());
    v_Contact Hashmap;
    v_Type    Hashmap;
  begin
    for i in 1 .. v_List.Count
    loop
      v_Contact := Treat(v_List.r_Hashmap(i) as Hashmap);
      v_Type    := v_Contact.r_Hashmap('type');
    
      continue when v_Type.r_Varchar2('id') <> Hrec_Pref.c_Hh_Contact_Type_Email;
    
      return v_Contact.r_Varchar2('value');
    end loop;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Resume_Handler(p Hashmap) is
    v_Candidate   Href_Pref.Candidate_Rt;
    v_Gender_Code varchar2(100);
    v_Gender      varchar2(1);
    r_Candidate   Hrec_Vacancy_Candidates%rowtype;
  begin
    if not z_Hrec_Hh_Resumes.Exist_Lock(i_Company_Id  => g_Company_Id,
                                        i_Filial_Id   => g_Filial_Id,
                                        i_Resume_Code => g_Resume_Code) then
      --------------------------------------------------
      -- candidate save
      --------------------------------------------------
      v_Gender_Code := p.o_Varchar2('gender_id');
    
      if v_Gender_Code = Hrec_Pref.c_Hh_Gender_Male then
        v_Gender := Md_Pref.c_Pg_Male;
      elsif v_Gender_Code = Hrec_Pref.c_Hh_Gender_Female then
        v_Gender := Md_Pref.c_Pg_Female;
      end if;
    
      Href_Util.Candidate_New(o_Candidate        => v_Candidate,
                              i_Company_Id       => g_Company_Id,
                              i_Filial_Id        => g_Filial_Id,
                              i_Candidate_Id     => Md_Next.Person_Id,
                              i_Person_Type_Id   => null,
                              i_Candidate_Kind   => Href_Pref.c_Candidate_Kind_New,
                              i_First_Name       => trim(p.r_Varchar2('first_name')),
                              i_Last_Name        => trim(p.o_Varchar2('last_name')),
                              i_Middle_Name      => trim(p.o_Varchar2('middle_name')),
                              i_Gender           => v_Gender,
                              i_Birthday         => p.o_Date('birth_date', 'yyyy-mm-dd'),
                              i_Photo_Sha        => null,
                              i_Region_Id        => null,
                              i_Main_Phone       => Get_Phone(p),
                              i_Extra_Phone      => null,
                              i_Email            => Get_Email(p),
                              i_Address          => null,
                              i_Legal_Address    => null,
                              i_Source_Id        => null,
                              i_Wage_Expectation => null,
                              i_Cv_Sha           => null,
                              i_Note             => null,
                              i_Edu_Stages       => Array_Number(),
                              i_Candidate_Jobs   => Array_Number());
    
      Href_Api.Candidate_Save(v_Candidate);
    
      --------------------------------------------------
      -- resume save
      --------------------------------------------------
      Hrec_Api.Hh_Resume_Save(i_Company_Id    => g_Company_Id,
                              i_Filial_Id     => g_Filial_Id,
                              i_Resume_Code   => g_Resume_Code,
                              i_Candidate_Id  => v_Candidate.Person.Person_Id,
                              i_First_Name    => v_Candidate.Person.First_Name,
                              i_Last_Name     => v_Candidate.Person.Last_Name,
                              i_Middle_Name   => v_Candidate.Person.Middle_Name,
                              i_Gender_Code   => v_Gender_Code,
                              i_Date_Of_Birth => v_Candidate.Person.Birthday,
                              i_Extra_Data    => Substr(p.Json(), 1, 3500));
    end if;
  
    if not z_Hrec_Vacancy_Candidates.Exist_Lock(i_Company_Id   => g_Company_Id,
                                                i_Filial_Id    => g_Filial_Id,
                                                i_Vacancy_Id   => g_Vacancy_Id,
                                                i_Candidate_Id => v_Candidate.Person.Person_Id) then
      --------------------------------------------------
      -- vacancy add candidate
      --------------------------------------------------
      r_Candidate.Company_Id   := g_Company_Id;
      r_Candidate.Filial_Id    := g_Filial_Id;
      r_Candidate.Vacancy_Id   := g_Vacancy_Id;
      r_Candidate.Candidate_Id := v_Candidate.Person.Person_Id;
    
      Hrec_Api.Vacancy_Add_Candidate(r_Candidate);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Event_Save
  (
    i_Company_Id number,
    p            Hashmap
  ) is
  begin
    Hrec_Api.Hh_Event_Save(i_Company_Id        => i_Company_Id,
                           i_Event_Code        => p.r_Varchar2('id'),
                           i_Subscription_Code => p.r_Varchar2('subscription_id'),
                           i_Event_Type        => p.r_Varchar2('action_type'),
                           i_User_Code         => p.r_Varchar2('user_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function New_Negotiation_Save(p Hashmap) return Runtime_Service is
    v_Company_Id        number;
    v_Filial_Id         number;
    v_User_Id           number;
    v_Resume_Code       varchar2(100);
    v_Payload           Hashmap := p.r_Hashmap('payload');
    v_Vacancy_Code      varchar2(100) := v_Payload.r_Varchar2('vacancy_id');
    r_Published_Vacancy Hrec_Hh_Published_Vacancies%rowtype;
  
  begin
    v_Company_Id        := Hrec_Util.Company_Id_By_Employer_Code(v_Payload.r_Varchar2('employer_id'));
    r_Published_Vacancy := Hrec_Util.Load_Published_Vacancy(i_Company_Id   => v_Company_Id,
                                                            i_Vacancy_Code => v_Vacancy_Code);
    v_Filial_Id         := r_Published_Vacancy.Filial_Id;
    v_User_Id           := Hrec_Util.Subscription_User_Id(v_Company_Id);
    v_Resume_Code       := v_Payload.r_Varchar2('resume_id');
  
    Ui_Context.Init(i_User_Id      => v_User_Id,
                    i_Project_Code => Verifix.Project_Code,
                    i_Filial_Id    => v_Filial_Id);
  
    Event_Save(i_Company_Id => v_Company_Id, p => p);
  
    Hrec_Api.Hh_Negotiation_Save(i_Company_Id       => v_Company_Id,
                                 i_Filial_Id        => v_Filial_Id,
                                 i_Topic_Code       => v_Payload.r_Varchar2('topic_id'),
                                 i_Event_Code       => p.r_Varchar2('id'),
                                 i_Negotiation_Date => sysdate,
                                 i_Vacancy_Code     => v_Vacancy_Code,
                                 i_Resume_Code      => v_Resume_Code);
  
    if v_Vacancy_Code is null then
      return null;
    end if;
  
    Init_Global(i_Company_Id  => v_Company_Id,
                i_Filial_Id   => v_Filial_Id,
                i_Vacancy_Id  => r_Published_Vacancy.Vacancy_Id,
                i_Resume_Code => v_Resume_Code);
  
    return Hrec_Api.Vacancy_Runtime_Service(i_Company_Id         => v_Company_Id,
                                            i_User_Id            => Hrec_Util.Subscription_User_Id(v_Company_Id),
                                            i_Host_Uri           => Hrec_Pref.c_Head_Hunter_Api_Url,
                                            i_Api_Uri            => Hrec_Pref.c_Load_Candidate_Resume_Url || '/' ||
                                                                    v_Resume_Code,
                                            i_Api_Method         => Href_Pref.c_Http_Method_Get,
                                            i_Responce_Procedure => 'Ui_Vhr618.Resume_Handler',
                                            i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Event_Handler(p Hashmap) return Runtime_Service is
    v_Event_Type varchar2(100) := p.r_Varchar2('action_type');
  begin
    if v_Event_Type = Hrec_Pref.c_Hh_Event_Type_New_Negotiation then
      return New_Negotiation_Save(p);
    end if;
  end;

end Ui_Vhr618;
/
