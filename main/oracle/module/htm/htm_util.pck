create or replace package Htm_Util is
  ----------------------------------------------------------------------------------------------------
  -- Experience
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_New
  (
    o_Experience    out Htm_Pref.Experience_Rt,
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number,
    i_Name          varchar2,
    i_Order_No      number,
    i_State         varchar2,
    i_Code          varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Period_New
  (
    o_Period       out nocopy Htm_Pref.Experience_Period_Rt,
    i_From_Rank_Id number,
    i_To_Rank_Id   number,
    i_Order_No     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Period_Add
  (
    p_Experience in out nocopy Htm_Pref.Experience_Rt,
    i_Period     Htm_Pref.Experience_Period_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Period_Attempt_Add
  (
    p_Period            in out nocopy Htm_Pref.Experience_Period_Rt,
    i_Period            number,
    i_Nearest           number,
    i_Penalty_Period    number,
    i_Exam_Id           number,
    i_Success_Score     number,
    i_Ignore_Score      number,
    i_Recommend_Failure varchar2,
    i_Indicators        Array_Number,
    i_Subjects          Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  -- Recommended Rank Document
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_New
  (
    o_Document        out Htm_Pref.Recommended_Rank_Document_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Document_Id     number,
    i_Document_Number varchar2,
    i_Document_Date   date,
    i_Division_Id     number,
    i_Note            varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Recommended_Rank_Document_Add_Staff
  (
    p_Document           in out nocopy Htm_Pref.Recommended_Rank_Document_Rt,
    i_Staff_Id           number,
    i_Robot_Id           number,
    i_From_Rank_Id       number,
    i_Last_Change_Date   date,
    i_To_Rank_Id         number,
    i_New_Change_Date    date,
    i_Attempt_No         number,
    i_Experience_Id      number,
    i_Old_Penalty_Period number,
    i_Period             number,
    i_Nearest            number,
    i_Note               varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Add_Staff_Training
  (
    p_Staffs      in out nocopy Htm_Pref.Recommended_Rank_Training_Nt,
    i_Staff_Id    number,
    i_Exam_Id     number,
    i_Subject_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Add_Staff_Status
  (
    p_Staffs           in out nocopy Htm_Pref.Recommended_Rank_Status_Nt,
    i_Staff_Id         number,
    i_Increment_Status varchar2,
    i_Indicators       Href_Pref.Indicator_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Function Recommended_Rank_Document_Calc_Indicators
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Document_Id       number,
    i_Staff_Ids         Array_Number := null,
    i_Include_Trainings boolean := false
  ) return Htm_Pref.Recommended_Rank_Status_Nt;
  ----------------------------------------------------------------------------------------------------
  Function t_Document_Status(i_Status varchar2) return varchar2;
  Function Document_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Increment_Status(i_Status varchar2) return varchar2;
  Function Increment_Statuses return Matrix_Varchar2;
end Htm_Util;
/
create or replace package body Htm_Util is
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
    return b.Translate('HTM:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  -- Experience
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_New
  (
    o_Experience    out Htm_Pref.Experience_Rt,
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number,
    i_Name          varchar2,
    i_Order_No      number,
    i_State         varchar2,
    i_Code          varchar2
  ) is
  begin
    o_Experience.Company_Id    := i_Company_Id;
    o_Experience.Filial_Id     := i_Filial_Id;
    o_Experience.Experience_Id := i_Experience_Id;
    o_Experience.Name          := i_Name;
    o_Experience.Order_No      := i_Order_No;
    o_Experience.State         := i_State;
    o_Experience.Code          := i_Code;
  
    o_Experience.Periods := Htm_Pref.Experience_Period_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Period_New
  (
    o_Period       out nocopy Htm_Pref.Experience_Period_Rt,
    i_From_Rank_Id number,
    i_To_Rank_Id   number,
    i_Order_No     number
  ) is
  begin
    o_Period.From_Rank_Id := i_From_Rank_Id;
    o_Period.To_Rank_Id   := i_To_Rank_Id;
    o_Period.Order_No     := i_Order_No;
  
    o_Period.Attempts := Htm_Pref.Experience_Period_Attempt_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Period_Add
  (
    p_Experience in out nocopy Htm_Pref.Experience_Rt,
    i_Period     Htm_Pref.Experience_Period_Rt
  ) is
  begin
    p_Experience.Periods.Extend;
    p_Experience.Periods(p_Experience.Periods.Count) := i_Period;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Period_Attempt_Add
  (
    p_Period            in out nocopy Htm_Pref.Experience_Period_Rt,
    i_Period            number,
    i_Nearest           number,
    i_Penalty_Period    number,
    i_Exam_Id           number,
    i_Success_Score     number,
    i_Ignore_Score      number,
    i_Recommend_Failure varchar2,
    i_Indicators        Array_Number,
    i_Subjects          Array_Number
  ) is
    v_Attempt Htm_Pref.Experience_Period_Attempt_Rt;
  begin
    v_Attempt.Period            := i_Period;
    v_Attempt.Nearest           := i_Nearest;
    v_Attempt.Penalty_Period    := i_Penalty_Period;
    v_Attempt.Exam_Id           := i_Exam_Id;
    v_Attempt.Success_Score     := i_Success_Score;
    v_Attempt.Ignore_Score      := i_Ignore_Score;
    v_Attempt.Recommend_Failure := i_Recommend_Failure;
    v_Attempt.Indicators        := i_Indicators;
    v_Attempt.Subjects          := i_Subjects;
  
    p_Period.Attempts.Extend;
    p_Period.Attempts(p_Period.Attempts.Count) := v_Attempt;
  end;

  ----------------------------------------------------------------------------------------------------
  -- Recommended Rank Document
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_New
  (
    o_Document        out Htm_Pref.Recommended_Rank_Document_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Document_Id     number,
    i_Document_Number varchar2,
    i_Document_Date   date,
    i_Division_Id     number,
    i_Note            varchar2
  ) is
  begin
    o_Document.Company_Id      := i_Company_Id;
    o_Document.Filial_Id       := i_Filial_Id;
    o_Document.Document_Id     := i_Document_Id;
    o_Document.Document_Number := i_Document_Number;
    o_Document.Document_Date   := i_Document_Date;
    o_Document.Division_Id     := i_Division_Id;
    o_Document.Note            := i_Note;
  
    o_Document.Staffs := Htm_Pref.Recommended_Rank_Staff_Nt();
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Recommended_Rank_Document_Add_Staff
  (
    p_Document           in out nocopy Htm_Pref.Recommended_Rank_Document_Rt,
    i_Staff_Id           number,
    i_Robot_Id           number,
    i_From_Rank_Id       number,
    i_Last_Change_Date   date,
    i_To_Rank_Id         number,
    i_New_Change_Date    date,
    i_Attempt_No         number,
    i_Experience_Id      number,
    i_Old_Penalty_Period number,
    i_Period             number,
    i_Nearest            number,
    i_Note               varchar2
  ) is
    v_Staff Htm_Pref.Recommended_Rank_Staff_Rt;
  begin
    v_Staff.Staff_Id           := i_Staff_Id;
    v_Staff.Robot_Id           := i_Robot_Id;
    v_Staff.From_Rank_Id       := i_From_Rank_Id;
    v_Staff.Last_Change_Date   := i_Last_Change_Date;
    v_Staff.To_Rank_Id         := i_To_Rank_Id;
    v_Staff.New_Change_Date    := i_New_Change_Date;
    v_Staff.Attempt_No         := i_Attempt_No;
    v_Staff.Experience_Id      := i_Experience_Id;
    v_Staff.Old_Penalty_Period := i_Old_Penalty_Period;
    v_Staff.Period             := i_Period;
    v_Staff.Nearest            := i_Nearest;
    v_Staff.Note               := i_Note;
  
    p_Document.Staffs.Extend;
    p_Document.Staffs(p_Document.Staffs.Count) := v_Staff;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Add_Staff_Training
  (
    p_Staffs      in out nocopy Htm_Pref.Recommended_Rank_Training_Nt,
    i_Staff_Id    number,
    i_Exam_Id     number,
    i_Subject_Ids Array_Number
  ) is
    v_Staff Htm_Pref.Recommended_Rank_Training_Rt;
  begin
    v_Staff.Staff_Id    := i_Staff_Id;
    v_Staff.Exam_Id     := i_Exam_Id;
    v_Staff.Subject_Ids := i_Subject_Ids;
  
    p_Staffs.Extend;
    p_Staffs(p_Staffs.Count) := v_Staff;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Add_Staff_Status
  (
    p_Staffs           in out nocopy Htm_Pref.Recommended_Rank_Status_Nt,
    i_Staff_Id         number,
    i_Increment_Status varchar2,
    i_Indicators       Href_Pref.Indicator_Nt
  ) is
    v_Staff Htm_Pref.Recommended_Rank_Status_Rt;
  begin
    v_Staff.Staff_Id         := i_Staff_Id;
    v_Staff.Increment_Status := i_Increment_Status;
    v_Staff.Indicators       := i_Indicators;
  
    p_Staffs.Extend;
    p_Staffs(p_Staffs.Count) := v_Staff;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Recommended_Rank_Document_Calc_Indicators
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Document_Id       number,
    i_Staff_Ids         Array_Number := null,
    i_Include_Trainings boolean := false
  ) return Htm_Pref.Recommended_Rank_Status_Nt is
    v_Indicators      Href_Pref.Indicator_Nt;
    v_Indicator_Value number;
    v_Begin_Date      date;
    v_End_Date        date;
  
    v_Exam_Id     number;
    v_Subject_Ids Array_Number;
  
    v_Staffs Htm_Pref.Recommended_Rank_Status_Nt := Htm_Pref.Recommended_Rank_Status_Nt();
  
    v_Overall_Score number;
    v_Indicator_Cnt number;
  
    v_Increment_Status varchar2(1);
  begin
    for St in (select Qr.*,
                      (select Jr.Experience_Id
                         from Htm_Experience_Job_Ranks Jr
                        where Jr.Company_Id = i_Company_Id
                          and Jr.Filial_Id = i_Filial_Id
                          and Jr.Job_Id =
                              Hpd_Util.Get_Closest_Job_Id(i_Company_Id => i_Company_Id,
                                                          i_Filial_Id  => i_Filial_Id,
                                                          i_Staff_Id   => Qr.Staff_Id,
                                                          i_Period     => Qr.New_Change_Date - 1)
                          and Jr.From_Rank_Id = Qr.New_From_Rank_Id) New_Experience_Id
                 from (select q.*,
                              (select t.Dismissal_Date
                                 from Href_Staffs t
                                where t.Company_Id = q.Company_Id
                                  and t.Filial_Id = q.Filial_Id
                                  and t.Staff_Id = q.Staff_Id) Dismissal_Date,
                              (select Jr.Experience_Id
                                 from Htm_Experience_Job_Ranks Jr
                                where Jr.Company_Id = i_Company_Id
                                  and Jr.Filial_Id = i_Filial_Id
                                  and Jr.Job_Id = w.Job_Id
                                  and Jr.From_Rank_Id = q.From_Rank_Id) Old_Experience_Id,
                              Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => i_Company_Id,
                                                           i_Filial_Id  => i_Filial_Id,
                                                           i_Staff_Id   => q.Staff_Id,
                                                           i_Period     => q.New_Change_Date - 1) New_From_Rank_Id
                         from Htm_Recommended_Rank_Staffs q
                         join Mrf_Robots w
                           on w.Company_Id = i_Company_Id
                          and w.Filial_Id = i_Filial_Id
                          and w.Robot_Id = q.Robot_Id
                        where q.Company_Id = i_Company_Id
                          and q.Filial_Id = i_Filial_Id
                          and q.Document_Id = i_Document_Id
                          and (i_Staff_Ids is null or q.Staff_Id member of i_Staff_Ids)) Qr)
    loop
      v_Indicator_Cnt    := 0;
      v_Overall_Score    := 0;
      v_Increment_Status := Htm_Pref.c_Increment_Status_Ignored;
    
      v_Indicators := Href_Pref.Indicator_Nt();
    
      v_Subject_Ids := Array_Number();
    
      for r in (select p.*, q.Staff_Id, q.Indicator_Value
                  from Htm_Recommended_Rank_Staff_Indicators q
                  join Href_Indicators p
                    on p.Company_Id = q.Company_Id
                   and p.Indicator_Id = q.Indicator_Id
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.Document_Id = i_Document_Id
                   and q.Staff_Id = St.Staff_Id)
      loop
        if r.Used = Href_Pref.c_Indicator_Used_Automatically then
          v_End_Date    := St.New_Change_Date;
          v_Exam_Id     := null;
          v_Subject_Ids := Array_Number();
        
          if r.Pcode = Href_Pref.c_Pcode_Indicator_Trainings_Subjects and i_Include_Trainings then
            v_Begin_Date := Add_Months(v_End_Date, -6);
          
            select p.Subject_Id
              bulk collect
              into v_Subject_Ids
              from Htm_Recommended_Rank_Staff_Subjects p
             where p.Company_Id = i_Company_Id
               and p.Filial_Id = i_Filial_Id
               and p.Document_Id = i_Document_Id
               and p.Staff_Id = r.Staff_Id;
          elsif r.Pcode = Href_Pref.c_Pcode_Indicator_Exam_Results and i_Include_Trainings then
            v_Begin_Date := v_End_Date;
          else
            v_End_Date   := Trunc(v_End_Date, 'mon') - 1;
            v_Begin_Date := Trunc(v_End_Date, 'mon');
          end if;
        
          if i_Include_Trainings or
             r.Pcode not in (Href_Pref.c_Pcode_Indicator_Trainings_Subjects,
                             Href_Pref.c_Pcode_Indicator_Exam_Results) then
            v_Indicator_Value := Hpr_Util.Calc_Indicator_Value(i_Company_Id   => i_Company_Id,
                                                               i_Filial_Id    => i_Filial_Id,
                                                               i_Staff_Id     => r.Staff_Id,
                                                               i_Charge_Id    => null,
                                                               i_Begin_Date   => v_Begin_Date,
                                                               i_End_Date     => v_End_Date,
                                                               i_Indicator_Id => r.Indicator_Id,
                                                               i_Exam_Id      => St.Exam_Id,
                                                               i_Subject_Ids  => v_Subject_Ids);
          else
            v_Indicator_Value := r.Indicator_Value;
          end if;
        else
          v_Indicator_Value := r.Indicator_Value;
        end if;
      
        Href_Util.Indicator_Add(p_Indicators      => v_Indicators,
                                i_Indicator_Id    => r.Indicator_Id,
                                i_Indicator_Value => v_Indicator_Value);
      
        v_Indicator_Cnt := v_Indicator_Cnt + 1;
        v_Overall_Score := v_Overall_Score + Nvl(v_Indicator_Value, 0);
      end loop;
    
      if v_Indicator_Cnt > 0 then
        v_Overall_Score := v_Overall_Score / v_Indicator_Cnt;
      
        if St.Dismissal_Date < St.New_Change_Date or --
           St.Old_Experience_Id is null or --
           St.New_Experience_Id is null or --
           St.Old_Experience_Id <> St.New_Experience_Id or --
           St.From_Rank_Id <> St.New_From_Rank_Id then
          v_Increment_Status := Htm_Pref.c_Increment_Status_Ignored;
        else
          if St.Success_Score is not null and St.Success_Score <= v_Overall_Score then
            v_Increment_Status := Htm_Pref.c_Increment_Status_Success;
          elsif St.Recommend_Failure = 'Y' and
                (St.Ignore_Score is null or v_Overall_Score < St.Ignore_Score) then
            v_Increment_Status := Htm_Pref.c_Increment_Status_Failure;
          else
            v_Increment_Status := Htm_Pref.c_Increment_Status_Ignored;
          end if;
        end if;
      
        Recommended_Rank_Add_Staff_Status(p_Staffs           => v_Staffs,
                                          i_Staff_Id         => St.Staff_Id,
                                          i_Increment_Status => v_Increment_Status,
                                          i_Indicators       => v_Indicators);
      end if;
    end loop;
  
    return v_Staffs;
  end;

  ----------------------------------------------------------------------------------------------------
  -- Recommended Rank Document Status
  ----------------------------------------------------------------------------------------------------
  Function t_Document_Status_New return varchar2 is
  begin
    return t('document_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Document_Status_Set_Training return varchar2 is
  begin
    return t('document_status:set training');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Document_Status_Training return varchar2 is
  begin
    return t('document_status:training');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Document_Status_Waiting return varchar2 is
  begin
    return t('document_status:waiting');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Document_Status_Approved return varchar2 is
  begin
    return t('document_status:approved');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Document_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Htm_Pref.c_Document_Status_New then t_Document_Status_New --
    when Htm_Pref.c_Document_Status_Set_Training then t_Document_Status_Set_Training --
    when Htm_Pref.c_Document_Status_Training then t_Document_Status_Training --
    when Htm_Pref.c_Document_Status_Waiting then t_Document_Status_Waiting --
    when Htm_Pref.c_Document_Status_Approved then t_Document_Status_Approved --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Document_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htm_Pref.c_Document_Status_New,
                                          Htm_Pref.c_Document_Status_Set_Training,
                                          Htm_Pref.c_Document_Status_Training,
                                          Htm_Pref.c_Document_Status_Waiting,
                                          Htm_Pref.c_Document_Status_Approved),
                           Array_Varchar2(t_Document_Status_New,
                                          t_Document_Status_Set_Training,
                                          t_Document_Status_Training,
                                          t_Document_Status_Waiting,
                                          t_Document_Status_Approved));
  end;

  ----------------------------------------------------------------------------------------------------
  -- increment statuses 
  ----------------------------------------------------------------------------------------------------
  Function t_Increment_Status_Success return varchar2 is
  begin
    return t('increment_status:success');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Increment_Status_Failure return varchar2 is
  begin
    return t('increment_status:failure');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Increment_Status_Ignored return varchar2 is
  begin
    return t('increment_status:ignored');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Increment_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Htm_Pref.c_Increment_Status_Success then t_Increment_Status_Success --
    when Htm_Pref.c_Increment_Status_Failure then t_Increment_Status_Failure --
    when Htm_Pref.c_Increment_Status_Ignored then t_Increment_Status_Ignored --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Increment_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Htm_Pref.c_Increment_Status_Success,
                                          Htm_Pref.c_Increment_Status_Failure,
                                          Htm_Pref.c_Increment_Status_Ignored),
                           Array_Varchar2(t_Increment_Status_Success,
                                          t_Increment_Status_Failure,
                                          t_Increment_Status_Ignored));
  end;

end Htm_Util;
/
