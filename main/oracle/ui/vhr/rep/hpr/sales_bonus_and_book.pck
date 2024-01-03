create or replace package Ui_Vhr499 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr499;
/
create or replace package body Ui_Vhr499 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr499:settings';

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
    return b.Translate('UI-VHR499:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Month  date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select *
                  from href_staffs w
                 where w.company_id = :company_id 
                   and w.filial_id = :filial_id
                   and w.hiring_date <= :max_date
                   and (w.dismissal_date is null or
                       w.dismissal_date >= :min_date)
                   and w.state = ''A''
                   and exists (select 1
                          from mhr_employees e
                         where e.company_id = :company_id
                           and e.filial_id = w.filial_id
                           and e.employee_id = w.employee_id
                           and e.state = ''A'')';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'min_date',
                                 v_Month,
                                 'max_date',
                                 Last_Day(v_Month)));
  
    q.Number_Field('staff_id', 'employee_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
  
    v_Matrix := Href_Util.Staff_Kinds;
  
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Oper_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mpr_oper_types q
                      where q.company_id = :company_id
                        and q.state = ''A''
                        and exists (select *
                               from hpr_oper_types w
                              where w.company_id = :company_id
                                and w.oper_type_id = q.oper_type_id)',
                    Fazo.Zip_Map('company_id', Ui.Company_Id));
  
    q.Number_Field('oper_type_id');
    q.Varchar2_Field('name', 'operation_kind');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap) is
  begin
    Ui.User_Setting_Save(i_Setting_Code => g_Setting_Code, i_Setting_Value => p.Json());
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Preferences return Hashmap is
  begin
    return Fazo.Parse_Map(Ui.User_Setting_Load(i_Setting_Code  => g_Setting_Code,
                                               i_Default_Value => '{}'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('month', to_char(Trunc(sysdate), Href_Pref.c_Date_Format_Month));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('settings', Load_Preferences);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_User_Id              number := Ui.User_Id;
    v_Colspan              number := 2;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Settings             Hashmap := Load_Preferences;
  
    v_Division_Ids      Array_Number := p.o_Array_Number('division_ids');
    v_Job_Ids           Array_Number := p.o_Array_Number('job_ids');
    v_Desired_Staff_Ids Array_Number := p.o_Array_Number('staff_ids');
    v_Begin_Date        date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_End_Date          date := Last_Day(v_Begin_Date);
  
    v_Accrual_Ids          Array_Number := Nvl(v_Settings.o_Array_Number('accrual_ids'),
                                               Array_Number());
    v_Deduction_Ids        Array_Number := Nvl(v_Settings.o_Array_Number('deduction_ids'),
                                               Array_Number());
    v_Show_Division        boolean := Nvl(v_Settings.o_Varchar2('division'), 'N') = 'Y';
    v_Show_Job             boolean := Nvl(v_Settings.o_Varchar2('job'), 'N') = 'Y';
    v_Show_Rank            boolean := Nvl(v_Settings.o_Varchar2('rank'), 'N') = 'Y';
    v_Show_Staff_Number    boolean := Nvl(v_Settings.o_Varchar2('staff_number'), 'N') = 'Y';
    v_Show_Plan_Days       boolean := Nvl(v_Settings.o_Varchar2('plan_days'), 'N') = 'Y';
    v_Show_Plan_Hours      boolean := Nvl(v_Settings.o_Varchar2('plan_hours'), 'N') = 'Y';
    v_Show_Fact_Days       boolean := Nvl(v_Settings.o_Varchar2('fact_days'), 'N') = 'Y';
    v_Show_Fact_Hours      boolean := Nvl(v_Settings.o_Varchar2('fact_hours'), 'N') = 'Y';
    v_Show_Income_Tax      boolean := Nvl(v_Settings.o_Varchar2('income_tax'), 'N') = 'Y';
    v_Show_Pension_Payment boolean := Nvl(v_Settings.o_Varchar2('pension_payment'), 'N') = 'Y';
    v_Show_Social_Payment  boolean := Nvl(v_Settings.o_Varchar2('social_payment'), 'N') = 'Y';
  
    v_Subordinate_Chiefs    Array_Number := Array_Number();
    v_Subordinate_Divisions Array_Number := Array_Number();
  
    v_Oper_Type_Ids   Array_Number := v_Accrual_Ids multiset union v_Deduction_Ids;
    v_Oper_Type_Names Fazo.Varchar2_Id_Aat;
  
    a              b_Table;
    v_Column       number := 1;
    v_Calc         Calc := Calc();
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number := null
    ) is
    begin
      a.Data(i_Val => i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
    
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(v_Column, i_Column_Width);
      
        v_Column := v_Column + 1;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Put
    (
      i_Val        number,
      i_Style_Name varchar2 := null,
      i_Colspan    number := null,
      i_Rowspan    number := null
    ) is
    begin
      a.Data(i_Val        => Nullif(i_Val, 0),
             i_Style_Name => i_Style_Name,
             i_Colspan    => i_Colspan,
             i_Rowspan    => i_Rowspan);
    end;
  
    --------------------------------------------------
    Procedure Put_Amount
    (
      i_Val        number,
      i_Style_Name varchar2 := null,
      i_Colspan    number := null,
      i_Rowspan    number := null
    ) is
    begin
      a.Data(i_Val        => Uit_Href.Num_To_Char(Nvl(i_Val, 0)),
             i_Style_Name => i_Style_Name,
             i_Colspan    => i_Colspan,
             i_Rowspan    => i_Rowspan);
    end;
  
    --------------------------------------------------
    Procedure Init_Report is
    begin
      b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                     i_File_Name   => Ui.Current_Form_Name);
    
      a := b_Report.New_Table();
    
      -- body centralized
      b_Report.New_Style(i_Style_Name        => 'body_centralized',
                         i_Parent_Style_Name => 'body',
                         i_Horizontal_Align  => b_Report.a_Center,
                         i_Vertical_Align    => b_Report.a_Middle);
    end;
  
    --------------------------------------------------
    Procedure Print_Info is
      v_Names Array_Varchar2;
    begin
      a.New_Row();
      a.Data(t('sales bonus and book for $1{month_year}',
               to_char(v_Begin_Date, 'fmMonth yyyy', v_Nls_Language)),
             i_Colspan => 5);
    
      if v_Division_Ids is not null then
        a.New_Row;
      
        select d.Name
          bulk collect
          into v_Names
          from Mhr_Divisions d
         where d.Company_Id = v_Company_Id
           and d.Filial_Id = v_Filial_Id
           and d.Division_Id member of v_Division_Ids
         order by d.Name;
      
        a.Data(t('divisions: $1{division_names}',
                 Fazo.Gather(Nvl(v_Names, Array_Varchar2()), ', ')),
               i_Colspan => 5);
      end if;
    
      if v_Job_Ids is not null then
        a.New_Row;
      
        select d.Name
          bulk collect
          into v_Names
          from Mhr_Jobs d
         where d.Company_Id = v_Company_Id
           and d.Filial_Id = v_Filial_Id
           and d.Job_Id member of v_Job_Ids
         order by d.Name;
      
        a.Data(t('job: $1{job_names}', Fazo.Gather(v_Names, ', ')), i_Colspan => 5);
      end if;
    
      a.New_Row();
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
      v_Length number;
    begin
      a.Current_Style('header');
      a.New_Row();
      a.New_Row();
    
      Print_Header(t('order no'), 1, 2, 50);
      Print_Header(t('staff name'), 1, 2, 200);
    
      if v_Show_Division then
        Print_Header(t('division name'), 1, 2, 150);
      
        v_Colspan := v_Colspan + 1;
      end if;
    
      if v_Show_Job then
        Print_Header(t('job name'), 1, 2, 150);
      
        v_Colspan := v_Colspan + 1;
      end if;
    
      if v_Show_Rank then
        Print_Header(t('rank name'), 1, 2, 150);
      
        v_Colspan := v_Colspan + 1;
      end if;
    
      if v_Show_Staff_Number then
        Print_Header(t('staff number'), 1, 2, 100);
      
        v_Colspan := v_Colspan + 1;
      end if;
    
      -- plan
      v_Length := 0;
    
      if v_Show_Plan_Days then
        v_Length := v_Length + 1;
      end if;
    
      if v_Show_Plan_Hours then
        v_Length := v_Length + 1;
      end if;
    
      if v_Length > 0 then
        Print_Header(t('plan'), v_Length, 1, 100);
      end if;
    
      -- fact
      v_Length := 0;
    
      if v_Show_Fact_Days then
        v_Length := v_Length + 1;
      end if;
    
      if v_Show_Fact_Hours then
        v_Length := v_Length + 1;
      end if;
    
      if v_Length > 0 then
        Print_Header(t('fact'), v_Length, 1, 100);
      end if;
    
      -- oper types
      if v_Accrual_Ids.Count > 0 then
        Print_Header(t('accrual'), v_Accrual_Ids.Count, 1, 100);
      end if;
    
      if v_Deduction_Ids.Count > 0 then
        Print_Header(t('deduction'), v_Deduction_Ids.Count, 1, 100);
      end if;
    
      Print_Header(t('sales bonus'), 2, 1, 100);
    
      -- tax
      v_Length := 0;
    
      if v_Show_Income_Tax then
        v_Length := v_Length + 1;
      end if;
    
      if v_Show_Pension_Payment then
        v_Length := v_Length + 1;
      end if;
    
      if v_Show_Social_Payment then
        v_Length := v_Length + 1;
      end if;
    
      if v_Length > 0 then
        Print_Header(t('tax'), v_Length, 1, 100);
      end if;
    
      Print_Header(t('total'), 1, 2, 100);
    
      -- sub cells
      a.New_Row(50);
    
      -- plan
      if v_Show_Plan_Days then
        Print_Header(t('plan days'), 1, 1);
      end if;
    
      if v_Show_Plan_Hours then
        Print_Header(t('plan hours'), 1, 1);
      end if;
    
      -- fact
      if v_Show_Fact_Days then
        Print_Header(t('fact days'), 1, 1);
      end if;
    
      if v_Show_Fact_Hours then
        Print_Header(t('fact hours'), 1, 1);
      end if;
    
      -- oper types
      if v_Oper_Type_Ids.Count > 0 then
        for r in (select Op.Oper_Type_Id, Op.Name
                    from Mpr_Oper_Types Op
                   where Op.Company_Id = v_Company_Id
                     and Op.Oper_Type_Id in (select *
                                               from table(v_Oper_Type_Ids)))
        loop
          v_Oper_Type_Names(r.Oper_Type_Id) := r.Name;
        end loop;
      end if;
    
      for i in 1 .. v_Accrual_Ids.Count
      loop
        Print_Header(v_Oper_Type_Names(v_Accrual_Ids(i)), 1, 1);
      end loop;
    
      for i in 1 .. v_Deduction_Ids.Count
      loop
        Print_Header(v_Oper_Type_Names(v_Deduction_Ids(i)), 1, 1);
      end loop;
    
      -- sales bonus
      Print_Header(t('personal sales bonus'), 1, 1);
      Print_Header(t('department sales bonus'), 1, 1);
    
      -- tax
      if v_Show_Income_Tax then
        Print_Header(t('income_tax'), 1, 1);
      end if;
    
      if v_Show_Pension_Payment then
        Print_Header(t('pension_payment'), 1, 1);
      end if;
    
      if v_Show_Social_Payment then
        Print_Header(t('social_payment'), 1, 1);
      end if;
    end;
  
    --------------------------------------------------
    Procedure Print_Body is
      v_Rownum number := 0;
      v_Amount number;
    begin
      a.Current_Style('body_centralized');
    
      if v_Access_All_Employees = 'N' then
        v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                      i_Direct             => true,
                                                                      i_Indirect           => true,
                                                                      i_Manual             => true,
                                                                      i_Gather_Chiefs      => false);
      end if;
    
      for r in (select q.Staff_Id,
                       q.Employee_Id,
                       (select Mp.Name
                          from Md_Persons Mp
                         where Mp.Company_Id = q.Company_Id
                           and Mp.Person_Id = q.Employee_Id) as name,
                       q.Staff_Number,
                       (select d.Name
                          from Mhr_Divisions d
                         where d.Company_Id = v_Company_Id
                           and d.Filial_Id = v_Filial_Id
                           and d.Division_Id = q.Division_Id) as Division_Name,
                       (select d.Name
                          from Mhr_Jobs d
                         where d.Company_Id = v_Company_Id
                           and d.Filial_Id = v_Filial_Id
                           and d.Job_Id = q.Job_Id) as Job_Name,
                       (select d.Name
                          from Mhr_Ranks d
                         where d.Company_Id = v_Company_Id
                           and d.Filial_Id = v_Filial_Id
                           and d.Rank_Id = q.Rank_Id) as Rank_Name
                  from Href_Staffs q
                 where q.Company_Id = v_Company_Id
                   and q.Filial_Id = v_Filial_Id
                   and q.Hiring_Date <= v_End_Date
                   and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Begin_Date)
                   and State = 'A'
                   and (v_Desired_Staff_Ids is null or
                       q.Staff_Id in (select *
                                         from table(v_Desired_Staff_Ids)))
                   and (v_Division_Ids is null or
                       q.Division_Id in (select *
                                            from table(v_Division_Ids)))
                   and (v_Job_Ids is null or
                       q.Job_Id in (select *
                                       from table(v_Job_Ids)))
                   and (v_Access_All_Employees = 'Y' or q.Employee_Id = v_User_Id or --
                       q.Org_Unit_Id member of v_Subordinate_Divisions)
                 order by name)
      loop
        v_Calc.Set_Value('income_tax', 0);
        v_Calc.Set_Value('pension_payment', 0);
        v_Calc.Set_Value('social_payment', 0);
        v_Calc.Set_Value('total', 0);
      
        for i in 1 .. v_Oper_Type_Ids.Count
        loop
          v_Calc.Set_Value('oper_type', v_Oper_Type_Ids(i), 0);
        end loop;
      
        v_Rownum := v_Rownum + 1;
      
        a.New_Row();
        a.Data(v_Rownum);
        a.Data(r.Name);
      
        if v_Show_Division then
          a.Data(r.Division_Name);
        end if;
      
        if v_Show_Job then
          a.Data(r.Job_Name);
        end if;
      
        if v_Show_Rank then
          a.Data(r.Rank_Name);
        end if;
      
        if v_Show_Staff_Number then
          a.Data(r.Staff_Number);
        end if;
      
        if v_Show_Plan_Days then
          v_Amount := Htt_Util.Calc_Working_Days(i_Company_Id => v_Company_Id,
                                                 i_Filial_Id  => v_Filial_Id,
                                                 i_Staff_Id   => r.Staff_Id,
                                                 i_Begin_Date => v_Begin_Date,
                                                 i_End_Date   => v_End_Date);
        
          Put(v_Amount);
          v_Calc.Plus('total', 'plan_days', v_Amount);
        end if;
      
        if v_Show_Plan_Hours then
          v_Amount := Round(Htt_Util.Calc_Working_Seconds(i_Company_Id => v_Company_Id,
                                                          i_Filial_Id  => v_Filial_Id,
                                                          i_Staff_Id   => r.Staff_Id,
                                                          i_Begin_Date => v_Begin_Date,
                                                          i_End_Date   => v_End_Date) / 3600,
                            2);
        
          Put(v_Amount);
          v_Calc.Plus('total', 'plan_hours', v_Amount);
        end if;
      
        if v_Show_Fact_Days then
          v_Amount := Hpr_Util.Calc_Fact_Days_Indicator(i_Company_Id => v_Company_Id,
                                                        i_Filial_Id  => v_Filial_Id,
                                                        i_Staff_Id   => r.Staff_Id,
                                                        i_Charge_Id  => null,
                                                        i_Begin_Date => v_Begin_Date,
                                                        i_End_Date   => v_End_Date);
        
          Put(v_Amount);
          v_Calc.Plus('total', 'fact_days', v_Amount);
        end if;
      
        if v_Show_Fact_Hours then
          v_Amount := Hpr_Util.Calc_Fact_Hours_Indicator(i_Company_Id => v_Company_Id,
                                                         i_Filial_Id  => v_Filial_Id,
                                                         i_Staff_Id   => r.Staff_Id,
                                                         i_Charge_Id  => null,
                                                         i_Begin_Date => v_Begin_Date,
                                                         i_End_Date   => v_End_Date);
        
          Put(v_Amount);
          v_Calc.Plus('total', 'fact_hours', v_Amount);
        end if;
      
        -- oper types
        for Ot in (select q.Oper_Type_Id,
                          q.Amount,
                          q.Income_Tax_Amount,
                          q.Pension_Payment_Amount,
                          q.Social_Payment_Amount
                     from Mpr_Book_Operations q
                    where q.Company_Id = v_Company_Id
                      and q.Filial_Id = v_Filial_Id
                      and q.Employee_Id = r.Employee_Id
                      and q.Oper_Type_Id in (select *
                                               from table(v_Oper_Type_Ids))
                      and exists (select *
                             from Mpr_Books Mb
                            where Mb.Company_Id = v_Company_Id
                              and Mb.Filial_Id = v_Filial_Id
                              and Mb.Book_Id = q.Book_Id
                              and Mb.Month = v_Begin_Date
                              and Mb.Posted = 'Y')
                      and exists (select *
                             from Hpr_Book_Operations Ho
                            where Ho.Company_Id = v_Company_Id
                              and Ho.Filial_Id = v_Filial_Id
                              and Ho.Book_Id = q.Book_Id
                              and Ho.Operation_Id = q.Operation_Id
                              and Ho.Staff_Id = r.Staff_Id))
        loop
          v_Calc.Set_Value('oper_type', Ot.Oper_Type_Id, Ot.Amount);
          v_Calc.Plus('income_tax', Ot.Income_Tax_Amount);
          v_Calc.Plus('pension_payment', Ot.Pension_Payment_Amount);
          v_Calc.Plus('social_payment', Ot.Social_Payment_Amount);
          v_Calc.Plus('total', 'oper_type', Ot.Oper_Type_Id, Ot.Amount);
          v_Calc.Plus('total', 'income_tax', Ot.Income_Tax_Amount);
          v_Calc.Plus('total', 'pension_payment', Ot.Pension_Payment_Amount);
          v_Calc.Plus('total', 'social_payment', Ot.Social_Payment_Amount);
        end loop;
      
        for i in 1 .. v_Accrual_Ids.Count
        loop
          v_Amount := v_Calc.Get_Value('oper_type', v_Accrual_Ids(i));
        
          Put_Amount(v_Amount);
          v_Calc.Plus('total', v_Amount);
        end loop;
      
        for i in 1 .. v_Deduction_Ids.Count
        loop
          v_Amount := v_Calc.Get_Value('oper_type', v_Deduction_Ids(i));
        
          Put_Amount(v_Amount);
          v_Calc.Plus('total', -v_Amount);
        end loop;
      
        -- sales payment
        select sum(q.Amount)
          into v_Amount
          from Hpr_Sales_Bonus_Payment_Operation_Periods q
         where q.Company_Id = v_Company_Id
           and q.Filial_Id = v_Filial_Id
           and q.c_Staff_Id = r.Staff_Id
           and q.c_Bonus_Type = Hrm_Pref.c_Bonus_Type_Personal_Sales
           and q.Period between v_Begin_Date and v_End_Date
           and exists (select *
                  from Hpr_Sales_Bonus_Payment_Operations Po
                 where Po.Company_Id = v_Company_Id
                   and Po.Filial_Id = v_Filial_Id
                   and Po.Operation_Id = q.Operation_Id
                   and exists (select *
                          from Hpr_Sales_Bonus_Payments Bp
                         where Bp.Company_Id = v_Company_Id
                           and Bp.Filial_Id = v_Filial_Id
                           and Bp.Payment_Id = Po.Payment_Id
                           and Bp.Posted = 'Y'));
      
        Put_Amount(v_Amount);
        v_Calc.Plus('total', 'personal_sales_bonus', v_Amount);
        v_Calc.Plus('total', v_Amount);
      
        select sum(q.Amount)
          into v_Amount
          from Hpr_Sales_Bonus_Payment_Operation_Periods q
         where q.Company_Id = v_Company_Id
           and q.Filial_Id = v_Filial_Id
           and q.c_Staff_Id = r.Staff_Id
           and q.c_Bonus_Type = Hrm_Pref.c_Bonus_Type_Department_Sales
           and q.Period between v_Begin_Date and v_End_Date
           and exists (select *
                  from Hpr_Sales_Bonus_Payment_Operations Po
                 where Po.Company_Id = v_Company_Id
                   and Po.Filial_Id = v_Filial_Id
                   and Po.Operation_Id = q.Operation_Id
                   and exists (select *
                          from Hpr_Sales_Bonus_Payments Bp
                         where Bp.Company_Id = v_Company_Id
                           and Bp.Filial_Id = v_Filial_Id
                           and Bp.Payment_Id = Po.Payment_Id
                           and Bp.Posted = 'Y'));
      
        Put_Amount(v_Amount);
      
        v_Calc.Plus('total', 'department_sales_bonus', v_Amount);
        v_Calc.Plus('total', v_Amount);
      
        -- tax
        if v_Show_Income_Tax then
          v_Amount := v_Calc.Get_Value('income_tax');
        
          Put_Amount(v_Amount);
          v_Calc.Plus('total', -v_Amount);
        end if;
      
        if v_Show_Pension_Payment then
          v_Amount := v_Calc.Get_Value('pension_payment');
        
          Put_Amount(v_Amount);
          v_Calc.Plus('total', -v_Amount);
        end if;
      
        if v_Show_Social_Payment then
          v_Amount := v_Calc.Get_Value('social_payment');
        
          Put_Amount(v_Amount);
          v_Calc.Plus('total', -v_Amount);
        end if;
      
        -- total
        v_Amount := v_Calc.Get_Value('total');
      
        Put_Amount(v_Amount);
        v_Calc.Plus('total', 'total', v_Amount);
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Footer is
    begin
      a.Current_Style('footer');
    
      a.New_Row();
      a.Data(t('total:'), i_Style_Name => 'footer right', i_Colspan => v_Colspan);
    
      if v_Show_Plan_Days then
        Put(v_Calc.Get_Value('total', 'plan_days'));
      end if;
    
      if v_Show_Plan_Hours then
        Put(v_Calc.Get_Value('total', 'plan_hours'));
      end if;
    
      if v_Show_Fact_Days then
        Put(v_Calc.Get_Value('total', 'fact_days'));
      end if;
    
      if v_Show_Fact_Hours then
        Put(v_Calc.Get_Value('total', 'fact_hours'));
      end if;
    
      for i in 1 .. v_Accrual_Ids.Count
      loop
        Put_Amount(v_Calc.Get_Value('total', 'oper_type', v_Accrual_Ids(i)));
      end loop;
    
      for i in 1 .. v_Deduction_Ids.Count
      loop
        Put_Amount(v_Calc.Get_Value('total', 'oper_type', v_Deduction_Ids(i)));
      end loop;
    
      Put_Amount(v_Calc.Get_Value('total', 'personal_sales_bonus'));
      Put_Amount(v_Calc.Get_Value('total', 'department_sales_bonus'));
    
      if v_Show_Income_Tax then
        Put_Amount(v_Calc.Get_Value('total', 'income_tax'));
      end if;
    
      if v_Show_Pension_Payment then
        Put_Amount(v_Calc.Get_Value('total', 'pension_payment'));
      end if;
    
      if v_Show_Social_Payment then
        Put_Amount(v_Calc.Get_Value('total', 'social_payment'));
      end if;
    
      Put_Amount(v_Calc.Get_Value('total', 'total'));
    end;
  
    --------------------------------------------------
    Procedure Close_Report is
    begin
      b_Report.Add_Sheet(i_Name => t('sales bonus and book'), p_Table => a);
      b_Report.Close_Book();
    end;
  begin
    if Fazo.Is_Empty(v_Division_Ids) then
      v_Division_Ids := null;
    end if;
  
    if Fazo.Is_Empty(v_Job_Ids) then
      v_Job_Ids := null;
    end if;
  
    if Fazo.Is_Empty(v_Desired_Staff_Ids) then
      v_Desired_Staff_Ids := null;
    end if;
  
    Init_Report;
    Print_Info;
    Print_Header;
    Print_Body;
    Print_Footer;
    Close_Report;
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
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Staff_Kind     = null,
           Employee_Id    = null,
           Org_Unit_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           State       = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           name           = null,
           State          = null;
    update Hpr_Oper_Types
       set Company_Id   = null,
           Oper_Type_Id = null;
  end;

end Ui_Vhr499;
/
