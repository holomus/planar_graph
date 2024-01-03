create or replace package Ui_Vhr291 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Edu_Stages return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr291;
/
create or replace package body Ui_Vhr291 is
  g_Titles Fazo.Varchar2_Code_Aat;
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Massage varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('Ui-VHR291:' || i_Massage, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

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
  Function Query_Edu_Stages return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_edu_stages',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('edu_stage_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('date', Trunc(sysdate));
    Result.Put('type', 'age');
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Top
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Date         date,
    i_Type         varchar2,
    i_Colspan      number
  ) is
    v_Limit number := 5;
    v_Names Array_Varchar2 := Array_Varchar2();
  begin
    a.Current_Style('root bold');
    a.New_Row;
    a.Data(g_Titles(i_Type), i_Colspan => i_Colspan);
    a.New_Row;
    a.Data(t('Date $1', i_Date), i_Colspan => i_Colspan);
  
    if i_Division_Ids.Count > 0 then
      a.New_Row;
    
      v_Limit := Least(v_Limit, i_Division_Ids.Count);
      v_Names.Extend(v_Limit);
    
      for i in 1 .. v_Limit
      loop
        v_Names(i) := z_Mhr_Divisions.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Division_Id => i_Division_Ids(i)).Name;
      end loop;
    
      if v_Limit < i_Division_Ids.Count then
        Fazo.Push(v_Names, t('... others'));
      end if;
    
      a.Data(t('Divisions: $1', Fazo.Gather(v_Names, ', ')), i_Colspan => i_Colspan);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Title_Label(i_Type varchar2) return varchar2 is
  begin
    case i_Type
      when 'age' then
        return t('age ranges');
      when 'work' then
        return t('work ranges');
      when 'rank' then
        return t('ranks');
      when 'edu' then
        return t('edu stages');
      else
        return null;
    end case;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Header
  (
    a      in out nocopy b_Table,
    i_Type varchar2
  ) is
    v_Cols Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(Title_Label(i_Type), 100),
                                              Array_Varchar2(t('count'), 75),
                                              Array_Varchar2(t('wage'), 100),
                                              Array_Varchar2(t('count %'), 75),
                                              Array_Varchar2(t('wage %'), 75),
                                              Array_Varchar2(t('count female'), 75),
                                              Array_Varchar2(t('wage female'), 100),
                                              Array_Varchar2(t('count %'), 75),
                                              Array_Varchar2(t('wage %'), 75),
                                              Array_Varchar2(t('count male'), 75),
                                              Array_Varchar2(t('wage male'), 100),
                                              Array_Varchar2(t('count %'), 75),
                                              Array_Varchar2(t('wage %'), 75));
  begin
    a.Current_Style('header');
    a.New_Row;
  
    for i in 1 .. v_Cols.Count
    loop
      a.Data(v_Cols(i) (1));
      a.Column_Width(i, v_Cols(i) (2));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Footers
  (
    a       in out nocopy b_Table,
    i_Count number,
    i_Wage  number
  ) is
  begin
    a.Data(i_Count, 'footer right');
    a.Data(i_Wage, 'footer right');
  
    if i_Count = 0 then
      a.Data('0%', 'footer right');
      a.Data('0%', 'footer right');
    else
      a.Data('100%', 'footer right');
      a.Data('100%', 'footer right');
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gen_Label
  (
    i_Min_Range number,
    i_Max_Range number := null,
    i_Type      varchar2
  ) return varchar2 is
  begin
    if i_Type = 'age' then
      if i_Min_Range = 0 then
        return t('to $1 ages', i_Max_Range);
      end if;
    
      if (i_Max_Range is null) then
        return t('from $1 ages', i_Min_Range);
      end if;
    
      return t('from $1 to $2 ages', i_Min_Range, i_Max_Range);
    end if;
  
    if i_Min_Range = 0 then
      return t('to $1 experiences', i_Max_Range);
    end if;
  
    if (i_Max_Range is null) then
      return t('from $1 experiences', i_Min_Range);
    end if;
  
    return t('from $1 to $2 experiences', i_Min_Range, i_Max_Range);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Print_Body_Ranges
  (
    a               in out nocopy b_Table,
    i_Mins          Array_Number,
    i_Maxs          Array_Number,
    i_Wage_Males    Array_Number,
    i_Wage_Females  Array_Number,
    i_Count_Males   Array_Number,
    i_Count_Females Array_Number,
    i_Type          varchar2,
    i_Labels        Array_Varchar2 := null
  ) is
    v_Total_Wage         number;
    v_Total_Count        number;
    v_Total_Male_Wage    number := 0;
    v_Total_Female_Wage  number := 0;
    v_Total_Male_Count   number := 0;
    v_Total_Female_Count number := 0;
  
    -------------------------------------
    Procedure Print_Subbody
    (
      i_Count       number,
      i_Wage        number,
      i_Total_Count number,
      i_Total_Wage  number,
      i_Color       varchar2 := null
    ) is
      v_Style varchar2(100) := 'body right';
    begin
      a.Data(i_Count, trim('body number ' || i_Color));
      a.Data(i_Wage, 'body number2');
    
      if i_Total_Count > 0 then
        a.Data(Round(i_Count / i_Total_Count * 100, 2) || '%', v_Style);
      else
        a.Data('0%', v_Style);
      end if;
    
      if i_Total_Wage > 0 then
        a.Data(Round(i_Wage / i_Total_Wage * 100, 2) || '%', v_Style);
      else
        a.Data('0%', v_Style);
      end if;
    end;
  begin
    for i in 1 .. i_Wage_Males.Count
    loop
      v_Total_Male_Count   := v_Total_Male_Count + i_Count_Males(i);
      v_Total_Female_Count := v_Total_Female_Count + i_Count_Females(i);
      v_Total_Male_Wage    := v_Total_Male_Wage + i_Wage_Males(i);
      v_Total_Female_Wage  := v_Total_Female_Wage + i_Wage_Females(i);
    end loop;
  
    v_Total_Wage  := v_Total_Male_Wage + v_Total_Female_Wage;
    v_Total_Count := v_Total_Male_Count + v_Total_Female_Count;
  
    a.Current_Style('body');
  
    for i in 1 .. i_Mins.Count
    loop
      a.New_Row;
    
      if i_Type = 'rank' or i_Type = 'edu' then
        a.Data(i_Labels(i), i_Param => to_char(i_Mins(i)));
      else
        a.Data(Gen_Label(i_Mins(i), i_Maxs(i), i_Type), i_Param => i_Mins(i) || ',' || i_Maxs(i));
      end if;
    
      Print_Subbody(i_Count_Males(i) + i_Count_Females(i),
                    i_Wage_Males(i) + i_Wage_Females(i),
                    v_Total_Count,
                    v_Total_Wage);
    
      Print_Subbody(i_Count_Females(i),
                    i_Wage_Females(i),
                    v_Total_Female_Count,
                    v_Total_Female_Wage,
                    'female');
    
      Print_Subbody(i_Count_Males(i), --
                    i_Wage_Males(i),
                    v_Total_Male_Count,
                    v_Total_Male_Wage,
                    'male');
    end loop;
  
    ----- footer -----
    a.Current_Style('footer');
    a.New_Row;
    a.Data(t('total'), 'footer right');
  
    Print_Footers(a, v_Total_Count, v_Total_Wage);
    Print_Footers(a, v_Total_Female_Count, v_Total_Female_Wage);
    Print_Footers(a, v_Total_Male_Count, v_Total_Male_Wage);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_By_Age_Ranges
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Date         date,
    i_Mins         Array_Number,
    i_Maxs         Array_Number
  ) is
    v_Ages      Array_Number;
    v_Staff_Ids Array_Number;
    v_Genders   Array_Varchar2;
  
    v_Mins          Array_Number := i_Mins;
    v_Maxs          Array_Number := i_Maxs;
    v_Wage_Males    Array_Number := Array_Number();
    v_Wage_Females  Array_Number := Array_Number();
    v_Count_Males   Array_Number := Array_Number();
    v_Count_Females Array_Number := Array_Number();
  
    v_Div_Cnt              number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    v_Wage                 number;
  begin
    v_Wage_Females.Extend(v_Mins.Count);
    v_Wage_Males.Extend(v_Mins.Count);
    v_Count_Males.Extend(v_Mins.Count);
    v_Count_Females.Extend(v_Mins.Count);
  
    for i in 1 .. v_Mins.Count
    loop
      v_Mins(i) := Nvl(v_Mins(i), 0) * 12;
      v_Maxs(i) := v_Maxs(i) * 12;
      v_Wage_Females(i) := 0;
      v_Wage_Males(i) := 0;
      v_Count_Males(i) := 0;
      v_Count_Females(i) := 0;
    end loop;
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                  i_Indirect => true,
                                                                  i_Manual   => true);
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Div_Cnt := v_Filter_Division_Ids.Count;
  
    select w.Staff_Id, Months_Between(i_Date, q.Birthday), q.Gender
      bulk collect
      into v_Staff_Ids, v_Ages, v_Genders
      from Href_Staffs w
      join Mr_Natural_Persons q
        on q.Company_Id = w.Company_Id
       and q.Person_Id = w.Employee_Id
       and q.Birthday is not null
     where w.Company_Id = Ui.Company_Id
       and w.Filial_Id = Ui.Filial_Id
       and w.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and w.Hiring_Date <= i_Date
       and (w.Dismissal_Date is null or w.Dismissal_Date >= i_Date)
       and (v_Access_All_Employees = 'Y' and v_Div_Cnt = 0 or
           w.Org_Unit_Id in (select *
                                from table(v_Filter_Division_Ids)))
       and w.State = 'A'
       and exists (select 1
              from Mhr_Employees k
             where k.Company_Id = w.Company_Id
               and k.Filial_Id = w.Filial_Id
               and k.Employee_Id = w.Employee_Id
               and k.State = 'A');
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Wage := Hpd_Util.Get_Closest_Wage(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Staff_Id   => v_Staff_Ids(i),
                                          i_Period     => i_Date);
    
      for j in 1 .. v_Mins.Count
      loop
        if v_Ages(i) >= v_Mins(j) and (v_Ages(i) < v_Maxs(j) or v_Maxs(j) is null) then
          if v_Genders(i) = 'M' then
            v_Count_Males(j) := v_Count_Males(j) + 1;
            v_Wage_Males(j) := v_Wage_Males(j) + v_Wage;
          else
            v_Count_Females(j) := v_Count_Females(j) + 1;
            v_Wage_Females(j) := v_Wage_Females(j) + v_Wage;
          end if;
        end if;
      end loop;
    end loop;
  
    for i in 1 .. v_Mins.Count
    loop
      v_Mins(i) := Floor(v_Mins(i) / 12);
      v_Maxs(i) := Floor(v_Maxs(i) / 12);
    end loop;
  
    Print_Header(a, 'age');
    Print_Body_Ranges(a,
                      v_Mins,
                      v_Maxs,
                      v_Wage_Males,
                      v_Wage_Females,
                      v_Count_Males,
                      v_Count_Females,
                      'age');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_By_Experience_Ranges
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Date         date,
    i_Mins         Array_Number,
    i_Maxs         Array_Number
  ) is
    v_Work_Months Array_Number;
    v_Genders     Array_Varchar2;
    v_Staff_Ids   Array_Number;
  
    v_Mins          Array_Number := i_Mins;
    v_Maxs          Array_Number := i_Maxs;
    v_Wage_Males    Array_Number := Array_Number();
    v_Wage_Females  Array_Number := Array_Number();
    v_Count_Males   Array_Number := Array_Number();
    v_Count_Females Array_Number := Array_Number();
  
    v_Div_Cnt              number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    v_Wage                 number;
  begin
    v_Wage_Females.Extend(v_Mins.Count);
    v_Wage_Males.Extend(v_Mins.Count);
    v_Count_Males.Extend(v_Mins.Count);
    v_Count_Females.Extend(v_Mins.Count);
  
    for i in 1 .. v_Mins.Count
    loop
      v_Mins(i) := Nvl(v_Mins(i), 0) * 12;
      v_Maxs(i) := v_Maxs(i) * 12;
      v_Wage_Females(i) := 0;
      v_Wage_Males(i) := 0;
      v_Count_Males(i) := 0;
      v_Count_Females(i) := 0;
    end loop;
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                  i_Indirect => true,
                                                                  i_Manual   => true);
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Div_Cnt := v_Filter_Division_Ids.Count;
  
    select q.Staff_Id,
           Months_Between(i_Date, q.Hiring_Date),
           (select r.Gender
              from Mr_Natural_Persons r
             where r.Company_Id = q.Company_Id
               and r.Person_Id = q.Employee_Id)
      bulk collect
      into v_Staff_Ids, v_Work_Months, v_Genders
      from Href_Staffs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and q.Hiring_Date <= i_Date
       and (q.Dismissal_Date is null or q.Dismissal_Date >= i_Date)
       and (v_Access_All_Employees = 'Y' and v_Div_Cnt = 0 or
           q.Org_Unit_Id in (select *
                                from table(v_Filter_Division_Ids)))
       and q.State = 'A'
       and exists (select 1
              from Mhr_Employees k
             where k.Company_Id = q.Company_Id
               and k.Filial_Id = q.Filial_Id
               and k.Employee_Id = q.Employee_Id
               and k.State = 'A');
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Wage := Hpd_Util.Get_Closest_Wage(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Staff_Id   => v_Staff_Ids(i),
                                          i_Period     => i_Date);
    
      for j in 1 .. v_Mins.Count
      loop
        if v_Work_Months(i) >= v_Mins(j) and (v_Work_Months(i) < v_Maxs(j) or v_Maxs(j) is null) then
          if v_Genders(i) = 'M' then
            v_Count_Males(j) := v_Count_Males(j) + 1;
            v_Wage_Males(j) := v_Wage_Males(j) + v_Wage;
          else
            v_Count_Females(j) := v_Count_Females(j) + 1;
            v_Wage_Females(j) := v_Wage_Females(j) + v_Wage;
          end if;
        end if;
      end loop;
    end loop;
  
    for i in 1 .. v_Mins.Count
    loop
      v_Mins(i) := v_Mins(i) / 12;
      v_Maxs(i) := v_Maxs(i) / 12;
    end loop;
  
    Print_Header(a, 'work');
    Print_Body_Ranges(a,
                      v_Mins,
                      v_Maxs,
                      v_Wage_Males,
                      v_Wage_Females,
                      v_Count_Males,
                      v_Count_Females,
                      'work');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_By_Ranks
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Date         date,
    i_Rank_Ids     Array_Number
  ) is
    v_Staff_Ranks Array_Number;
    v_Genders     Array_Varchar2;
    v_Staff_Ids   Array_Number;
  
    v_Rank_Ids      Array_Number := i_Rank_Ids;
    v_Rank_Names    Array_Varchar2 := Array_Varchar2();
    v_Wage_Males    Array_Number := Array_Number();
    v_Wage_Females  Array_Number := Array_Number();
    v_Count_Males   Array_Number := Array_Number();
    v_Count_Females Array_Number := Array_Number();
  
    v_Ind                  number;
    v_Rank_Cnt             number;
    v_Wage                 number;
    v_Div_Cnt              number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
  
    v_Indexs Fazo.Number_Id_Aat;
  begin
    v_Rank_Cnt := i_Rank_Ids.Count;
  
    select q.Rank_Id, q.Name, 0, 0, 0, 0
      bulk collect
      into v_Rank_Ids, v_Rank_Names, v_Wage_Females, v_Wage_Males, v_Count_Males, v_Count_Females
      from Mhr_Ranks q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and (v_Rank_Cnt = 0 or
           q.Rank_Id in (select *
                            from table(i_Rank_Ids)))
     order by q.Order_No;
  
    for i in 1 .. v_Rank_Ids.Count
    loop
      v_Indexs(v_Rank_Ids(i)) := i;
    end loop;
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                  i_Indirect => true,
                                                                  i_Manual   => true);
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Div_Cnt := v_Filter_Division_Ids.Count;
  
    select q.Staff_Id,
           q.Rank_Id,
           (select r.Gender
              from Mr_Natural_Persons r
             where r.Company_Id = q.Company_Id
               and r.Person_Id = q.Employee_Id)
      bulk collect
      into v_Staff_Ids, v_Staff_Ranks, v_Genders
      from Href_Staffs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and q.Hiring_Date <= i_Date
       and (q.Dismissal_Date is null or q.Dismissal_Date >= i_Date)
       and (v_Access_All_Employees = 'Y' and v_Div_Cnt = 0 or
           q.Org_Unit_Id in (select *
                                from table(v_Filter_Division_Ids)))
       and q.Rank_Id is not null
       and (v_Rank_Cnt = 0 or
           q.Rank_Id in (select *
                            from table(v_Rank_Ids)))
       and q.State = 'A'
       and exists (select 1
              from Mhr_Employees k
             where k.Company_Id = q.Company_Id
               and k.Filial_Id = q.Filial_Id
               and k.Employee_Id = q.Employee_Id
               and k.State = 'A');
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Wage := Hpd_Util.Get_Closest_Wage(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Staff_Id   => v_Staff_Ids(i),
                                          i_Period     => i_Date);
    
      begin
        v_Ind := v_Indexs(v_Staff_Ranks(i));
      
        if v_Genders(i) = 'M' then
          v_Count_Males(v_Ind) := v_Count_Males(v_Ind) + 1;
          v_Wage_Males(v_Ind) := v_Wage_Males(v_Ind) + v_Wage;
        else
          v_Count_Females(v_Ind) := v_Count_Females(v_Ind) + 1;
          v_Wage_Females(v_Ind) := v_Wage_Females(v_Ind) + v_Wage;
        end if;
      
      exception
        when No_Data_Found then
          null;
      end;
    end loop;
  
    Print_Header(a, 'rank');
    Print_Body_Ranges(a,
                      v_Rank_Ids,
                      v_Rank_Ids,
                      v_Wage_Males,
                      v_Wage_Females,
                      v_Count_Males,
                      v_Count_Females,
                      'rank',
                      v_Rank_Names);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_By_Edu_Stages
  (
    a               in out nocopy b_Table,
    i_Division_Ids  Array_Number,
    i_Date          date,
    i_Edu_Stage_Ids Array_Number
  ) is
    v_Staff_Ids            Array_Number;
    v_Genders              Array_Varchar2;
    v_Edu_Stage_Ids        Array_Number;
    v_Div_Cnt              number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    v_Edu_Stage_Cnt        number;
    v_Staff_Edu_Stage_Ids  Array_Number;
    v_Educ_Type_Names      Array_Varchar2 := Array_Varchar2();
  
    v_Wage_Males    Array_Number := Array_Number();
    v_Wage_Females  Array_Number := Array_Number();
    v_Count_Males   Array_Number := Array_Number();
    v_Count_Females Array_Number := Array_Number();
  
    v_Indexs Fazo.Number_Id_Aat;
    v_Ind    number;
    v_Wage   number;
  begin
    v_Edu_Stage_Cnt := i_Edu_Stage_Ids.Count;
  
    select q.Edu_Stage_Id, q.Name, 0, 0, 0, 0
      bulk collect
      into v_Edu_Stage_Ids,
           v_Educ_Type_Names,
           v_Wage_Females,
           v_Wage_Males,
           v_Count_Males,
           v_Count_Females
      from Href_Edu_Stages q
     where q.Company_Id = Ui.Company_Id
       and q.State = 'A'
       and (v_Edu_Stage_Cnt = 0 or
           q.Edu_Stage_Id in (select *
                                 from table(i_Edu_Stage_Ids)));
  
    for i in 1 .. v_Edu_Stage_Ids.Count
    loop
      v_Indexs(v_Edu_Stage_Ids(i)) := i;
    end loop;
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                  i_Indirect => true,
                                                                  i_Manual   => true);
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Div_Cnt := v_Filter_Division_Ids.Count;
  
    select q.Staff_Id,
           (select r.Gender
              from Mr_Natural_Persons r
             where r.Company_Id = q.Company_Id
               and r.Person_Id = q.Employee_Id),
           w.Edu_Stage_Id
      bulk collect
      into v_Staff_Ids, v_Genders, v_Staff_Edu_Stage_Ids
      from Href_Staffs q
      join Href_Person_Edu_Stages w
        on w.Company_Id = q.Company_Id
       and w.Person_Id = q.Employee_Id
       and (v_Edu_Stage_Cnt = 0 or
           w.Edu_Stage_Id in (select *
                                 from table(v_Edu_Stage_Ids)))
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and q.Hiring_Date <= i_Date
       and (q.Dismissal_Date is null or q.Dismissal_Date >= i_Date)
       and (v_Access_All_Employees = 'Y' and v_Div_Cnt = 0 or
           q.Org_Unit_Id in (select *
                                from table(v_Filter_Division_Ids)))
       and q.State = 'A'
       and exists (select 1
              from Mhr_Employees k
             where k.Company_Id = q.Company_Id
               and k.Filial_Id = q.Filial_Id
               and k.Employee_Id = q.Employee_Id
               and k.State = 'A');
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      v_Wage := Hpd_Util.Get_Closest_Wage(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Staff_Id   => v_Staff_Ids(i),
                                          i_Period     => i_Date);
    
      begin
        v_Ind := v_Indexs(v_Staff_Edu_Stage_Ids(i));
      
        if v_Genders(i) = 'M' then
          v_Count_Males(v_Ind) := v_Count_Males(v_Ind) + 1;
          v_Wage_Males(v_Ind) := v_Wage_Males(v_Ind) + v_Wage;
        else
          v_Count_Females(v_Ind) := v_Count_Females(v_Ind) + 1;
          v_Wage_Females(v_Ind) := v_Wage_Females(v_Ind) + v_Wage;
        end if;
      
      exception
        when No_Data_Found then
          null;
      end;
    end loop;
  
    Print_Header(a, 'edu');
    Print_Body_Ranges(a,
                      v_Edu_Stage_Ids,
                      v_Edu_Stage_Ids,
                      v_Wage_Males,
                      v_Wage_Females,
                      v_Count_Males,
                      v_Count_Females,
                      'edu',
                      v_Educ_Type_Names);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Run_Header(p Hashmap) is
    a                      b_Table := b_Report.New_Table;
    v_Param                Hashmap := Hashmap();
    v_Division_Ids         Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Div_Cnt              number := v_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := v_Division_Ids;
    v_Date                 date := p.r_Date('date');
    v_Mins                 Array_Number := Nvl(p.o_Array_Number('mins'), Array_Number());
    v_Maxs                 Array_Number := Nvl(p.o_Array_Number('maxs'), Array_Number());
    v_Type                 varchar2(10) := p.r_Varchar2('type');
    v_Staff_Division_Ids   Array_Number;
  begin
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                  i_Indirect => true,
                                                                  i_Manual   => true);
    
      if v_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect v_Division_Ids;
      end if;
    end if;
  
    v_Div_Cnt := v_Filter_Division_Ids.Count;
  
    select q.Division_Id
      bulk collect
      into v_Staff_Division_Ids
      from Href_Staffs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and q.Hiring_Date <= v_Date
       and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Date)
       and (v_Access_All_Employees = 'Y' and v_Div_Cnt = 0 or --
           q.Org_Unit_Id member of v_Filter_Division_Ids)
       and q.State = 'A'
       and exists (select 1
              from Mhr_Employees k
             where k.Company_Id = q.Company_Id
               and k.Filial_Id = q.Filial_Id
               and k.Employee_Id = q.Employee_Id
               and k.State = 'A')
     group by q.Division_Id;
  
    a.New_Row;
    Print_Top(a, v_Staff_Division_Ids, v_Date, v_Type, 11);
    a.New_Row;
  
    case v_Type
      when 'age' then
        if v_Mins.Count = 0 then
          b.Raise_Error(t('run_header: range not found, type=$1', v_Type));
        end if;
      
        Run_By_Age_Ranges(a, v_Staff_Division_Ids, v_Date, v_Mins, v_Maxs);
      when 'work' then
        if v_Mins.Count = 0 then
          b.Raise_Error(t('run_header: range not found, type=$1', v_Type));
        end if;
      
        Run_By_Experience_Ranges(a, v_Staff_Division_Ids, v_Date, v_Mins, v_Maxs);
      when 'rank' then
        Run_By_Ranks(a,
                     v_Staff_Division_Ids,
                     v_Date,
                     Nvl(p.o_Array_Number('rank_ids'), Array_Number()));
      when 'edu' then
        Run_By_Edu_Stages(a,
                          v_Staff_Division_Ids,
                          v_Date,
                          Nvl(p.o_Array_Number('edu_stage_ids'), Array_Number()));
      else
        null;
    end case;
  
    v_Param.Put('division_ids', v_Staff_Division_Ids);
    v_Param.Put('date', v_Date);
    v_Param.Put('type', v_Type);
    b_Report.Add_Sheet('report_header', a, i_Param => v_Param.Json);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_By_Age_Ranges_Detail
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Date         date,
    i_Min_Age      number,
    i_Max_Age      number := null
  ) is
    v_Min_Age              number := i_Min_Age * 12;
    v_Max_Age              number := i_Max_Age * 12 - 0.001;
    v_Male                 varchar2(100) := t('male');
    v_Female               varchar2(100) := t('female');
    v_Div_Cnt              number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    v_Cols                 Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(t('name'), 250),
                                                              Array_Varchar2(t('birthday'), 100),
                                                              Array_Varchar2(t('age'), 50),
                                                              Array_Varchar2(t('wage'), 75),
                                                              Array_Varchar2(t('gender'), 75),
                                                              Array_Varchar2(t('division'), 200),
                                                              Array_Varchar2(t('job'), 200));
  begin
    ------------ header --------------
    a.New_Row;
    a.Current_Style('header');
    a.New_Row;
  
    for i in 1 .. v_Cols.Count
    loop
      a.Data(v_Cols(i) (1));
      a.Column_Width(i, v_Cols(i) (2));
    end loop;
  
    ------------ body --------------
    a.Current_Style('body');
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                  i_Indirect => true,
                                                                  i_Manual   => true);
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Div_Cnt := v_Filter_Division_Ids.Count;
  
    for r in (select q.Company_Id,
                     q.Filial_Id,
                     (select Div.Name
                        from Mhr_Divisions Div
                       where Div.Company_Id = q.Company_Id
                         and Div.Filial_Id = q.Filial_Id
                         and Div.Division_Id = q.Division_Id) as Division_Name,
                     (select Job.Name
                        from Mhr_Jobs Job
                       where Job.Company_Id = q.Company_Id
                         and Job.Filial_Id = q.Filial_Id
                         and Job.Job_Id = q.Job_Id) as Job_Name,
                     q.Staff_Id,
                     w.Name,
                     w.Birthday,
                     Round(Months_Between(i_Date, w.Birthday) / 12) as Age,
                     w.Gender
                from Href_Staffs q
                join Mr_Natural_Persons w
                  on w.Company_Id = q.Company_Id
                 and w.Person_Id = q.Employee_Id
                 and w.Birthday is not null
                 and Months_Between(i_Date, w.Birthday) > v_Min_Age
                 and (v_Max_Age is null or Months_Between(i_Date, w.Birthday) < v_Max_Age)
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and (v_Access_All_Employees = 'Y' and v_Div_Cnt = 0 or
                     q.Org_Unit_Id in (select *
                                          from table(v_Filter_Division_Ids)))
                 and q.Hiring_Date <= i_Date
                 and (q.Dismissal_Date is null or q.Dismissal_Date >= i_Date)
                 and q.State = 'A'
                 and exists (select 1
                        from Mhr_Employees k
                       where k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Employee_Id = q.Employee_Id
                         and k.State = 'A')
               order by name)
    loop
      a.New_Row;
      a.Data(r.Name);
      a.Data(r.Birthday, 'body center');
      a.Data(r.Age, 'body right');
      a.Data(Hpd_Util.Get_Closest_Wage(i_Company_Id => r.Company_Id,
                                       i_Filial_Id  => r.Filial_Id,
                                       i_Staff_Id   => r.Staff_Id,
                                       i_Period     => i_Date),
             'body right');
    
      if r.Gender = 'M' then
        a.Data(v_Male, 'body center');
      else
        a.Data(v_Female, 'body center');
      end if;
    
      a.Data(r.Division_Name);
      a.Data(r.Job_Name);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_By_Experience_Ranges_Detail
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Date         date,
    i_Min_Age      number,
    i_Max_Age      number := null
  ) is
    v_Min_Age              number := i_Min_Age * 12;
    v_Max_Age              number := i_Max_Age * 12 - 0.001;
    t_Male                 varchar2(100 char) := t('male');
    t_Female               varchar2(100 char) := t('female');
    t_Year                 varchar2(100 char) := t('year');
    t_Month                varchar2(100 char) := t('month');
    t_Some_Days            varchar2(100 char) := t('some days ago');
    v_Div_Cnt              number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    v_Year                 number;
    v_Month                number;
  
    v_Cols Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(t('name'), 250),
                                              Array_Varchar2(t('hiring_date'), 100),
                                              Array_Varchar2(t('wage'), 75),
                                              Array_Varchar2(t('work_month'), 100),
                                              Array_Varchar2(t('gender'), 75),
                                              Array_Varchar2(t('division'), 200),
                                              Array_Varchar2(t('job'), 200));
  begin
    ------------ header --------------
    a.New_Row;
    a.Current_Style('header');
    a.New_Row;
  
    for i in 1 .. v_Cols.Count
    loop
      a.Data(v_Cols(i) (1));
      a.Column_Width(i, v_Cols(i) (2));
    end loop;
  
    ------------ body --------------
    a.Current_Style('body');
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                  i_Indirect => true,
                                                                  i_Manual   => true);
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Div_Cnt := v_Filter_Division_Ids.Count;
  
    for r in (select q.Company_Id,
                     q.Filial_Id,
                     q.Staff_Id,
                     Months_Between(i_Date, q.Hiring_Date) as Work_Months,
                     (select Div.Name
                        from Mhr_Divisions Div
                       where Div.Company_Id = q.Company_Id
                         and Div.Filial_Id = q.Filial_Id
                         and Div.Division_Id = q.Division_Id) as Division_Name,
                     (select Job.Name
                        from Mhr_Jobs Job
                       where Job.Company_Id = q.Company_Id
                         and Job.Filial_Id = q.Filial_Id
                         and Job.Job_Id = q.Job_Id) as Job_Name,
                     q.Hiring_Date,
                     w.Name,
                     w.Gender
                from Href_Staffs q
                join Mr_Natural_Persons w
                  on w.Company_Id = q.Company_Id
                 and w.Person_Id = q.Employee_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and (v_Access_All_Employees = 'Y' and v_Div_Cnt = 0 or
                     q.Org_Unit_Id in (select *
                                          from table(v_Filter_Division_Ids)))
                 and Months_Between(i_Date, q.Hiring_Date) > v_Min_Age
                 and (v_Max_Age is null or Months_Between(i_Date, q.Hiring_Date) < v_Max_Age)
                 and q.Hiring_Date <= i_Date
                 and (v_Access_All_Employees = 'Y' and q.Dismissal_Date is null or
                     q.Dismissal_Date >= i_Date)
                 and q.State = 'A'
                 and exists (select 1
                        from Mhr_Employees k
                       where k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Employee_Id = q.Employee_Id
                         and k.State = 'A')
               order by name)
    loop
      a.New_Row;
      a.Data(r.Name);
      a.Data(r.Hiring_Date, 'body center');
      a.Data(Hpd_Util.Get_Closest_Wage(i_Company_Id => r.Company_Id,
                                       i_Filial_Id  => r.Filial_Id,
                                       i_Staff_Id   => r.Staff_Id,
                                       i_Period     => i_Date),
             'body right');
    
      v_Month := Floor(r.Work_Months) mod 12;
      v_Year  := Floor(r.Work_Months / 12);
    
      if v_Month = 0 then
        if v_Year = 0 then
          a.Data(t_Some_Days);
        else
          a.Data(v_Year || ' ' || t_Year);
        end if;
      
      elsif v_Year = 0 then
        a.Data(v_Month || ' ' || t_Month);
      else
        a.Data(v_Year || ' ' || t_Year || ' ' || v_Month || ' ' || t_Month);
      end if;
    
      if r.Gender = 'M' then
        a.Data(t_Male, 'body center');
      else
        a.Data(t_Female, 'body center');
      end if;
    
      a.Data(r.Division_Name);
      a.Data(r.Job_Name);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_By_Ranks_Detail
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Date         date,
    i_Rank_Id      number
  ) is
    t_Male                 varchar2(100 char) := t('male');
    t_Female               varchar2(100 char) := t('female');
    v_Div_Cnt              number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    v_Cols                 Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(t('name'), 250),
                                                              Array_Varchar2(t('wage'), 75),
                                                              Array_Varchar2(t('gender'), 100),
                                                              Array_Varchar2(t('division'), 200),
                                                              Array_Varchar2(t('job'), 200));
  begin
    a.Current_Style('root bold');
    a.New_Row;
    a.Data(t('rank : $1',
             z_Mhr_Ranks.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Rank_Id => i_Rank_Id).Name),
           i_Colspan => 11);
    a.New_Row;
  
    ------------ header --------------
    a.Current_Style('header');
    a.New_Row;
  
    for i in 1 .. v_Cols.Count
    loop
      a.Data(v_Cols(i) (1));
      a.Column_Width(i, v_Cols(i) (2));
    end loop;
  
    ------------ body --------------
    a.Current_Style('body');
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                  i_Indirect => true,
                                                                  i_Manual   => true);
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Div_Cnt := v_Filter_Division_Ids.Count;
  
    for r in (select q.Company_Id,
                     q.Filial_Id,
                     q.Staff_Id,
                     (select Div.Name
                        from Mhr_Divisions Div
                       where Div.Company_Id = q.Company_Id
                         and Div.Filial_Id = q.Filial_Id
                         and Div.Division_Id = q.Division_Id) as Division_Name,
                     (select Job.Name
                        from Mhr_Jobs Job
                       where Job.Company_Id = q.Company_Id
                         and Job.Filial_Id = q.Filial_Id
                         and Job.Job_Id = q.Job_Id) as Job_Name,
                     w.Gender,
                     w.Name
                from Href_Staffs q
                join Mr_Natural_Persons w
                  on w.Company_Id = q.Company_Id
                 and w.Person_Id = q.Employee_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and (v_Access_All_Employees = 'Y' and v_Div_Cnt = 0 or
                     q.Org_Unit_Id in (select *
                                          from table(v_Filter_Division_Ids)))
                 and q.Rank_Id = i_Rank_Id
                 and q.Hiring_Date <= i_Date
                 and (q.Dismissal_Date is null or q.Dismissal_Date >= i_Date)
                 and q.State = 'A'
                 and exists (select 1
                        from Mhr_Employees k
                       where k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Employee_Id = q.Employee_Id
                         and k.State = 'A')
               order by name)
    loop
      a.New_Row;
      a.Data(r.Name);
      a.Data(Hpd_Util.Get_Closest_Wage(i_Company_Id => r.Company_Id,
                                       i_Filial_Id  => r.Filial_Id,
                                       i_Staff_Id   => r.Staff_Id,
                                       i_Period     => i_Date),
             'body right');
    
      if r.Gender = 'M' then
        a.Data(t_Male, 'body center');
      else
        a.Data(t_Female, 'body center');
      end if;
    
      a.Data(r.Division_Name);
      a.Data(r.Job_Name);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_By_Edu_Stages_Detail
  (
    a              in out nocopy b_Table,
    i_Division_Ids Array_Number,
    i_Date         date,
    i_Edu_Stage_Id number
  ) is
    t_Male                 varchar2(100 char) := t('male');
    t_Female               varchar2(100 char) := t('female');
    v_Div_Cnt              number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
  
    v_Cols Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(t('name'), 250),
                                              Array_Varchar2(t('wage'), 75),
                                              Array_Varchar2(t('gender'), 100),
                                              Array_Varchar2(t('division'), 200),
                                              Array_Varchar2(t('job'), 200));
  begin
    a.Current_Style('root bold');
    a.New_Row;
    a.Data(t('eduction stage : $1',
             z_Href_Edu_Stages.Load(i_Company_Id => Ui.Company_Id, i_Edu_Stage_Id => i_Edu_Stage_Id).Name),
           i_Colspan => 11);
    a.New_Row;
  
    ------------ header --------------
    a.Current_Style('header');
    a.New_Row;
  
    for i in 1 .. v_Cols.Count
    loop
      a.Data(v_Cols(i) (1));
      a.Column_Width(i, v_Cols(i) (2));
    end loop;
  
    ------------ body --------------
    a.Current_Style('body');
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                                  i_Indirect => true,
                                                                  i_Manual   => true);
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Div_Cnt := v_Filter_Division_Ids.Count;
  
    for r in (select q.Company_Id,
                     q.Filial_Id,
                     q.Staff_Id,
                     (select Div.Name
                        from Mhr_Divisions Div
                       where Div.Company_Id = q.Company_Id
                         and Div.Filial_Id = q.Filial_Id
                         and Div.Division_Id = q.Division_Id) as Division_Name,
                     (select Job.Name
                        from Mhr_Jobs Job
                       where Job.Company_Id = q.Company_Id
                         and Job.Filial_Id = q.Filial_Id
                         and Job.Job_Id = q.Job_Id) as Job_Name,
                     w.Name,
                     w.Gender
                from Href_Staffs q
                join Mr_Natural_Persons w
                  on w.Company_Id = q.Company_Id
                 and w.Person_Id = q.Employee_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and (v_Access_All_Employees = 'Y' and v_Div_Cnt = 0 or
                     q.Org_Unit_Id in (select *
                                          from table(v_Filter_Division_Ids)))
                 and q.Hiring_Date <= i_Date
                 and (q.Dismissal_Date is null or q.Dismissal_Date >= i_Date)
                 and q.State = 'A'
                 and exists (select 1
                        from Href_Person_Edu_Stages x
                       where x.Company_Id = q.Company_Id
                         and x.Person_Id = q.Employee_Id
                         and x.Edu_Stage_Id = i_Edu_Stage_Id)
                 and exists (select 1
                        from Mhr_Employees k
                       where k.Company_Id = q.Company_Id
                         and k.Filial_Id = q.Filial_Id
                         and k.Employee_Id = q.Employee_Id
                         and k.State = 'A')
               order by name)
    loop
      a.New_Row;
      a.Data(r.Name);
      a.Data(Hpd_Util.Get_Closest_Wage(i_Company_Id => r.Company_Id,
                                       i_Filial_Id  => r.Filial_Id,
                                       i_Staff_Id   => r.Staff_Id,
                                       i_Period     => i_Date),
             'body right');
    
      if r.Gender = 'M' then
        a.Data(t_Male, 'body center');
      else
        a.Data(t_Female, 'body center');
      end if;
    
      a.Data(r.Division_Name);
      a.Data(r.Job_Name);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Detail(p Hashmap) is
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Date         date := p.r_Date('date');
    v_Type         varchar2(20) := p.r_Varchar2('type');
    a              b_Table := b_Report.New_Table;
  begin
    a.New_Row;
    Print_Top(a, v_Division_Ids, v_Date, v_Type, 11);
  
    case v_Type
      when 'age' then
        Run_By_Age_Ranges_Detail(a,
                                 v_Division_Ids,
                                 v_Date,
                                 p.r_Number('min_range'),
                                 p.o_Number('max_range'));
      when 'work' then
        Run_By_Experience_Ranges_Detail(a,
                                        v_Division_Ids,
                                        v_Date,
                                        p.r_Number('min_range'),
                                        p.o_Number('max_range'));
      when 'rank' then
        Run_By_Ranks_Detail(a, v_Division_Ids, v_Date, p.r_Number('rank_id'));
      when 'edu' then
        Run_By_Edu_Stages_Detail(a, v_Division_Ids, v_Date, p.r_Number('edu_stage_id'));
      else
        null;
    end case;
  
    b_Report.Add_Sheet('report_detail', a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Init is
  begin
    g_Titles('age') := t('age range title');
    g_Titles('work') := t('experience range title');
    g_Titles('rank') := t('rank title');
    g_Titles('edu') := t('educ title');
  
    b_Report.New_Style(i_Style_Name       => 'female',
                       i_Font_Color       => '#FFFFFF',
                       i_Background_Color => '#E7505A');
  
    b_Report.New_Style(i_Style_Name       => 'male',
                       i_Font_Color       => '#FFFFFF',
                       i_Background_Color => '#4B77BE');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Param Hashmap := Hashmap;
    v_Range Array_Varchar2;
    v_Map   Hashmap := Hashmap;
  begin
    if b_Report.Is_Redirect(p) then
      v_Param := Fazo.Parse_Map(p.o_Varchar2('table_param'));
    
      case v_Param.r_Varchar2('type')
        when 'age' then
          v_Range := Fazo.Split(p.o_Varchar2('cell_param'), ',');
          v_Param.Put('min_range', v_Range(1));
          v_Param.Put('max_range', v_Range(2));
        when 'work' then
          v_Range := Fazo.Split(p.o_Varchar2('cell_param'), ',');
          v_Param.Put('min_range', v_Range(1));
          v_Param.Put('max_range', v_Range(2));
        when 'rank' then
          v_Param.Put('rank_id', p.o_Varchar2('cell_param'));
        when 'edu' then
          v_Param.Put('edu_stage_id', p.o_Varchar2('cell_param'));
        else
          null;
      end case;
    
      v_Map.Put('redirect', v_Param.Json);
      b_Report.Redirect_To_Report('/vhr/rep/href/employee_by_gender:run', v_Map);
      return;
    end if;
  
    b_Report.Open_Book_With_Styles(p.o_Varchar2('rt'));
  
    Init;
  
    if p.Has('redirect') then
      v_Map := Fazo_Schema.Fazo.Parse_Map(p.r_Array_Varchar2('redirect'));
      Run_Detail(v_Map);
    else
      Run_Header(p);
    end if;
  
    b_Report.Close_Book;
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
    update Href_Edu_Stages
       set Company_Id   = null,
           Edu_Stage_Id = null,
           name         = null,
           Order_No     = null;
  end;

end Ui_Vhr291;
/
