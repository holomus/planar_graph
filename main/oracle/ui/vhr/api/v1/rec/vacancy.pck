create or replace package Ui_Vhr656 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Vacancies(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function List_Regions(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function List_Jobs(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Vacancy_Exam(p Hashmap) return Json_Object_t;
end Ui_Vhr656;
/
create or replace package body Ui_Vhr656 is
  ---------------------------------------------------------------------------------------------------- 
  c_No_Region_Id constant number := -1;

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
    return b.Translate('UI-VHR656:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function List_Vacancies(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Wage_Name varchar2(400 char);
  
    v_Region_Id number := p.o_Number('region_id');
    v_Job_Id    number := p.o_Number('job_id');
    v_Vacancy   Gmap;
    v_Vacancies Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select Qr.*,
                     (select Jb.Name
                        from Mhr_Jobs Jb
                       where Jb.Company_Id = v_Company_Id
                         and Jb.Filial_Id = v_Filial_Id
                         and Jb.Job_Id = Qr.Job_Id) Job_Name,
                     (select Dv.Name
                        from Mhr_Divisions Dv
                       where Dv.Company_Id = v_Company_Id
                         and Dv.Filial_Id = v_Filial_Id
                         and Dv.Division_Id = Qr.Division_Id) Division_Name,
                     (select s.Name
                        from Htt_Schedules s
                       where s.Company_Id = v_Company_Id
                         and s.Filial_Id = v_Filial_Id
                         and s.Schedule_Id = Qr.Schedule_Id) Schedule_Name,
                     (select Rg.Name
                        from Md_Regions Rg
                       where Rg.Company_Id = v_Company_Id
                         and Rg.Region_Id = Qr.Region_Id) Region_Name,
                     (select Listagg(Gs.Name || '(' || Ll.Name || ')', ', ')
                        from Hrec_Vacancy_Langs Lg
                        join Href_Langs Gs
                          on Gs.Company_Id = v_Company_Id
                         and Gs.Lang_Id = Lg.Lang_Id
                        join Href_Lang_Levels Ll
                          on Ll.Company_Id = v_Company_Id
                         and Ll.Lang_Level_Id = Lg.Lang_Level_Id
                       where Lg.Company_Id = v_Company_Id
                         and Lg.Filial_Id = v_Filial_Id
                         and Lg.Vacancy_Id = Qr.Vacancy_Id) Langs
                from (select *
                        from Hrec_Vacancies q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and q.Status = Hrec_Pref.c_Vacancy_Status_Open
                         and (v_Job_Id is null or q.Job_Id = v_Job_Id)
                         and (v_Region_Id is null or Nvl(q.Region_Id, c_No_Region_Id) = v_Region_Id)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Vacancy := Gmap();
    
      v_Wage_Name := Hrec_Util.Wage_From_To_Message(i_Wage_From => r.Wage_From,
                                                    i_Wage_To   => r.Wage_To);
    
      v_Vacancy.Put('vacancy_id', r.Vacancy_Id);
      v_Vacancy.Put('vacancy_name', r.Name);
      v_Vacancy.Put('vacancy_description', r.Description);
      v_Vacancy.Put('job_name',
                    case when r.Job_Name is not null then t('job: $1', r.Job_Name) else null end);
      v_Vacancy.Put('division_name',
                    case when r.Division_Name is not null then t('division: $1', r.Division_Name) else null end);
      v_Vacancy.Put('region_name',
                    case when r.Region_Name is not null then t('region: $1', r.Region_Name) else null end);
      v_Vacancy.Put('schedule_name',
                    case when r.Schedule_Name is not null then t('schedule: $1', r.Schedule_Name) else null end);
      v_Vacancy.Put('wage_limits',
                    case when v_Wage_Name is not null then t('wage: $1', v_Wage_Name) else null end);
      v_Vacancy.Put('langs',
                    case when r.Langs is not null then t('langs: $1', r.Langs) else null end);
    
      v_Last_Id := r.Modified_Id;
    
      v_Vacancies.Push(v_Vacancy.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Vacancies, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function List_Regions(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    t_No_Region_Msg constant varchar2(250 char) := t('no region');
  
    v_Job_Id  number := p.o_Number('job_id');
    v_Region  Gmap;
    v_Regions Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select q.Company_Id, q.Region_Id, q.Name, q.Modified_Id
                        from Md_Regions q
                       where q.Company_Id = v_Company_Id
                         and q.Region_Id in
                             (select t.Region_Id
                                from Hrec_Vacancies t
                               where t.Company_Id = v_Company_Id
                                 and t.Filial_Id = v_Filial_Id
                                 and t.Status = Hrec_Pref.c_Vacancy_Status_Open
                                 and (v_Job_Id is null or t.Job_Id = v_Job_Id))
                      union all
                      select v_Company_Id, c_No_Region_Id, t_No_Region_Msg, 1
                        from Dual
                       where exists (select 1
                                from Hrec_Vacancies t
                               where t.Company_Id = v_Company_Id
                                 and t.Filial_Id = v_Filial_Id
                                 and t.Status = Hrec_Pref.c_Vacancy_Status_Open
                                 and (v_Job_Id is null or t.Job_Id = v_Job_Id)
                                 and t.Region_Id is null)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Region := Gmap();
    
      v_Region.Put('region_id', r.Region_Id);
      v_Region.Put('region_name', r.Name);
    
      v_Last_Id := r.Modified_Id;
    
      v_Regions.Push(v_Region.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Regions, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function List_Jobs(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Region_Id number := p.o_Number('region_id');
    v_Job       Gmap;
    v_Jobs      Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Mhr_Jobs q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and q.Job_Id in
                             (select t.Job_Id
                                from Hrec_Vacancies t
                               where t.Company_Id = v_Company_Id
                                 and t.Filial_Id = v_Filial_Id
                                 and t.Status = Hrec_Pref.c_Vacancy_Status_Open
                                 and (v_Region_Id is null or
                                     Nvl(t.Region_Id, c_No_Region_Id) = v_Region_Id))) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Job := Gmap();
    
      v_Job.Put('job_id', r.Job_Id);
      v_Job.Put('job_name', r.Name);
    
      v_Last_Id := r.Modified_Id;
    
      v_Jobs.Push(v_Job.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Jobs, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Vacancy_Exam(p Hashmap) return Json_Object_t is
    v_Company_Id          number := Ui.Company_Id;
    v_Filial_Id           number := Ui.Filial_Id;
    r_Exam                Hln_Exams%rowtype;
    r_Vacancy             Hrec_Vacancies%rowtype;
    r_Question            Hln_Questions%rowtype;
    r_Option              Hln_Question_Options%rowtype;
    v_Question_Ids        Array_Number;
    v_Question_Option_Ids Array_Number;
    v_Questions           Glist := Glist();
    v_Options             Glist;
    v_Question            Gmap;
    v_Option              Gmap;
    result                Gmap := Gmap();
  begin
    r_Vacancy := z_Hrec_Vacancies.Load(i_Company_Id => v_Company_Id,
                                       i_Filial_Id  => v_Filial_Id,
                                       i_Vacancy_Id => p.r_Number('vacancy_id'));
  
    if r_Vacancy.Exam_Id is null then
      return Result.Val;
    end if;
  
    r_Exam := z_Hln_Exams.Load(i_Company_Id => r_Vacancy.Company_Id,
                               i_Filial_Id  => r_Vacancy.Filial_Id,
                               i_Exam_Id    => r_Vacancy.Exam_Id);
  
    if r_Exam.For_Recruitment = 'N' then
      return Result.Val;
    end if;
  
    Result.Put('exam_name', r_Exam.Name);
    Result.Put('exam_id', r_Exam.Exam_Id);
    Result.Put('passing_score', r_Exam.Passing_Score);
  
    select Mq.Question_Id
      bulk collect
      into v_Question_Ids
      from Hln_Exam_Manual_Questions Mq
     where Mq.Company_Id = r_Exam.Company_Id
       and Mq.Filial_Id = r_Exam.Filial_Id
       and Mq.Exam_Id = r_Exam.Exam_Id
     order by Mq.Order_No;
  
    if r_Exam.Randomize_Questions = 'Y' then
      v_Question_Ids := Hln_Util.Randomizer_Array(v_Question_Ids);
    end if;
  
    for i in 1 .. r_Exam.Question_Count
    loop
      r_Question := z_Hln_Questions.Load(i_Company_Id  => r_Exam.Company_Id,
                                         i_Filial_Id   => r_Exam.Filial_Id,
                                         i_Question_Id => v_Question_Ids(i));
    
      v_Question := Gmap();
      v_Options  := Glist();
      v_Question.Put('name', r_Question.Name);
      v_Question.Put('question_id', r_Question.Question_Id);
    
      select q.Question_Option_Id
        bulk collect
        into v_Question_Option_Ids
        from Hln_Question_Options q
       where q.Company_Id = r_Question.Company_Id
         and q.Filial_Id = r_Question.Filial_Id
         and q.Question_Id = r_Question.Question_Id
       order by q.Order_No;
    
      if r_Exam.Randomize_Options = 'Y' then
        v_Question_Option_Ids := Hln_Util.Randomizer_Array(v_Question_Option_Ids);
      end if;
    
      for i in 1 .. v_Question_Option_Ids.Count
      loop
        r_Option := z_Hln_Question_Options.Load(i_Company_Id         => r_Question.Company_Id,
                                                i_Filial_Id          => r_Question.Filial_Id,
                                                i_Question_Option_Id => v_Question_Option_Ids(i));
      
        v_Option := Gmap();
        v_Option.Put('option_id', r_Option.Question_Option_Id);
        v_Option.Put('name', r_Option.Name);
        v_Option.Put('is_correct', r_Option.Is_Correct);
      
        v_Options.Push(v_Option.Val);
      end loop;
    
      v_Question.Put('options', v_Options);
    
      v_Questions.Push(v_Question.Val);
    end loop;
  
    Result.Put('questions', v_Questions);
  
    return Result.Val;
  end;

end Ui_Vhr656;
/
