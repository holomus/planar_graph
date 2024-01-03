create or replace package Ui_Vhr281 is
  ----------------------------------------------------------------------------------------------------
  Function List_Hirings(i_Data Hashmap) return Json_Object_t;
end Ui_Vhr281;
/
create or replace package body Ui_Vhr281 is
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
  -- hiring keys
  ---------------------------------------------------------------------------------------------------- 
  c_Key_Hirings              constant varchar2(50) := 'hirings';
  c_Key_Hiring_Date          constant varchar2(50) := 'hiring_date';
  c_Key_Trial_Period         constant varchar2(50) := 'trial_period';
  c_Key_Page_Id              constant varchar2(50) := 'page_id';
  c_Key_Staff_Id             constant varchar2(50) := 'staff_id';
  c_Key_Employee_Id          constant varchar2(50) := 'employee_id';
  c_Key_Position_Id          constant varchar2(50) := 'position_id';
  c_Key_Division_Id          constant varchar2(50) := 'division_id';
  c_Key_Job_Id               constant varchar2(50) := 'job_id';
  c_Key_Rank_Id              constant varchar2(50) := 'rank_id';
  c_Key_Schedule_Id          constant varchar2(50) := 'schedule_id';
  c_Key_Fte_Id               constant varchar2(50) := 'fte_id';
  c_Key_Fte_Value            constant varchar2(50) := 'fte_value';
  c_Key_Employment_Type_Code constant varchar2(50) := 'employment_type_code';
  c_Key_Employment_Type_Name constant varchar2(50) := 'employment_type_name';
  c_Key_Vacation_Days_Limit  constant varchar2(50) := 'vacation_days_limit';

  ---------------------------------------------------------------------------------------------------- 
  -- contract keys
  ---------------------------------------------------------------------------------------------------- 
  c_Key_Contract_Number            constant varchar2(50) := 'contract_number';
  c_Key_Contract_Date              constant varchar2(50) := 'contract_date';
  c_Key_Fixed_Term                 constant varchar2(50) := 'contract_fixed_term';
  c_Key_Contract_Expiry_Date       constant varchar2(50) := 'contract_expiry_date';
  c_Key_Fixed_Term_Base_Id         constant varchar2(50) := 'fixed_term_base_id';
  c_Key_Fixed_Term_Concluding_Term constant varchar2(50) := 'fixed_term_concluding_term';
  c_Key_Hiring_Conditions          constant varchar2(50) := 'contract_hiring_conditions';
  c_Key_Other_Conditions           constant varchar2(50) := 'contract_other_conditions';
  c_Key_Workplace_Equipment        constant varchar2(50) := 'contract_workplace_equipment';
  c_Key_Representative_Basis       constant varchar2(50) := 'contract_representative_basis';

  ----------------------------------------------------------------------------------------------------
  -- oper type keys 
  ----------------------------------------------------------------------------------------------------
  c_Key_Oper_Types      constant varchar2(50) := 'oper_types';
  c_Key_Oper_Type_Id    constant varchar2(50) := 'oper_type_id';
  c_Key_Indicators      constant varchar2(50) := 'indicators';
  c_Key_Indicator_Id    constant varchar2(50) := 'indicator_id';
  c_Key_Indicator_Value constant varchar2(50) := 'indicator_value';

  ----------------------------------------------------------------------------------------------------
  Function Export_Data
  (
    i_Data               Hashmap,
    i_Include_Oper_Types boolean := true,
    i_Include_Contract   boolean := true
  ) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Journal_Ids Array_Number := Nvl(i_Data.o_Array_Number('journal_ids'), Array_Number());
    v_Count       number := v_Journal_Ids.Count;
  
    v_Hiring_Id          number;
    v_Hiring_Multiple_Id number;
  
    v_Journal    Gmap;
    v_Journals   Glist := Glist();
    v_Oper_Type  Gmap;
    v_Oper_Types Glist := Glist();
    v_Indicators Glist;
    v_Hiring     Gmap;
    v_Hirings    Glist;
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    v_Hiring_Id          := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                     i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring);
    v_Hiring_Multiple_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                     i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple);
  
    for r in (select *
                from (select *
                        from Hpd_Journals w
                       where w.Company_Id = v_Company_Id
                         and w.Filial_Id = v_Filial_Id
                         and w.Journal_Type_Id in (v_Hiring_Id, v_Hiring_Multiple_Id)
                         and (v_Count = 0 or --                 
                             w.Journal_Id member of v_Journal_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Journal := Gmap();
      v_Hirings := Glist();
    
      for Hrg in (select q.Page_Id,
                         q.Staff_Id,
                         q.Employee_Id,
                         w.Hiring_Date,
                         w.Trial_Period,
                         m.Robot_Id,
                         m.Division_Id,
                         m.Job_Id,
                         m.Rank_Id,
                         s.Schedule_Id,
                         m.Fte_Id,
                         m.Fte,
                         m.Employment_Type,
                         Pl.Days_Limit,
                         c.Contract_Number,
                         c.Contract_Date,
                         c.Fixed_Term,
                         c.Expiry_Date,
                         c.Fixed_Term_Base_Id,
                         c.Concluding_Term,
                         c.Hiring_Conditions,
                         c.Other_Conditions,
                         c.Workplace_Equipment,
                         c.Representative_Basis
                    from Hpd_Journal_Pages q
                    join Hpd_Hirings w
                      on w.Company_Id = q.Company_Id
                     and w.Filial_Id = q.Filial_Id
                     and w.Page_Id = q.Page_Id
                    left join Hpd_Page_Robots m
                      on m.Company_Id = q.Company_Id
                     and m.Filial_Id = q.Filial_Id
                     and m.Page_Id = q.Page_Id
                    left join Hpd_Page_Schedules s
                      on s.Company_Id = q.Company_Id
                     and s.Filial_Id = q.Filial_Id
                     and s.Page_Id = q.Page_Id
                    left join Hpd_Page_Vacation_Limits Pl
                      on Pl.Company_Id = q.Company_Id
                     and Pl.Filial_Id = q.Filial_Id
                     and Pl.Page_Id = q.Page_Id
                    left join Hpd_Page_Contracts c
                      on c.Company_Id = q.Company_Id
                     and c.Filial_Id = q.Filial_Id
                     and c.Page_Id = q.Page_Id
                   where q.Company_Id = r.Company_Id
                     and q.Filial_Id = r.Filial_Id
                     and q.Journal_Id = r.Journal_Id)
      loop
        v_Hiring := Gmap();
      
        v_Hiring.Put(c_Key_Page_Id, Hrg.Page_Id);
        v_Hiring.Put(c_Key_Hiring_Date, Hrg.Hiring_Date);
        v_Hiring.Put(c_Key_Trial_Period, Hrg.Trial_Period);
        v_Hiring.Put(c_Key_Staff_Id, Hrg.Staff_Id);
        v_Hiring.Put(c_Key_Employee_Id, Hrg.Employee_Id);
        v_Hiring.Put(c_Key_Position_Id, Hrg.Robot_Id);
        v_Hiring.Put(c_Key_Division_Id, Hrg.Division_Id);
        v_Hiring.Put(c_Key_Job_Id, Hrg.Job_Id);
        v_Hiring.Put(c_Key_Rank_Id, Hrg.Rank_Id);
        v_Hiring.Put(c_Key_Schedule_Id, Hrg.Schedule_Id);
        v_Hiring.Put(c_Key_Fte_Id, Hrg.Fte_Id);
        v_Hiring.Put(c_Key_Fte_Value, Hrg.Fte);
        v_Hiring.Put(c_Key_Employment_Type_Code, Hrg.Employment_Type);
        v_Hiring.Put(c_Key_Employment_Type_Name, Hpd_Util.t_Employment_Type(Hrg.Employment_Type));
        v_Hiring.Put(c_Key_Vacation_Days_Limit, Hrg.Days_Limit);
      
        if i_Include_Contract then
          v_Hiring.Put(c_Key_Contract_Number, Hrg.Contract_Number);
          v_Hiring.Put(c_Key_Contract_Date, Hrg.Contract_Date);
          v_Hiring.Put(c_Key_Fixed_Term, Hrg.Fixed_Term);
          v_Hiring.Put(c_Key_Contract_Expiry_Date, Hrg.Expiry_Date);
          v_Hiring.Put(c_Key_Fixed_Term_Base_Id, Hrg.Fixed_Term_Base_Id);
          v_Hiring.Put(c_Key_Fixed_Term_Concluding_Term, Hrg.Concluding_Term);
          v_Hiring.Put(c_Key_Hiring_Conditions, Hrg.Hiring_Conditions);
          v_Hiring.Put(c_Key_Other_Conditions, Hrg.Other_Conditions);
          v_Hiring.Put(c_Key_Workplace_Equipment, Hrg.Workplace_Equipment);
          v_Hiring.Put(c_Key_Representative_Basis, Hrg.Representative_Basis);
        end if;
      
        if i_Include_Oper_Types then
          v_Oper_Types := Glist();
        
          for Opt in (select q.Oper_Type_Id,
                             (select Json_Arrayagg(Json_Object(c_Key_Indicator_Id value
                                                               Pi.Indicator_Id,
                                                               c_Key_Indicator_Value value
                                                               Pi.Indicator_Value))
                                from Hpd_Oper_Type_Indicators Oti
                                join Hpd_Page_Indicators Pi
                                  on Pi.Company_Id = Oti.Company_Id
                                 and Pi.Filial_Id = Oti.Filial_Id
                                 and Pi.Page_Id = Oti.Page_Id
                                 and Pi.Indicator_Id = Oti.Indicator_Id
                               where Oti.Company_Id = q.Company_Id
                                 and Oti.Filial_Id = q.Filial_Id
                                 and Oti.Page_Id = q.Page_Id
                                 and Oti.Oper_Type_Id = q.Oper_Type_Id) Indicators
                        from Hpd_Page_Oper_Types q
                       where q.Company_Id = r.Company_Id
                         and q.Filial_Id = r.Filial_Id
                         and q.Page_Id = Hrg.Page_Id)
          loop
            v_Oper_Type  := Gmap();
            v_Indicators := Glist();
          
            v_Oper_Type.Put(c_Key_Oper_Type_Id, Opt.Oper_Type_Id);
          
            if Opt.Indicators is not null then
              v_Indicators := Glist(Json_Array_t(Opt.Indicators));
            end if;
          
            v_Oper_Type.Put(c_Key_Indicators, v_Indicators);
          
            v_Oper_Types.Push(v_Oper_Type.Val);
          end loop;
        
          v_Hiring.Put(c_Key_Oper_Types, v_Oper_Types);
        end if;
      
        v_Hirings.Push(v_Hiring.Val);
      end loop;
    
      v_Journal.Put(c_Key_Journal_Id, r.Journal_Id);
      v_Journal.Put(c_Key_Journal_Created_On, r.Created_On);
      v_Journal.Put(c_Key_Journal_Modified_On, r.Modified_On);
      v_Journal.Put(c_Key_Journal_Number, r.Journal_Number);
      v_Journal.Put(c_Key_Journal_Date, r.Journal_Date);
      v_Journal.Put(c_Key_Journal_Name, r.Journal_Name);
      v_Journal.Put(c_Key_Journal_Posted, r.Posted);
    
      v_Journal.Put(c_Key_Hirings, v_Hirings);
    
      v_Last_Id := r.Modified_Id;
    
      v_Journals.Push(v_Journal.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Journals, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function List_Hirings(i_Data Hashmap) return Json_Object_t is
  begin
    return Export_Data(i_Data               => i_Data, --
                       i_Include_Oper_Types => true,
                       i_Include_Contract   => true);
  end;

end Ui_Vhr281;
/
