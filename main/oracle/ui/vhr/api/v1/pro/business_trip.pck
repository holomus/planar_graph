create or replace package Ui_Vhr289 is
  ----------------------------------------------------------------------------------------------------
  Function List_Business_Trips(i_Data Hashmap) return Json_Object_t;
end Ui_Vhr289;
/
create or replace package body Ui_Vhr289 is
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
  -- business trip keys
  ----------------------------------------------------------------------------------------------------
  c_Key_Business_Trips  constant varchar2(50) := 'business_trips';
  c_Key_Timeoff_Id      constant varchar2(50) := 'timeoff_id';
  c_Key_Staff_Id        constant varchar2(50) := 'staff_id';
  c_Key_Employee_Id     constant varchar2(50) := 'employee_id';
  c_Key_Begin_Date      constant varchar2(50) := 'trip_begin_date';
  c_Key_End_Date        constant varchar2(50) := 'trip_end_date';
  c_Key_Time_Kind_Id    constant varchar2(50) := 'time_kind_id';
  c_Key_Region_Id       constant varchar2(50) := 'region_id';
  c_Key_Region_Ids      constant varchar2(50) := 'region_ids';
  c_Key_Legal_Person_Id constant varchar2(50) := 'legal_person_id';
  c_Key_Reason_Id       constant varchar2(50) := 'trip_reason_id';

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
  
    v_Trip_Id    number;
    v_Trip_Tk_Id number;
    r_Trip_Tk    Htt_Time_Kinds%rowtype;
  
    v_Amount             number;
    v_Net_Amount         number;
    v_Income_Tax_Amount  number;
    v_Pension_Tax_Amount number;
    v_Social_Tax_Amount  number;
    v_Region_Ids         Array_Number;
    v_Charge_Infos       varchar2(4000);
    v_Charges            Glist;
  
    v_Trip     Gmap;
    v_Trips    Glist;
    v_Journal  Gmap;
    v_Journals Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    v_Trip_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                          i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Business_Trip);
  
    v_Trip_Tk_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                          i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Trip);
  
    r_Trip_Tk := z_Htt_Time_Kinds.Load(i_Company_Id => v_Company_Id, i_Time_Kind_Id => v_Trip_Tk_Id);
  
    for t in (select *
                from (select *
                        from Hpd_Journals w
                       where w.Company_Id = v_Company_Id
                         and w.Filial_Id = v_Filial_Id
                         and w.Journal_Type_Id = v_Trip_Id
                         and (v_Count = 0 or --                 
                             w.Journal_Id member of v_Journal_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Trips := Glist();
    
      for c in (select j.Timeoff_Id,
                       j.Staff_Id,
                       j.Employee_Id,
                       j.Begin_Date  Begin_Date,
                       j.End_Date    End_Date,
                       b.Person_Id   Legal_Person_Id,
                       b.Reason_Id,
                       b.Note        Trip_Note,
                       k.Interval_Id
                  from Hpd_Journal_Timeoffs j
                  join Hpd_Business_Trips b
                    on b.Company_Id = j.Company_Id
                   and b.Filial_Id = j.Filial_Id
                   and b.Timeoff_Id = j.Timeoff_Id
                  join Hpd_Timeoff_Intervals k
                    on k.Company_Id = j.Company_Id
                   and k.Filial_Id = j.Filial_Id
                   and k.Timeoff_Id = j.Timeoff_Id
                 where j.Company_Id = t.Company_Id
                   and j.Filial_Id = t.Filial_Id
                   and j.Journal_Id = t.Journal_Id)
      loop
        select r.Region_Id
          bulk collect
          into v_Region_Ids
          from Hpd_Business_Trip_Regions r
         where r.Company_Id = t.Company_Id
           and r.Filial_Id = t.Filial_Id
           and r.Timeoff_Id = c.Timeoff_Id
         order by r.Order_No;
      
        v_Trip := Gmap();
      
        v_Trip.Put(c_Key_Timeoff_Id, c.Timeoff_Id);
        v_Trip.Put(c_Key_Staff_Id, c.Staff_Id);
        v_Trip.Put(c_Key_Employee_Id, c.Employee_Id);
        v_Trip.Put(c_Key_Begin_Date, c.Begin_Date);
        v_Trip.Put(c_Key_End_Date, c.End_Date);
        v_Trip.Put(c_Key_Region_Id, v_Region_Ids(1));
        v_Trip.Put(c_Key_Region_Ids, v_Region_Ids);
        v_Trip.Put(c_Key_Legal_Person_Id, c.Legal_Person_Id);
        v_Trip.Put(c_Key_Reason_Id, c.Reason_Id);
        v_Trip.Put(c_Key_Time_Kind_Id, r_Trip_Tk.Time_Kind_Id);
      
        if i_Include_Charges and c.Interval_Id is not null then
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
           where Ch.Company_Id = t.Company_Id
             and Ch.Filial_Id = t.Filial_Id
             and Ch.Interval_Id = c.Interval_Id;
        
          v_Trip.Put(c_Key_Payroll_Amount, v_Amount);
          v_Trip.Put(c_Key_Payroll_Net_Amount, v_Net_Amount);
          v_Trip.Put(c_Key_Payroll_Income_Tax_Amount, v_Income_Tax_Amount);
          v_Trip.Put(c_Key_Payroll_Pension_Tax_Amount, v_Pension_Tax_Amount);
          v_Trip.Put(c_Key_Payroll_Social_Tax_Amount, v_Social_Tax_Amount);
        
          v_Charges := Glist();
        
          if v_Charge_Infos is not null then
            v_Charges := Glist(Json_Array_t(v_Charge_Infos));
          end if;
        
          v_Trip.Put(c_Key_Charges, v_Charges);
        end if;
      
        v_Trips.Push(v_Trip.Val);
      end loop;
    
      v_Journal := Gmap();
    
      v_Journal.Put(c_Key_Journal_Id, t.Journal_Id);
      v_Journal.Put(c_Key_Journal_Created_On, t.Created_On);
      v_Journal.Put(c_Key_Journal_Modified_On, t.Modified_On);
      v_Journal.Put(c_Key_Journal_Number, t.Journal_Number);
      v_Journal.Put(c_Key_Journal_Date, t.Journal_Date);
      v_Journal.Put(c_Key_Journal_Name, t.Journal_Name);
      v_Journal.Put(c_Key_Journal_Posted, t.Posted);
    
      v_Journal.Put(c_Key_Business_Trips, v_Trips);
    
      if v_Trips.Count > 0 then
        v_Last_Id := t.Modified_Id;
      
        v_Journals.Push(v_Journal.Val);
      end if;
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Journals, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function List_Business_Trips(i_Data Hashmap) return Json_Object_t is
  begin
    return Export_Data(i_Data            => i_Data, --
                       i_Include_Charges => true);
  end;

end Ui_Vhr289;
/
