create or replace package Ui_Vhr288 is
  ----------------------------------------------------------------------------------------------------
  Function List_Dismissals(i_Data Hashmap) return Json_Object_t;
end Ui_Vhr288;
/
create or replace package body Ui_Vhr288 is
  ---------------------------------------------------------------------------------------------------
  -- journal keys
  ---------------------------------------------------------------------------------------------------
  c_Key_Journal_Id          constant varchar2(50) := 'journal_id';
  c_Key_Journal_Created_On  constant varchar2(50) := 'created_on';
  c_Key_Journal_Modified_On constant varchar2(50) := 'modified_on';
  c_Key_Journal_Number      constant varchar2(50) := 'journal_number';
  c_Key_Journal_Date        constant varchar2(50) := 'journal_date';
  c_Key_Journal_Name        constant varchar2(50) := 'journal_name';
  c_Key_Journal_Posted      constant varchar2(50) := 'journal_posted';

  ---------------------------------------------------------------------------------------------------
  -- dismissal keys
  ---------------------------------------------------------------------------------------------------
  c_Key_Dismissals           constant varchar2(50) := 'dismissals';
  c_Key_Page_Id              constant varchar2(50) := 'page_id';
  c_Key_Staff_Id             constant varchar2(50) := 'staff_id';
  c_Key_Employee_Id          constant varchar2(50) := 'employee_id';
  c_Key_Dismissal_Date       constant varchar2(50) := 'dismissal_date';
  c_Key_Dismissal_Reason_Id  constant varchar2(50) := 'dismissal_reason_id';
  c_Key_Employment_Source_Id constant varchar2(50) := 'employment_source_id';
  c_Key_Based_On_Doc         constant varchar2(50) := 'based_on_doc';
  c_Key_Dismissal_Note       constant varchar2(50) := 'dismissal_note';

  ----------------------------------------------------------------------------------------------------
  Function List_Dismissals(i_Data Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Journal_Ids Array_Number := Nvl(i_Data.o_Array_Number('journal_ids'), Array_Number());
    v_Count       number := v_Journal_Ids.Count;
  
    v_Dismissal_Id          number;
    v_Dismissal_Multiple_Id number;
  
    v_Dismissal  Gmap;
    v_Dismissals Glist;
    v_Journal    Gmap;
    v_Journals   Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    v_Dismissal_Id          := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
    v_Dismissal_Multiple_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                        i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple);
    for Tr in (select *
                 from (select *
                         from Hpd_Journals w
                        where w.Company_Id = v_Company_Id
                          and w.Filial_Id = v_Filial_Id
                          and w.Journal_Type_Id in (v_Dismissal_Id, v_Dismissal_Multiple_Id)
                          and (v_Count = 0 or --                 
                              w.Journal_Id member of v_Journal_Ids)) Qr
                where Qr.Company_Id = v_Company_Id
                  and Qr.Filial_Id = v_Filial_Id
                  and Qr.Modified_Id > v_Start_Id
                order by Qr.Modified_Id
                fetch first v_Limit Rows only)
    loop
      v_Dismissals := Glist();
    
      for r in (select w.Page_Id,
                       w.Staff_Id,
                       w.Employee_Id,
                       t.Dismissal_Date       Dismissal_Date,
                       t.Dismissal_Reason_Id,
                       t.Employment_Source_Id,
                       t.Based_On_Doc         Based_On_Doc,
                       t.Note                 Dismissal_Note
                  from Hpd_Journal_Pages w
                  join Hpd_Dismissals t
                    on t.Company_Id = w.Company_Id
                   and t.Filial_Id = w.Filial_Id
                   and t.Page_Id = w.Page_Id
                 where w.Company_Id = Tr.Company_Id
                   and w.Filial_Id = Tr.Filial_Id
                   and w.Journal_Id = Tr.Journal_Id)
      loop
        v_Dismissal := Gmap();
      
        v_Dismissal.Put(c_Key_Page_Id, r.Page_Id);
        v_Dismissal.Put(c_Key_Staff_Id, r.Staff_Id);
        v_Dismissal.Put(c_Key_Employee_Id, r.Employee_Id);
        v_Dismissal.Put(c_Key_Dismissal_Date, r.Dismissal_Date);
        v_Dismissal.Put(c_Key_Dismissal_Reason_Id, r.Dismissal_Reason_Id);
        v_Dismissal.Put(c_Key_Employment_Source_Id, r.Employment_Source_Id);
        v_Dismissal.Put(c_Key_Based_On_Doc, r.Based_On_Doc);
        v_Dismissal.Put(c_Key_Dismissal_Note, r.Dismissal_Note);
      
        v_Dismissals.Push(v_Dismissal.Val);
      end loop;
    
      v_Journal := Gmap();
    
      v_Journal.Put(c_Key_Journal_Id, Tr.Journal_Id);
      v_Journal.Put(c_Key_Journal_Created_On, Tr.Created_On);
      v_Journal.Put(c_Key_Journal_Modified_On, Tr.Modified_On);
      v_Journal.Put(c_Key_Journal_Number, Tr.Journal_Number);
      v_Journal.Put(c_Key_Journal_Date, Tr.Journal_Date);
      v_Journal.Put(c_Key_Journal_Name, Tr.Journal_Name);
      v_Journal.Put(c_Key_Journal_Posted, Tr.Posted);
    
      v_Journal.Put(c_Key_Dismissals, v_Dismissals);
    
      v_Last_Id := Tr.Modified_Id;
    
      v_Journals.Push(v_Journal.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Journals, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr288;
/
