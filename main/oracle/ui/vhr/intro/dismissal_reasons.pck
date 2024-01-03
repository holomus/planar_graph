create or replace package Ui_Vhr139 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Reload(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
end Ui_Vhr139;
/
create or replace package body Ui_Vhr139 is
  ----------------------------------------------------------------------------------------------------
  g_Dummy constant Array_Number := Array_Number(1);

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
    return b.Translate('UI-VHR139:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissal_Quantity
  (
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Key_Person   varchar2 := null
  ) return number is
    result number;
  begin
    select count(*)
      into result
      from Href_Staffs q
      left join Href_Person_Details w
        on w.Company_Id = q.Company_Id
       and w.Person_Id = q.Employee_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Dismissal_Date is not null
       and q.Dismissal_Date between i_Begin_Date and i_End_Date
       and q.State = 'A'
       and Nvl2(i_Key_Person, Nvl(w.Key_Person, 'N'), 1) = Nvl(i_Key_Person, 1)
       and Nvl2(i_Division_Ids, q.Division_Id, 1) in
           (select *
              from table(Nvl(i_Division_Ids, g_Dummy)))
          
       and Nvl2(i_Job_Ids, q.Job_Id, 1) in
           (select *
              from table(Nvl(i_Job_Ids, g_Dummy)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Work_Experience
  (
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Key_Person   varchar2 := null
  ) return number is
    result number;
  begin
    select Round(avg((q.Dismissal_Date - q.Hiring_Date) / 365), 1)
      into result
      from Href_Staffs q
      left join Href_Person_Details r
        on r.Company_Id = q.Company_Id
       and r.Person_Id = q.Employee_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Dismissal_Date is not null
       and q.Dismissal_Date between i_Begin_Date and i_End_Date
       and q.State = 'A'
       and Nvl2(i_Key_Person, Nvl(r.Key_Person, 'N'), 1) = Nvl(i_Key_Person, 1)
       and Nvl2(i_Division_Ids, q.Division_Id, 1) in
           (select *
              from table(Nvl(i_Division_Ids, g_Dummy)))
          
       and Nvl2(i_Job_Ids, q.Job_Id, 1) in
           (select *
              from table(Nvl(i_Job_Ids, g_Dummy)));
  
    return Nvl(result, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Average_Age
  (
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Key_Person   varchar2 := null
  ) return number is
    result number;
  begin
    select Round(avg((q.Dismissal_Date - r.Birthday) / 365), 1)
      into result
      from Href_Staffs q
      left join Href_Person_Details d
        on d.Company_Id = q.Company_Id
       and d.Person_Id = q.Employee_Id
      join Mr_Natural_Persons r
        on r.Company_Id = q.Company_Id
       and r.Person_Id = q.Employee_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Dismissal_Date is not null
       and q.Dismissal_Date between i_Begin_Date and i_End_Date
       and q.State = 'A'
       and Nvl2(i_Key_Person, Nvl(d.Key_Person, 'N'), 1) = Nvl(i_Key_Person, 1)
       and Nvl2(i_Division_Ids, q.Division_Id, 1) in
           (select *
              from table(Nvl(i_Division_Ids, g_Dummy)))
          
       and Nvl2(i_Job_Ids, q.Job_Id, 1) in
           (select *
              from table(Nvl(i_Job_Ids, g_Dummy)));
  
    return Nvl(result, 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Average_Wage
  (
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Period       date := sysdate,
    i_Key_Person   varchar2 := null
  ) return varchar2 is
    r_Staff        Hpd_Transactions%rowtype;
    v_Trans_Id     number;
    v_Value        number;
    v_Count        number := 0;
    v_Indicator_Id number;
    result         number := 0;
  begin
    v_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
  
    for r in (select q.Staff_Id
                from Href_Staffs q
                left join Href_Person_Details w
                  on w.Company_Id = q.Company_Id
                 and w.Person_Id = q.Employee_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Dismissal_Date is not null
                 and q.Dismissal_Date between i_Begin_Date and i_End_Date
                 and q.State = 'A'
                 and Nvl2(i_Key_Person, Nvl(w.Key_Person, 'N'), 1) = Nvl(i_Key_Person, 1)
                 and Nvl2(i_Division_Ids, q.Division_Id, 1) in
                     (select *
                        from table(Nvl(i_Division_Ids, g_Dummy)))
                 and Nvl2(i_Job_Ids, q.Job_Id, 1) in
                     (select *
                        from table(Nvl(i_Job_Ids, g_Dummy))))
    loop
      v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Staff_Id   => r.Staff_Id,
                                                i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                                i_Period     => i_Period);
    
      r_Staff := z_Hpd_Transactions.Take(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Trans_Id   => v_Trans_Id);
    
      if r_Staff.Page_Id is not null then
        select Nvl(sum(q.Indicator_Value), 0)
          into v_Value
          from Hpd_Page_Indicators q
         where q.Company_Id = r_Staff.Company_Id
           and q.Filial_Id = r_Staff.Filial_Id
           and q.Page_Id = r_Staff.Page_Id
           and q.Indicator_Id = v_Indicator_Id;
      
        result  := result + v_Value;
        v_Count := v_Count + 1;
      end if;
    end loop;
  
    if result = 0 or v_Count = 0 then
      return 0;
    end if;
  
    result := result / v_Count;
  
    return t('$1 m', Uit_Href.Num_To_Char(Round(result / 1000000, 2)));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Division_Dismissals
  (
    i_Division_Ids Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Key_Person   varchar2 := null
  ) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(w.Name, r.Division_Id, r.Quantity)
      bulk collect
      into v_Matrix
      from Mhr_Divisions w
      join (select q.Division_Id, count(*) as Quantity
              from Href_Staffs q
              left join Href_Person_Details d
                on d.Company_Id = q.Company_Id
               and d.Person_Id = q.Employee_Id
             where q.Company_Id = Ui.Company_Id
               and q.Filial_Id = Ui.Filial_Id
               and q.Dismissal_Date is not null
               and q.Dismissal_Date between i_Begin_Date and i_End_Date
               and q.State = 'A'
               and Nvl2(i_Key_Person, Nvl(d.Key_Person, 'N'), 1) = Nvl(i_Key_Person, 1)
               and Nvl2(i_Division_Ids, q.Division_Id, 1) in
                   (select *
                      from table(Nvl(i_Division_Ids, g_Dummy)))
             group by q.Division_Id) r
        on r.Division_Id = w.Division_Id
     where w.Company_Id = Ui.Company_Id
       and w.Filial_Id = Ui.Filial_Id;
  
    Result.Put('division_dismissals', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Job_Dismissals
  (
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Key_Person   varchar2 := null
  ) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(w.Name, r.Job_Id, r.Quantity)
      bulk collect
      into v_Matrix
      from Mhr_Jobs w
      join (select q.Job_Id, count(*) as Quantity
              from Href_Staffs q
              left join Href_Person_Details d
                on d.Company_Id = q.Company_Id
               and d.Person_Id = q.Employee_Id
             where q.Company_Id = Ui.Company_Id
               and q.Filial_Id = Ui.Filial_Id
               and q.Dismissal_Date is not null
               and q.Dismissal_Date between i_Begin_Date and i_End_Date
               and q.State = 'A'
               and Nvl2(i_Key_Person, Nvl(d.Key_Person, 'N'), 1) = Nvl(i_Key_Person, 1)
               and Nvl2(i_Division_Ids, q.Division_Id, 1) in
                   (select *
                      from table(Nvl(i_Division_Ids, g_Dummy)))
               and Nvl2(i_Job_Ids, q.Job_Id, 1) in
                   (select *
                      from table(Nvl(i_Job_Ids, g_Dummy)))
             group by q.Job_Id) r
        on r.Job_Id = w.Job_Id
     where w.Company_Id = Ui.Company_Id
       and w.Filial_Id = Ui.Filial_Id;
  
    Result.Put('job_dismissals', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hiring_Sources
  (
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Key_Person   varchar2 := null
  ) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Source_Id, t.Name, count(r.Page_Id))
      bulk collect
      into v_Matrix
      from Href_Staffs q
      left join Href_Person_Details d
        on d.Company_Id = q.Company_Id
       and d.Person_Id = q.Employee_Id
      join Hpd_Journal_Pages w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Staff_Id = q.Staff_Id
      join Hpd_Hirings r
        on r.Company_Id = w.Company_Id
       and r.Filial_Id = w.Filial_Id
       and r.Page_Id = w.Page_Id
      join Href_Employment_Sources t
        on t.Company_Id = r.Company_Id
       and t.Source_Id = r.Employment_Source_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Dismissal_Date is not null
       and q.Dismissal_Date between i_Begin_Date and i_End_Date
       and q.State = 'A'
       and Nvl2(i_Key_Person, Nvl(d.Key_Person, 'N'), 1) = Nvl(i_Key_Person, 1)
       and Nvl2(i_Division_Ids, q.Division_Id, 1) in
           (select *
              from table(Nvl(i_Division_Ids, g_Dummy)))
       and Nvl2(i_Job_Ids, q.Job_Id, 1) in
           (select *
              from table(Nvl(i_Job_Ids, g_Dummy)))
     group by t.Source_Id, t.Name;
  
    Result.Put('hiring_sources', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissal_Info
  (
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Key_Person   varchar2 := null
  ) return Hashmap is
    v_Company_Id number := Ui.Company_Id;
    v_Matrix     Matrix_Varchar2;
    result       Hashmap := Hashmap();
  begin
    select Array_Varchar2((select Dr.Name
                            from Href_Dismissal_Reasons Dr
                           where Dr.Company_Id = v_Company_Id
                             and Dr.Dismissal_Reason_Id = r.Dismissal_Reason_Id),
                          (select Es.Name
                             from Href_Employment_Sources Es
                            where Es.Company_Id = v_Company_Id
                              and Es.Source_Id = r.Employment_Source_Id),
                          count(r.Page_Id))
      bulk collect
      into v_Matrix
      from Href_Staffs q
      left join Href_Person_Details d
        on d.Company_Id = q.Company_Id
       and d.Person_Id = q.Employee_Id
      join Hpd_Journal_Pages w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Staff_Id = q.Staff_Id
      join Hpd_Dismissals r
        on r.Company_Id = w.Company_Id
       and r.Filial_Id = w.Filial_Id
       and r.Page_Id = w.Page_Id
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Dismissal_Date is not null
       and q.Dismissal_Date between i_Begin_Date and i_End_Date
       and q.State = 'A'
       and Nvl2(i_Key_Person, Nvl(d.Key_Person, 'N'), 1) = Nvl(i_Key_Person, 1)
       and Nvl2(i_Division_Ids, q.Division_Id, 1) in
           (select *
              from table(Nvl(i_Division_Ids, g_Dummy)))
       and Nvl2(i_Job_Ids, q.Job_Id, 1) in
           (select *
              from table(Nvl(i_Job_Ids, g_Dummy)))
     group by r.Dismissal_Reason_Id, r.Employment_Source_Id;
  
    Result.Put('dismissal_info', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Key_Person
  (
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Key          varchar2
  ) return number is
    result number;
  begin
    select count(*)
      into result
      from Href_Staffs q
      left join Href_Person_Details w
        on w.Company_Id = q.Company_Id
       and w.Person_Id = q.Employee_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Dismissal_Date is not null
       and q.Dismissal_Date between i_Begin_Date and i_End_Date
       and q.State = 'A'
       and Nvl(w.Key_Person, 'N') = i_Key
       and Nvl2(i_Division_Ids, q.Division_Id, 1) in
           (select *
              from table(Nvl(i_Division_Ids, g_Dummy)))
       and Nvl2(i_Job_Ids, q.Job_Id, 1) in
           (select *
              from table(Nvl(i_Job_Ids, g_Dummy)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage_Info
  (
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Period       date := sysdate,
    i_Key_Person   varchar2 := null
  ) return Hashmap is
    r_Staff    Hpd_Transactions%rowtype;
    v_Average  number := 0;
    v_High     number := 0;
    v_Short    number := 0;
    v_Value    number;
    v_Trans_Id number;
    result     Hashmap := Hashmap();
  begin
  
    for Wage in (select q.Staff_Id, t.Wage_Begin, t.Wage_End
                   from Href_Staffs q
                   left join Href_Person_Details d
                     on d.Company_Id = q.Company_Id
                    and d.Person_Id = q.Employee_Id
                   join Href_Wages t
                     on t.Company_Id = q.Company_Id
                    and t.Filial_Id = q.Filial_Id
                    and t.Job_Id = q.Job_Id
                  where q.Company_Id = Ui.Company_Id
                    and q.Filial_Id = Ui.Filial_Id
                    and q.Dismissal_Date is not null
                    and q.Dismissal_Date between i_Begin_Date and i_End_Date
                    and q.State = 'A'
                    and Nvl2(i_Key_Person, Nvl(d.Key_Person, 'N'), 1) = Nvl(i_Key_Person, 1)
                    and Nvl2(i_Division_Ids, q.Division_Id, 1) in
                        (select *
                           from table(Nvl(i_Division_Ids, g_Dummy)))
                    and Nvl2(i_Job_Ids, q.Job_Id, 1) in
                        (select *
                           from table(Nvl(i_Job_Ids, g_Dummy))))
    loop
      v_Trans_Id := Hpd_Util.Trans_Id_By_Period(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Staff_Id   => Wage.Staff_Id,
                                                i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                                i_Period     => i_Period);
    
      r_Staff := z_Hpd_Transactions.Take(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Trans_Id   => v_Trans_Id);
    
      if r_Staff.Page_Id is not null then
        select q.Indicator_Value
          into v_Value
          from Hpd_Page_Indicators q
         where q.Company_Id = r_Staff.Company_Id
           and q.Filial_Id = r_Staff.Filial_Id
           and q.Page_Id = r_Staff.Page_Id;
      
        if (v_Value > Wage.Wage_End) then
          v_High := v_High + 1;
        elsif (v_Value < Wage.Wage_Begin) then
          v_Short := v_Short + 1;
        else
          v_Average := v_Average + 1;
        end if;
      
      end if;
    end loop;
  
    Result.Put('wage_average', v_Average);
    Result.Put('wage_high', v_High);
    Result.Put('wage_short', v_Short);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Experience_Info
  (
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date := Trunc(sysdate, 'year'),
    i_End_Date     date := Trunc(Add_Months(sysdate, 12), 'year') - 1,
    i_Key_Person   varchar2 := null
  ) return Hashmap is
    v_Year  number;
    v_Exp_1 number := 0;
    v_Exp_2 number := 0;
    v_Exp_3 number := 0;
    v_Exp_4 number := 0;
    v_Exp_5 number := 0;
    v_Exp_6 number := 0;
    result  Hashmap := Hashmap();
  begin
    for r in (select q.Hiring_Date, q.Dismissal_Date
                from Href_Staffs q
                left join Href_Person_Details d
                  on d.Company_Id = q.Company_Id
                 and d.Person_Id = q.Employee_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Dismissal_Date is not null
                 and q.Dismissal_Date between i_Begin_Date and i_End_Date
                 and q.State = 'A'
                 and Nvl2(i_Key_Person, Nvl(d.Key_Person, 'N'), 1) = Nvl(i_Key_Person, 1)
                 and Nvl2(i_Division_Ids, q.Division_Id, 1) in
                     (select *
                        from table(Nvl(i_Division_Ids, g_Dummy)))
                 and Nvl2(i_Job_Ids, q.Job_Id, 1) in
                     (select *
                        from table(Nvl(i_Job_Ids, g_Dummy))))
    loop
      v_Year := Round((r.Dismissal_Date - r.Hiring_Date) / 365, 1);
    
      if (v_Year < 1) then
        v_Exp_1 := v_Exp_1 + 1;
      elsif (v_Year > 1 and v_Year < 2) then
        v_Exp_2 := v_Exp_2 + 1;
      elsif (v_Year > 2 and v_Year < 3) then
        v_Exp_3 := v_Exp_3 + 1;
      elsif (v_Year > 3 and v_Year < 4) then
        v_Exp_4 := v_Exp_4 + 1;
      elsif (v_Year > 4 and v_Year < 5) then
        v_Exp_5 := v_Exp_5 + 1;
      elsif (v_Year > 5) then
        v_Exp_6 := v_Exp_6 + 1;
      end if;
    end loop;
  
    Result.Put('exp_1', v_Exp_1);
    Result.Put('exp_2', v_Exp_2);
    Result.Put('exp_3', v_Exp_3);
    Result.Put('exp_4', v_Exp_4);
    Result.Put('exp_5', v_Exp_5);
    Result.Put('exp_6', v_Exp_6);
  
    return result;
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
                                 'A'),
                    true);
  
    q.Number_Field('job_id', 'job_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('dismissals', Dismissal_Quantity);
    Result.Put('experience', Work_Experience);
    Result.Put('average_age', Average_Age);
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
    Result.Put_All(Division_Dismissals);
    Result.Put_All(Job_Dismissals);
    Result.Put_All(Hiring_Sources);
    Result.Put_All(Dismissal_Info);
    Result.Put('average_wage', Average_Wage);
    Result.Put('key_persons', Key_Person(i_Key => 'Y'));
    Result.Put('not_key_persons', Key_Person(i_Key => 'N'));
    Result.Put_All(Wage_Info);
    Result.Put_All(Experience_Info);
    Result.Put('date', to_char(sysdate, Href_Pref.c_Date_Format_Year));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Reload(p Hashmap) return Hashmap is
    v_Division_Ids Array_Number := p.o_Array_Number('division_ids');
    v_Job_Ids      Array_Number := p.o_Array_Number('job_ids');
    v_Year         varchar2(10) := p.o_Number('year');
    v_Period_Type  varchar2(1) := p.r_Varchar2('period_type');
    v_Begin_Date   date := p.r_Date('date', Href_Pref.c_Date_Format_Month);
    v_End_Date     date;
    v_Key_Person   varchar2(1) := p.o_Varchar2('key_person');
    result         Hashmap := Hashmap();
  begin
    if (v_Division_Ids.Count = 0) then
      v_Division_Ids := null;
    end if;
    if (v_Job_Ids.Count = 0) then
      v_Job_Ids := null;
    end if;
    if (v_Key_Person = 'A') then
      v_Key_Person := null;
    end if;
  
    Result.Put('date', v_Begin_Date);
    Result.Put('period_type', v_Period_Type);
  
    case v_Period_Type
      when 'Y' then
        v_End_Date := Add_Months(v_Begin_Date, 12) - 1;
      when 'Q' then
        v_End_Date := Add_Months(v_Begin_Date, 3) - 1;
      when 'M' then
        v_End_Date := Add_Months(v_Begin_Date, 1) - 1;
    end case;
  
    Result.Put('dismissals',
               Dismissal_Quantity(i_Division_Ids => v_Division_Ids,
                                  i_Job_Ids      => v_Job_Ids,
                                  i_Begin_Date   => v_Begin_Date,
                                  i_End_Date     => v_End_Date,
                                  i_Key_Person   => v_Key_Person));
    Result.Put('experience',
               Work_Experience(i_Division_Ids => v_Division_Ids,
                               i_Job_Ids      => v_Job_Ids,
                               i_Begin_Date   => v_Begin_Date,
                               i_End_Date     => v_End_Date,
                               i_Key_Person   => v_Key_Person));
    Result.Put('average_age',
               Average_Age(i_Division_Ids => v_Division_Ids,
                           i_Job_Ids      => v_Job_Ids,
                           i_Begin_Date   => v_Begin_Date,
                           i_End_Date     => v_End_Date,
                           i_Key_Person   => v_Key_Person));
    Result.Put('average_wage',
               Average_Wage(i_Division_Ids => v_Division_Ids,
                            i_Job_Ids      => v_Job_Ids,
                            i_Begin_Date   => v_Begin_Date,
                            i_End_Date     => v_End_Date,
                            i_Period       => to_date(v_Year, Href_Pref.c_Date_Format_Year),
                            i_Key_Person   => v_Key_Person));
    Result.Put_All(Division_Dismissals(i_Division_Ids => v_Division_Ids,
                                       i_Begin_Date   => v_Begin_Date,
                                       i_End_Date     => v_End_Date,
                                       i_Key_Person   => v_Key_Person));
    Result.Put_All(Job_Dismissals(i_Division_Ids => v_Division_Ids,
                                  i_Job_Ids      => v_Job_Ids,
                                  i_Begin_Date   => v_Begin_Date,
                                  i_End_Date     => v_End_Date,
                                  i_Key_Person   => v_Key_Person));
    Result.Put_All(Hiring_Sources(i_Division_Ids => v_Division_Ids,
                                  i_Job_Ids      => v_Job_Ids,
                                  i_Begin_Date   => v_Begin_Date,
                                  i_End_Date     => v_End_Date,
                                  i_Key_Person   => v_Key_Person));
    Result.Put_All(Dismissal_Info(i_Division_Ids => v_Division_Ids,
                                  i_Job_Ids      => v_Job_Ids,
                                  i_Begin_Date   => v_Begin_Date,
                                  i_End_Date     => v_End_Date,
                                  i_Key_Person   => v_Key_Person));
    Result.Put_All(Wage_Info(i_Division_Ids => v_Division_Ids,
                             i_Job_Ids      => v_Job_Ids,
                             i_Begin_Date   => v_Begin_Date,
                             i_End_Date     => v_End_Date,
                             i_Period       => to_date(v_Year, Href_Pref.c_Date_Format_Year),
                             i_Key_Person   => v_Key_Person));
    Result.Put_All(Experience_Info(i_Division_Ids => v_Division_Ids,
                                   i_Job_Ids      => v_Job_Ids,
                                   i_Begin_Date   => v_Begin_Date,
                                   i_End_Date     => v_End_Date,
                                   i_Key_Person   => v_Key_Person));
    if (v_Key_Person is null) then
      Result.Put('key_persons',
                 Key_Person(i_Division_Ids => v_Division_Ids,
                            i_Job_Ids      => v_Job_Ids,
                            i_Begin_Date   => v_Begin_Date,
                            i_End_Date     => v_End_Date,
                            i_Key          => 'Y'));
      Result.Put('not_key_persons',
                 Key_Person(i_Division_Ids => v_Division_Ids,
                            i_Job_Ids      => v_Job_Ids,
                            i_Begin_Date   => v_Begin_Date,
                            i_End_Date     => v_End_Date,
                            i_Key          => 'N'));
    elsif (v_Key_Person = 'Y') then
      Result.Put('key_persons',
                 Key_Person(i_Division_Ids => v_Division_Ids,
                            i_Job_Ids      => v_Job_Ids,
                            i_Begin_Date   => v_Begin_Date,
                            i_End_Date     => v_End_Date,
                            i_Key          => v_Key_Person));
      Result.Put('not_key_persons', 0);
    
    else
      Result.Put('not_key_persons',
                 Key_Person(i_Division_Ids => v_Division_Ids,
                            i_Job_Ids      => v_Job_Ids,
                            i_Begin_Date   => v_Begin_Date,
                            i_End_Date     => v_End_Date,
                            i_Key          => v_Key_Person));
      Result.Put('key_persons', 0);
    
    end if;
  
    return result;
  end;

end Ui_Vhr139;
/
