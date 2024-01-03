create or replace package Ui_Vhr138 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Filials return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Reload_Filter(p Hashmap) return Hashmap;
end Ui_Vhr138;
/
create or replace package body Ui_Vhr138 is
  c_Headcount_Dimension_Setting_Code  constant Md_User_Settings.Setting_Code%type := 'UI-VHR138:HEADCOUNT_DIMENSION';
  c_Headcount_Dimension_By_Filials    constant varchar2(1) := 'F';
  c_Headcount_Dimension_By_Divisions  constant varchar2(1) := 'D';
  c_Headcount_Dimension_By_Job_Groups constant varchar2(1) := 'J';
  c_Headcount_Dimension_By_Months     constant varchar2(1) := 'M';
  ----------
  g_Company_Id number;
  g_Filial_Id  number;
  -- subordination checks are not implemented as it is asserted that this dashboard is used by members of upper management
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
    return b.Translate('UI-VHR138:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Relative_Evaluation
  (
    i_First_Value  number,
    i_Second_Value number
  ) return number is
  begin
    if i_First_Value != 0 and i_Second_Value != 0 then
      return Round((i_Second_Value / i_First_Value) * 100 - 100, 2);
    elsif i_First_Value != 0 and i_Second_Value = 0 then
      return - 100;
    elsif i_First_Value = 0 and i_Second_Value != 0 then
      return 100;
    else
      return 0;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Headcount
  (
    i_Begin_Date_Minus_1_Period date,
    i_Begin_Date                date,
    i_End_Date                  date,
    i_Period_Type               varchar2,
    i_Ids                       Array_Number, -- ids of division or filial for which data needs to be calculated
    i_Job_Group_Ids             Array_Number
  ) return Array_Varchar2 is
    result          Array_Varchar2 := Array_Varchar2();
    v_Period_Format varchar(20 char);
  begin
    Result.Extend(9);
  
    case i_Period_Type
      when 'Y' then
        v_Period_Format := Href_Pref.c_Date_Format_Year;
      when 'Q' then
        v_Period_Format := Href_Pref.c_Date_Format_Year_Quarter;
      when 'M' then
        v_Period_Format := Href_Pref.c_Date_Format_Month;
      else
        v_Period_Format := Href_Pref.c_Date_Format_Year;
    end case;
  
    result(1) := to_char(i_Begin_Date, v_Period_Format);
  
    result(2) := Uit_Href.Total_Working_Staff_Count(i_Begin_Date    => i_Begin_Date,
                                                    i_Ids           => i_Ids,
                                                    i_Job_Group_Ids => i_Job_Group_Ids);
  
    result(3) := Uit_Href.Total_Hired_Staff_Count(i_Begin_Date    => i_Begin_Date,
                                                  i_End_Date      => i_End_Date,
                                                  i_Ids           => i_Ids,
                                                  i_Job_Group_Ids => i_Job_Group_Ids);
  
    result(4) := -Uit_Href.Total_Dismissed_Staff_Count(i_Begin_Date    => i_Begin_Date,
                                                       i_End_Date      => i_End_Date,
                                                       i_Ids           => i_Ids,
                                                       i_Job_Group_Ids => i_Job_Group_Ids);
  
    result(5) := Uit_Href.Staff_Turnovers(i_Begin_Date    => i_Begin_Date,
                                          i_End_Date      => i_End_Date,
                                          i_Ids           => i_Ids,
                                          i_Job_Group_Ids => i_Job_Group_Ids);
  
    result(6) := Relative_Evaluation(Uit_Href.Total_Working_Staff_Count(i_Begin_Date_Minus_1_Period),
                                     result(2));
  
    result(7) := Relative_Evaluation(Uit_Href.Total_Hired_Staff_Count(i_Begin_Date_Minus_1_Period,
                                                                      i_Begin_Date),
                                     result(3));
  
    result(8) := Relative_Evaluation(Uit_Href.Total_Dismissed_Staff_Count(i_Begin_Date_Minus_1_Period,
                                                                          i_Begin_Date),
                                     -result(4));
  
    result(9) := Relative_Evaluation(Uit_Href.Staff_Turnovers(i_Begin_Date_Minus_1_Period,
                                                              i_Begin_Date),
                                     result(5));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  --
  ----------------------------------------------------------------------------------------------------
  Function Headcount_By_Dimension
  (
    i_Begin_Date    date,
    i_End_Date      date,
    i_Ids           Array_Number, -- id of filial, division or job group for which data needs to be calculated
    i_Name          varchar2,
    i_Job_Group_Ids Array_Number,
    i_Not_By_Month  boolean := true
  ) return Array_Varchar2 is
    result Array_Varchar2 := Array_Varchar2();
  begin
    Result.Extend(5);
    result(1) := i_Name;
    result(2) := Uit_Href.Total_Working_Staff_Count(i_Begin_Date    => i_Begin_Date,
                                                    i_Ids           => i_Ids,
                                                    i_Job_Group_Ids => i_Job_Group_Ids);
    result(3) := Uit_Href.Total_Hired_Staff_Count(i_Begin_Date    => i_Begin_Date,
                                                  i_End_Date      => i_End_Date,
                                                  i_Ids           => i_Ids,
                                                  i_Job_Group_Ids => i_Job_Group_Ids);
    result(4) := -Uit_Href.Total_Dismissed_Staff_Count(i_Begin_Date    => i_Begin_Date,
                                                       i_End_Date      => i_End_Date,
                                                       i_Ids           => i_Ids,
                                                       i_Job_Group_Ids => i_Job_Group_Ids);
    result(5) := Uit_Href.Staff_Turnovers(i_Begin_Date    => i_Begin_Date,
                                          i_End_Date      => i_End_Date,
                                          i_Ids           => i_Ids,
                                          i_Job_Group_Ids => i_Job_Group_Ids);
  
    if result(2) = 0 and result(3) = 0 and result(4) = 0 and result(5) = 0 and i_Not_By_Month then
      -- we do not show division/filial if it has 0s
      return null;
    else
      return result;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissal_Reasons_Count
  (
    i_Begin_Date          date,
    i_End_Date            date,
    i_Dismissal_Reason_Id number,
    i_Ids                 Array_Number,
    i_Job_Group_Ids       Array_Number
  ) return number is
    v_Count           number;
    v_Total_Dismissal number := Uit_Href.Total_Dismissed_Staff_Count(i_Begin_Date => i_Begin_Date,
                                                                     i_End_Date   => i_End_Date);
  begin
    if Ui.Is_Filial_Head then
      select count(*)
        into v_Count
        from Hpd_Journals q
        join Md_Filials f
          on f.Company_Id = q.Company_Id
         and f.Filial_Id = q.Filial_Id
         and f.State = 'A'
        join Hpd_Journal_Pages w
          on w.Company_Id = g_Company_Id
         and w.Filial_Id = q.Filial_Id
         and w.Journal_Id = q.Journal_Id
        join Hpd_Dismissals r
          on r.Company_Id = g_Company_Id
         and r.Filial_Id = w.Filial_Id
         and r.Page_Id = w.Page_Id
         and r.Dismissal_Reason_Id = i_Dismissal_Reason_Id
       where q.Company_Id = g_Company_Id
         and (i_Ids is null or q.Filial_Id member of i_Ids)
         and q.Posted = 'Y'
         and r.Dismissal_Date between i_Begin_Date and i_End_Date
         and (i_Job_Group_Ids is null or exists
              (select 1
                 from Mhr_Jobs j
                where j.Company_Id = q.Company_Id
                  and j.Filial_Id = q.Filial_Id
                  and j.Job_Id =
                      Hpd_Util.Get_Closest_Job_Id(i_Company_Id => q.Company_Id,
                                                  i_Filial_Id  => q.Filial_Id,
                                                  i_Staff_Id   => w.Staff_Id,
                                                  i_Period     => r.Dismissal_Date)
                  and j.Job_Group_Id in (select Column_Value
                                           from table(i_Job_Group_Ids))));
    else
      select count(*)
        into v_Count
        from Hpd_Journals q
        join Md_Filials f
          on f.Company_Id = q.Company_Id
         and f.Filial_Id = q.Filial_Id
         and f.State = 'A'
        join Hpd_Journal_Pages w
          on w.Company_Id = g_Company_Id
         and w.Filial_Id = g_Filial_Id
         and w.Journal_Id = q.Journal_Id
        join Hpd_Dismissals r
          on r.Company_Id = g_Company_Id
         and r.Filial_Id = g_Filial_Id
         and r.Page_Id = w.Page_Id
         and r.Dismissal_Reason_Id = i_Dismissal_Reason_Id
       where q.Company_Id = g_Company_Id
         and q.Filial_Id = g_Filial_Id
         and (i_Ids is null or
             Hpd_Util.Get_Closest_Division_Id(i_Company_Id => g_Company_Id,
                                               i_Filial_Id  => g_Filial_Id,
                                               i_Staff_Id   => w.Staff_Id,
                                               i_Period     => r.Dismissal_Date) member of i_Ids)
         and q.Posted = 'Y'
         and r.Dismissal_Date between i_Begin_Date and i_End_Date
         and (i_Job_Group_Ids is null or exists
              (select 1
                 from Mhr_Jobs j
                where j.Company_Id = q.Company_Id
                  and j.Filial_Id = q.Filial_Id
                  and j.Job_Id =
                      Hpd_Util.Get_Closest_Job_Id(i_Company_Id => q.Company_Id,
                                                  i_Filial_Id  => q.Filial_Id,
                                                  i_Staff_Id   => w.Staff_Id,
                                                  i_Period     => r.Dismissal_Date)
                  and j.Job_Group_Id in (select Column_Value
                                           from table(i_Job_Group_Ids))));
    end if;
  
    if v_Total_Dismissal != 0 and v_Count != 0 then
      return Relative_Evaluation(v_Total_Dismissal, v_Count) + 100;
    else
      return null;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissal_Reason_Data
  (
    i_Begin_Date_1        date,
    i_Begin_Date_2        date,
    i_End_Date            date,
    i_Dismissal_Reason_Id number,
    i_Name                varchar2,
    i_Ids                 Array_Number,
    i_Job_Group_Ids       Array_Number
  ) return Array_Varchar2 is
    result Array_Varchar2 := Array_Varchar2();
  begin
    Result.Extend(3);
    result(1) := i_Name;
    result(2) := Dismissal_Reasons_Count(i_Begin_Date_1,
                                         i_Begin_Date_2,
                                         i_Dismissal_Reason_Id => i_Dismissal_Reason_Id,
                                         i_Ids                 => i_Ids,
                                         i_Job_Group_Ids       => i_Job_Group_Ids); -- period 1 percentage
    result(3) := Dismissal_Reasons_Count(i_Begin_Date_2,
                                         i_End_Date,
                                         i_Dismissal_Reason_Id => i_Dismissal_Reason_Id,
                                         i_Ids                 => i_Ids,
                                         i_Job_Group_Ids       => i_Job_Group_Ids); -- period 2 percentage
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Experience_By_Years
  (
    i_Date          date, -- (truncated) start of period. E.g.: if user selects '2022 Q3', '01.07.2022' is passed
    i_Trunc_Format  varchar2, -- based on period type, helps to truncate hiring and dismissal dates in query to determine whether hiring was done in this time period and dismissal (if not null) was done after the period
    i_Ids           Array_Number,
    i_Job_Group_Ids Array_Number
  ) return Hashmap is
    v_Exp_Counts Array_Number := Array_Number(0, 0, 0, 0);
    result       Hashmap := Hashmap();
  
    --------------------------------------------------
    Procedure Iterate_Experience(i_Hiring_Date date) is
      v_Exp_Years number;
      v_Exp_Index number;
    begin
      v_Exp_Years := Round(Months_Between(i_Date, i_Hiring_Date) / 12, 1); -- approx count of years of experience (i.e. how many years passed since the staff was hired), rounded to one decimal place
    
      if (v_Exp_Years < 1) then
        v_Exp_Index := 1;
      elsif (v_Exp_Years >= 1 and v_Exp_Years <= 3) then
        v_Exp_Index := 2;
      elsif (v_Exp_Years > 3 and v_Exp_Years <= 5) then
        v_Exp_Index := 3;
      elsif (v_Exp_Years > 5) then
        v_Exp_Index := 4;
      end if;
    
      v_Exp_Counts(v_Exp_Index) := v_Exp_Counts(v_Exp_Index) + 1;
    end;
  begin
    if Ui.Is_Filial_Head then
      for r in (select q.Hiring_Date
                  from Href_Staffs q
                 where q.Company_Id = g_Company_Id
                   and Trunc(q.Hiring_Date, i_Trunc_Format) <= i_Date
                   and (q.Dismissal_Date is null or
                       Trunc(q.Dismissal_Date + 1, i_Trunc_Format) > i_Date)
                   and q.State = 'A'
                   and (i_Ids is null or q.Filial_Id member of i_Ids)
                   and (i_Job_Group_Ids is null or exists
                        (select 1
                           from Mhr_Jobs m
                          where m.Company_Id = q.Company_Id
                            and m.Filial_Id = q.Filial_Id
                            and m.Job_Id = q.Job_Id
                            and m.Job_Group_Id in (select Column_Value
                                                     from table(i_Job_Group_Ids)))))
      loop
        Iterate_Experience(r.Hiring_Date);
      end loop;
    else
      for r in (select q.Hiring_Date
                  from Href_Staffs q
                 where q.Company_Id = g_Company_Id
                   and q.Filial_Id = g_Filial_Id
                   and Trunc(q.Hiring_Date, i_Trunc_Format) <= i_Date
                   and (q.Dismissal_Date is null or
                       Trunc(q.Dismissal_Date + 1, i_Trunc_Format) > i_Date)
                   and q.State = 'A'
                   and (i_Ids is null or q.Division_Id member of i_Ids)
                   and (i_Job_Group_Ids is null or exists
                        (select 1
                           from Mhr_Jobs m
                          where m.Company_Id = q.Company_Id
                            and m.Filial_Id = q.Filial_Id
                            and m.Job_Id = q.Job_Id
                            and m.Job_Group_Id in (select Column_Value
                                                     from table(i_Job_Group_Ids)))))
      loop
        Iterate_Experience(r.Hiring_Date);
      end loop;
    end if;
  
    Result.Put('less_than_1_year', v_Exp_Counts(1));
    Result.Put('between_1_and_3_years', v_Exp_Counts(2));
    Result.Put('between_4_and_5_years', v_Exp_Counts(3));
    Result.Put('more_than_5_years', v_Exp_Counts(4));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Filials return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from md_filials f
                      where f.company_id = :company_id
                        and f.state = ''A''
                        and f.filial_id <> :head_filial_id',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'head_filial_id', Ui.Filial_Head));
  
    q.Varchar2_Field('name');
    q.Number_Field('filial_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_job_groups', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('job_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Headcount_Dimension return varchar2 is
    v_Default_Value varchar(1) := c_Headcount_Dimension_By_Divisions;
  begin
    if Ui.Is_Filial_Head then
      v_Default_Value := c_Headcount_Dimension_By_Filials;
    end if;
  
    return Md_Api.User_Setting_Load(i_Company_Id    => Ui.Company_Id,
                                    i_User_Id       => Ui.User_Id,
                                    i_Filial_Id     => Ui.Filial_Id,
                                    i_Setting_Code  => c_Headcount_Dimension_Setting_Code,
                                    i_Default_Value => v_Default_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Headcount_Dimension_Setting(i_Value varchar2) is
  begin
    Md_Api.User_Setting_Save(i_Company_Id    => Ui.Company_Id,
                             i_User_Id       => Ui.User_Id,
                             i_Filial_Id     => Ui.Filial_Id,
                             i_Setting_Code  => c_Headcount_Dimension_Setting_Code,
                             i_Setting_Value => i_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Data(p Hashmap := null) return Hashmap is
    v_Date                 date;
    v_Yesterday            date := Trunc(sysdate) - 1;
    v_Date_Minus_4_Periods date; -- (date - 4 periods)
    v_Date_Minus_3_Periods date; -- (date - 3 periods)
    v_Date_Minus_2_Periods date; -- (date - 2 periods)
    v_Date_Minus_1_Period  date; -- (date - 1 period)
    v_Date_Plus_1_Period   date; -- (date + 1 period)
    v_Date_Format          varchar2(30 char);
    v_Date_Trunc_Format    varchar2(30 char);
    v_Ids                  Array_Number; -- either filial or division ids values
    v_Job_Group_Ids        Array_Number;
    v_Period_Type          varchar2(1 char);
    v_Headcount_Dimension  varchar2(1 char);
    v_Step                 number;
    v_Begin_Date           date;
    v_End_Date             date;
  
    v_Current_Date           date := Trunc(sysdate);
    v_Current_Staff_Cnt      number;
    v_Headcount_By_Dimension Array_Varchar2;
    v_Matrix                 Matrix_Varchar2;
    v_Dismissal_Reason_Data  Array_Varchar2; -- used to construct matrix of dismissal reasons, its elements are: dismissal name, period 1 percentage, period 2 percentage.
    result                   Hashmap := Hashmap;
  begin
    g_Company_Id := Ui.Company_Id;
    g_Filial_Id  := Ui.Filial_Id;
  
    if p is null then
      -- Model
      v_Period_Type         := 'Y';
      v_Date                := Trunc(sysdate, Href_Pref.c_Date_Trunc_Format_Year);
      v_Headcount_Dimension := Headcount_Dimension;
    else
      -- Reload
      v_Period_Type := p.r_Varchar2('period_type');
      v_Date        := p.r_Date('date', Href_Pref.c_Date_Format_Month);
    
      v_Job_Group_Ids := p.o_Array_Number('job_group_ids');
    
      if Fazo.Is_Empty(v_Job_Group_Ids) then
        v_Job_Group_Ids := null;
      end if;
    
      v_Headcount_Dimension := p.r_Varchar2('headcount_dimension');
      Save_Headcount_Dimension_Setting(v_Headcount_Dimension);
    
      if Ui.Is_Filial_Head then
        v_Ids := p.o_Array_Number('filial_ids');
      else
        v_Ids := p.o_Array_Number('division_ids');
      end if;
    
      if Fazo.Is_Empty(v_Ids) then
        v_Ids := null;
      end if;
    end if;
  
    case v_Period_Type
      when 'Y' then
        v_Step              := 12;
        v_Date_Format       := Href_Pref.c_Date_Format_Year;
        v_Date_Trunc_Format := Href_Pref.c_Date_Trunc_Format_Year;
      when 'Q' then
        v_Step              := 3;
        v_Date_Format       := Href_Pref.c_Date_Format_Year_Quarter;
        v_Date_Trunc_Format := Href_Pref.c_Date_Trunc_Format_Quarter;
      when 'M' then
        v_Step              := 1;
        v_Date_Format       := Href_Pref.c_Date_Format_Month;
        v_Date_Trunc_Format := Href_Pref.c_Date_Trunc_Format_Month;
    end case;
  
    v_Date_Minus_4_Periods := Add_Months(v_Date, -4 * v_Step);
    v_Date_Minus_3_Periods := Add_Months(v_Date, -3 * v_Step);
    v_Date_Minus_2_Periods := Add_Months(v_Date, -2 * v_Step);
    v_Date_Minus_1_Period  := Add_Months(v_Date, -1 * v_Step);
    v_Date_Plus_1_Period   := Add_Months(v_Date, 1 * v_Step);
  
    Result.Put('period_1', to_char(v_Date_Minus_1_Period, v_Date_Format));
    Result.Put('period_2', to_char(v_Date, v_Date_Format));
  
    if Ui.Is_Filial_Head then
      select count(distinct q.Employee_Id)
        into v_Current_Staff_Cnt
        from Href_Staffs q
        join Md_Filials f
          on f.Company_Id = q.Company_Id
         and f.Filial_Id = q.Filial_Id
         and f.State = 'A'
       where q.Company_Id = Ui.Company_Id
         and q.State = 'A'
         and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
         and q.Hiring_Date <= v_Current_Date
         and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Current_Date)
         and (v_Ids is null or q.Filial_Id member of v_Ids)
         and (v_Job_Group_Ids is null or exists
              (select 1
                 from Mhr_Jobs m
                where m.Company_Id = q.Company_Id
                  and m.Filial_Id = q.Filial_Id
                  and m.Job_Id = q.Job_Id
                  and m.Job_Group_Id in (select Column_Value
                                           from table(v_Job_Group_Ids))));
    else
      select count(*)
        into v_Current_Staff_Cnt
        from Href_Staffs q
        join Md_Filials f
          on f.Company_Id = q.Company_Id
         and f.Filial_Id = q.Filial_Id
         and f.State = 'A'
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Hiring_Date <= v_Current_Date
         and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Current_Date)
         and q.State = 'A'
         and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
         and (v_Ids is null or q.Division_Id member of v_Ids)
         and (v_Job_Group_Ids is null or exists
              (select 1
                 from Mhr_Jobs m
                where m.Company_Id = q.Company_Id
                  and m.Filial_Id = q.Filial_Id
                  and m.Job_Id = q.Job_Id
                  and m.Job_Group_Id in (select Column_Value
                                           from table(v_Job_Group_Ids))));
    end if;
  
    Result.Put('current_staff_headcount', v_Current_Staff_Cnt);
  
    -- headcount by periods
    v_Matrix := Matrix_Varchar2(Headcount(v_Date_Minus_4_Periods,
                                          v_Date_Minus_3_Periods,
                                          v_Date_Minus_2_Periods - 1,
                                          v_Period_Type,
                                          v_Ids,
                                          v_Job_Group_Ids),
                                Headcount(v_Date_Minus_3_Periods,
                                          v_Date_Minus_2_Periods,
                                          v_Date_Minus_1_Period - 1,
                                          v_Period_Type,
                                          v_Ids,
                                          v_Job_Group_Ids),
                                Headcount(v_Date_Minus_2_Periods,
                                          v_Date_Minus_1_Period,
                                          v_Date - 1,
                                          v_Period_Type,
                                          v_Ids,
                                          v_Job_Group_Ids),
                                Headcount(v_Date_Minus_1_Period,
                                          v_Date,
                                          v_Date_Plus_1_Period - 1,
                                          v_Period_Type,
                                          v_Ids,
                                          v_Job_Group_Ids));
  
    Result.Put('headcount_by_periods', Fazo.Zip_Matrix(v_Matrix));
  
    v_Matrix := Matrix_Varchar2();
  
    Result.Put('headcount_dimension', v_Headcount_Dimension);
  
    if v_Headcount_Dimension = c_Headcount_Dimension_By_Months then
      -- headcount by months
      for r in (select *
                  from Md_Filials Fl
                 where Fl.Company_Id = g_Company_Id
                   and Fl.Filial_Id <> Ui.Filial_Head
                   and Fl.State = 'A'
                   and (v_Ids is null or Fl.Filial_Id member of v_Ids))
      loop
        for i in 1 .. v_Step
        loop
          v_Begin_Date := Add_Months(v_Date, i - 1);
          v_End_Date   := Add_Months(v_Begin_Date, 1);
        
          v_Headcount_By_Dimension := Headcount_By_Dimension(v_Begin_Date,
                                                             Least(v_End_Date, v_Yesterday),
                                                             Array_Number(r.Filial_Id),
                                                             v_Begin_Date,
                                                             v_Job_Group_Ids,
                                                             false);
        
          if v_Headcount_By_Dimension is not null then
            Fazo.Push(v_Headcount_By_Dimension, r.Name);
          
            Fazo.Push(v_Matrix, v_Headcount_By_Dimension);
          end if;
        end loop;
      end loop;
    
      Result.Put('headcount_by_months', Fazo.Zip_Matrix(v_Matrix));
    elsif v_Headcount_Dimension = c_Headcount_Dimension_By_Job_Groups then
      -- headcount by job groups
      for r in (select *
                  from Mhr_Job_Groups q
                 where q.Company_Id = g_Company_Id
                   and (v_Job_Group_Ids is null or q.Job_Group_Id member of v_Job_Group_Ids)
                 order by q.Job_Group_Id)
      loop
        v_Headcount_By_Dimension := Headcount_By_Dimension(v_Date,
                                                           Least(v_Yesterday, v_Date_Plus_1_Period),
                                                           v_Ids,
                                                           r.Name,
                                                           Array_Number(r.Job_Group_Id));
      
        if v_Headcount_By_Dimension is not null then
          Fazo.Push(v_Matrix, v_Headcount_By_Dimension);
        end if;
      end loop;
    
      Result.Put('headcount_by_job_groups', Fazo.Zip_Matrix(v_Matrix));
    else
      if v_Headcount_Dimension = c_Headcount_Dimension_By_Divisions then
        -- headcount by divisions
        for r in (select q.*
                    from Mhr_Divisions q
                    join Md_Filials f
                      on f.Company_Id = q.Company_Id
                     and f.Filial_Id = q.Filial_Id
                     and f.State = 'A'
                    join Hrm_Divisions Dv
                      on Dv.Company_Id = q.Company_Id
                     and Dv.Filial_Id = q.Filial_Id
                     and Dv.Division_Id = q.Division_Id
                     and Dv.Is_Department = 'Y'
                   where q.Company_Id = g_Company_Id
                     and q.Filial_Id = g_Filial_Id
                     and (v_Ids is null or q.Division_Id member of v_Ids)
                   order by q.Division_Id)
        loop
          v_Headcount_By_Dimension := Headcount_By_Dimension(v_Date,
                                                             Least(v_Yesterday, v_Date_Plus_1_Period),
                                                             Array_Number(r.Division_Id),
                                                             r.Name,
                                                             v_Job_Group_Ids);
        
          if v_Headcount_By_Dimension is not null then
            Fazo.Push(v_Matrix, v_Headcount_By_Dimension);
          end if;
        end loop;
      
        Result.Put('headcount_by_divisions', Fazo.Zip_Matrix(v_Matrix));
      else
        -- headcount by filials
        for r in (select *
                    from Md_Filials q
                   where q.Company_Id = g_Company_Id
                     and q.Filial_Id <> Ui.Filial_Head
                     and q.State = 'A'
                     and (v_Ids is null or q.Filial_Id member of v_Ids)
                   order by q.Filial_Id)
        loop
          v_Headcount_By_Dimension := Headcount_By_Dimension(v_Date,
                                                             Least(v_Yesterday, v_Date_Plus_1_Period),
                                                             Array_Number(r.Filial_Id),
                                                             r.Name,
                                                             v_Job_Group_Ids);
        
          if v_Headcount_By_Dimension is not null then
            Fazo.Push(v_Matrix, v_Headcount_By_Dimension);
          end if;
        end loop;
      
        Result.Put('headcount_by_filials', Fazo.Zip_Matrix(v_Matrix));
      end if;
    end if;
  
    -- Dismissal reasons
    v_Matrix := Matrix_Varchar2();
  
    for r in (select *
                from Href_Dismissal_Reasons q
               where q.Company_Id = g_Company_Id)
    loop
      v_Dismissal_Reason_Data := Dismissal_Reason_Data(v_Date_Minus_1_Period,
                                                       v_Date,
                                                       Least(v_Yesterday, v_Date_Plus_1_Period),
                                                       r.Dismissal_Reason_Id,
                                                       r.Name,
                                                       v_Ids,
                                                       v_Job_Group_Ids);
    
      if v_Dismissal_Reason_Data(2) != 0 or v_Dismissal_Reason_Data(3) != 0 then
        Fazo.Push(v_Matrix, v_Dismissal_Reason_Data);
      end if;
    end loop;
  
    Result.Put('dismissal_reasons', Fazo.Zip_Matrix(v_Matrix));
  
    -- Experience by years
    Result.Put('experience_period_1',
               Experience_By_Years(v_Date_Minus_1_Period,
                                   v_Date_Trunc_Format,
                                   v_Ids,
                                   v_Job_Group_Ids));
    Result.Put('experience_period_2',
               Experience_By_Years(v_Date, v_Date_Trunc_Format, v_Ids, v_Job_Group_Ids));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Load_Data;
  
    Result.Put('headcount_dimension_by_filials', c_Headcount_Dimension_By_Filials);
    Result.Put('headcount_dimension_by_divisions', c_Headcount_Dimension_By_Divisions);
    Result.Put('headcount_dimension_by_job_groups', c_Headcount_Dimension_By_Job_Groups);
    Result.Put('headcount_dimension_by_months', c_Headcount_Dimension_By_Months);
  
    if not Ui.Is_Filial_Head then
      Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  -- executes model with data provided to the filter
  ----------------------------------------------------------------------------------------------------
  Function Reload_Filter(p Hashmap) return Hashmap is
  begin
    return Load_Data(p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr138;
/
