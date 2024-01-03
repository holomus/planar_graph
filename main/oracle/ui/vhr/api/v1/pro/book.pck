create or replace package Ui_Vhr662 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Books(p Hashmap) return Json_Object_t;
end Ui_Vhr662;
/
create or replace package body Ui_Vhr662 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Indicators
  (
    i_Currency_Id number,
    i_Book_Date   date,
    i_Charge_Id   number
  ) return Glist is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Indicator  Gmap;
    v_Indicators Glist := Glist();
  begin
    for r in (select q.Indicator_Id,
                     case
                        when p.Used = Href_Pref.c_Indicator_Used_Constantly then
                         Mk_Util.Calc_Amount(i_Company_Id  => v_Company_Id,
                                             i_Filial_Id   => v_Filial_Id,
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
                         Mk_Util.Calc_Amount(i_Company_Id  => v_Company_Id,
                                             i_Filial_Id   => v_Filial_Id,
                                             i_Currency_Id => i_Currency_Id,
                                             i_Rate_Date   => i_Book_Date,
                                             i_Amount_Base => q.Indicator_Value)
                        else
                         q.Indicator_Value
                      end as Indicator_Value
                from Hpr_Charges Ch
                join Hpr_Charge_Indicators q
                  on q.Company_Id = Ch.Company_Id
                 and q.Filial_Id = Ch.Filial_Id
                 and q.Charge_Id = Ch.Charge_Id
                join Href_Indicators p
                  on p.Company_Id = q.Company_Id
                 and p.Indicator_Id = q.Indicator_Id
               where Ch.Company_Id = v_Company_Id
                 and Ch.Filial_Id = v_Filial_Id
                 and Ch.Charge_Id = i_Charge_Id)
    loop
      v_Indicator := Gmap();
    
      v_Indicator.Put('indicator_id', r.Indicator_Id);
      v_Indicator.Put('indicator_value', r.Indicator_Value);
    
      v_Indicators.Push(v_Indicator.Val);
    end loop;
  
    return v_Indicators;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function List_Book_Operations(i_Book_Id number) return Glist is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Operation  Gmap;
    v_Operations Glist := Glist();
  begin
    for r in (select k.Charge_Id,
                     k.Staff_Id,
                     Pd.Iapa,
                     Pd.Npin,
                     (select Mr.Tin
                        from Mr_Person_Details Mr
                       where Mr.Company_Id = Pd.Company_Id
                         and Mr.Person_Id = Pd.Person_Id) Tin,
                     Hpd_Util.Get_Closest_Robot_Id(i_Company_Id => k.Company_Id,
                                                   i_Filial_Id  => k.Filial_Id,
                                                   i_Staff_Id   => k.Staff_Id,
                                                   i_Period     => Nvl(Ch.End_Date, Trunc(sysdate))) Robot_Id,
                     Hpd_Util.Get_Closest_Division_Id(i_Company_Id => k.Company_Id,
                                                      i_Filial_Id  => k.Filial_Id,
                                                      i_Staff_Id   => k.Staff_Id,
                                                      i_Period     => Nvl(Ch.End_Date, Trunc(sysdate))) Division_Id,
                     Hpd_Util.Get_Closest_Job_Id(i_Company_Id => k.Company_Id,
                                                 i_Filial_Id  => k.Filial_Id,
                                                 i_Staff_Id   => k.Staff_Id,
                                                 i_Period     => Nvl(Ch.End_Date, Trunc(sysdate))) Job_Id,
                     q.Oper_Type_Id,
                     Ch.Begin_Date,
                     Ch.End_Date,
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
               where q.Company_Id = v_Company_Id
                 and q.Filial_Id = v_Filial_Id
                 and q.Book_Id = i_Book_Id
               order by q.Order_No)
    loop
      v_Operation := Gmap();
    
      v_Operation.Put('charge_id', r.Charge_Id);
      v_Operation.Put('staff_id', r.Staff_Id);
      v_Operation.Put('iapa', r.Iapa);
      v_Operation.Put('npin', r.Npin);
      v_Operation.Put('tin', r.Tin);
      v_Operation.Put('robot_id', r.Robot_Id);
      v_Operation.Put('division_id', r.Division_Id);
      v_Operation.Put('job_id', r.Job_Id);
      v_Operation.Put('oper_type_id', r.Oper_Type_Id);
      v_Operation.Put('begin_date', r.Begin_Date);
      v_Operation.Put('end_date', r.End_Date);
      v_Operation.Put('subfilial_id', r.Subfilial_Id);
      v_Operation.Put('subfilial_name', r.Subfilial_Name);
      v_Operation.Put('note', r.Note);
      v_Operation.Put('amount', r.Amount);
      v_Operation.Put('net_amount', r.Net_Amount);
      v_Operation.Put('income_tax_amount', r.Income_Tax_Amount);
      v_Operation.Put('pension_payment_amount', r.Pension_Payment_Amount);
      v_Operation.Put('social_payment_amount', r.Social_Payment_Amount);
      v_Operation.Put('operation_id', r.Operation_Id);
      v_Operation.Put('operation_kind', r.Operation_Kind);
    
      v_Operations.Push(v_Operation.Val);
    end loop;
  
    return v_Operations;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function List_Books(p Hashmap) return Json_Object_t is
    v_Month    date := Trunc(p.o_Date('month'), 'mon');
    v_Book_Ids Array_Number := Nvl(p.o_Array_Number('book_ids'), Array_Number());
    v_Count    number := v_Book_Ids.Count;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Book  Gmap;
    v_Books Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    for r in (select q.Book_Id,
                     q.Book_Number,
                     q.Book_Date,
                     q.Book_Name,
                     q.Month,
                     q.Division_Id,
                     q.Currency_Id,
                     (select Cur.Name
                        from Mk_Currencies Cur
                       where Cur.Company_Id = q.Company_Id
                         and Cur.Currency_Id = q.Currency_Id) as Currency_Name,
                     q.Posted,
                     q.Note,
                     q.c_Accrued_Amount,
                     q.c_Accrued_Amount_Base,
                     q.c_Deducted_Amount,
                     q.c_Deducted_Amount_Base,
                     q.c_Income_Tax_Amount,
                     q.c_Pension_Payment_Amount,
                     q.c_Social_Payment_Amount,
                     w.Book_Type_Id,
                     (select Bt.Name
                        from Hpr_Book_Types Bt
                       where Bt.Company_Id = w.Company_Id
                         and Bt.Book_Type_Id = w.Book_Type_Id) as Book_Type_Name,
                     w.Modified_Id
                from Mpr_Books q
                join Hpr_Books w
                  on w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Book_Id = q.Book_Id
                 and w.Modified_Id > v_Start_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and (v_Count = 0 or q.Book_Id member of v_Book_Ids)
                 and (v_Month is null or v_Month = q.Month)
               order by w.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Book := Gmap();
      v_Book.Put('book_id', r.Book_Id);
      v_Book.Put('book_number', r.Book_Number);
      v_Book.Put('book_date', r.Book_Date);
      v_Book.Put('book_name', r.Book_Name);
      v_Book.Put('month', r.Month);
      v_Book.Put('division_id', r.Division_Id);
      v_Book.Put('currency_id', r.Currency_Id);
      v_Book.Put('currency_name', r.Currency_Name);
      v_Book.Put('posted', r.Posted);
      v_Book.Put('c_accrued_amount', r.c_Accrued_Amount);
      v_Book.Put('c_accrued_amount_base', r.c_Accrued_Amount_Base);
      v_Book.Put('c_deducted_amount', r.c_Deducted_Amount);
      v_Book.Put('c_deducted_amount_base', r.c_Deducted_Amount_Base);
      v_Book.Put('c_income_tax_amount', r.c_Income_Tax_Amount);
      v_Book.Put('c_pension_payment_amount', r.c_Pension_Payment_Amount);
      v_Book.Put('c_social_payment_amount', r.c_Social_Payment_Amount);
      v_Book.Put('note', r.Note);
    
      v_Book.Put('book_type_id', r.Book_Type_Id);
      v_Book.Put('book_type_name', r.Book_Type_Name);
    
      v_Book.Put('operations', List_Book_Operations(r.Book_Id));
    
      v_Last_Id := r.Modified_Id;
    
      v_Books.Push(v_Book.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Books, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr662;
/
