create or replace package Ui_Vhr588 is
  ----------------------------------------------------------------------------------------------------
  Function Create_Candidate(Jo Json_Object_t) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Procedure Create_Candidate_Via_Telegram(Jo Json_Object_t);
end Ui_Vhr588;
/
create or replace package body Ui_Vhr588 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR588' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Candidate
  (
    Jo             Json_Object_t,
    i_Candidate_Id number := null
  ) return Json_Object_t is
    p             Gmap := Gmap(Jo);
    v_Lang        Gmap;
    v_Langs       Glist;
    v_Candidate   Href_Pref.Candidate_Rt;
    v_Name        Array_Varchar2;
    v_First_Name  varchar2(250);
    v_Last_Name   varchar2(250);
    v_Middle_Name varchar2(250);
    result        Gmap := Gmap();
  begin
    if p.Has('name') then
      v_Name := Fazo.Split(p.r_Varchar2('name'), ' ');
    
      if v_Name.Count = 1 then
        v_First_Name := v_Name(1);
      else
        v_First_Name := v_Name(2);
        v_Last_Name  := v_Name(1);
      
        if v_Name.Count >= 3 then
          for i in 3 .. v_Name.Count
          loop
            v_Middle_Name := v_Middle_Name || v_Name(i);
          
            if v_Name.Count <> i then
              v_Middle_Name := v_Middle_Name || ' ';
            end if;
          end loop;
        end if;
      end if;
    
    else
      v_First_Name  := p.r_Varchar2('first_name');
      v_Last_Name   := p.o_Varchar2('last_name');
      v_Middle_Name := p.o_Varchar2('middle_name');
    end if;
  
    Href_Util.Candidate_New(o_Candidate        => v_Candidate,
                            i_Company_Id       => Ui.Company_Id,
                            i_Filial_Id        => Ui.Filial_Id,
                            i_Candidate_Id     => Coalesce(i_Candidate_Id, Md_Next.Person_Id),
                            i_Person_Type_Id   => null,
                            i_Candidate_Kind   => Href_Pref.c_Candidate_Kind_New,
                            i_First_Name       => v_First_Name,
                            i_Last_Name        => v_Last_Name,
                            i_Middle_Name      => v_Middle_Name,
                            i_Gender           => p.r_Varchar2('gender'),
                            i_Birthday         => p.o_Date('birthday'),
                            i_Photo_Sha        => null,
                            i_Region_Id        => p.o_Number('region_id'),
                            i_Main_Phone       => p.o_Varchar2('main_phone'),
                            i_Extra_Phone      => p.o_Varchar2('extra_phone'),
                            i_Email            => p.o_Varchar2('email'),
                            i_Address          => p.o_Varchar2('address'),
                            i_Legal_Address    => p.o_Varchar2('legal_address'),
                            i_Source_Id        => null,
                            i_Wage_Expectation => p.o_Number('wage_expectation'),
                            i_Cv_Sha           => null,
                            i_Note             => p.o_Varchar2('note'),
                            i_Edu_Stages       => Nvl(p.o_Array_Number('edu_stage_ids'),
                                                      Array_Number()),
                            i_Candidate_Jobs   => Nvl(p.o_Array_Number('job_ids'), Array_Number()));
  
    -- langs
    v_Langs := Nvl(p.o_Glist('langs'), Glist());
  
    for i in 1 .. v_Langs.Count
    loop
      v_Lang := Gmap(v_Langs.r_Gmap(i));
    
      Href_Util.Candidate_Add_Lang(p_Candidate     => v_Candidate,
                                   i_Lang_Id       => v_Lang.r_Number('lang_id'),
                                   i_Lang_Level_Id => v_Lang.r_Number('level_id'));
    end loop;
  
    Href_Api.Candidate_Save(v_Candidate, i_Check_Required_Columns => false);
  
    Result.Put('candidate_id', v_Candidate.Person.Person_Id);
    Result.Put('name', trim(v_Last_Name || ' ' || v_First_Name || ' ' || v_Middle_Name));
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Create_Candidate(Jo Json_Object_t) return Json_Object_t is
  begin
    return Save_Candidate(Jo);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Create_Candidate_Via_Telegram(Jo Json_Object_t) is
    p           Gmap := Gmap(Jo);
    v_Candidate Gmap;
  
    r_Candidate    Hrec_Vacancy_Candidates%rowtype;
    r_Contact      Hrec_Telegram_Candidates%rowtype;
    v_Operation    Hrec_Pref.Candidate_Operation_Rt;
    v_Candidate_Id number;
    v_Vacancy_Id   number;
  
    v_Stage_Id number;
  begin
    r_Contact := Hrec_Util.Take_Telegram_Candidate(i_Company_Id   => Ui.Company_Id,
                                                   i_Filial_Id    => Ui.Filial_Id,
                                                   i_Contact_Code => p.r_Number('contact_code'));
  
    v_Candidate := Gmap(Save_Candidate(Jo, i_Candidate_Id => r_Contact.Candidate_Id));
  
    v_Candidate_Id := v_Candidate.r_Number('candidate_id');
  
    if r_Contact.Candidate_Id is null then
      Hrec_Api.Telegram_Candidate_Save(i_Company_Id   => Ui.Company_Id,
                                       i_Filial_Id    => Ui.Filial_Id,
                                       i_Candidate_Id => v_Candidate_Id,
                                       i_Contact_Code => p.r_Number('contact_code'));
    end if;
  
    v_Vacancy_Id := p.o_Number('vacancy_id');
  
    if v_Vacancy_Id is not null then
      r_Candidate.Company_Id   := Ui.Company_Id;
      r_Candidate.Filial_Id    := Ui.Filial_Id;
      r_Candidate.Vacancy_Id   := v_Vacancy_Id;
      r_Candidate.Candidate_Id := v_Candidate_Id;
    
      if not z_Hrec_Vacancy_Candidates.Exist(i_Company_Id   => r_Candidate.Company_Id,
                                             i_Filial_Id    => r_Candidate.Filial_Id,
                                             i_Vacancy_Id   => r_Candidate.Vacancy_Id,
                                             i_Candidate_Id => r_Candidate.Candidate_Id) then
        Hrec_Api.Vacancy_Add_Candidate(r_Candidate);
      end if;
    
      if p.o_Varchar2('test_failed') = 'Y' then
        v_Stage_Id := Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Hrec_Pref.c_Pcode_Stage_Rejected);
      
        Hrec_Util.Candidate_Operation_Fill(o_Operation        => v_Operation,
                                           i_Company_Id       => Ui.Company_Id,
                                           i_Filial_Id        => Ui.Filial_Id,
                                           i_Operation_Id     => Hrec_Next.Operation_Id,
                                           i_Vacancy_Id       => v_Vacancy_Id,
                                           i_Candidate_Id     => v_Candidate_Id,
                                           i_Operation_Kind   => Hrec_Pref.c_Operation_Kind_Action,
                                           i_To_Stage_Id      => v_Stage_Id,
                                           i_Reject_Reason_Id => null,
                                           i_Note             => case
                                                                   when p.o_Varchar2('test_score') is not null then
                                                                    t('testing score: $1',
                                                                      p.o_Varchar2('test_score'))
                                                                   else
                                                                    t('test failed')
                                                                 end);
      
        Hrec_Api.Candidate_Operation_Save(v_Operation);
      end if;
    end if;
  
  end;

end Ui_Vhr588;
/
