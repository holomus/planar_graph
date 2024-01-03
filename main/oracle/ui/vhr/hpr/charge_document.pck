create or replace package Ui_Vhr612 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Oper_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Currencies return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Employee_Wage(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Staffs(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Blocked_Staffs(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr612;
/
create or replace package body Ui_Vhr612 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Month  date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
    v_Query  varchar2(32767);
    v_Params Hashmap;
  begin
    v_Query := 'select q.*
                  from href_staffs q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.state = ''A''
                   and q.hiring_date <= :end_date
                   and nvl(q.dismissal_date, :begin_date) >= :begin_date
                   and (:division_id is null or q.division_id = :division_id)
                   and uit_hrm.access_to_hidden_salary_job(i_job_id      => hpd_util.get_closest_job_id(q.company_id,
                                                                                                        q.filial_id,
                                                                                                        q.staff_id,
                                                                                                        :end_date),
                                                           i_employee_id => q.employee_id) = ''Y''';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'begin_date',
                             v_Month,
                             'end_date',
                             Last_Day(v_Month),
                             'division_id',
                             p.o_Number('division_id'));
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query ||
                 ' and (st.employee_id = :user_id or
                   hpd_util.get_closest_division_id(q.company_id, q.filial_id, q.staff_id, :end_date) of :division_ids)';
    
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
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            w.oper_group_id
                       from mpr_oper_types q
                       join hpr_oper_types w
                         on w.company_id = q.company_id
                        and w.oper_type_id = q.oper_type_id
                        and w.estimation_type = :estimation_type
                      where q.company_id = :company_id
                        and q.operation_kind = :operation_kind
                        and q.state = ''A''',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'operation_kind',
                                 p.r_Varchar2('operation_kind'),
                                 'estimation_type',
                                 Hpr_Pref.c_Estimation_Type_Entered));
  
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
    q.Varchar2_Field('name', 'round_model');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id)));
    Result.Put('estimation_type_entered', Hpr_Pref.c_Estimation_Type_Entered);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Staffs(p Hashmap) return Hashmap is
    v_Month_Begin          date := p.r_Date('month_begin');
    v_Month_End            date := p.r_Date('month_end');
    v_Division_Id          number := p.o_Number('division_id');
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Staff_Ids            Array_Number := Nvl(p.o_Array_Number('staff_ids'), Array_Number());
    v_Staff_Cnt            number := v_Staff_Ids.Count;
    v_Division_Ids         Array_Number;
    v_Staffs               Matrix_Varchar2;
    result                 Hashmap := Hashmap();
  begin
    if v_Access_All_Employees = 'N' then
      v_Division_Ids := Uit_Href.Get_All_Subordinate_Divisions;
    end if;
  
    select Array_Varchar2(q.Staff_Id,
                          (select w.Name
                             from Mr_Natural_Persons w
                            where w.Company_Id = q.Company_Id
                              and w.Person_Id = q.Employee_Id),
                          Nvl(Hpd_Util.Get_Closest_Wage(i_Company_Id => q.Company_Id,
                                                        i_Filial_Id  => q.Filial_Id,
                                                        i_Staff_Id   => q.Staff_Id,
                                                        i_Period     => v_Month_End),
                              0))
      bulk collect
      into v_Staffs
      from Href_Staffs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and (v_Staff_Cnt = 0 or --
           q.Staff_Id member of v_Staff_Ids)
       and (v_Division_Id is null or q.Division_Id = v_Division_Id)
       and q.State = 'A'
       and q.Hiring_Date <= v_Month_End
       and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Month_Begin)
       and Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => Ui.Company_Id,
                                                                                            i_Filial_Id  => Ui.Filial_Id,
                                                                                            i_Staff_Id   => q.Staff_Id,
                                                                                            i_Period     => Least(v_Month_End,
                                                                                                                  Nvl(q.Dismissal_Date,
                                                                                                                      v_Month_End))),
                                               i_Employee_Id => q.Employee_Id) = 'Y'
       and (v_Access_All_Employees = 'Y' or --
           Hpd_Util.Get_Closest_Division_Id(i_Company_Id => q.Company_Id,
                                             i_Filial_Id  => q.Filial_Id,
                                             i_Staff_Id   => q.Staff_Id,
                                             i_Period     => Least(v_Month_End,
                                                                   Nvl(q.Dismissal_Date, v_Month_End)))
            member of v_Division_Ids);
  
    Result.Put('staffs', Fazo.Zip_Matrix(v_Staffs));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Blocked_Staffs(p Hashmap) return Hashmap is
    v_Month_Begin date := p.r_Date('month_begin');
    v_Month_End   date := p.r_Date('month_end');
    v_Staff_Ids   Array_Number;
    result        Hashmap := Hashmap();
  begin
    select q.Staff_Id
      bulk collect
      into v_Staff_Ids
      from Href_Staffs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Hiring_Date <= v_Month_End
       and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Month_Begin)
       and Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Hpd_Util.Get_Closest_Job_Id(i_Company_Id => Ui.Company_Id,
                                                                                            i_Filial_Id  => Ui.Filial_Id,
                                                                                            i_Staff_Id   => q.Staff_Id,
                                                                                            i_Period     => Least(v_Month_End,
                                                                                                                  Nvl(q.Dismissal_Date,
                                                                                                                      v_Month_End))),
                                               i_Employee_Id => q.Employee_Id) = 'N';
  
    Result.Put('staff_ids', v_Staff_Ids);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Employee_Wage(p Hashmap) return Hashmap is
    v_Wage number;
  begin
    v_Wage := Nvl(Hpd_Util.Get_Closest_Wage(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Staff_Id   => p.r_Number('staff_id'),
                                            i_Period     => Last_Day(p.r_Date('month'))),
                  0);
  
    return Fazo.Zip_Map('wage', v_Wage);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Operations
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number,
    i_Date        date
  ) return Matrix_Varchar2 is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Operation_Id,
                           q.Staff_Id,
                           (select w.Name -- staff name
                              from Mr_Natural_Persons w
                             where w.Company_Id = i_Company_Id
                               and w.Person_Id = (select St.Employee_Id
                                                    from Href_Staffs St
                                                   where St.Company_Id = i_Company_Id
                                                     and St.Filial_Id = i_Filial_Id
                                                     and St.Staff_Id = q.Staff_Id)),
                           Ch.Charge_Id,
                           Ch.Oper_Type_Id,
                           (select Ot.Name -- oper type name
                              from Mpr_Oper_Types Ot
                             where Ot.Company_Id = i_Company_Id
                               and Ot.Oper_Type_Id = Ch.Oper_Type_Id),
                           case
                             when Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Ch.Job_Id,
                                                                      i_Employee_Id => St.Employee_Id) = 'Y' then
                              q.Amount
                             else
                              -1
                           end,
                           q.Note,
                           Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Ch.Job_Id,
                                                               i_Employee_Id => St.Employee_Id),
                           case
                             when Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id      => Ch.Job_Id,
                                                                      i_Employee_Id => St.Employee_Id) = 'Y' then
                              Nvl(Hpd_Util.Get_Closest_Wage(i_Company_Id => i_Company_Id,
                                                            i_Filial_Id  => i_Filial_Id,
                                                            i_Staff_Id   => q.Staff_Id,
                                                            i_Period     => i_Date),
                                  0)
                             else
                              -1
                           end)
      bulk collect
      into v_Matrix
      from Hpr_Charge_Document_Operations q
      join Hpr_Charges Ch
        on Ch.Company_Id = q.Company_Id
       and Ch.Filial_Id = q.Filial_Id
       and Ch.Doc_Oper_Id = q.Operation_Id
      join Href_Staffs St
        on St.Company_Id = q.Company_Id
       and St.Filial_Id = q.Filial_Id
       and St.Staff_Id = q.Staff_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Document_Id = i_Document_Id;
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    r_Currency Mk_Currencies%rowtype;
    v_Month    date := Add_Months(Trunc(sysdate, 'MON'), -1);
    result     Hashmap;
  begin
    r_Currency := z_Mk_Currencies.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Currency_Id => Mk_Pref.Base_Currency(i_Company_Id => Ui.Company_Id,
                                                                              i_Filial_Id  => Ui.Filial_Id));
  
    result := Fazo.Zip_Map('document_date',
                           Trunc(sysdate),
                           'month',
                           to_char(v_Month, Href_Pref.c_Date_Format_Month),
                           'document_kind',
                           p.r_Varchar2('document_kind'),
                           'currency_id',
                           r_Currency.Currency_Id,
                           'currency_name',
                           r_Currency.Name);
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    result     Hashmap;
    r_Currency Mk_Currencies%rowtype;
    r_Data     Hpr_Charge_Documents%rowtype;
  begin
    r_Data := z_Hpr_Charge_Documents.Load(i_Company_Id  => Ui.Company_Id,
                                          i_Filial_Id   => Ui.Filial_Id,
                                          i_Document_Id => p.r_Number('document_id'));
  
    result := z_Hpr_Charge_Documents.To_Map(r_Data,
                                            z.Document_Id,
                                            z.Document_Number,
                                            z.Document_Date,
                                            z.Document_Name,
                                            z.Posted,
                                            z.Oper_Type_Id,
                                            z.Document_Kind,
                                            z.Division_Id,
                                            z.Currency_Id);
  
    if r_Data.Oper_Type_Id is not null then
      Result.Put('oper_type_name',
                 z_Mpr_Oper_Types.Load(i_Company_Id => r_Data.Company_Id, --
                 i_Oper_Type_Id => r_Data.Oper_Type_Id).Name);
    end if;
  
    r_Currency := z_Mk_Currencies.Load(i_Company_Id  => r_Data.Company_Id,
                                       i_Currency_Id => r_Data.Currency_Id);
  
    Result.Put('currency_name', r_Currency.Name);
    Result.Put('month', to_char(r_Data.Month, Href_Pref.c_Date_Format_Month));
    Result.Put('operations',
               Fazo.Zip_Matrix(Get_Operations(i_Company_Id  => r_Data.Company_Id,
                                              i_Filial_Id   => r_Data.Filial_Id,
                                              i_Document_Id => r_Data.Document_Id,
                                              i_Date        => Last_Day(r_Data.Month))));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    i_Document_Id number,
    p             Hashmap
  ) is
    p_Charge_Document Hpr_Pref.Charge_Document_Rt;
    v_Oper_Type_Id    number := p.o_Number('oper_type_id');
    v_Operations      Arraylist := p.r_Arraylist('operations');
    v_Operation_Id    number;
    v_Charge_Id       number;
    v_Amount          number;
    v_Operation       Hashmap;
    r_Operation       Hpr_Charge_Document_Operations%rowtype;
  begin
    Hpr_Util.Charge_Document_New(o_Charge_Document => p_Charge_Document,
                                 i_Company_Id      => Ui.Company_Id,
                                 i_Filial_Id       => Ui.Filial_Id,
                                 i_Document_Id     => i_Document_Id,
                                 i_Document_Number => p.o_Varchar2('document_number'),
                                 i_Document_Date   => p.r_Date('document_date'),
                                 i_Document_Name   => p.o_Varchar2('document_name'),
                                 i_Month           => p.r_Date('month',
                                                               Href_Pref.c_Date_Format_Month),
                                 i_Oper_Type_Id    => v_Oper_Type_Id,
                                 i_Currency_Id     => p.r_Number('currency_id'),
                                 i_Division_Id     => p.o_Number('division_id'),
                                 i_Document_Kind   => p.r_Varchar2('document_kind'));
  
    for i in 1 .. v_Operations.Count
    loop
      v_Operation := Treat(v_Operations.r_Hashmap(i) as Hashmap);
    
      v_Amount       := v_Operation.o_Number('amount');
      v_Operation_Id := v_Operation.o_Number('operation_id');
      v_Charge_Id    := v_Operation.o_Number('charge_id');
    
      continue when v_Amount is null;
    
      if v_Amount = -1 then
        if not z_Hpr_Charge_Document_Operations.Exist(i_Company_Id   => p_Charge_Document.Company_Id,
                                                      i_Filial_Id    => p_Charge_Document.Filial_Id,
                                                      i_Operation_Id => v_Operation_Id,
                                                      o_Row          => r_Operation) then
          continue;
        end if;
      
        v_Amount := r_Operation.Amount;
      end if;
    
      if v_Operation_Id is null then
        v_Operation_Id := Hpr_Next.Charge_Document_Operation_Id;
      end if;
    
      if v_Charge_Id is null then
        v_Charge_Id := Hpr_Next.Charge_Id;
      end if;
    
      if p_Charge_Document.Oper_Type_Id is null then
        v_Oper_Type_Id := v_Operation.r_Number('oper_type_id');
      end if;
    
      Hpr_Util.Charge_Document_Add_Operation(o_Charge_Document => p_Charge_Document,
                                             i_Operation_Id    => v_Operation_Id,
                                             i_Staff_Id        => v_Operation.r_Number('staff_id'),
                                             i_Charge_Id       => v_Charge_Id,
                                             i_Oper_Type_Id    => v_Oper_Type_Id,
                                             i_Amount          => v_Amount,
                                             i_Note            => v_Operation.o_Varchar2('note'));
    end loop;
  
    Hpr_Api.Charge_Document_Save(p_Charge_Document);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hpr_Api.Charge_Document_Post(i_Company_Id   => p_Charge_Document.Company_Id,
                                   i_Filial_Id    => p_Charge_Document.Filial_Id,
                                   i_Documentr_Id => p_Charge_Document.Document_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(Hpr_Next.Charge_Document_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Document Hpr_Charge_Documents%rowtype;
  begin
    r_Document := z_Hpr_Charge_Documents.Load(i_Company_Id  => Ui.Company_Id,
                                              i_Filial_Id   => Ui.Filial_Id,
                                              i_Document_Id => p.r_Number('document_id'));
  
    if r_Document.Posted = 'Y' then
      Hpr_Api.Charge_Document_Unpost(i_Company_Id   => r_Document.Company_Id,
                                     i_Filial_Id    => r_Document.Filial_Id,
                                     i_Documentr_Id => r_Document.Document_Id);
    end if;
  
    save(r_Document.Document_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validaton is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Staff_Kind     = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Division_Id    = null,
           Job_Id         = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mpr_Oper_Types
       set Company_Id     = null,
           Oper_Type_Id   = null,
           Operation_Kind = null,
           name           = null;
    update Hpr_Oper_Types
       set Company_Id      = null,
           Oper_Type_Id    = null,
           Estimation_Type = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null,
           Round_Model = null,
           State       = null;
  
    Uie.x(Hpd_Util.Get_Closest_Division_Id(i_Company_Id => null,
                                           i_Filial_Id  => null,
                                           i_Staff_Id   => null,
                                           i_Period     => null));
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(i_Job_Id => null, i_Employee_Id => null));
  end;

end Ui_Vhr612;
/
