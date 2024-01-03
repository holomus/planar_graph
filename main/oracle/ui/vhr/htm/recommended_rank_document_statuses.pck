create or replace package Ui_Vhr677 is
  ----------------------------------------------------------------------------------------------------
  Function Recalc_Indicators(P1 Json_Object_t) return Json_Array_t;
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Edit_Statuses(P1 Json_Object_t);
end Ui_Vhr677;
/
create or replace package body Ui_Vhr677 is
  ----------------------------------------------------------------------------------------------------
  Function Recalc_Indicators(P1 Json_Object_t) return Json_Array_t is
    p Gmap := Gmap(P1);
  
    r_Document Htm_Recommended_Rank_Documents%rowtype;
  
    v_Staff  Htm_Pref.Recommended_Rank_Status_Rt;
    v_Staffs Htm_Pref.Recommended_Rank_Status_Nt;
  
    v_Indicator Href_Pref.Indicator_Rt;
  
    v_Staff_Ids Array_Number := p.r_Array_Number('staff_ids');
  
    v_Indicator_Map    Gmap;
    v_Indicators_Lists Glist;
  
    v_Staff_Map   Gmap;
    v_Staffs_List Glist := Glist();
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Load(i_Company_Id  => Ui.Company_Id,
                                                        i_Filial_Id   => Ui.Filial_Id,
                                                        i_Document_Id => p.r_Number('document_id'));
  
    v_Staffs := Htm_Util.Recommended_Rank_Document_Calc_Indicators(i_Company_Id        => r_Document.Company_Id,
                                                                   i_Filial_Id         => r_Document.Filial_Id,
                                                                   i_Document_Id       => r_Document.Document_Id,
                                                                   i_Staff_Ids         => v_Staff_Ids,
                                                                   i_Include_Trainings => false);
  
    for i in 1 .. v_Staffs.Count
    loop
      v_Staff := v_Staffs(i);
    
      v_Staff_Map        := Gmap();
      v_Indicators_Lists := Glist();
    
      for j in 1 .. v_Staff.Indicators.Count
      loop
        v_Indicator := v_Staff.Indicators(j);
      
        v_Indicator_Map := Gmap();
      
        v_Indicator_Map.Put('indicator_id', v_Indicator.Indicator_Id);
        v_Indicator_Map.Put('indicator_value', v_Indicator.Indicator_Value);
      
        v_Indicators_Lists.Push(v_Indicator_Map.Val);
      end loop;
    
      v_Staff_Map.Put('staff_id', v_Staff.Staff_Id);
      v_Staff_Map.Put('increment_status', v_Staff.Increment_Status);
      v_Staff_Map.Put('indicators', v_Indicators_Lists);
    
      v_Staffs_List.Push(v_Staff_Map.Val);
    end loop;
  
    return v_Staffs_List.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('training_subjects_indicator',
                           Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Trainings_Subjects),
                           'exam_score_indicator',
                           Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Exam_Results),
                           'increment_status_ignore',
                           Htm_Pref.c_Increment_Status_Ignored,
                           'increment_status_success',
                           Htm_Pref.c_Increment_Status_Success,
                           'increment_status_failure',
                           Htm_Pref.c_Increment_Status_Failure);
  
    Result.Put('indicator_used_automatically', Href_Pref.c_Indicator_Used_Automatically);
    Result.Put('increment_statuses', Fazo.Zip_Matrix_Transposed(Htm_Util.Increment_Statuses));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
    v_Matrix   Matrix_Varchar2;
    result     Hashmap := Hashmap;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Load(i_Company_Id  => Ui.Company_Id,
                                                        i_Filial_Id   => Ui.Filial_Id,
                                                        i_Document_Id => p.r_Number('document_id'));
  
    if r_Document.Status not in (Htm_Pref.c_Document_Status_Waiting) then
      Htm_Error.Raise_007(i_Document_Status => Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Waiting),
                          i_Current_Status  => Htm_Util.t_Document_Status(r_Document.Status));
    end if;
  
    Result.Put('document_id', r_Document.Document_Id);
    Result.Put('document_number', r_Document.Document_Number);
    Result.Put('document_date', r_Document.Document_Date);
    Result.Put('division_id', r_Document.Division_Id);
    Result.Put('note', r_Document.Note);
  
    select Array_Varchar2(Ts.Staff_Id,
                          q.Staff_Number,
                          (select Np.Name
                             from Mr_Natural_Persons Np
                            where Np.Company_Id = r_Document.Company_Id
                              and Np.Person_Id = q.Employee_Id),
                          q.Dismissal_Date,
                          Ts.Last_Change_Date,
                          Ts.New_Change_Date,
                          Ts.Period,
                          Ts.Nearest,
                          Ts.Old_Penalty_Period,
                          Ts.Success_Score,
                          Ts.Ignore_Score,
                          Ts.Recommend_Failure,
                          Ts.Increment_Status,
                          w.Name,
                          Ts.From_Rank_Id,
                          (select Mr.Name
                             from Mhr_Ranks Mr
                            where Mr.Company_Id = r_Document.Company_Id
                              and Mr.Filial_Id = r_Document.Filial_Id
                              and Mr.Rank_Id = Ts.From_Rank_Id),
                          (select Mr.Name
                             from Mhr_Ranks Mr
                            where Mr.Company_Id = r_Document.Company_Id
                              and Mr.Filial_Id = r_Document.Filial_Id
                              and Mr.Rank_Id = Ts.To_Rank_Id),
                          (select d.Name
                             from Mhr_Divisions d
                            where d.Company_Id = r_Document.Company_Id
                              and d.Filial_Id = r_Document.Filial_Id
                              and d.Division_Id = w.Division_Id),
                          (select j.Name
                             from Mhr_Jobs j
                            where j.Company_Id = r_Document.Company_Id
                              and j.Filial_Id = r_Document.Filial_Id
                              and j.Job_Id = w.Job_Id),
                          Ts.Attempt_No,
                          (select x.Name
                             from Hln_Exams x
                            where x.Company_Id = r_Document.Company_Id
                              and x.Filial_Id = r_Document.Filial_Id
                              and x.Exam_Id = Ts.Exam_Id),
                          (select Jr.Experience_Id
                             from Htm_Experience_Job_Ranks Jr
                            where Jr.Company_Id = r_Document.Company_Id
                              and Jr.Filial_Id = r_Document.Filial_Id
                              and Jr.Job_Id = w.Job_Id
                              and Jr.From_Rank_Id = Ts.From_Rank_Id),
                          (select Jr.Experience_Id
                             from Htm_Experience_Job_Ranks Jr
                            where Jr.Company_Id = r_Document.Company_Id
                              and Jr.Filial_Id = r_Document.Filial_Id
                              and Jr.Job_Id =
                                  Hpd_Util.Get_Closest_Job_Id(i_Company_Id => r_Document.Company_Id,
                                                              i_Filial_Id  => r_Document.Filial_Id,
                                                              i_Staff_Id   => Ts.Staff_Id,
                                                              i_Period     => Ts.New_Change_Date - 1)
                              and Jr.From_Rank_Id =
                                  Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => r_Document.Company_Id,
                                                               i_Filial_Id  => r_Document.Filial_Id,
                                                               i_Staff_Id   => Ts.Staff_Id,
                                                               i_Period     => Ts.New_Change_Date - 1)),
                          Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => r_Document.Company_Id,
                                                       i_Filial_Id  => r_Document.Filial_Id,
                                                       i_Staff_Id   => Ts.Staff_Id,
                                                       i_Period     => Ts.New_Change_Date - 1),
                          Ts.Note)
      bulk collect
      into v_Matrix
      from Htm_Recommended_Rank_Staffs Ts
      join Href_Staffs q
        on q.Company_Id = r_Document.Company_Id
       and q.Filial_Id = r_Document.Filial_Id
       and q.Staff_Id = Ts.Staff_Id
      join Mrf_Robots w
        on w.Company_Id = r_Document.Company_Id
       and w.Filial_Id = r_Document.Filial_Id
       and w.Robot_Id = Ts.Robot_Id
     where Ts.Company_Id = r_Document.Company_Id
       and Ts.Filial_Id = r_Document.Filial_Id
       and Ts.Document_Id = r_Document.Document_Id;
  
    Result.Put('staffs', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Staff_Id, q.Indicator_Id, x.Name, x.Used, q.Indicator_Value)
      bulk collect
      into v_Matrix
      from Htm_Recommended_Rank_Staff_Indicators q
      join Href_Indicators x
        on x.Company_Id = q.Company_Id
       and x.Indicator_Id = q.Indicator_Id
     where q.Company_Id = r_Document.Company_Id
       and q.Filial_Id = r_Document.Filial_Id
       and q.Document_Id = r_Document.Document_Id;
  
    Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Staff_Id,
                          (select t.Name
                             from Hln_Training_Subjects t
                            where t.Company_Id = q.Company_Id
                              and t.Filial_Id = q.Filial_Id
                              and t.Subject_Id = q.Subject_Id))
      bulk collect
      into v_Matrix
      from Htm_Recommended_Rank_Staff_Subjects q
     where q.Company_Id = r_Document.Company_Id
       and q.Filial_Id = r_Document.Filial_Id
       and q.Document_Id = r_Document.Document_Id;
  
    Result.Put('subjects', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit_Statuses(P1 Json_Object_t) is
    v_Staffs     Htm_Pref.Recommended_Rank_Status_Nt := Htm_Pref.Recommended_Rank_Status_Nt();
    v_Indicators Href_Pref.Indicator_Nt;
  
    v_Staffs_List Glist;
    v_Staff_Map   Gmap;
  
    v_Indicators_List Glist;
    v_Indicator_Map   Gmap;
  
    p Gmap := Gmap(P1);
  begin
    v_Staffs_List := p.r_Glist('staffs');
  
    for i in 1 .. v_Staffs_List.Count
    loop
      v_Staff_Map := Gmap(v_Staffs_List.r_Gmap(i));
    
      v_Indicators_List := v_Staff_Map.r_Glist('indicators');
      v_Indicators      := Href_Pref.Indicator_Nt();
    
      for j in 1 .. v_Indicators_List.Count
      loop
        v_Indicator_Map := Gmap(v_Indicators_List.r_Gmap(j));
      
        Href_Util.Indicator_Add(p_Indicators      => v_Indicators,
                                i_Indicator_Id    => v_Indicator_Map.r_Number('indicator_id'),
                                i_Indicator_Value => v_Indicator_Map.r_Number('indicator_value'));
      end loop;
    
      Htm_Util.Recommended_Rank_Add_Staff_Status(p_Staffs           => v_Staffs,
                                                 i_Staff_Id         => v_Staff_Map.r_Number('staff_id'),
                                                 i_Increment_Status => v_Staff_Map.r_Varchar2('increment_status'),
                                                 i_Indicators       => v_Indicators);
    end loop;
  
    Htm_Api.Recommended_Rank_Document_Update_Status(i_Company_Id  => Ui.Company_Id,
                                                    i_Filial_Id   => Ui.Filial_Id,
                                                    i_Document_Id => p.r_Number('document_id'),
                                                    i_Staffs      => v_Staffs);
  
    if p.o_Varchar2('approved') = 'Y' then
      Htm_Api.Recommended_Rank_Document_Status_Approved(i_Company_Id  => Ui.Company_Id,
                                                        i_Filial_Id   => Ui.Filial_Id,
                                                        i_Document_Id => p.r_Number('document_id'));
    end if;
  end;

end Ui_Vhr677;
/
