create or replace package Ui_Vhr287 is
  ----------------------------------------------------------------------------------------------------
  Function List_Schedule_Changes(i_Data Hashmap) return Json_Object_t;
end Ui_Vhr287;
/
create or replace package body Ui_Vhr287 is
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
  -- schedule change keys
  ---------------------------------------------------------------------------------------------------- 
  c_Key_Schedule_Changes constant varchar2(50) := 'schedule_changes';
  c_Key_Page_Id          constant varchar2(50) := 'page_id';
  c_Key_Staff_Id         constant varchar2(50) := 'staff_id';
  c_Key_Employee_Id      constant varchar2(50) := 'employee_id';
  c_Key_Begin_Date       constant varchar2(50) := 'change_begin_date';
  c_Key_End_Date         constant varchar2(50) := 'change_end_date';
  c_Key_Schedule_Id      constant varchar2(50) := 'schedule_id';
  c_Key_Division_Id      constant varchar2(50) := 'division_id';

  ----------------------------------------------------------------------------------------------------
  Function List_Schedule_Changes(i_Data Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Journal_Ids Array_Number := Nvl(i_Data.o_Array_Number('journal_ids'), Array_Number());
    v_Count       number := v_Journal_Ids.Count;
  
    v_Change_Id number;
  
    v_Schedule_Change  Gmap;
    v_Schedule_Changes Glist;
    v_Journal          Gmap;
    v_Journals         Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    v_Change_Id := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                            i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change);
  
    for Ts in (select *
                 from (select q.*, --
                              t.Begin_Date,
                              t.End_Date,
                              t.Division_Id
                         from Hpd_Journals q
                         join Hpd_Schedule_Changes t
                           on q.Company_Id = t.Company_Id
                          and q.Filial_Id = t.Filial_Id
                          and q.Journal_Id = t.Journal_Id
                        where q.Company_Id = v_Company_Id
                          and q.Filial_Id = v_Filial_Id
                          and q.Journal_Type_Id = v_Change_Id
                          and (v_Count = 0 or --                 
                              q.Journal_Id member of v_Journal_Ids)) Qr
                where Qr.Company_Id = v_Company_Id
                  and Qr.Filial_Id = v_Filial_Id
                  and Qr.Modified_Id > v_Start_Id
                order by Qr.Modified_Id
                fetch first v_Limit Rows only)
    loop
      v_Schedule_Changes := Glist();
    
      for Tr in (select Jp.Page_Id, --
                        Jp.Staff_Id,
                        Jp.Employee_Id,
                        (select s.Schedule_Id
                           from Hpd_Page_Schedules s
                          where s.Company_Id = v_Company_Id
                            and s.Filial_Id = v_Filial_Id
                            and s.Page_Id = Jp.Page_Id) as Schedule_Id
                   from Hpd_Journal_Pages Jp
                  where Jp.Company_Id = Ts.Company_Id
                    and Jp.Filial_Id = Ts.Filial_Id
                    and Jp.Journal_Id = Ts.Journal_Id)
      loop
        v_Schedule_Change := Gmap();
      
        v_Schedule_Change.Put(c_Key_Page_Id, Tr.Page_Id);
        v_Schedule_Change.Put(c_Key_Staff_Id, Tr.Staff_Id);
        v_Schedule_Change.Put(c_Key_Employee_Id, Tr.Employee_Id);
        v_Schedule_Change.Put(c_Key_Schedule_Id, Tr.Schedule_Id);
      
        v_Schedule_Changes.Push(v_Schedule_Change.Val);
      end loop;
    
      v_Journal := Gmap();
    
      -- journal info
      v_Journal.Put(c_Key_Journal_Id, Ts.Journal_Id);
      v_Journal.Put(c_Key_Journal_Created_On, Ts.Created_On);
      v_Journal.Put(c_Key_Journal_Modified_On, Ts.Modified_On);
      v_Journal.Put(c_Key_Journal_Number, Ts.Journal_Number);
      v_Journal.Put(c_Key_Journal_Date, Ts.Journal_Date);
      v_Journal.Put(c_Key_Journal_Name, Ts.Journal_Name);
      v_Journal.Put(c_Key_Journal_Posted, Ts.Posted);
    
      -- schedule_change info    
      v_Journal.Put(c_Key_Begin_Date, Ts.Begin_Date);
      v_Journal.Put(c_Key_End_Date, Ts.End_Date);
      v_Journal.Put(c_Key_Division_Id, Ts.Division_Id);
    
      v_Journal.Put(c_Key_Schedule_Changes, v_Schedule_Changes);
    
      v_Last_Id := Ts.Modified_Id;
    
      v_Journals.Push(v_Journal.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Journals, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr287;
/
