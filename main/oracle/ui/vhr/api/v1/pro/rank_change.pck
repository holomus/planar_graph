create or replace package Ui_Vhr428 is
  ----------------------------------------------------------------------------------------------------
  Function List_Rank_Changes(i_Data Hashmap) return Json_Object_t;
end Ui_Vhr428;
/
create or replace package body Ui_Vhr428 is
  ----------------------------------------------------------------------------------------------------
  Function List_Rank_Changes(i_Data Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Journal_Ids Array_Number := Nvl(i_Data.o_Array_Number('journal_ids'), Array_Number());
    v_Count       number := v_Journal_Ids.Count;
  
    v_Change_Type_Id number;
  
    v_Rank_Change  Gmap;
    v_Rank_Changes Glist;
    v_Journal      Gmap;
    v_Journals     Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
    v_Change_Type_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Rank_Change);
  
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
      v_Rank_Changes := Glist();
    
      for Tr in (select Jp.Page_Id, --
                        Jp.Staff_Id,
                        Jp.Employee_Id,
                        Wc.Change_Date,
                        Wc.Rank_Id
                   from Hpd_Journal_Pages Jp
                   join Hpd_Rank_Changes Wc
                     on Wc.Company_Id = Jp.Company_Id
                    and Wc.Filial_Id = Jp.Filial_Id
                    and Wc.Page_Id = Jp.Page_Id
                  where Jp.Company_Id = Ts.Company_Id
                    and Jp.Filial_Id = Ts.Filial_Id
                    and Jp.Journal_Id = Ts.Journal_Id)
      loop
        v_Rank_Change := Gmap();
      
        v_Rank_Change.Put('page_id', Tr.Page_Id);
        v_Rank_Change.Put('staff_id', Tr.Staff_Id);
        v_Rank_Change.Put('employee_id', Tr.Employee_Id);
        v_Rank_Change.Put('change_date', Tr.Change_Date);
        v_Rank_Change.Put('rank_id', Tr.Rank_Id);
      
        v_Rank_Changes.Push(v_Rank_Change.Val);
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
    
      v_Journal.Put('rank_changes', v_Rank_Changes);
    
      v_Last_Id := Ts.Modified_Id;
    
      v_Journals.Push(v_Journal.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Journals, --
                                       i_Modified_Id => v_Last_Id);
  end;
end Ui_Vhr428;
/
