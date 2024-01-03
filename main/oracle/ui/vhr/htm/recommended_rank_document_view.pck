create or replace package Ui_Vhr611 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure To_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Set_Training(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Training(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Waiting(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure To_Approved(p Hashmap);
end Ui_Vhr611;
/
create or replace package body Ui_Vhr611 is
  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('status_new',
                           Htm_Pref.c_Document_Status_New,
                           'status_set_training',
                           Htm_Pref.c_Document_Status_Set_Training,
                           'status_training',
                           Htm_Pref.c_Document_Status_Training,
                           'status_waiting',
                           Htm_Pref.c_Document_Status_Waiting,
                           'status_approved',
                           Htm_Pref.c_Document_Status_Approved);
    Result.Put('training_subjects_indicator',
               Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                      i_Pcode      => Href_Pref.c_Pcode_Indicator_Trainings_Subjects));
    Result.Put('exam_score_indicator',
               Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                      i_Pcode      => Href_Pref.c_Pcode_Indicator_Exam_Results));
    Result.Put('increment_status_ignore', Htm_Pref.c_Increment_Status_Ignored);
    Result.Put('increment_status_success', Htm_Pref.c_Increment_Status_Success);
    Result.Put('increment_status_failure', Htm_Pref.c_Increment_Status_Failure);
  
    Result.Put('indicator_used_automatically', Href_Pref.c_Indicator_Used_Automatically);
    Result.Put('increment_statuses', Fazo.Zip_Matrix_Transposed(Htm_Util.Increment_Statuses));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Matrix   Matrix_Varchar2;
    r_Document Htm_Recommended_Rank_Documents%rowtype;
    result     Hashmap := Hashmap();
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Load(i_Company_Id  => Ui.Company_Id,
                                                        i_Filial_Id   => Ui.Filial_Id,
                                                        i_Document_Id => p.r_Number('document_id'));
  
    result := z_Htm_Recommended_Rank_Documents.To_Map(r_Document,
                                                      z.Document_Id,
                                                      z.Document_Number,
                                                      z.Document_Date,
                                                      z.Note,
                                                      z.Status,
                                                      z.Created_On,
                                                      z.Modified_On);
  
    Result.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Document.Company_Id, i_Filial_Id => r_Document.Filial_Id, i_Division_Id => r_Document.Division_Id).Name);
    Result.Put('status_name', Htm_Util.t_Document_Status(r_Document.Status));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Document.Company_Id, i_User_Id => r_Document.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Document.Company_Id, i_User_Id => r_Document.Modified_By).Name);
  
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
  Procedure To_New(p Hashmap) is
  begin
    Htm_Api.Recommended_Rank_Document_Status_New(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Document_Id => p.r_Number('document_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Set_Training(p Hashmap) is
  begin
    Htm_Api.Recommended_Rank_Document_Status_Set_Training(i_Company_Id  => Ui.Company_Id,
                                                          i_Filial_Id   => Ui.Filial_Id,
                                                          i_Document_Id => p.r_Number('document_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Training(p Hashmap) is
  begin
    Htm_Api.Recommended_Rank_Document_Status_Training(i_Company_Id  => Ui.Company_Id,
                                                      i_Filial_Id   => Ui.Filial_Id,
                                                      i_Document_Id => p.r_Number('document_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Waiting(p Hashmap) is
  begin
    Htm_Api.Recommended_Rank_Document_Status_Waiting(i_Company_Id  => Ui.Company_Id,
                                                     i_Filial_Id   => Ui.Filial_Id,
                                                     i_Document_Id => p.r_Number('document_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Approved(p Hashmap) is
  begin
    Htm_Api.Recommended_Rank_Document_Status_Approved(i_Company_Id  => Ui.Company_Id,
                                                      i_Filial_Id   => Ui.Filial_Id,
                                                      i_Document_Id => p.r_Number('document_id'));
  end;

end Ui_Vhr611;
/
