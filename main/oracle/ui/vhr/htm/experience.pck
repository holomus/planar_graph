create or replace package Ui_Vhr528 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Indicators return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Exams return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Subjects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr528;
/
create or replace package body Ui_Vhr528 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Ranks return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_ranks',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('rank_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Indicators return Fazo_Query is
    v_Experience_Indicator_Group number;
  
    q Fazo_Query;
  begin
    v_Experience_Indicator_Group := Href_Util.Indicator_Group_Id(i_Company_Id => Ui.Company_Id,
                                                                 i_Pcode      => Href_Pref.c_Pcode_Indicator_Group_Experience);
  
    q := Fazo_Query('select q.*
                       from href_indicators q
                      where q.company_id = :company_id
                        and q.indicator_group_id = :experience_indicator_group
                        and q.state = :state',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'experience_indicator_group',
                                 v_Experience_Indicator_Group,
                                 'state',
                                 'A'));
  
    q.Number_Field('indicator_id', 'indicator_group_id');
    q.Varchar2_Field('name', 'pcode');
  
    return q;
  end;

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
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('training_subjects_indicator',
                           Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Trainings_Subjects),
                           'exam_score_indicator',
                           Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Exam_Results),
                           'attendance_percentage_indicator',
                           Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Average_Attendance_Percentage),
                           'perfomance_percentage_indicator',
                           Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Average_Perfomance_Percentage),
                           'experience_indicator_group',
                           Href_Util.Indicator_Group_Id(i_Company_Id => Ui.Company_Id,
                                                        i_Pcode      => Href_Pref.c_Pcode_Indicator_Group_Experience));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('state', 'A');
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    v_Matrix     Matrix_Varchar2;
    r_Experience Htm_Experiences%rowtype;
    result       Hashmap;
  begin
    r_Experience := z_Htm_Experiences.Load(i_Company_Id    => Ui.Company_Id,
                                           i_Filial_Id     => Ui.Filial_Id,
                                           i_Experience_Id => p.r_Number('experience_id'));
  
    result := z_Htm_Experiences.To_Map(r_Experience,
                                       z.Experience_Id,
                                       z.Name,
                                       z.Order_No,
                                       z.State,
                                       z.Code);
  
    select Array_Varchar2(q.From_Rank_Id,
                          (select Rk.Name
                             from Mhr_Ranks Rk
                            where Rk.Company_Id = q.Company_Id
                              and Rk.Filial_Id = q.Filial_Id
                              and Rk.Rank_Id = q.From_Rank_Id),
                          q.To_Rank_Id,
                          (select Kr.Name
                             from Mhr_Ranks Kr
                            where Kr.Company_Id = q.Company_Id
                              and Kr.Filial_Id = q.Filial_Id
                              and Kr.Rank_Id = q.To_Rank_Id),
                          q.Order_No)
      bulk collect
      into v_Matrix
      from Htm_Experience_Periods q
     where q.Company_Id = r_Experience.Company_Id
       and q.Filial_Id = r_Experience.Filial_Id
       and q.Experience_Id = r_Experience.Experience_Id;
  
    Result.Put('periods', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.From_Rank_Id,
                          q.Attempt_No,
                          q.Period,
                          q.Nearest,
                          q.Penalty_Period,
                          q.Exam_Id,
                          (select t.Name
                             from Hln_Exams t
                            where t.Company_Id = q.Company_Id
                              and t.Filial_Id = q.Filial_Id
                              and t.Exam_Id = q.Exam_Id),
                          q.Success_Score,
                          q.Ignore_Score,
                          q.Recommend_Failure)
      bulk collect
      into v_Matrix
      from Htm_Experience_Period_Attempts q
     where q.Company_Id = r_Experience.Company_Id
       and q.Filial_Id = r_Experience.Filial_Id
       and q.Experience_Id = r_Experience.Experience_Id;
  
    Result.Put('attempts', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.From_Rank_Id, q.Attempt_No, q.Indicator_Id, t.Name)
      bulk collect
      into v_Matrix
      from Htm_Experience_Period_Indicators q
      join Href_Indicators t
        on t.Company_Id = q.Company_Id
       and t.Indicator_Id = q.Indicator_Id
     where q.Company_Id = r_Experience.Company_Id
       and q.Filial_Id = r_Experience.Filial_Id
       and q.Experience_Id = r_Experience.Experience_Id;
  
    Result.Put('indicators', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.From_Rank_Id,
                          q.Attempt_No,
                          q.Subject_Id,
                          (select t.Name
                             from Hln_Training_Subjects t
                            where t.Company_Id = q.Company_Id
                              and t.Filial_Id = q.Filial_Id
                              and t.Subject_Id = q.Subject_Id))
      bulk collect
      into v_Matrix
      from Htm_Experience_Training_Subjects q
     where q.Company_Id = r_Experience.Company_Id
       and q.Filial_Id = r_Experience.Filial_Id
       and q.Experience_Id = r_Experience.Experience_Id;
  
    Result.Put('subjects', Fazo.Zip_Matrix(v_Matrix));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p               Hashmap,
    i_Experience_Id number
  ) return Hashmap is
    v_Experience Htm_Pref.Experience_Rt;
    v_Periods    Arraylist := p.o_Arraylist('periods');
    v_Period_Map Hashmap;
  
    v_Attempts    Arraylist;
    v_Attempt_Map Hashmap;
  
    v_Period Htm_Pref.Experience_Period_Rt;
  begin
    Htm_Util.Experience_New(o_Experience    => v_Experience,
                            i_Company_Id    => Ui.Company_Id,
                            i_Filial_Id     => Ui.Filial_Id,
                            i_Experience_Id => i_Experience_Id,
                            i_Name          => p.r_Varchar2('name'),
                            i_Order_No      => p.o_Number('order_no'),
                            i_State         => p.r_Varchar2('state'),
                            i_Code          => p.o_Varchar2('code'));
  
    for i in 1 .. v_Periods.Count
    loop
      v_Period_Map := Treat(v_Periods.r_Hashmap(i) as Hashmap);
      v_Attempts   := v_Period_Map.r_Arraylist('attempts');
    
      continue when v_Attempts is null or v_Attempts.Count = 0;
    
      Htm_Util.Experience_Period_New(o_Period       => v_Period,
                                     i_From_Rank_Id => v_Period_Map.r_Number('from_rank_id'),
                                     i_To_Rank_Id   => v_Period_Map.r_Number('to_rank_id'),
                                     i_Order_No     => i);
    
      for j in 1 .. v_Attempts.Count
      loop
        v_Attempt_Map := Treat(v_Attempts.r_Hashmap(j) as Hashmap);
      
        Htm_Util.Experience_Period_Attempt_Add(p_Period            => v_Period,
                                               i_Period            => v_Attempt_Map.o_Number('period'),
                                               i_Nearest           => v_Attempt_Map.o_Number('nearest'),
                                               i_Penalty_Period    => v_Attempt_Map.o_Number('penalty_period'),
                                               i_Exam_Id           => v_Attempt_Map.o_Number('exam_id'),
                                               i_Success_Score     => v_Attempt_Map.o_Number('success_score'),
                                               i_Ignore_Score      => v_Attempt_Map.o_Number('ignore_score'),
                                               i_Recommend_Failure => v_Attempt_Map.o_Varchar2('recommend_failure'),
                                               i_Indicators        => v_Attempt_Map.o_Array_Number('indicator_ids'),
                                               i_Subjects          => v_Attempt_Map.o_Array_Number('subject_ids'));
      end loop;
    
      Htm_Util.Experience_Period_Add(p_Experience => v_Experience, --
                                     i_Period     => v_Period);
    end loop;
  
    Htm_Api.Experience_Save(v_Experience);
  
    return Fazo.Zip_Map('experience_id', i_Experience_Id, 'name', v_Experience.Name);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Htm_Next.Experience_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap is
    v_Experience_Id number := p.r_Number('experience_id');
  begin
    z_Htm_Experiences.Lock_Only(i_Company_Id    => Ui.Company_Id,
                                i_Filial_Id     => Ui.Filial_Id,
                                i_Experience_Id => v_Experience_Id);
  
    return save(p, v_Experience_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null,
           Order_No   = null;
  
    update Href_Indicators
       set Company_Id         = null,
           Indicator_Id       = null,
           Indicator_Group_Id = null,
           name               = null,
           State              = null,
           Pcode              = null;
  
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

end Ui_Vhr528;
/
