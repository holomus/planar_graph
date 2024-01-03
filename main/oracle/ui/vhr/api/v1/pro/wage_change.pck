create or replace package Ui_Vhr426 is
  ----------------------------------------------------------------------------------------------------
  Function List_Wage_Changes(i_Data Hashmap) return Json_Object_t;
end Ui_Vhr426;
/
create or replace package body Ui_Vhr426 is
  ----------------------------------------------------------------------------------------------------
  Function List_Wage_Changes(i_Data Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Journal_Ids Array_Number := Nvl(i_Data.o_Array_Number('journal_ids'), Array_Number());
    v_Count       number := v_Journal_Ids.Count;
  
    v_Change_Type_Id number;
  
    v_Wage_Change  Gmap;
    v_Wage_Changes Glist;
    v_Oper_Types   Glist;
    v_Oper_Type    Gmap;
    v_Indicators   Glist;
    v_Journal      Gmap;
    v_Journals     Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
    v_Change_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Wage_Change);
  
    for Ts in (select *
                 from (select q.*
                         from Hpd_Journals q
                        where q.Company_Id = v_Company_Id
                          and q.Filial_Id = v_Filial_Id
                          and q.Journal_Type_Id = v_Change_Type_Id
                          and (v_Count = 0 or --                 
                              q.Journal_Id member of v_Journal_Ids)) Qr
                where Qr.Company_Id = v_Company_Id
                  and Qr.Filial_Id = v_Filial_Id
                  and Qr.Modified_Id > v_Start_Id
                order by Qr.Modified_Id
                fetch first v_Limit Rows only)
    loop
      v_Wage_Changes := Glist();
    
      for Tr in (select Jp.Page_Id, --
                        Jp.Staff_Id,
                        Jp.Employee_Id,
                        (select Wc.Change_Date
                           from Hpd_Wage_Changes Wc
                          where Wc.Company_Id = Jp.Company_Id
                            and Wc.Filial_Id = Jp.Filial_Id
                            and Wc.Page_Id = Jp.Page_Id) Change_Date
                   from Hpd_Journal_Pages Jp
                  where Jp.Company_Id = Ts.Company_Id
                    and Jp.Filial_Id = Ts.Filial_Id
                    and Jp.Journal_Id = Ts.Journal_Id)
      loop
        v_Wage_Change := Gmap();
      
        v_Wage_Change.Put('page_id', Tr.Page_Id);
        v_Wage_Change.Put('staff_id', Tr.Staff_Id);
        v_Wage_Change.Put('employee_id', Tr.Employee_Id);
        v_Wage_Change.Put('change_date', Tr.Change_Date);
      
        v_Oper_Types := Glist();
      
        for Opt in (select q.Oper_Type_Id,
                           (select Json_Arrayagg(Json_Object('indicator_id' value Pi.Indicator_Id,
                                                             'indicator_value' value
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
                     where q.Company_Id = Ts.Company_Id
                       and q.Filial_Id = Ts.Filial_Id
                       and q.Page_Id = Tr.Page_Id)
        loop
          v_Oper_Type  := Gmap();
          v_Indicators := Glist();
        
          v_Oper_Type.Put('oper_type_id', Opt.Oper_Type_Id);
        
          if Opt.Indicators is not null then
            v_Indicators := Glist(Json_Array_t(Opt.Indicators));
          end if;
        
          v_Oper_Type.Put('indicators', v_Indicators);
        
          v_Oper_Types.Push(v_Oper_Type.Val);
        end loop;
      
        v_Wage_Change.Put('oper_types', v_Oper_Types);
      
        v_Wage_Changes.Push(v_Wage_Change.Val);
      end loop;
    
      v_Journal := Gmap();
    
      -- journal info
      v_Journal.Put('journal_id', Ts.Journal_Id);
      v_Journal.Put('created_on', Ts.Created_On);
      v_Journal.Put('modified_on', Ts.Modified_On);
      v_Journal.Put('journal_number', Ts.Journal_Number);
      v_Journal.Put('journal_date', Ts.Journal_Date);
      v_Journal.Put('journal_name', Ts.Journal_Name);
      v_Journal.Put('journal_posted', Ts.Posted);
    
      v_Journal.Put('wage_changes', v_Wage_Changes);
    
      v_Last_Id := Ts.Modified_Id;
    
      v_Journals.Push(v_Journal.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Journals, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr426;
/
