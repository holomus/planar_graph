create or replace package Ui_Vhr285 is
  ----------------------------------------------------------------------------------------------------
  Function List_Vacations(i_Data Hashmap) return Json_Object_t;
end Ui_Vhr285;
/
create or replace package body Ui_Vhr285 is
  ----------------------------------------------------------------------------------------------------
  -- journal keys 
  ----------------------------------------------------------------------------------------------------
  c_Key_Journal_Id          constant varchar2(50) := 'journal_id';
  c_Key_Journal_Created_On  constant varchar2(50) := 'created_on';
  c_Key_Journal_Modified_On constant varchar2(50) := 'modified_on';
  c_Key_Journal_Number      constant varchar2(50) := 'journal_number';
  c_Key_Journal_Date        constant varchar2(50) := 'journal_date';
  c_Key_Journal_Name        constant varchar2(50) := 'journal_name';
  c_Key_Journal_Posted      constant varchar2(50) := 'journal_posted';

  ----------------------------------------------------------------------------------------------------
  -- vacation keys 
  ----------------------------------------------------------------------------------------------------
  c_Key_Vacations           constant varchar2(50) := 'vacations';
  c_Key_Timeoff_Id          constant varchar2(50) := 'timeoff_id';
  c_Key_Staff_Id            constant varchar2(50) := 'staff_id';
  c_Key_Employee_Id         constant varchar2(50) := 'employee_id';
  c_Key_Time_Kind_Id        constant varchar2(50) := 'time_kind_id';
  c_Key_Vacation_Begin_Date constant varchar2(50) := 'vacation_begin_date';
  c_Key_Vacation_End_Date   constant varchar2(50) := 'vacation_end_date';

  ----------------------------------------------------------------------------------------------------
  -- payroll keys 
  ----------------------------------------------------------------------------------------------------
  c_Key_Payroll_Amount             constant varchar2(50) := 'payroll_amount';
  c_Key_Payroll_Net_Amount         constant varchar2(50) := 'payroll_net_amount';
  c_Key_Payroll_Income_Tax_Amount  constant varchar2(50) := 'payroll_income_tax_amount';
  c_Key_Payroll_Pension_Tax_Amount constant varchar2(50) := 'payroll_pension_tax_amount';
  c_Key_Payroll_Social_Tax_Amount  constant varchar2(50) := 'payroll_social_tax_amount';

  ----------------------------------------------------------------------------------------------------
  -- charge keys
  ----------------------------------------------------------------------------------------------------
  c_Key_Charges           constant varchar2(50) := 'charges';
  c_Key_Charge_Begin_Date constant varchar2(50) := 'charge_begin_date';
  c_Key_Charge_End_Date   constant varchar2(50) := 'charge_end_date';
  c_Key_Charge_Amount     constant varchar2(50) := 'charge_amount';

  ----------------------------------------------------------------------------------------------------
  -- oper type keys 
  ----------------------------------------------------------------------------------------------------
  c_Key_Oper_Type_Id    constant varchar2(50) := 'oper_type_id';
  c_Key_Indicators      constant varchar2(50) := 'indicators';
  c_Key_Indicator_Id    constant varchar2(50) := 'indicator_id';
  c_Key_Indicator_Value constant varchar2(50) := 'indicator_value';

  ----------------------------------------------------------------------------------------------------
  Function Export_Data
  (
    i_Data            Hashmap,
    i_Include_Charges boolean := true
  ) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Journal_Ids Array_Number := Nvl(i_Data.o_Array_Number('journal_ids'), Array_Number());
    v_Count       number := v_Journal_Ids.Count;
  
    v_Vacation_Id number;
  
    v_Amount             number;
    v_Net_Amount         number;
    v_Income_Tax_Amount  number;
    v_Pension_Tax_Amount number;
    v_Social_Tax_Amount  number;
    v_Charge_Infos       varchar2(4000);
    v_Charges            Glist;
  
    v_Vacation  Gmap;
    v_Vacations Glist;
    v_Journal   Gmap;
    v_Journals  Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    v_Vacation_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                              i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Vacation);
  
    for r in (select *
                from (select *
                        from Hpd_Journals w
                       where w.Company_Id = v_Company_Id
                         and w.Filial_Id = v_Filial_Id
                         and w.Journal_Type_Id = v_Vacation_Id
                         and (v_Count = 0 or --                 
                             w.Journal_Id member of v_Journal_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Journal   := Gmap();
      v_Vacations := Glist();
    
      for Vac in (select t.Interval_Id,
                         Vc.Time_Kind_Id,
                         Jt.Timeoff_Id,
                         Jt.Staff_Id,
                         Jt.Employee_Id,
                         Jt.Begin_Date,
                         Jt.End_Date
                    from Hpd_Journal_Timeoffs Jt
                    join Hpd_Vacations Vc
                      on Vc.Company_Id = Jt.Company_Id
                     and Vc.Filial_Id = Jt.Filial_Id
                     and Vc.Timeoff_Id = Jt.Timeoff_Id
                    join Hpd_Timeoff_Intervals t
                      on t.Company_Id = Jt.Company_Id
                     and t.Filial_Id = Jt.Filial_Id
                     and t.Timeoff_Id = Jt.Timeoff_Id
                   where Jt.Company_Id = r.Company_Id
                     and Jt.Filial_Id = r.Filial_Id
                     and Jt.Journal_Id = r.Journal_Id)
      loop
        v_Vacation := Gmap();
      
        v_Vacation.Put(c_Key_Timeoff_Id, Vac.Timeoff_Id);
        v_Vacation.Put(c_Key_Staff_Id, Vac.Staff_Id);
        v_Vacation.Put(c_Key_Employee_Id, Vac.Employee_Id);
        v_Vacation.Put(c_Key_Time_Kind_Id, Vac.Time_Kind_Id);
        v_Vacation.Put(c_Key_Vacation_Begin_Date, Vac.Begin_Date);
        v_Vacation.Put(c_Key_Vacation_End_Date, Vac.End_Date);
      
        if i_Include_Charges and Vac.Interval_Id is not null then
          select sum(Bop.Amount),
                 sum(Bop.Net_Amount),
                 sum(Bop.Income_Tax_Amount),
                 sum(Bop.Pension_Payment_Amount),
                 sum(Bop.Social_Payment_Amount),
                 Json_Arrayagg(Json_Object(c_Key_Oper_Type_Id value Ch.Oper_Type_Id,
                                           c_Key_Charge_Begin_Date value
                                           to_char(Ch.Begin_Date, Href_Pref.c_Date_Format_Day),
                                           c_Key_Charge_End_Date value
                                           to_char(Ch.End_Date, Href_Pref.c_Date_Format_Day),
                                           c_Key_Charge_Amount value Round(Ch.Amount, 2),
                                           c_Key_Indicators value
                                           (select Json_Arrayagg(Json_Object(c_Key_Indicator_Id value
                                                                             p.Indicator_Id,
                                                                             c_Key_Indicator_Value
                                                                             value p.Indicator_Value))
                                              from Hpr_Charge_Indicators p
                                             where p.Company_Id = Ch.Company_Id
                                               and p.Filial_Id = Ch.Filial_Id
                                               and p.Charge_Id = Ch.Charge_Id)))
            into v_Amount,
                 v_Net_Amount,
                 v_Income_Tax_Amount,
                 v_Pension_Tax_Amount,
                 v_Social_Tax_Amount,
                 v_Charge_Infos
            from Hpr_Charges Ch
            left join Hpr_Book_Operations Op
              on Op.Company_Id = Ch.Company_Id
             and Op.Filial_Id = Ch.Filial_Id
             and Op.Charge_Id = Ch.Charge_Id
            left join Mpr_Book_Operations Bop
              on Bop.Company_Id = Op.Company_Id
             and Bop.Filial_Id = Op.Filial_Id
             and Bop.Operation_Id = Op.Operation_Id
           where Ch.Company_Id = r.Company_Id
             and Ch.Filial_Id = r.Filial_Id
             and Ch.Interval_Id = Vac.Interval_Id;
        
          v_Vacation.Put(c_Key_Payroll_Amount, v_Amount);
          v_Vacation.Put(c_Key_Payroll_Net_Amount, v_Net_Amount);
          v_Vacation.Put(c_Key_Payroll_Income_Tax_Amount, v_Income_Tax_Amount);
          v_Vacation.Put(c_Key_Payroll_Pension_Tax_Amount, v_Pension_Tax_Amount);
          v_Vacation.Put(c_Key_Payroll_Social_Tax_Amount, v_Social_Tax_Amount);
        
          v_Charges := Glist();
        
          if v_Charge_Infos is not null then
            v_Charges := Glist(Json_Array_t(v_Charge_Infos));
          end if;
        
          v_Vacation.Put(c_Key_Charges, v_Charges);
        end if;
      
        v_Vacations.Push(v_Vacation.Val);
      end loop;
    
      v_Journal.Put(c_Key_Journal_Id, r.Journal_Id);
      v_Journal.Put(c_Key_Journal_Created_On, r.Created_On);
      v_Journal.Put(c_Key_Journal_Modified_On, r.Modified_On);
      v_Journal.Put(c_Key_Journal_Number, r.Journal_Number);
      v_Journal.Put(c_Key_Journal_Date, r.Journal_Date);
      v_Journal.Put(c_Key_Journal_Name, r.Journal_Name);
      v_Journal.Put(c_Key_Journal_Posted, r.Posted);
    
      v_Journal.Put(c_Key_Vacations, v_Vacations);
    
      if v_Vacations.Count > 0 then
        v_Last_Id := r.Modified_Id;
      
        v_Journals.Push(v_Journal.Val);
      end if;
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Journals, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function List_Vacations(i_Data Hashmap) return Json_Object_t is
  begin
    return Export_Data(i_Data            => i_Data, --
                       i_Include_Charges => true);
  end;

end Ui_Vhr285;
/
