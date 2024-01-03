create or replace package Hln_Core is
  ----------------------------------------------------------------------------------------------------  
  Function Gen_Exam_Questions
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Exam_Id    number
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Attestation
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Attestation_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Attestation_Change_Status;
  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Daily_Notifications;
end Hln_Core;
/
create or replace package body Hln_Core is
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
    return b.Translate('HLN:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Gen_Exam_Questions
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Exam_Id    number
  ) return Array_Number is
    r_Exam                Hln_Exams%rowtype;
    v_Question_Type_Ids   Array_Number;
    v_Question_Type_Names Array_Varchar2;
    v_Result              Array_Number := Array_Number();
    v_Question_Ids        Array_Number := Array_Number();
  begin
    r_Exam := z_Hln_Exams.Lock_Load(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Exam_Id    => i_Exam_Id);
  
    if r_Exam.Pick_Kind = Hln_Pref.c_Exam_Pick_Kind_Manual then
      Hln_Error.Raise_002(r_Exam.Name);
    end if;
  
    for Ptrn in (select *
                   from Hln_Exam_Patterns Ep
                  where Ep.Company_Id = r_Exam.Company_Id
                    and Ep.Filial_Id = r_Exam.Filial_Id
                    and Ep.Exam_Id = r_Exam.Exam_Id
                  order by Ep.Order_No)
    loop
      select Pqt.Question_Type_Id
        bulk collect
        into v_Question_Type_Ids
        from Hln_Pattern_Question_Types Pqt
       where Pqt.Company_Id = Ptrn.Company_Id
         and Pqt.Filial_Id = Ptrn.Filial_Id
         and Pqt.Pattern_Id = Ptrn.Pattern_Id;
    
      v_Question_Ids := Hln_Util.Randomizer_Array(i_Array       => Hln_Util.Gen_Questions(i_Company_Id                 => i_Company_Id,
                                                                                          i_Filial_Id                  => i_Filial_Id,
                                                                                          i_Question_Types             => v_Question_Type_Ids,
                                                                                          i_Has_Writing_Question       => Ptrn.Has_Writing_Question,
                                                                                          i_Max_Count_Writing_Question => Ptrn.Max_Cnt_Writing_Question,
                                                                                          i_Used_Question_Ids          => v_Result),
                                                  i_Result_Size => Ptrn.Quantity);
    
      if Ptrn.Quantity > v_Question_Ids.Count then
        select q.Name
          bulk collect
          into v_Question_Type_Names
          from Hln_Question_Types q
         where q.Company_Id = Ptrn.Company_Id
           and q.Filial_Id = Ptrn.Filial_Id
           and q.Question_Type_Id member of v_Question_Type_Ids
         order by q.Order_No;
      
        Hln_Error.Raise_003(i_Exam_Name          => r_Exam.Name,
                            i_Pattern_Name       => Fazo.Gather(v_Question_Type_Names, ', '),
                            i_Pattern_Quantity   => Ptrn.Quantity,
                            i_Questions_Quantity => v_Question_Ids.Count);
      end if;
    
      v_Result := v_Result multiset union v_Question_Ids;
    end loop;
  
    return v_Result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Make_Dirty_Attestation
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Attestation_Id number
  ) is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hln_Dirty_Attestations q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Attestation_Id = i_Attestation_Id;
  exception
    when No_Data_Found then
      insert into Hln_Dirty_Attestations
        (Company_Id, Filial_Id, Attestation_Id)
      values
        (i_Company_Id, i_Filial_Id, i_Attestation_Id);
    
      b.Add_Post_Callback('begin hln_core.attestation_change_status; end;');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attestation_Change_Status is
    v_All_Count    number;
    v_New_Count    number;
    v_Finish_Count number;
  begin
    for r in (select *
                from Hln_Dirty_Attestations)
    loop
      select count(*),
             sum(Decode(w.Status, Hln_Pref.c_Testing_Status_New, 1, 0)),
             sum(Decode(w.Status, Hln_Pref.c_Testing_Status_Finished, 1, 0))
        into v_All_Count, v_New_Count, v_Finish_Count
        from Hln_Attestation_Testings q
        join Hln_Testings w
          on w.Company_Id = q.Company_Id
         and w.Testing_Id = q.Testing_Id
       where q.Company_Id = r.Company_Id
         and q.Filial_Id = r.Filial_Id
         and q.Attestation_Id = r.Attestation_Id;
    
      z_Hln_Attestations.Update_One(i_Company_Id     => r.Company_Id,
                                    i_Filial_Id      => r.Filial_Id,
                                    i_Attestation_Id => r.Attestation_Id,
                                    i_Status         => Option_Varchar2(Md_Util.Decode(v_All_Count,
                                                                                       v_New_Count,
                                                                                       Hln_Pref.c_Testing_Status_New,
                                                                                       v_Finish_Count,
                                                                                       Hln_Pref.c_Testing_Status_Finished,
                                                                                       Hln_Pref.c_Attestation_Status_Processing)));
    end loop;
  
    delete Hln_Dirty_Attestations;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Daily_Notifications
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    v_Period_Begin date := sysdate;
    v_Period_End   date := v_Period_Begin + 1;
    v_User_System  number := Md_Pref.User_System(i_Company_Id);
    v_Filial_Head  number := Md_Pref.Filial_Head(i_Company_Id);
  begin
    for r in (select q.Company_Id, q.Filial_Id
                from Md_Filials q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id <> v_Filial_Head
                 and q.State = 'A')
    loop
      Biruni_Route.Context_Begin;
    
      Ui_Context.Init(i_User_Id      => v_User_System,
                      i_Filial_Id    => r.Filial_Id,
                      i_Project_Code => Verifix.Project_Code,
                      i_Lang_Code    => i_Lang_Code);
    
      for Test in (select cast(multiset (select (select t.Person_Id
                                          from Hln_Testings t
                                         where t.Company_Id = p.Company_Id
                                           and t.Filial_Id = p.Filial_Id
                                           and t.Testing_Id = p.Testing_Id) Person_Id
                                  from Hln_Attestation_Testings p
                                 where p.Company_Id = q.Company_Id
                                   and p.Filial_Id = q.Filial_Id
                                   and p.Attestation_Id = q.Attestation_Id) as Array_Number) Person_Ids,
                          q.Begin_Time_Period_Begin,
                          q.Attestation_Number
                     from Hln_Attestations q
                    where q.Company_Id = r.Company_Id
                      and q.Filial_Id = r.Filial_Id
                      and q.Status = Hln_Pref.c_Attestation_Status_New
                      and q.Begin_Time_Period_Begin between v_Period_Begin and v_Period_End)
      loop
        Href_Core.Send_Notification(i_Company_Id => r.Company_Id,
                                    i_Filial_Id  => r.Filial_Id,
                                    i_Title      => t('today, you have attestation with $1{attestation_number} at $2{begin_time}',
                                                      Test.Attestation_Number,
                                                      to_char(Test.Begin_Time_Period_Begin, 'hh12:mi')),
                                    i_Person_Ids => Test.Person_Ids);
      end loop;
    
      for Training in (select (cast(multiset (select p.Person_Id
                                       from Hln_Training_Persons p
                                      where p.Company_Id = q.Company_Id
                                        and p.Filial_Id = q.Filial_Id
                                        and p.Training_Id = q.Training_Id) as Array_Number)) Person_Ids, --
                              w.Begin_Date,
                              w.Training_Number
                         from Hln_Training_Persons q
                         join Hln_Trainings w
                           on w.Company_Id = q.Company_Id
                          and w.Filial_Id = q.Filial_Id
                          and w.Training_Id = q.Training_Id
                        where w.Company_Id = r.Company_Id
                          and w.Filial_Id = r.Filial_Id
                          and w.Status = Hln_Pref.c_Training_Status_New
                          and w.Begin_Date between v_Period_Begin and v_Period_End)
      loop
        Href_Core.Send_Notification(i_Company_Id => r.Company_Id,
                                    i_Filial_Id  => r.Filial_Id,
                                    i_Title      => t('today, you have training with $1{training_number} at $2{begin_time}',
                                                      Training.Training_Number,
                                                      to_char(Training.Begin_Date, 'hh12:mi')),
                                    i_Person_Ids => Training.Person_Ids);
      end loop;
    
      Biruni_Route.Context_End;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Generate_Daily_Notifications is
  begin
    for Cmp in (select c.Company_Id, c.Lang_Code
                  from Md_Companies c
                 where c.State = 'A'
                   and (exists (select 1
                                  from Md_Company_Projects Cp
                                 where Cp.Company_Id = c.Company_Id
                                   and Cp.Project_Code = Verifix.Project_Code) or
                        c.Company_Id = Md_Pref.c_Company_Head))
    loop
      begin
        Generate_Daily_Notifications(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
      
        commit;
      exception
        when others then
          rollback;
      end;
    end loop;
  end;

end Hln_Core;
/
