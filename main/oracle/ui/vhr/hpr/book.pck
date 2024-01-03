create or replace package Ui_Vhr64 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Oper_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Currencies return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Subfilials return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Staff_Info(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Indicators(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Load_Operations(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Subfilials(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Load_Daily_Details(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Calc_Amount(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------       
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
end Ui_Vhr64;
/
create or replace package body Ui_Vhr64 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Month                date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_Matrix               Matrix_Varchar2;
    q                      Fazo_Query;
    v_Query                varchar2(32767);
    v_Params               Hashmap;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
  begin
    v_Query := 'select st.*
                  from (select q.*,
                               case
                                  when :access_all_employees = ''Y'' and :division_id is null then
                                   null
                                  else
                                   hpd_util.get_closest_org_unit_id(q.company_id, q.filial_id, q.staff_id, :end_date)
                                end cur_division_id
                          from href_staffs q
                         where q.company_id = :company_id
                           and q.filial_id = :filial_id
                           and q.state = ''A''
                           and q.hiring_date <= :end_date
                           and nvl(q.dismissal_date, :begin_date) >= :begin_date
                           and uit_hrm.access_to_hidden_salary_job(i_job_id      => hpd_util.get_closest_job_id(q.company_id,
                                                                                                                q.filial_id,
                                                                                                                q.staff_id,
                                                                                                                :end_date),
                                                                   i_employee_id => q.employee_id) = ''Y'') st
                 where (:division_id is null or :division_id = st.cur_division_id)';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'division_id',
                             p.o_Number('division_id'),
                             'begin_date',
                             v_Month,
                             'end_date',
                             Last_Day(v_Month),
                             'access_all_employees',
                             v_Access_All_Employees);
  
    if v_Access_All_Employees = 'N' then
      v_Query := v_Query || ' and (st.employee_id = :user_id or
                        st.cur_division_id member of :division_ids)';
    
      v_Params.Put('division_ids', Uit_Href.Get_All_Subordinate_Divisions);
      v_Params.Put('user_id', Ui.User_Id);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id', 'employee_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
  
    q.Map_Field('name',
                'select r.name
                   from mr_natural_persons r
                  where r.company_id = :company_id
                    and r.person_id = $employee_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Oper_Types(p Hashmap) return Fazo_Query is
    v_Ids   Array_Number;
    v_Param Hashmap;
    q       Fazo_Query;
  begin
    v_Param := Fazo.Zip_Map('company_id',
                            Ui.Company_Id,
                            'operation_kind',
                            p.r_Varchar2('operation_kind'));
  
    if p.r_Varchar2('operation_kind') = Mpr_Pref.c_Ok_Accrual then
      v_Ids := Nvl(p.o_Array_Number('oper_group_ids'), Array_Number());
    
      v_Param.Put('oper_group_ids', v_Ids);
      v_Param.Put('og_cnt', v_Ids.Count);
    else
      v_Param.Put('oper_group_ids', Array_Number());
      v_Param.Put('og_cnt', 0);
    end if;
  
    q := Fazo_Query('select q.*,
                            w.oper_group_id
                       from mpr_oper_types q
                       left join hpr_oper_types w
                         on w.company_id = q.company_id
                        and w.oper_type_id = q.oper_type_id
                      where q.company_id = :company_id
                        and q.operation_kind = :operation_kind
                        and (:og_cnt = 0 or
                             w.oper_group_id in (select *
                                                   from table(:oper_group_ids)))
                        and q.state = ''A''',
                    v_Param);
  
    q.Number_Field('oper_type_id');
    q.Varchar2_Field('name', 'operation_kind');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Currencies return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mk_currencies', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('currency_id');
    q.Varchar2_Field('name', 'round_model', 'prefix', 'suffix');
    q.Map_Field('scale',
                'select to_number(substr($round_model, 1, 4), ''S9D9'', ''NLS_NUMERIC_CHARACTERS=''''. '') from dual');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Subfilials return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mrf_subfilials', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('subfilial_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Staff_Info(p Hashmap) return Hashmap is
    v_Staff_Id      number := p.r_Number('staff_id');
    r_Person_Detail Href_Person_Details%rowtype;
    r_Robot         Mrf_Robots%rowtype;
    v_Employee_Id   number;
    result          Hashmap;
  begin
    r_Robot := Hpd_Util.Get_Closest_Robot(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Staff_Id   => v_Staff_Id,
                                          i_Period     => Last_Day(p.r_Date('month',
                                                                            Href_Pref.c_Date_Format_Month)));
  
    v_Employee_Id := Href_Util.Get_Employee_Id(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Staff_Id   => v_Staff_Id);
  
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id);
  
    r_Person_Detail := z_Href_Person_Details.Take(i_Company_Id => Ui.Company_Id,
                                                  i_Person_Id  => v_Employee_Id);
  
    result := Fazo.Zip_Map('robot_name',
                           r_Robot.Name,
                           'job_name',
                           z_Mhr_Jobs.Take(i_Company_Id => r_Robot.Company_Id, -- 
                           i_Filial_Id => r_Robot.Filial_Id, --
                           i_Job_Id => r_Robot.Job_Id).Name,
                           'division_name',
                           z_Mhr_Divisions.Take(i_Company_Id => r_Robot.Company_Id, --
                           i_Filial_Id => r_Robot.Filial_Id, --
                           i_Division_Id => r_Robot.Division_Id).Name,
                           'access_to_hidden_salary',
                           Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => r_Robot.Job_Id,
                                                               i_Employee_Id => r_Robot.Person_Id));
  
    Result.Put('iapa', r_Person_Detail.Iapa);
    Result.Put('npin', r_Person_Detail.Npin);
    Result.Put('tin',
               z_Mr_Person_Details.Take(i_Company_Id => r_Person_Detail.Company_Id, i_Person_Id => r_Person_Detail.Person_Id).Tin);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Indicators
  (
    i_Currency_Id number,
    i_Book_Date   date,
    i_Charge_Ids  Array_Number
  ) return Arraylist is
    result Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Charge_Id,
                           p.Name,
                           p.Identifier,
                           case
                             when p.Used = Href_Pref.c_Indicator_Used_Constantly then
                              Mk_Util.Calc_Amount(i_Company_Id  => Ui.Company_Id,
                                                  i_Filial_Id   => Ui.Filial_Id,
                                                  i_Currency_Id => i_Currency_Id,
                                                  i_Rate_Date   => i_Book_Date,
                                                  i_Amount_Base => q.Indicator_Value)
                             when p.Pcode in (Href_Pref.c_Pcode_Indicator_Hourly_Wage,
                                              Href_Pref.c_Pcode_Indicator_Penalty_For_Late,
                                              Href_Pref.c_Pcode_Indicator_Penalty_For_Early_Output,
                                              Href_Pref.c_Pcode_Indicator_Penalty_For_Absence,
                                              Href_Pref.c_Pcode_Indicator_Penalty_For_Day_Skip,
                                              Href_Pref.c_Pcode_Indicator_Perf_Penalty,
                                              Href_Pref.c_Pcode_Indicator_Perf_Extra_Penalty) then
                              Mk_Util.Calc_Amount(i_Company_Id  => Ui.Company_Id,
                                                  i_Filial_Id   => Ui.Filial_Id,
                                                  i_Currency_Id => i_Currency_Id,
                                                  i_Rate_Date   => i_Book_Date,
                                                  i_Amount_Base => q.Indicator_Value)
                             else
                              q.Indicator_Value
                           end)
      bulk collect
      into result
      from Hpr_Charges Ch
      join Hpr_Charge_Indicators q
        on q.Company_Id = Ch.Company_Id
       and q.Filial_Id = Ch.Filial_Id
       and q.Charge_Id = Ch.Charge_Id
      join Href_Indicators p
        on p.Company_Id = q.Company_Id
       and p.Indicator_Id = q.Indicator_Id
     where Ch.Company_Id = Ui.Company_Id
       and Ch.Filial_Id = Ui.Filial_Id
       and Ch.Charge_Id in (select *
                              from table(i_Charge_Ids));
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Indicators(p Hashmap) return Arraylist is
    v_Currency_Id number := Coalesce(p.o_Number('currency_id'),
                                     Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id));
  begin
    return Get_Indicators(i_Currency_Id => v_Currency_Id,
                          i_Book_Date   => p.r_Date('book_date'),
                          i_Charge_Ids  => Nvl(p.o_Array_Number('charge_ids'), Array_Number()));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Operations(p Hashmap) return Hashmap is
    v_Company_Id             number := Ui.Company_Id;
    v_Filial_Id              number := Ui.Filial_Id;
    v_Oper_Group_Ids         Array_Number := p.r_Array_Number('oper_group_ids');
    v_Division_Id            number := p.o_Number('division_id');
    v_Base_Currency_Id       number := Mk_Pref.Base_Currency(i_Company_Id => v_Company_Id,
                                                             i_Filial_Id  => v_Filial_Id);
    v_Currency_Id            number := Nvl(p.r_Number('currency_id'), v_Base_Currency_Id);
    v_Staff_Id               number := p.o_Number('staff_id');
    v_Month                  date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_Book_Date              date := p.r_Date('book_date');
    v_Amount                 number;
    v_Net_Amount             number;
    v_Income_Tax_Amount      number;
    v_Pension_Payment_Amount number;
    v_Social_Payment_Amount  number;
    v_Matrix                 Matrix_Varchar2;
    v_Accrual_Charge_Ids     Array_Number;
    v_Deduction_Charge_Ids   Array_Number;
    v_Charge_Ids             Array_Number;
    v_Oper_Type_Ids          Array_Number;
    v_Currency_Ids           Array_Number;
    v_Amounts                Array_Number;
    v_Item                   Array_Varchar2;
    v_Division_Ids           Array_Number;
    v_Access_All_Employees   varchar2(1) := Uit_Href.User_Access_All_Employees;
    result                   Hashmap := Hashmap();
  begin
    if v_Access_All_Employees = 'N' then
      v_Division_Ids := Uit_Href.Get_All_Subordinate_Divisions;
    end if;
  
    select Array_Varchar2(q.Charge_Id,
                          q.Staff_Id,
                          q.Staff_Name,
                          (select St.Staff_Number
                             from Href_Staffs St
                            where St.Company_Id = q.Company_Id
                              and St.Filial_Id = q.Filial_Id
                              and St.Staff_Id = q.Staff_Id),
                          q.Iapa,
                          q.Npin,
                          q.Tin,
                          (select d.Name
                             from Mrf_Robots d
                            where d.Company_Id = q.Company_Id
                              and d.Filial_Id = q.Filial_Id
                              and d.Robot_Id = q.Robot_Id),
                          (select d.Name
                             from Mhr_Divisions d
                            where d.Company_Id = q.Company_Id
                              and d.Filial_Id = q.Filial_Id
                              and d.Division_Id = q.Division_Id),
                          (select j.Name
                             from Mhr_Jobs j
                            where j.Company_Id = q.Company_Id
                              and j.Filial_Id = q.Filial_Id
                              and j.Job_Id = q.Job_Id),
                          q.Oper_Type_Id,
                          (select Ot.Name
                             from Mpr_Oper_Types Ot
                            where Ot.Company_Id = q.Company_Id
                              and Ot.Oper_Type_Id = q.Oper_Type_Id),
                          (select Ot.Estimation_Formula
                             from Hpr_Oper_Types Ot
                            where Ot.Company_Id = q.Company_Id
                              and Ot.Oper_Type_Id = q.Oper_Type_Id),
                          q.Begin_Date,
                          q.End_Date,
                          'Y', -- Autofilled
                          q.Subfilial_Id,
                          (select w.Name
                             from Mrf_Subfilials w
                            where w.Company_Id = q.Company_Id
                              and w.Subfilial_Id = q.Subfilial_Id),
                          Mpr_Pref.c_Ok_Accrual),
           q.Charge_Id,
           q.Oper_Type_Id,
           q.Currency_Id,
           q.Amount
      bulk collect
      into v_Matrix, v_Accrual_Charge_Ids, v_Oper_Type_Ids, v_Currency_Ids, v_Amounts
      from (select w.Company_Id,
                   w.Filial_Id,
                   s.Staff_Id,
                   (select p.Name
                      from Mr_Natural_Persons p
                     where p.Company_Id = s.Company_Id
                       and p.Person_Id = s.Employee_Id) Staff_Name,
                   Pd.Iapa,
                   Pd.Npin,
                   (select Mr.Tin
                      from Mr_Person_Details Mr
                     where Mr.Company_Id = s.Company_Id
                       and Mr.Person_Id = s.Employee_Id) Tin,
                   w.Charge_Id,
                   w.Begin_Date,
                   w.End_Date,
                   w.Oper_Type_Id,
                   w.Amount,
                   w.Division_Id,
                   Uit_Hpr.Load_Division_Subfilial(w.Division_Id) as Subfilial_Id,
                   w.Schedule_Id,
                   w.Currency_Id,
                   w.Job_Id,
                   w.Rank_Id,
                   w.Robot_Id
              from Hpr_Charges w
              join Href_Staffs s
                on s.Company_Id = w.Company_Id
               and s.Filial_Id = w.Filial_Id
               and s.Staff_Id = w.Staff_Id
              left join Href_Person_Details Pd
                on Pd.Company_Id = s.Company_Id
               and Pd.Person_Id = s.Employee_Id
             where w.Company_Id = v_Company_Id
               and w.Filial_Id = v_Filial_Id
               and w.Status not in
                   (Hpr_Pref.c_Charge_Status_Completed, Hpr_Pref.c_Charge_Status_Draft)
               and (v_Division_Id is null or w.Division_Id = v_Division_Id)
               and (v_Oper_Group_Ids is null or exists
                    (select 1
                       from Hpr_Oper_Types Ot
                      where Ot.Company_Id = w.Company_Id
                        and Ot.Oper_Type_Id = w.Oper_Type_Id
                        and Ot.Oper_Group_Id in (select *
                                                   from table(v_Oper_Group_Ids))))
               and exists (select 1
                      from Mpr_Oper_Types Ot
                     where Ot.Company_Id = w.Company_Id
                       and Ot.Oper_Type_Id = w.Oper_Type_Id
                       and Ot.Operation_Kind = Mpr_Pref.c_Ok_Accrual)
               and Trunc(w.Begin_Date, 'Mon') = v_Month
               and (v_Staff_Id is null or s.Staff_Id = v_Staff_Id)
               and Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => w.Job_Id,
                                                       i_Employee_Id => s.Employee_Id) = 'Y'
               and (v_Access_All_Employees = 'Y' or
                   Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => s.Company_Id,
                                                     i_Filial_Id  => s.Filial_Id,
                                                     i_Staff_Id   => s.Staff_Id,
                                                     i_Period     => Least(w.End_Date,
                                                                           Nvl(s.Dismissal_Date,
                                                                               w.End_Date)))
                    member of v_Division_Ids)) q
     order by q.Staff_Name;
  
    for i in 1 .. v_Matrix.Count
    loop
      v_Item := v_Matrix(i);
    
      Hpr_Util.Calc_Amounts(i_Company_Id             => v_Company_Id,
                            i_Filial_Id              => v_Filial_Id,
                            i_Currency_Id            => v_Currency_Id,
                            i_Date                   => v_Book_Date,
                            i_Oper_Type_Id           => v_Oper_Type_Ids(i),
                            i_Amount                 => Mk_Util.Calc_Amount(i_Company_Id  => v_Company_Id,
                                                                            i_Filial_Id   => v_Filial_Id,
                                                                            i_Currency_Id => v_Currency_Id,
                                                                            i_Rate_Date   => v_Book_Date,
                                                                            i_Amount_Base => v_Amounts(i)),
                            i_Is_Net_Amount          => false,
                            o_Amount                 => v_Amount,
                            o_Net_Amount             => v_Net_Amount,
                            o_Income_Tax_Amount      => v_Income_Tax_Amount,
                            o_Pension_Payment_Amount => v_Pension_Payment_Amount,
                            o_Social_Payment_Amount  => v_Social_Payment_Amount);
    
      Fazo.Push(v_Item, ''); -- hpr_book_operations.note
      Fazo.Push(v_Item, v_Amount);
      Fazo.Push(v_Item, v_Net_Amount);
      Fazo.Push(v_Item, v_Income_Tax_Amount);
      Fazo.Push(v_Item, v_Pension_Payment_Amount);
      Fazo.Push(v_Item, v_Social_Payment_Amount);
      Fazo.Push(v_Item, 'Y'); -- Access_To_Hidden_salary
    
      v_Matrix(i) := v_Item;
    end loop;
  
    Result.Put('operations', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Charge_Id,
                          s.Staff_Id,
                          (select p.Name
                             from Mr_Natural_Persons p
                            where p.Company_Id = s.Company_Id
                              and p.Person_Id = s.Employee_Id),
                          Pd.Iapa,
                          Pd.Npin,
                          (select Mr.Tin
                             from Mr_Person_Details Mr
                            where Mr.Company_Id = s.Company_Id
                              and Mr.Person_Id = s.Employee_Id),
                          q.Oper_Type_Id,
                          (select t.Name
                             from Mpr_Oper_Types t
                            where t.Company_Id = q.Company_Id
                              and t.Oper_Type_Id = q.Oper_Type_Id),
                          Mk_Util.Calc_Amount(i_Company_Id  => v_Company_Id,
                                              i_Filial_Id   => v_Filial_Id,
                                              i_Currency_Id => v_Currency_Id,
                                              i_Rate_Date   => v_Book_Date,
                                              i_Amount_Base => q.Amount),
                          'Y', -- Autofilled
                          'Y', -- Access_To_Hidden_Salary_Job
                          (select Ot.Estimation_Formula
                             from Hpr_Oper_Types Ot
                            where Ot.Company_Id = q.Company_Id
                              and Ot.Oper_Type_Id = q.Oper_Type_Id),
                          Uit_Hpr.Load_Division_Subfilial(q.Division_Id),
                          (select w.Name
                             from Mrf_Subfilials w
                            where w.Company_Id = q.Company_Id
                              and w.Subfilial_Id = Uit_Hpr.Load_Division_Subfilial(q.Division_Id)),
                          Mpr_Pref.c_Ok_Deduction),
           q.Charge_Id
      bulk collect
      into v_Matrix, v_Deduction_Charge_Ids
      from Hpr_Charges q
      left join Hpd_Lock_Intervals w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Interval_Id = q.Interval_Id
      left join Hpr_Charge_Document_Operations o
        on o.Company_Id = q.Company_Id
       and o.Filial_Id = q.Filial_Id
       and o.Operation_Id = q.Doc_Oper_Id
      join Href_Staffs s
        on s.Company_Id = q.Company_Id
       and s.Filial_Id = q.Filial_Id
       and s.Staff_Id = Nvl(w.Staff_Id, o.Staff_Id)
      left join Href_Person_Details Pd
        on Pd.Company_Id = s.Company_Id
       and Pd.Person_Id = s.Employee_Id
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and (v_Division_Id is null or q.Division_Id = v_Division_Id)
       and q.Status not in (Hpr_Pref.c_Charge_Status_Completed, Hpr_Pref.c_Charge_Status_Draft)
       and Trunc(q.Begin_Date, 'Mon') = v_Month
       and (v_Staff_Id is null or s.Staff_Id = v_Staff_Id)
       and (v_Oper_Group_Ids is null or exists
            (select 1
               from Hpr_Oper_Types Ot
              where Ot.Company_Id = q.Company_Id
                and Ot.Oper_Type_Id = q.Oper_Type_Id
                and Ot.Oper_Group_Id in (select Column_Value
                                           from table(v_Oper_Group_Ids))))
       and exists
     (select 1
              from Mpr_Oper_Types Ot
             where Ot.Company_Id = q.Company_Id
               and Ot.Oper_Type_Id = q.Oper_Type_Id
               and Ot.Operation_Kind = Mpr_Pref.c_Ok_Deduction)
       and Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => q.Job_Id, i_Employee_Id => s.Employee_Id) = 'Y'
       and (v_Access_All_Employees = 'Y' or q.Division_Id member of v_Division_Ids);
  
    Result.Put('deductions', Fazo.Zip_Matrix(v_Matrix));
  
    select Column_Value
      bulk collect
      into v_Charge_Ids
      from table(v_Accrual_Charge_Ids)
    union all
    select *
      from table(v_Deduction_Charge_Ids);
  
    Result.Put('indicators',
               Get_Indicators(i_Currency_Id => v_Currency_Id,
                              i_Book_Date   => v_Book_Date,
                              i_Charge_Ids  => v_Charge_Ids));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Subfilials(p Hashmap) return Arraylist is
    v_Operation_Ids Array_Number := p.r_Array_Number('operation_ids');
    v_Data          Arraylist := Arraylist();
    v_Hashmap       Hashmap;
    v_Subfilial_Id  number;
  begin
    for r in (select q.Operation_Id, w.Division_Id
                from Hpr_Book_Operations q
                join Href_Staffs w
                  on q.Company_Id = w.Company_Id
                 and q.Filial_Id = w.Filial_Id
                 and q.Staff_Id = w.Staff_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Operation_Id in (select Column_Value
                                          from table(v_Operation_Ids)))
    loop
      v_Hashmap      := Hashmap();
      v_Subfilial_Id := Uit_Hpr.Load_Division_Subfilial(r.Division_Id);
    
      v_Hashmap.Put('operation_id', r.Operation_Id);
      v_Hashmap.Put('subfilial_id', v_Subfilial_Id);
      v_Hashmap.Put('subfilial_name',
                    z_Mrf_Subfilials.Take(i_Company_Id => Ui.Company_Id, i_Subfilial_Id => v_Subfilial_Id).Name);
    
      v_Data.Push(v_Hashmap);
    end loop;
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Daily_Details(p Hashmap) return Hashmap is
    v_Company_Id     number := Ui.Company_Id;
    v_Filial_Id      number := Ui.Filial_Id;
    v_Staff_Id       number := p.r_Number('staff_id');
    v_Month          date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_Part_Begin     date := v_Month;
    v_Part_End       date := Last_Day(v_Month);
    v_Start_Of_Month date := Trunc(v_Part_Begin, 'mon');
    v_Schedule_Id    number;
  
    v_Access_To_Hidden_Salary varchar2(1);
    r_Robot                   Mrf_Robots%rowtype;
    r_Staff                   Href_Staffs%rowtype;
  
    v_Base_Currency_Id number := Mk_Pref.Base_Currency(i_Company_Id => v_Company_Id,
                                                       i_Filial_Id  => v_Filial_Id);
    v_Currency_Id      number := Nvl(p.r_Number('currency_id'), v_Base_Currency_Id);
    v_Book_Date        date := p.r_Date('book_date');
  
    v_Filter_Oper_Type_Ids Array_Number := Nvl(p.o_Array_Number('oper_type_ids'), Array_Number());
  
    v_Oper_Type_Ids    Array_Number;
    v_Daily_Indicators Hpr_Pref.Daily_Indicators_Nt;
    v_Daily_Indicator  Hpr_Pref.Daily_Indicators_Rt;
    v_Oper_Amount      number;
  
    v_Late_Id     number;
    v_Early_Id    number;
    v_Lack_Id     number;
    v_Turnout_Id  number;
    v_Overtime_Id number;
  
    v_Oper_Type  Hashmap;
    v_Day_Info   Hashmap;
    v_Indicators Arraylist;
    v_Oper_Types Arraylist := Arraylist();
    v_Days       Arraylist := Arraylist();
    result       Hashmap := Hashmap();
  
    -------------------------------------------------- 
    Function Day_Index(i_Date date) return number is
    begin
      return i_Date - v_Start_Of_Month + 1;
    end;
  
    --------------------------------------------------
    Procedure Put_Tk_Facts
    (
      p_Map          in out nocopy Hashmap,
      i_Time_Kind_Id number,
      i_Key_Name     varchar2,
      i_Begin_Date   date,
      i_End_Date     date
    ) is
      v_Fact_Seconds number;
      v_Fact_Days    number;
    begin
      Htt_Util.Calc_Time_Kind_Facts(o_Fact_Seconds => v_Fact_Seconds,
                                    o_Fact_Days    => v_Fact_Days,
                                    i_Company_Id   => v_Company_Id,
                                    i_Filial_Id    => v_Filial_Id,
                                    i_Staff_Id     => v_Staff_Id,
                                    i_Time_Kind_Id => i_Time_Kind_Id,
                                    i_Begin_Date   => i_Begin_Date,
                                    i_End_Date     => i_End_Date);
    
      p_Map.Put(i_Key_Name || '_time', Htt_Util.To_Time_Seconds_Text(v_Fact_Seconds, true, true));
      p_Map.Put(i_Key_Name || '_days', v_Fact_Days);
    end;
  
    -------------------------------------------------- 
    Procedure Put_Lack_n_Skip_Facts
    (
      p_Map          in out nocopy Hashmap,
      i_Time_Kind_Id number,
      i_Begin_Date   date,
      i_End_Date     date
    ) is
      v_Lack_Seconds   number;
      v_Lack_Days      number;
      v_Skip_Seconds   number;
      v_Skip_Days      number;
      v_Skip_Times     number;
      v_Mark_Skip_Days number;
    begin
      select sum(Tf.Fact_Value), count(*)
        into v_Lack_Seconds, v_Lack_Days
        from Htt_Timesheets t
        join Htt_Timesheet_Facts Tf
          on Tf.Company_Id = t.Company_Id
         and Tf.Filial_Id = t.Filial_Id
         and Tf.Timesheet_Id = t.Timesheet_Id
         and Tf.Time_Kind_Id = i_Time_Kind_Id
         and Tf.Fact_Value < t.Plan_Time
         and Tf.Fact_Value > 0
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Staff_Id = v_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date;
    
      select sum(Tf.Fact_Value), count(*)
        into v_Skip_Seconds, v_Skip_Days
        from Htt_Timesheets t
        join Htt_Timesheet_Facts Tf
          on Tf.Company_Id = t.Company_Id
         and Tf.Filial_Id = t.Filial_Id
         and Tf.Timesheet_Id = t.Timesheet_Id
         and Tf.Time_Kind_Id = i_Time_Kind_Id
         and Tf.Fact_Value = t.Plan_Time
         and Tf.Fact_Value > 0
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Staff_Id = v_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date;
    
      select sum(t.Planned_Marks - t.Done_Marks), count(*)
        into v_Skip_Times, v_Mark_Skip_Days
        from Htt_Timesheets t
       where t.Company_Id = v_Company_Id
         and t.Filial_Id = v_Filial_Id
         and t.Staff_Id = v_Staff_Id
         and t.Timesheet_Date between i_Begin_Date and i_End_Date
         and t.Day_Kind = Htt_Pref.c_Day_Kind_Work
         and t.Planned_Marks > t.Done_Marks;
    
      p_Map.Put('lack_time', Htt_Util.To_Time_Seconds_Text(Nvl(v_Lack_Seconds, 0), true, true));
      p_Map.Put('lack_days', v_Lack_Days);
      p_Map.Put('day_skip_time', Htt_Util.To_Time_Seconds_Text(Nvl(v_Skip_Seconds, 0), true, true));
      p_Map.Put('day_skip_days', v_Skip_Days);
      p_Map.Put('mark_skip_times', v_Skip_Times);
      p_Map.Put('mark_skip_days', v_Mark_Skip_Days);
    end;
  
    --------------------------------------------------
    Function Load_Month_Stats return Hashmap is
      v_Monthly_Time number;
      v_Monthly_Days number;
      v_Plan_Time    number;
      v_Plan_Days    number;
    
      Month_Stats Hashmap;
    begin
      v_Monthly_Time := Htt_Util.Calc_Plan_Minutes(i_Company_Id  => v_Company_Id,
                                                   i_Filial_Id   => v_Filial_Id,
                                                   i_Staff_Id    => v_Staff_Id,
                                                   i_Schedule_Id => v_Schedule_Id,
                                                   i_Period      => v_Part_End);
    
      v_Monthly_Days := Htt_Util.Calc_Plan_Days(i_Company_Id  => v_Company_Id,
                                                i_Filial_Id   => v_Filial_Id,
                                                i_Staff_Id    => v_Staff_Id,
                                                i_Schedule_Id => v_Schedule_Id,
                                                i_Period      => v_Part_End);
    
      v_Plan_Time := Htt_Util.Calc_Working_Seconds(i_Company_Id => v_Company_Id,
                                                   i_Filial_Id  => v_Filial_Id,
                                                   i_Staff_Id   => v_Staff_Id,
                                                   i_Begin_Date => v_Part_Begin,
                                                   i_End_Date   => v_Part_End);
    
      v_Plan_Days := Htt_Util.Calc_Working_Days(i_Company_Id => v_Company_Id,
                                                i_Filial_Id  => v_Filial_Id,
                                                i_Staff_Id   => v_Staff_Id,
                                                i_Begin_Date => v_Part_Begin,
                                                i_End_Date   => v_Part_End);
    
      Month_Stats := Fazo.Zip_Map('monthly_time',
                                  Htt_Util.To_Time_Text(v_Monthly_Time, true, true),
                                  'monthly_days',
                                  v_Monthly_Days,
                                  'plan_time',
                                  Htt_Util.To_Time_Seconds_Text(v_Plan_Time, true, true),
                                  'plan_days',
                                  v_Plan_Days);
    
      -- turnout
      Put_Tk_Facts(Month_Stats, v_Turnout_Id, 'turnout', v_Part_Begin, v_Part_End);
    
      -- overtime
      Put_Tk_Facts(Month_Stats, v_Overtime_Id, 'overtime', v_Part_Begin, v_Part_End);
    
      -- late
      Put_Tk_Facts(Month_Stats, v_Late_Id, 'late', v_Part_Begin, v_Part_End);
    
      -- early
      Put_Tk_Facts(Month_Stats, v_Early_Id, 'early', v_Part_Begin, v_Part_End);
    
      -- put time and days for lack and day skips
      Put_Lack_n_Skip_Facts(Month_Stats, v_Lack_Id, v_Part_Begin, v_Part_End);
    
      return Month_Stats;
    end;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => v_Company_Id,
                                  i_Filial_Id  => v_Filial_Id,
                                  i_Staff_Id   => v_Staff_Id);
  
    v_Part_End := Least(v_Part_End, Nvl(r_Staff.Dismissal_Date, v_Part_End));
  
    r_Robot := Hpd_Util.Get_Closest_Robot(i_Company_Id => v_Company_Id,
                                          i_Filial_Id  => v_Filial_Id,
                                          i_Staff_Id   => v_Staff_Id,
                                          i_Period     => v_Part_End);
  
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r_Robot.Person_Id);
  
    v_Access_To_Hidden_Salary := Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => r_Robot.Job_Id,
                                                                     i_Employee_Id => r_Robot.Person_Id);
  
    Result.Put('access_to_hidden_salary', v_Access_To_Hidden_Salary);
  
    if v_Access_To_Hidden_Salary = 'N' then
      return result;
    end if;
  
    v_Schedule_Id := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => v_Company_Id,
                                                      i_Filial_Id  => v_Filial_Id,
                                                      i_Staff_Id   => v_Staff_Id,
                                                      i_Period     => v_Part_End);
  
    v_Turnout_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
  
    v_Overtime_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime);
  
    v_Late_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
  
    v_Early_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                        i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Early);
  
    v_Lack_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
  
    select q.Oper_Type_Id
      bulk collect
      into v_Oper_Type_Ids
      from Hpr_Oper_Types q
      join Hpr_Oper_Groups t
        on t.Company_Id = q.Company_Id
       and t.Oper_Group_Id = q.Oper_Group_Id
     where q.Company_Id = v_Company_Id
       and q.Oper_Type_Id --
     member of v_Filter_Oper_Type_Ids
       and q.Estimation_Type = Hpr_Pref.c_Estimation_Type_Formula
       and t.Pcode not in (Hpr_Pref.c_Pcode_Operation_Group_Perf,
                           Hpr_Pref.c_Pcode_Operation_Group_Sick_Leave,
                           Hpr_Pref.c_Pcode_Operation_Group_Vacation,
                           Hpr_Pref.c_Pcode_Operation_Group_Business_Trip,
                           Hpr_Pref.c_Pcode_Operation_Group_Perf_Penalty);
  
    for r in (select q.Timesheet_Date,
                     q.Day_Kind,
                     q.Break_Enabled,
                     q.Plan_Time,
                     q.Begin_Time,
                     q.End_Time,
                     q.Break_Begin_Time,
                     q.Break_End_Time,
                     q.Input_Time,
                     q.Output_Time
                from Htt_Timesheets q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Staff_Id = v_Staff_Id
                 and q.Timesheet_Date between v_Part_Begin and v_Part_End)
    loop
      v_Day_Info := Fazo.Zip_Map('timesheet_date', --
                                 r.Timesheet_Date,
                                 'day_kind',
                                 r.Day_Kind,
                                 'break_enabled',
                                 r.Break_Enabled);
    
      v_Day_Info.Put('begin_time', to_char(r.Begin_Time, Href_Pref.c_Time_Format_Minute));
      v_Day_Info.Put('end_time', to_char(r.End_Time, Href_Pref.c_Time_Format_Minute));
      v_Day_Info.Put('input_time', to_char(r.Input_Time, Href_Pref.c_Time_Format_Minute));
      v_Day_Info.Put('output_time', to_char(r.Output_Time, Href_Pref.c_Time_Format_Minute));
      v_Day_Info.Put('break_begin_time',
                     to_char(r.Break_Begin_Time, Href_Pref.c_Time_Format_Minute));
      v_Day_Info.Put('break_end_time', to_char(r.Break_End_Time, Href_Pref.c_Time_Format_Minute));
    
      v_Day_Info.Put('plan_time', Htt_Util.To_Time_Seconds_Text(r.Plan_Time, true, true));
    
      -- turnout
      Put_Tk_Facts(v_Day_Info, v_Turnout_Id, 'turnout', r.Timesheet_Date, r.Timesheet_Date);
    
      -- overtime
      Put_Tk_Facts(v_Day_Info, v_Overtime_Id, 'overtime', r.Timesheet_Date, r.Timesheet_Date);
    
      -- late
      Put_Tk_Facts(v_Day_Info, v_Late_Id, 'late', r.Timesheet_Date, r.Timesheet_Date);
    
      -- early
      Put_Tk_Facts(v_Day_Info, v_Early_Id, 'early', r.Timesheet_Date, r.Timesheet_Date);
    
      -- lack
      Put_Tk_Facts(v_Day_Info, v_Lack_Id, 'lack', r.Timesheet_Date, r.Timesheet_Date);
    
      for i in 1 .. v_Oper_Type_Ids.Count
      loop
        begin
          v_Oper_Amount := Hpr_Util.Calc_Amount_With_Indicators(o_Indicators   => v_Daily_Indicators,
                                                                i_Company_Id   => v_Company_Id,
                                                                i_Filial_Id    => v_Filial_Id,
                                                                i_Staff_Id     => v_Staff_Id,
                                                                i_Oper_Type_Id => v_Oper_Type_Ids(i),
                                                                i_Part_Begin   => r.Timesheet_Date,
                                                                i_Part_End     => r.Timesheet_Date);
        
          v_Oper_Type := Fazo.Zip_Map('amount',
                                      Mk_Util.Calc_Amount(i_Company_Id  => v_Company_Id,
                                                          i_Filial_Id   => v_Filial_Id,
                                                          i_Currency_Id => v_Currency_Id,
                                                          i_Rate_Date   => v_Book_Date,
                                                          i_Amount_Base => v_Oper_Amount));
        
          for j in 1 .. v_Daily_Indicators.Count
          loop
            v_Daily_Indicator := v_Daily_Indicators(j);
          
            v_Oper_Type.Put(to_char(v_Daily_Indicator.Indicator_Id),
                            Mk_Util.Calc_Amount(i_Company_Id  => v_Company_Id,
                                                i_Filial_Id   => v_Filial_Id,
                                                i_Currency_Id => v_Currency_Id,
                                                i_Rate_Date   => v_Book_Date,
                                                i_Amount_Base => v_Daily_Indicator.Indicator_Value));
          end loop;
        
          v_Day_Info.Put(v_Oper_Type_Ids(i), v_Oper_Type);
        exception
          when others then
            null;
        end;
      end loop;
    
      v_Days.Push(v_Day_Info);
    end loop;
  
    for i in 1 .. v_Oper_Type_Ids.Count
    loop
      v_Oper_Type := Fazo.Zip_Map('oper_type_id',
                                  v_Oper_Type_Ids(i),
                                  'oper_type_name',
                                  z_Mpr_Oper_Types.Load(i_Company_Id => Ui.Company_Id, i_Oper_Type_Id => v_Oper_Type_Ids(i)).Name);
    
      v_Indicators := Arraylist();
    
      for r in (select q.*, t.Short_Name name
                  from Hpr_Oper_Type_Indicators q
                  join Href_Indicators t
                    on t.Company_Id = q.Company_Id
                   and t.Indicator_Id = q.Indicator_Id
                 where q.Company_Id = v_Company_Id
                   and q.Oper_Type_Id = v_Oper_Type_Ids(i))
      loop
        v_Indicators.Push(Fazo.Zip_Map('indicator_id', r.Indicator_Id, 'indicator_name', r.Name));
      end loop;
    
      v_Oper_Type.Put('indicators', v_Indicators);
    
      v_Oper_Types.Push(v_Oper_Type);
    end loop;
  
    Result.Put('days', v_Days);
    Result.Put('oper_types', v_Oper_Types);
    Result.Put('month_stats', Load_Month_Stats);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => v_Company_Id, --
               i_Filial_Id => v_Filial_Id, --
               i_Schedule_Id => v_Schedule_Id).Name);
    Result.Put('manager_name',
               Href_Util.Get_Manager_Name(i_Company_Id => v_Company_Id,
                                          i_Filial_Id  => v_Filial_Id,
                                          i_Staff_Id   => v_Staff_Id));
    Result.Put('photo_sha',
               z_Md_Persons.Load(i_Company_Id => v_Company_Id, i_Person_Id => r_Staff.Employee_Id).Photo_Sha);
    Result.Put('gender',
               z_Mr_Natural_Persons.Load(i_Company_Id => v_Company_Id, i_Person_Id => r_Staff.Employee_Id).Gender);
    Result.Put('rank_name',
               z_Mhr_Ranks.Take(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Rank_Id => r_Staff.Rank_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Calc_Amount(p Hashmap) return Hashmap is
    v_Amount                 number;
    v_Net_Amount             number;
    v_Income_Tax_Amount      number;
    v_Pension_Payment_Amount number;
    v_Social_Payment_Amount  number;
    v_Is_Net_Amount          boolean := false;
    result                   Hashmap := Hashmap();
  begin
    v_Amount := p.o_Number('amount');
  
    if v_Amount is null then
      v_Amount        := p.r_Number('net_amount');
      v_Is_Net_Amount := true;
    end if;
  
    Hpr_Util.Calc_Amounts(i_Company_Id             => Ui.Company_Id,
                          i_Filial_Id              => Ui.Filial_Id,
                          i_Currency_Id            => p.o_Number('currency_id'),
                          i_Date                   => p.r_Date('book_date'),
                          i_Oper_Type_Id           => p.r_Number('oper_type_id'),
                          i_Amount                 => v_Amount,
                          i_Is_Net_Amount          => v_Is_Net_Amount,
                          o_Amount                 => v_Amount,
                          o_Net_Amount             => v_Net_Amount,
                          o_Income_Tax_Amount      => v_Income_Tax_Amount,
                          o_Pension_Payment_Amount => v_Pension_Payment_Amount,
                          o_Social_Payment_Amount  => v_Social_Payment_Amount);
  
    Result.Put('amount', v_Amount);
    Result.Put('net_amount', v_Net_Amount);
    Result.Put('income_tax_amount', v_Income_Tax_Amount);
    Result.Put('pension_payment_amount', v_Pension_Payment_Amount);
    Result.Put('social_payment_amount', v_Social_Payment_Amount);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References
  (
    i_Book_Type_Id number,
    i_Pcode        varchar2 := null,
    i_Division_Id  number := null
  ) return Hashmap is
    v_Array Array_Varchar2;
    result  Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id)));
  
    select q.Oper_Group_Id
      bulk collect
      into v_Array
      from Hpr_Book_Type_Binds q
      join Hpr_Oper_Groups w
        on w.Company_Id = q.Company_Id
       and w.Oper_Group_Id = q.Oper_Group_Id
     where q.Company_Id = Ui.Company_Id
       and (q.Book_Type_Id = i_Book_Type_Id or i_Pcode = Hpr_Pref.c_Pcode_Book_Type_All);
  
    Result.Put('oper_group_ids', v_Array);
    Result.Put('chs_completed', Hpr_Pref.c_Charge_Status_Completed);
    Result.Put('chs_draft', Hpr_Pref.c_Charge_Status_Draft);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model(p Hashmap) return Hashmap is
    r_Book_Type Hpr_Book_Types%rowtype;
    r_Currency  Mk_Currencies%rowtype;
    v_Month     date := Add_Months(Trunc(sysdate, 'MON'), -1);
    v_Data      Hashmap;
    result      Hashmap := Hashmap();
  begin
    r_Book_Type := z_Hpr_Book_Types.Load(i_Company_Id   => Ui.Company_Id,
                                         i_Book_Type_Id => p.r_Number('book_type_id'));
  
    r_Currency := z_Mk_Currencies.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Currency_Id => Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                                                              i_Filial_Id  => Ui.Filial_Id));
  
    v_Data := Fazo.Zip_Map('book_date',
                           Trunc(sysdate),
                           'month',
                           to_char(v_Month, Href_Pref.c_Date_Format_Month),
                           'book_type_id',
                           r_Book_Type.Book_Type_Id,
                           'book_type_name',
                           r_Book_Type.Name,
                           'currency_id',
                           r_Currency.Currency_Id,
                           'currency_name',
                           r_Currency.Name);
    v_Data.Put('round_model', r_Currency.Round_Model);
    v_Data.Put('allow_use_subfilial',
               Hpr_Util.Load_Use_Subfilial_Settings(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id));
    v_Data.Put('scale',
               to_number(Substr(r_Currency.Round_Model, 1, 4),
                         'S9D9',
                         'NLS_NUMERIC_CHARACTERS=''. '''));
    v_Data.Put('currency_prefix', r_Currency.Prefix);
    v_Data.Put('currency_suffix', r_Currency.Suffix);
  
    Result.Put('data', v_Data);
    Result.Put('references', References(r_Book_Type.Book_Type_Id, r_Book_Type.Pcode));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Hpr_Book   Hpr_Books%rowtype;
    r_Book_Type  Hpr_Book_Types%rowtype;
    r_Mpr_Book   Mpr_Books%rowtype;
    r_Currency   Mk_Currencies%rowtype;
    v_Matrix     Matrix_Varchar2;
    v_Charge_Ids Array_Number;
    v_Data       Hashmap;
    v_End_Date   date;
    v_Book_Id    number := p.r_Number('book_id');
    result       Hashmap := Hashmap();
  begin
    Uit_Hpr.Assert_Access_To_Book(i_Book_Id => v_Book_Id);
  
    r_Mpr_Book := z_Mpr_Books.Load(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Book_Id    => v_Book_Id);
  
    v_Data := z_Mpr_Books.To_Map(r_Mpr_Book,
                                 z.Company_Id,
                                 z.Filial_Id,
                                 z.Book_Id,
                                 z.Book_Number,
                                 z.Book_Date,
                                 z.Book_Name,
                                 z.Division_Id,
                                 z.Currency_Id,
                                 z.Posted,
                                 z.Note);
  
    v_Data.Put('month', to_char(r_Mpr_Book.Month, Href_Pref.c_Date_Format_Month));
    v_Data.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Mpr_Book.Company_Id, --
               i_Filial_Id => r_Mpr_Book.Filial_Id, --
               i_Division_Id => r_Mpr_Book.Division_Id).Name);
  
    r_Currency := z_Mk_Currencies.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Currency_Id => r_Mpr_Book.Currency_Id);
  
    v_Data.Put('currency_name', r_Currency.Name);
    v_Data.Put('round_model', r_Currency.Round_Model);
    v_Data.Put('scale',
               to_number(Substr(r_Currency.Round_Model, 1, 4),
                         'S9D9',
                         'NLS_NUMERIC_CHARACTERS=''. '''));
    v_Data.Put('currency_prefix', r_Currency.Prefix);
    v_Data.Put('currency_suffix', r_Currency.Suffix);
  
    r_Hpr_Book := z_Hpr_Books.Load(i_Company_Id => r_Mpr_Book.Company_Id,
                                   i_Filial_Id  => r_Mpr_Book.Filial_Id,
                                   i_Book_Id    => r_Mpr_Book.Book_Id);
  
    r_Book_Type := z_Hpr_Book_Types.Load(i_Company_Id   => r_Hpr_Book.Company_Id,
                                         i_Book_Type_Id => r_Hpr_Book.Book_Type_Id);
  
    v_Data.Put('book_type_id', r_Book_Type.Book_Type_Id);
    v_Data.Put('book_type_name', r_Book_Type.Name);
    v_Data.Put('allow_use_subfilial',
               Hpr_Util.Load_Use_Subfilial_Settings(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id));
  
    v_End_Date := Last_Day(r_Mpr_Book.Month);
  
    select Array_Varchar2(Bk.Charge_Id,
                           Bk.Staff_Id,
                           Bk.Staff_Name,
                           Bk.Staff_Number,
                           Bk.Iapa,
                           Bk.Npin,
                           Bk.Tin,
                           Bk.Robot_Name,
                           Bk.Division_Name,
                           Bk.Job_Name,
                           Bk.Oper_Type_Id,
                           Bk.Name,
                           Bk.Estimation_Formula,
                           Bk.Begin_Date,
                           Bk.End_Date,
                           Bk.Autofilled,
                           Bk.Subfilial_Id,
                           Bk.Subfilial_Name,
                           Bk.Operation_Kind,
                           Bk.Note,
                           (case
                             when Bk.Access_To_Hidden_Salary_Job = 'Y' then
                              Bk.Amount
                             else
                              -1
                           end),
                           (case
                             when Bk.Access_To_Hidden_Salary_Job = 'Y' then
                              Bk.Net_Amount
                             else
                              -1
                           end),
                           (case
                             when Bk.Access_To_Hidden_Salary_Job = 'Y' then
                              Bk.Income_Tax_Amount
                             else
                              -1
                           end),
                           (case
                             when Bk.Access_To_Hidden_Salary_Job = 'Y' then
                              Bk.Pension_Payment_Amount
                             else
                              -1
                           end),
                           (case
                             when Bk.Access_To_Hidden_Salary_Job = 'Y' then
                              Bk.Social_Payment_Amount
                             else
                              -1
                           end),
                           Bk.Access_To_Hidden_Salary_Job,
                           Bk.Operation_Id),
           Bk.Charge_Id
      bulk collect
      into v_Matrix, v_Charge_Ids
      from (select k.Charge_Id,
                   k.Staff_Id,
                   (select p.Name
                      from Mr_Natural_Persons p
                     where p.Company_Id = q.Company_Id
                       and p.Person_Id = q.Employee_Id) Staff_Name,
                   (select t.Staff_Number
                      from Href_Staffs t
                     where t.Company_Id = k.Company_Id
                       and t.Filial_Id = k.Filial_Id
                       and t.Staff_Id = k.Staff_Id) Staff_Number,
                   Pd.Iapa,
                   Pd.Npin,
                   (select Mr.Tin
                      from Mr_Person_Details Mr
                     where Mr.Company_Id = Pd.Company_Id
                       and Mr.Person_Id = Pd.Person_Id) Tin,
                   (select Mr.Name
                      from Mrf_Robots Mr
                     where Mr.Company_Id = k.Company_Id
                       and Mr.Filial_Id = k.Filial_Id
                       and Mr.Robot_Id =
                           Hpd_Util.Get_Closest_Robot_Id(i_Company_Id => k.Company_Id,
                                                         i_Filial_Id  => k.Filial_Id,
                                                         i_Staff_Id   => k.Staff_Id,
                                                         i_Period     => Nvl(Ch.End_Date, v_End_Date))) Robot_Name,
                   (select m.Name
                      from Mhr_Divisions m
                     where m.Company_Id = k.Company_Id
                       and m.Filial_Id = k.Filial_Id
                       and m.Division_Id =
                           Hpd_Util.Get_Closest_Division_Id(i_Company_Id => k.Company_Id,
                                                            i_Filial_Id  => k.Filial_Id,
                                                            i_Staff_Id   => k.Staff_Id,
                                                            i_Period     => Nvl(Ch.End_Date, v_End_Date))) Division_Name,
                   (select j.Name
                      from Mhr_Jobs j
                     where j.Company_Id = k.Company_Id
                       and j.Filial_Id = k.Filial_Id
                       and j.Job_Id =
                           Hpd_Util.Get_Closest_Job_Id(i_Company_Id => k.Company_Id,
                                                       i_Filial_Id  => k.Filial_Id,
                                                       i_Staff_Id   => k.Staff_Id,
                                                       i_Period     => Nvl(Ch.End_Date, v_End_Date))) Job_Name,
                   q.Oper_Type_Id,
                   w.Name,
                   (select Ot.Estimation_Formula -- if charge id exists, then estimation_formula would be given
                      from Hpr_Oper_Types Ot
                     where Ot.Company_Id = Ch.Company_Id
                       and Ot.Oper_Type_Id = Ch.Oper_Type_Id) Estimation_Formula,
                   Ch.Begin_Date,
                   Ch.End_Date,
                   k.Autofilled,
                   q.Note,
                   q.Amount,
                   q.Net_Amount,
                   q.Income_Tax_Amount,
                   q.Pension_Payment_Amount,
                   q.Social_Payment_Amount,
                   q.Subfilial_Id,
                   (select w.Name
                      from Mrf_Subfilials w
                     where w.Company_Id = q.Company_Id
                       and w.Subfilial_Id = q.Subfilial_Id) as Subfilial_Name,
                   Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => k.Company_Id,
                                                                                                    i_Filial_Id  => k.Filial_Id,
                                                                                                    i_Staff_Id   => k.Staff_Id,
                                                                                                    i_Period     => Nvl(Ch.End_Date,
                                                                                                                        v_End_Date)),
                                                       i_Employee_Id => q.Employee_Id) Access_To_Hidden_Salary_Job,
                   q.Operation_Id,
                   w.Operation_Kind
              from Mpr_Book_Operations q
              join Hpr_Book_Operations k
                on k.Company_Id = q.Company_Id
               and k.Filial_Id = q.Filial_Id
               and k.Book_Id = q.Book_Id
               and k.Operation_Id = q.Operation_Id
              join Mpr_Oper_Types w
                on w.Company_Id = q.Company_Id
               and w.Oper_Type_Id = q.Oper_Type_Id
              left join Hpr_Charges Ch
                on Ch.Company_Id = k.Company_Id
               and Ch.Filial_Id = k.Filial_Id
               and Ch.Charge_Id = k.Charge_Id
              left join Href_Person_Details Pd
                on Pd.Company_Id = k.Company_Id
               and Pd.Person_Id = q.Employee_Id
             where q.Company_Id = r_Mpr_Book.Company_Id
               and q.Filial_Id = r_Mpr_Book.Filial_Id
               and q.Book_Id = r_Mpr_Book.Book_Id
             order by q.Order_No) Bk;
  
    v_Data.Put('operations', Fazo.Zip_Matrix(v_Matrix));
    v_Data.Put('indicators',
               Get_Indicators(i_Currency_Id => r_Mpr_Book.Currency_Id,
                              i_Book_Date   => r_Mpr_Book.Book_Date,
                              i_Charge_Ids  => v_Charge_Ids));
  
    Result.Put('data', v_Data);
    Result.Put('references',
               References(r_Book_Type.Book_Type_Id, r_Book_Type.Pcode, r_Mpr_Book.Division_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure save
  (
    i_Book_Id number,
    p         Hashmap,
    i_Repost  boolean := false,
    i_Exists  boolean := false
  ) is
    p_Book                   Hpr_Pref.Book_Rt;
    v_Operations             Arraylist := p.r_Arraylist('operations');
    v_Operation              Hashmap;
    v_Operation_Id           number;
    v_Notification_Title     varchar2(500);
    v_Posted                 varchar2(1) := p.r_Varchar2('posted');
    v_User_Id                number := Ui.User_Id;
    v_Amount                 number;
    v_Net_Amount             number;
    v_Income_Tax_Amount      number;
    v_Pension_Payment_Amount number;
    v_Social_Payment_Amount  number;
    v_Staff_Id               number;
    v_Allow_Subfilial        varchar2(1) := Hpr_Util.Load_Use_Subfilial_Settings(i_Company_Id => Ui.Company_Id,
                                                                                 i_Filial_Id  => Ui.Filial_Id);
    r_Book_Operations        Mpr_Book_Operations%rowtype;
  begin
    Hpr_Util.Book_New(o_Book         => p_Book,
                      i_Company_Id   => Ui.Company_Id,
                      i_Filial_Id    => Ui.Filial_Id,
                      i_Book_Id      => i_Book_Id,
                      i_Book_Type_Id => p.r_Number('book_type_id'),
                      i_Book_Number  => p.o_Varchar2('book_number'),
                      i_Book_Date    => p.r_Date('book_date'),
                      i_Book_Name    => p.o_Varchar2('book_name'),
                      i_Month        => p.o_Date('month', Href_Pref.c_Date_Format_Month),
                      i_Division_Id  => p.o_Number('division_id'),
                      i_Currency_Id  => p.r_Number('currency_id'),
                      i_Note         => p.o_Varchar2('note'));
  
    for i in 1 .. v_Operations.Count
    loop
      v_Operation := Treat(v_Operations.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id := v_Operation.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Employee(Href_Util.Get_Employee_Id(i_Company_Id => p_Book.Book.Company_Id,
                                                                   i_Filial_Id  => p_Book.Book.Filial_Id,
                                                                   i_Staff_Id   => v_Staff_Id));
    
      v_Operation_Id := v_Operation.o_Number('operation_id');
    
      if v_Operation_Id is null then
        v_Operation_Id := Mpr_Next.Operation_Id;
      end if;
    
      v_Amount                 := v_Operation.r_Number('amount');
      v_Net_Amount             := v_Operation.o_Number('net_amount');
      v_Income_Tax_Amount      := Nullif(v_Operation.o_Number('income_tax_amount'), 0); -- TODO: temporary solution
      v_Pension_Payment_Amount := Nullif(v_Operation.o_Number('pension_payment_amount'), 0); -- TODO: temporary solution
      v_Social_Payment_Amount  := Nullif(v_Operation.o_Number('social_payment_amount'), 0); -- TODO: temporary solution, fix mpr_operation checks
    
      if v_Amount = -1 then
        if not z_Mpr_Book_Operations.Exist(i_Company_Id   => p_Book.Book.Company_Id,
                                           i_Filial_Id    => p_Book.Book.Filial_Id,
                                           i_Book_Id      => p_Book.Book.Book_Id,
                                           i_Operation_Id => v_Operation_Id,
                                           o_Row          => r_Book_Operations) then
          continue;
        end if;
      
        v_Amount                 := r_Book_Operations.Amount;
        v_Net_Amount             := r_Book_Operations.Net_Amount;
        v_Income_Tax_Amount      := r_Book_Operations.Income_Tax_Amount;
        v_Pension_Payment_Amount := r_Book_Operations.Pension_Payment_Amount;
        v_Social_Payment_Amount  := r_Book_Operations.Social_Payment_Amount;
      end if;
    
      Hpr_Util.Book_Add_Operation(p_Book                   => p_Book,
                                  i_Operation_Id           => v_Operation_Id,
                                  i_Staff_Id               => v_Staff_Id,
                                  i_Oper_Type_Id           => v_Operation.r_Number('oper_type_id'),
                                  i_Charge_Id              => v_Operation.o_Number('charge_id'),
                                  i_Autofilled             => Nvl(v_Operation.o_Varchar2('autofilled'),
                                                                  'N'),
                                  i_Note                   => v_Operation.o_Varchar2('note'),
                                  i_Amount                 => v_Amount,
                                  i_Net_Amount             => v_Net_Amount,
                                  i_Income_Tax_Amount      => v_Income_Tax_Amount,
                                  i_Pension_Payment_Amount => v_Pension_Payment_Amount,
                                  i_Social_Payment_Amount  => v_Social_Payment_Amount,
                                  i_Subfilial_Id           => Md_Util.Decode(i_Kind        => v_Allow_Subfilial,
                                                                             i_First_Kind  => 'Y',
                                                                             i_First_Name  => v_Operation.o_Number('subfilial_id'),
                                                                             i_Second_Kind => 'N',
                                                                             i_Second_Name => null,
                                                                             i_Default     => null));
    end loop;
  
    -- notification title should make before saving journal
    if i_Exists = false and v_Posted = 'N' then
      v_Notification_Title := Hpr_Util.t_Notification_Title_Book_Save(i_Company_Id  => p_Book.Book.Company_Id,
                                                                      i_User_Id     => v_User_Id,
                                                                      i_Book_Number => p_Book.Book.Book_Number,
                                                                      i_Month       => p_Book.Book.Month);
    elsif i_Repost = false and v_Posted = 'Y' then
      v_Notification_Title := Hpr_Util.t_Notification_Title_Book_Post(i_Company_Id  => p_Book.Book.Company_Id,
                                                                      i_User_Id     => v_User_Id,
                                                                      i_Book_Number => p_Book.Book.Book_Number,
                                                                      i_Month       => p_Book.Book.Month);
    else
      v_Notification_Title := Hpr_Util.t_Notification_Title_Book_Update(i_Company_Id  => p_Book.Book.Company_Id,
                                                                        i_User_Id     => v_User_Id,
                                                                        i_Book_Number => p_Book.Book.Book_Number,
                                                                        i_Month       => p_Book.Book.Month);
    end if;
  
    Hpr_Api.Book_Save(p_Book);
  
    if v_Posted = 'Y' then
      Hpr_Api.Book_Post(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Book_Id    => i_Book_Id);
    end if;
  
    -- notification send after saving journal
    Href_Core.Send_Notification(i_Company_Id    => p_Book.Book.Company_Id,
                                i_Filial_Id     => p_Book.Book.Filial_Id,
                                i_Title         => v_Notification_Title,
                                i_Uri           => Hpr_Pref.c_Form_Book_View,
                                i_Uri_Param     => Fazo.Zip_Map('book_id', p_Book.Book.Book_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Add(p Hashmap) is
  begin
    save(Mpr_Next.Book_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Edit(p Hashmap) is
    r_Book Mpr_Books%rowtype;
  begin
    r_Book := z_Mpr_Books.Lock_Load(i_Company_Id => Ui.Company_Id,
                                    i_Filial_Id  => Ui.Filial_Id,
                                    i_Book_Id    => p.r_Number('book_id'));
  
    if r_Book.Posted = 'Y' then
      Hpr_Api.Book_Unpost(i_Company_Id => r_Book.Company_Id,
                          i_Filial_Id  => r_Book.Filial_Id,
                          i_Book_Id    => r_Book.Book_Id);
    end if;
  
    save(r_Book.Book_Id, p, (r_Book.Posted = 'Y' and p.r_Varchar2('posted') = 'Y'), true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
  begin
    Hpr_Api.Book_Unpost(i_Company_Id => Ui.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Book_Id    => p.r_Number('book_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Staff_Kind     = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           name           = null,
           Operation_Kind = null,
           State          = null;
    update Hpr_Oper_Types
       set Company_Id    = null,
           Oper_Type_Id  = null,
           Oper_Group_Id = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null,
           Round_Model = null,
           State       = null;
    Uie.x(Hpd_Util.Get_Closest_Org_Unit_Id(null, null, null, null));
    Uie.x(Hpd_Util.Get_Closest_Job_Id(null, null, null, null));
    Uie.x(Href_Util.Get_Employee_Id(null, null, null));
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(null, null));
  
  end;

end Ui_Vhr64;
/
