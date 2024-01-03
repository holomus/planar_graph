create or replace package Ui_Vhr676 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Exams return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Subjects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Edit_Trainings(P1 Json_Object_t);
end Ui_Vhr676;
/
create or replace package body Ui_Vhr676 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Exams return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_exams',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('exam_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Subjects return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_training_subjects',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('subject_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
    v_Matrix   Matrix_Varchar2;
    result     Hashmap := Hashmap;
  
    v_Subject_Indicator_Id number;
    v_Exam_Indicator_Id    number;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Load(i_Company_Id  => Ui.Company_Id,
                                                        i_Filial_Id   => Ui.Filial_Id,
                                                        i_Document_Id => p.r_Number('document_id'));
  
    if r_Document.Status not in (Htm_Pref.c_Document_Status_Set_Training) then
      Htm_Error.Raise_006(i_Document_Status => Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Set_Training),
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
                          Ts.New_Change_Date,
                          Ts.Robot_Id,
                          w.Name,
                          Ts.From_Rank_Id,
                          (select Mr.Name
                             from Mhr_Ranks Mr
                            where Mr.Company_Id = r_Document.Company_Id
                              and Mr.Filial_Id = r_Document.Filial_Id
                              and Mr.Rank_Id = Ts.From_Rank_Id),
                          Ts.To_Rank_Id,
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
                          Ts.Exam_Id,
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
  
    v_Subject_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => r_Document.Company_Id,
                                                     i_Pcode      => Href_Pref.c_Pcode_Indicator_Trainings_Subjects);
    v_Exam_Indicator_Id    := Href_Util.Indicator_Id(i_Company_Id => r_Document.Company_Id,
                                                     i_Pcode      => Href_Pref.c_Pcode_Indicator_Exam_Results);
  
    select Array_Varchar2(q.Staff_Id, q.Indicator_Id)
      bulk collect
      into v_Matrix
      from Htm_Recommended_Rank_Staff_Indicators q
     where q.Company_Id = r_Document.Company_Id
       and q.Filial_Id = r_Document.Filial_Id
       and q.Document_Id = r_Document.Document_Id
       and q.Indicator_Id in (v_Subject_Indicator_Id, v_Exam_Indicator_Id);
  
    Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Staff_Id,
                          q.Subject_Id,
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
  
    Result.Put('references',
               Fazo.Zip_Map('training_subjects_indicator',
                            v_Subject_Indicator_Id,
                            'exam_score_indicator',
                            v_Exam_Indicator_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit_Trainings(P1 Json_Object_t) is
    v_Staffs Htm_Pref.Recommended_Rank_Training_Nt := Htm_Pref.Recommended_Rank_Training_Nt();
  
    v_Staffs_List Glist;
    v_Staff_Map   Gmap;
  
    p Gmap := Gmap(P1);
  begin
    v_Staffs_List := p.r_Glist('staffs');
  
    for i in 1 .. v_Staffs_List.Count
    loop
      v_Staff_Map := Gmap(v_Staffs_List.r_Gmap(i));
    
      Htm_Util.Recommended_Rank_Add_Staff_Training(p_Staffs      => v_Staffs,
                                                   i_Staff_Id    => v_Staff_Map.r_Number('staff_id'),
                                                   i_Exam_Id     => v_Staff_Map.r_Number('exam_id'),
                                                   i_Subject_Ids => v_Staff_Map.r_Array_Number('subject_ids'));
    end loop;
  
    Htm_Api.Recommended_Rank_Document_Update_Trainings(i_Company_Id  => Ui.Company_Id,
                                                       i_Filial_Id   => Ui.Filial_Id,
                                                       i_Document_Id => p.r_Number('document_id'),
                                                       i_Staffs      => v_Staffs);
  
    if p.o_Varchar2('training') = 'Y' then
      Htm_Api.Recommended_Rank_Document_Status_Training(i_Company_Id  => Ui.Company_Id,
                                                        i_Filial_Id   => Ui.Filial_Id,
                                                        i_Document_Id => p.r_Number('document_id'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hln_Exams
       set Company_Id = null,
           Filial_Id  = null,
           Exam_Id    = null,
           name       = null,
           State      = null;
  
    update Hln_Training_Subjects
       set Company_Id = null,
           Filial_Id  = null,
           Subject_Id = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr676;
/
