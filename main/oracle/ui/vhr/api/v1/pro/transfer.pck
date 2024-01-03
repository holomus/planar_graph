create or replace package Ui_Vhr286 is
  ----------------------------------------------------------------------------------------------------
  Function List_Transfers(i_Data Hashmap) return Json_Object_t;
end Ui_Vhr286;
/
create or replace package body Ui_Vhr286 is
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
  -- transfer keys 
  ----------------------------------------------------------------------------------------------------
  c_Key_Transfers            constant varchar2(50) := 'transfers';
  c_Key_Transfer_Begin       constant varchar2(50) := 'transfer_begin';
  c_Key_Transfer_End         constant varchar2(50) := 'transfer_end';
  c_Key_Transfer_Reason      constant varchar2(50) := 'transfer_reason';
  c_Key_Transfer_Base        constant varchar2(50) := 'transfer_base';
  c_Key_Page_Id              constant varchar2(50) := 'page_id';
  c_Key_Staff_Id             constant varchar2(50) := 'staff_id';
  c_Key_Employee_Id          constant varchar2(50) := 'employee_id';
  c_Key_Position_Id          constant varchar2(50) := 'position_id';
  c_Key_Division_Id          constant varchar2(50) := 'division_id';
  c_Key_Job_Id               constant varchar2(50) := 'job_id';
  c_Key_Rank_Id              constant varchar2(50) := 'rank_id';
  c_Key_Schedule_Id          constant varchar2(50) := 'schedule_id';
  c_Key_Employment_Type_Code constant varchar2(50) := 'employment_type_code';
  c_Key_Employment_Type_Name constant varchar2(50) := 'employment_type_name';
  c_Key_Fte_Id               constant varchar2(50) := 'fte_id';
  c_Key_Fte_Value            constant varchar2(50) := 'fte_value';
  c_Key_Vacation_Days_Limit  constant varchar2(50) := 'vacation_days_limit';

  ----------------------------------------------------------------------------------------------------
  -- contract keys
  ----------------------------------------------------------------------------------------------------
  c_Key_Contract_Number      constant varchar2(50) := 'contract_number';
  c_Key_Contract_Date        constant varchar2(50) := 'contract_date';
  c_Key_Fixed_Term           constant varchar2(50) := 'contract_fixed_term';
  c_Key_Expiry_Date          constant varchar2(50) := 'contract_expiry_date';
  c_Key_Fixed_Term_Id        constant varchar2(50) := 'fixed_term_base_id';
  c_Key_Concluding_Term      constant varchar2(50) := 'fixed_term_concluding_term';
  c_Key_Hiring_Conditions    constant varchar2(50) := 'contract_hiring_conditions';
  c_Key_Other_Conditions     constant varchar2(50) := 'contract_other_conditions';
  c_Key_Workplace_Equipment  constant varchar2(50) := 'contract_workplace_equipment';
  c_Key_Representative_Basis constant varchar2(50) := 'contract_representative_basis';

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
  
    v_Transfer_Id          number;
    v_Transfer_Multiple_Id number;
  
    v_Transfer   Gmap;
    v_Transfers  Glist;
    v_Journal    Gmap;
    v_Journals   Glist := Glist();
    v_Oper_Types Glist;
    v_Oper_Type  Gmap;
    v_Indicators Glist;
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    v_Transfer_Id          := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                       i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer);
    v_Transfer_Multiple_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                       i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple);
    for r in (select *
                from (select *
                        from Hpd_Journals w
                       where w.Company_Id = v_Company_Id
                         and w.Filial_Id = v_Filial_Id
                         and w.Journal_Type_Id in (v_Transfer_Id, v_Transfer_Multiple_Id)
                         and (v_Count = 0 or --                 
                             w.Journal_Id member of v_Journal_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Transfers := Glist();
    
      for Tr in (select Jt.Page_Id,
                        Jt.Staff_Id,
                        Jt.Employee_Id,
                        t.Transfer_Begin,
                        t.Transfer_End,
                        Pr.Robot_Id,
                        Pr.Division_Id,
                        Pr.Job_Id,
                        Pr.Rank_Id,
                        Ps.Schedule_Id,
                        Pr.Employment_Type,
                        Pr.Fte_Id,
                        Pr.Fte,
                        Vl.Days_Limit,
                        t.Transfer_Reason,
                        t.Transfer_Base,
                        Pc.Contract_Number,
                        Pc.Contract_Date,
                        Pc.Fixed_Term,
                        Pc.Expiry_Date,
                        Pc.Fixed_Term_Base_Id,
                        Pc.Concluding_Term,
                        Pc.Hiring_Conditions,
                        Pc.Other_Conditions,
                        Pc.Workplace_Equipment,
                        Pc.Representative_Basis
                   from Hpd_Journal_Pages Jt
                   join Hpd_Transfers t
                     on t.Company_Id = Jt.Company_Id
                    and t.Filial_Id = Jt.Filial_Id
                    and t.Page_Id = Jt.Page_Id
                   left join Hpd_Page_Schedules Ps
                     on Ps.Company_Id = Jt.Company_Id
                    and Ps.Filial_Id = Jt.Filial_Id
                    and Ps.Page_Id = Jt.Page_Id
                   left join Hpd_Page_Robots Pr
                     on Pr.Company_Id = Jt.Company_Id
                    and Pr.Filial_Id = Jt.Filial_Id
                    and Pr.Page_Id = Jt.Page_Id
                   left join Hpd_Page_Contracts Pc
                     on Pc.Company_Id = Jt.Company_Id
                    and Pc.Filial_Id = Jt.Filial_Id
                    and Pc.Page_Id = Jt.Page_Id
                   left join Hpd_Page_Vacation_Limits Vl
                     on Vl.Company_Id = Jt.Company_Id
                    and Vl.Filial_Id = Jt.Filial_Id
                    and Vl.Page_Id = Jt.Page_Id
                  where Jt.Company_Id = r.Company_Id
                    and Jt.Filial_Id = r.Filial_Id
                    and Jt.Journal_Id = r.Journal_Id)
      loop
        v_Transfer := Gmap();
      
        v_Transfer.Put(c_Key_Page_Id, Tr.Page_Id);
        v_Transfer.Put(c_Key_Transfer_Begin, Tr.Transfer_Begin);
        v_Transfer.Put(c_Key_Transfer_End, Tr.Transfer_End);
        v_Transfer.Put(c_Key_Transfer_Reason, Tr.Transfer_Reason);
        v_Transfer.Put(c_Key_Transfer_Base, Tr.Transfer_Base);
        v_Transfer.Put(c_Key_Staff_Id, Tr.Staff_Id);
        v_Transfer.Put(c_Key_Employee_Id, Tr.Employee_Id);
        v_Transfer.Put(c_Key_Position_Id, Tr.Robot_Id);
        v_Transfer.Put(c_Key_Division_Id, Tr.Division_Id);
        v_Transfer.Put(c_Key_Job_Id, Tr.Job_Id);
        v_Transfer.Put(c_Key_Rank_Id, Tr.Rank_Id);
        v_Transfer.Put(c_Key_Schedule_Id, Tr.Schedule_Id);
        v_Transfer.Put(c_Key_Employment_Type_Code, Tr.Employment_Type);
        v_Transfer.Put(c_Key_Employment_Type_Name, Hpd_Util.t_Employment_Type(Tr.Employment_Type));
        v_Transfer.Put(c_Key_Fte_Id, Tr.Fte_Id);
        v_Transfer.Put(c_Key_Fte_Value, Tr.Fte);
        v_Transfer.Put(c_Key_Vacation_Days_Limit, Tr.Days_Limit);
      
        if i_Include_Contract then
          v_Transfer.Put(c_Key_Contract_Number, Tr.Contract_Number);
          v_Transfer.Put(c_Key_Contract_Date, Tr.Contract_Date);
          v_Transfer.Put(c_Key_Fixed_Term, Tr.Fixed_Term);
          v_Transfer.Put(c_Key_Expiry_Date, Tr.Expiry_Date);
          v_Transfer.Put(c_Key_Fixed_Term_Id, Tr.Fixed_Term_Base_Id);
          v_Transfer.Put(c_Key_Concluding_Term, Tr.Concluding_Term);
          v_Transfer.Put(c_Key_Hiring_Conditions, Tr.Hiring_Conditions);
          v_Transfer.Put(c_Key_Other_Conditions, Tr.Other_Conditions);
          v_Transfer.Put(c_Key_Workplace_Equipment, Tr.Workplace_Equipment);
          v_Transfer.Put(c_Key_Representative_Basis, Tr.Representative_Basis);
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
                         and q.Page_Id = Tr.Page_Id)
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
        
          v_Transfer.Put(c_Key_Oper_Types, v_Oper_Types);
        end if;
      
        v_Transfers.Push(v_Transfer.Val);
      end loop;
    
      v_Journal := Gmap();
    
      v_Journal.Put(c_Key_Journal_Id, r.Journal_Id);
      v_Journal.Put(c_Key_Journal_Created_On, r.Created_On);
      v_Journal.Put(c_Key_Journal_Modified_On, r.Modified_On);
      v_Journal.Put(c_Key_Journal_Number, r.Journal_Number);
      v_Journal.Put(c_Key_Journal_Date, r.Journal_Date);
      v_Journal.Put(c_Key_Journal_Name, r.Journal_Name);
      v_Journal.Put(c_Key_Journal_Posted, r.Posted);
    
      v_Journal.Put(c_Key_Transfers, v_Transfers);
    
      v_Last_Id := r.Modified_Id;
    
      v_Journals.Push(v_Journal.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Journals, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function List_Transfers(i_Data Hashmap) return Json_Object_t is
  begin
    return Export_Data(i_Data               => i_Data, --
                       i_Include_Oper_Types => true,
                       i_Include_Contract   => true);
  end;

end Ui_Vhr286;
/
