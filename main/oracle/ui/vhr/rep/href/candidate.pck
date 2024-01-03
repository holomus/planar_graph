create or replace package Ui_Vhr580 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Person_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Sources return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap);
end Ui_Vhr580;
/
create or replace package body Ui_Vhr580 is
  ---------------------------------------------------------------------------------------------------- 
  c_Pref_Gender_Both constant varchar2(1) := 'B';

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
    return b.Translate('UI-VHR580:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name', 'state');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Person_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mr_person_types',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'person_group_id',
                                 Mr_Pref.Pg_Natural_Category(Ui.Company_Id),
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('person_type_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Sources return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_employment_sources',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('source_id');
    q.Varchar2_Field('name', 'state');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function References return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Lang_Id, t.Name)
      bulk collect
      into v_Matrix
      from Href_Langs t
     where t.Company_Id = Ui.Company_Id
       and t.State = 'A'
     order by t.Name;
  
    Result.Put('langs', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(t.Lang_Level_Id, t.Name)
      bulk collect
      into v_Matrix
      from Href_Lang_Levels t
     where t.Company_Id = Ui.Company_Id
       and t.State = 'A';
  
    Result.Put('lang_levels', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(e.Edu_Stage_Id, e.Name)
      bulk collect
      into v_Matrix
      from Href_Edu_Stages e
     where e.Company_Id = Ui.Company_Id
       and e.State = 'A'
     order by e.Name;
  
    Result.Put('edu_stages', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('begin_date',
                           Trunc(sysdate, 'mon'),
                           'end_date',
                           Trunc(sysdate),
                           'gender',
                           c_Pref_Gender_Both);
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Head
  (
    a            in out nocopy b_Table,
    i_Begin_Date date,
    i_End_Date   date
  ) is
    v_Widths Array_Number := Array_Number(75, 100, 200, 150, 150, 150, 150, 100, 200, 300, 300, 75);
  begin
    for i in 1 .. v_Widths.Count
    loop
      a.Column_Width(i, v_Widths(i));
    end loop;
  
    a.New_Row;
    a.New_Row;
    a.Data(t('report on period $1 - $2', i_Begin_Date, i_End_Date), i_Colspan => 4);
  
    a.Current_Style('header');
  
    a.New_Row;
    a.Data('#');
    a.Data(t('created on'));
    a.Data(t('name'));
    a.Data(t('person type name'));
    a.Data(t('edu stage'));
    a.Data(t('source'));
    a.Data(t('birthday'));
    a.Data(t('gender'));
    a.Data(t('lang level'));
    a.Data(t('jobs'));
    a.Data(t('phone number'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_All
  (
    i_Begin_Date      date,
    i_End_Date        date,
    i_Job_Ids         Array_Number,
    i_Person_Type_Ids Array_Number,
    i_Source_Ids      Array_Number,
    i_Gender          varchar2,
    i_Lang_Ids        Array_Number,
    i_Level_Ids       Array_Number,
    i_Edu_Stage_Ids   Array_Number
  ) is
    a                   b_Table := b_Report.New_Table();
    c                   b_Table;
    v_Company_Id        number := Ui.Company_Id;
    v_Filial_Id         number := Ui.Filial_Id;
    v_Job_Count         number := i_Job_Ids.Count;
    v_Person_Type_Count number := i_Person_Type_Ids.Count;
    v_Source_Count      number := i_Source_Ids.Count;
    v_Edu_Stage_Count   number := i_Edu_Stage_Ids.Count;
    v_Lang_Count        number := i_Lang_Ids.Count;
    v_Max_Row           number;
  begin
    -- print header
    Print_Head(a => a, i_Begin_Date => i_Begin_Date, i_End_Date => i_End_Date);
  
    for r in (select Rownum,
                     q.Created_On,
                     w.Name,
                     (select w.Name
                        from Mr_Person_Types w
                       where w.Company_Id = v_Company_Id
                         and w.Person_Type_Id =
                             (select Tb.Person_Type_Id
                                from Mr_Person_Type_Binds Tb
                               where Tb.Company_Id = v_Company_Id
                                 and Tb.Person_Id = q.Candidate_Id)) as Person_Type_Name,
                     (select w.Name
                        from Href_Employment_Sources w
                       where w.Company_Id = v_Company_Id
                         and w.Source_Id = q.Source_Id) as Source_Name,
                     w.Birthday,
                     Md_Util.t_Person_Gender(w.Gender) as Gender_Name,
                     (select w.Phone
                        from Md_Persons w
                       where w.Company_Id = v_Company_Id
                         and w.Person_Id = q.Candidate_Id) as Phone,
                     cast(multiset (select Array_Varchar2(r.Name, t.Name)
                             from Href_Person_Langs w
                             join Href_Langs r
                               on w.Company_Id = r.Company_Id
                              and w.Lang_Id = r.Lang_Id
                             join Href_Lang_Levels t
                               on t.Company_Id = r.Company_Id
                              and t.Lang_Level_Id = w.Lang_Level_Id
                            where w.Company_Id = v_Company_Id
                              and w.Person_Id = q.Candidate_Id) as Matrix_Varchar2) as Langs,
                     cast(multiset (select Array_Varchar2((select Jb.Name
                                                   from Mhr_Jobs Jb
                                                  where Jb.Company_Id = w.Company_Id
                                                    and Jb.Filial_Id = w.Filial_Id
                                                    and Jb.Job_Id = w.Job_Id))
                             from Href_Candidate_Jobs w
                            where w.Company_Id = v_Company_Id
                              and w.Filial_Id = q.Filial_Id
                              and w.Candidate_Id = q.Candidate_Id) as Matrix_Varchar2) as Jobs,
                     cast(multiset (select Array_Varchar2((select Es.Name
                                                   from Href_Edu_Stages Es
                                                  where Es.Company_Id = w.Company_Id
                                                    and Es.Edu_Stage_Id = w.Edu_Stage_Id))
                             from Href_Person_Edu_Stages w
                            where w.Company_Id = v_Company_Id
                              and w.Person_Id = q.Candidate_Id) as Matrix_Varchar2) as Edu_Stages
                from Href_Candidates q
                join Mr_Natural_Persons w
                  on w.Company_Id = v_Company_Id
                 and w.Person_Id = q.Candidate_Id
                 and (i_Gender = c_Pref_Gender_Both or i_Gender = w.Gender)
               where q.Company_Id = v_Company_Id
                 and q.Filial_Id = v_Filial_Id
                 and (v_Source_Count = 0 or q.Source_Id member of i_Source_Ids)
                 and Trunc(q.Created_On) between i_Begin_Date and i_End_Date
                 and (v_Person_Type_Count = 0 or exists
                      (select 1
                         from Mr_Person_Type_Binds Tb
                        where Tb.Company_Id = v_Company_Id
                          and Tb.Person_Id = q.Candidate_Id
                          and Tb.Person_Type_Id member of i_Person_Type_Ids))
                 and (v_Edu_Stage_Count = 0 or exists
                      (select 1
                         from Href_Person_Edu_Stages Es
                        where Es.Company_Id = v_Company_Id
                          and Es.Person_Id = q.Candidate_Id
                          and Es.Edu_Stage_Id member of i_Edu_Stage_Ids))
                 and (v_Job_Count = 0 or exists
                      (select 1
                         from Href_Candidate_Jobs Cj
                        where Cj.Company_Id = v_Company_Id
                          and Cj.Filial_Id = v_Filial_Id
                          and Cj.Candidate_Id = q.Candidate_Id
                          and Cj.Job_Id member of i_Job_Ids))
                 and (v_Lang_Count = 0 or exists
                      (select 1
                         from Href_Person_Langs w
                         join (select Fazo.Column_Number(Column_Value, 1) Lang_Id,
                                     Fazo.Column_Number(Column_Value, 2) Level_Id
                                from table(cast(Fazo.Transpose(Matrix_Number(i_Lang_Ids, i_Level_Ids)) as
                                                Matrix_Number))) Ll
                           on w.Lang_Id = Ll.Lang_Id
                          and w.Lang_Level_Id = Ll.Level_Id
                        where w.Company_Id = v_Company_Id
                          and w.Person_Id = q.Candidate_Id)))
    loop
      v_Max_Row := 1;
      v_Max_Row := Greatest(v_Max_Row, r.Langs.Count);
      v_Max_Row := Greatest(v_Max_Row, r.Jobs.Count);
      v_Max_Row := Greatest(v_Max_Row, r.Edu_Stages.Count);
    
      a.New_Row;
      a.Current_Style('body');
    
      a.Data(to_char(r.Rownum)); -- Excel ga dowload qilganda ###### formatda chiqib qolgani uchun to_char ishlatildi
      a.Data(to_char(r.Created_On, Href_Pref.c_Date_Format_Day));
      a.Data(r.Name);
      a.Data(r.Person_Type_Name);
    
      c := b_Report.New_Table(a);
      for i in 1 .. r.Edu_Stages.Count
      loop
        c.New_Row;
        c.Data(r.Edu_Stages(i) (1));
      end loop;
    
      if not c.Is_Empty then
        if v_Max_Row > r.Edu_Stages.Count then
          c.New_Row();
          c.Data('', i_Rowspan => v_Max_Row - r.Edu_Stages.Count);
        end if;
        a.Data(c);
      else
        a.Data;
      end if; -- edu stages
    
      a.Data(r.Source_Name);
      a.Data(r.Birthday);
      a.Data(r.Gender_Name);
    
      c := b_Report.New_Table(a);
      for i in 1 .. r.Langs.Count
      loop
        c.New_Row;
        c.Data(r.Langs(i) (1));
        c.Data(r.Langs(i) (2));
      end loop;
    
      if not c.Is_Empty then
        if v_Max_Row > r.Langs.Count then
          c.New_Row();
          c.Data('', i_Rowspan => v_Max_Row - r.Langs.Count);
          c.Data('', i_Rowspan => v_Max_Row - r.Langs.Count);
        end if;
        a.Data(c);
      else
        a.Data;
      end if; -- lang levels
    
      c := b_Report.New_Table(a);
      for i in 1 .. r.Jobs.Count
      loop
        c.New_Row;
        c.Data(r.Jobs(i) (1));
      end loop;
    
      if not c.Is_Empty then
        if v_Max_Row > r.Jobs.Count then
          c.New_Row();
          c.Data('', i_Rowspan => v_Max_Row - r.Jobs.Count);
        end if;
        a.Data(c);
      else
        a.Data;
      end if; -- jobs
    
      a.Data(r.Phone);
    end loop;
  
    b_Report.Add_Sheet(t('candidate'), a);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    Run_All(i_Begin_Date      => Nvl(p.o_Date('begin_date'), Trunc(sysdate, 'mon')),
            i_End_Date        => Nvl(p.o_Date('end_date'), Trunc(Last_Day(sysdate))),
            i_Job_Ids         => Nvl(p.o_Array_Number('job_ids'), Array_Number()),
            i_Person_Type_Ids => Nvl(p.o_Array_Number('person_type_ids'), Array_Number()),
            i_Source_Ids      => Nvl(p.o_Array_Number('source_ids'), Array_Number()),
            i_Gender          => Nvl(p.o_Varchar2('gender'), c_Pref_Gender_Both),
            i_Lang_Ids        => Nvl(p.o_Array_Number('lang_ids'), Array_Number()),
            i_Level_Ids       => Nvl(p.o_Array_Number('level_ids'), Array_Number()),
            i_Edu_Stage_Ids   => Nvl(p.o_Array_Number('edu_stage_ids'), Array_Number()));
  
    b_Report.Close_Book();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
    update Mr_Person_Types
       set Company_Id      = null,
           Person_Type_Id  = null,
           Person_Group_Id = null,
           name            = null,
           State           = null;
    update Href_Employment_Sources
       set Company_Id = null,
           Source_Id  = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr580;
/
