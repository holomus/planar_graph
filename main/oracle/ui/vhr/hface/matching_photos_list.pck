create or replace package Ui_Vhr630 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Matching_Photos return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Check_Recognition_Job return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Check_Recognition_Job_Response(i_Response varchar2) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Recognition_Job(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Procedure Add_Recognition_Job_Response(i_Response varchar2);
  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector(p Hashmap) return Runtime_Service;
end Ui_Vhr630;
/
create or replace package body Ui_Vhr630 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Matching_Photos return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            nvl((select ''Y''
                                  from hface_calculated_photos cp
                                 where cp.company_id = q.company_id
                                   and cp.photo_sha = q.photo_sha),
                                ''N'') vector_calculated,
                            mp.matched_sha,
                            mp.match_score,
                            (round(1 - mp.match_score / :match_threshold, 2) * 100) match_score_percent
                       from htt_person_photos q
                       left join hface_matched_photos mp
                         on mp.company_id = q.company_id
                        and mp.photo_sha = q.photo_sha
                        and exists (select 1
                           from htt_person_photos qp
                          where qp.company_id = mp.company_id
                            and qp.photo_sha = mp.matched_sha)
                        and not exists (select 1
                           from htt_person_photos pp
                          where pp.company_id = q.company_id
                            and pp.person_id = q.person_id
                            and pp.photo_sha = mp.matched_sha)
                      where q.company_id = :company_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'match_threshold',
                                 Hface_Pref.c_Euclidian_Threshold));
  
    q.Number_Field('person_id', 'match_score', 'match_score_percent');
    q.Varchar2_Field('photo_sha', 'matched_sha', 'vector_calculated');
  
    q.Option_Field('vector_calculated_name',
                   'vector_calculated',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Refer_Field('person_name',
                  'person_id',
                  'select q.* 
                     from mr_natural_persons q
                    where q.company_id = :company_id',
                  'person_id',
                  'name');
  
    q.Multi_Number_Field('matched_person_ids',
                         'select q.* 
                            from htt_person_photos q
                           where q.company_id = :company_id',
                         '@photo_sha=$matched_sha',
                         'person_id');
  
    q.Refer_Field('matched_person_names',
                  'matched_person_ids',
                  'select q.* 
                     from mr_natural_persons q
                    where q.company_id = :company_id',
                  'person_id',
                  'name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Recognition_Job return Runtime_Service is
    v_Data Gmap := Gmap();
  begin
    v_Data.Put('company_id', Ui.Company_Id);
  
    return Hface_Core.Recognition_Runtime_Service(i_Response_Procedure => 'ui_vhr630.check_recognition_job_response',
                                                  i_Action             => Hface_Pref.c_Rs_Action_Check_Job,
                                                  i_Data               => v_Data,
                                                  i_Action_In          => Biruni_Pref.c_Rs_Action_In_Out_Varchar2);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Recognition_Job_Response(i_Response varchar2) return Hashmap is
  begin
    return Fazo.Zip_Map('job_running', i_Response);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Recognition_Job(p Hashmap) return Runtime_Service is
    v_All_Images varchar2(1) := p.r_Varchar2('all_images');
    v_Photo_Shas Array_Varchar2;
  
    v_Data Gmap := Gmap();
  begin
    select q.Photo_Sha
      bulk collect
      into v_Photo_Shas
      from Htt_Person_Photos q
     where q.Company_Id = Ui.Company_Id
       and (v_All_Images = 'Y' or not exists
            (select 1
               from Hface_Calculated_Photos Cp
              where Cp.Company_Id = q.Company_Id
                and Cp.Photo_Sha = q.Photo_Sha));
  
    delete Hface_Calculated_Photos q
     where q.Company_Id = Ui.Company_Id
       and q.Photo_Sha member of v_Photo_Shas;
  
    v_Data.Put('company_id', Ui.Company_Id);
    v_Data.Put('photo_shas', v_Photo_Shas);
  
    return Hface_Core.Recognition_Runtime_Service(i_Response_Procedure => 'ui_vhr630.add_recognition_job_response',
                                                  i_Action             => Hface_Pref.c_Rs_Action_Add_Job,
                                                  i_Api_Uri            => Hface_Pref.c_Recognition_Route_Embed,
                                                  i_Data               => v_Data,
                                                  i_Action_In          => Biruni_Pref.c_Rs_Action_In_Out_Varchar2,
                                                  i_Action_Out         => null);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add_Recognition_Job_Response(i_Response varchar2) is
  begin
    if i_Response <> 'success' then
      b.Raise_Not_Implemented;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector(p Hashmap) return Runtime_Service is
  begin
    return Uit_Hface.Calculate_Photo_Vector(i_Person_Id     => p.r_Number('person_id'),
                                            i_Photo_Shas    => p.r_Array_Varchar2('photo_shas'),
                                            i_Check_Setting => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Person_Photos
       set Company_Id = null,
           Person_Id  = null,
           Photo_Sha  = null;
  
    update Hface_Matched_Photos
       set Company_Id  = null,
           Photo_Sha   = null,
           Matched_Sha = null,
           Match_Score = null;
  
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  
    update Hface_Calculated_Photos
       set Company_Id = null,
           Photo_Sha  = null;
  end;

end Ui_Vhr630;
/
