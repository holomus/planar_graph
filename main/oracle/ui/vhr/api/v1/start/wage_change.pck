create or replace package Ui_Vhr347 is
  ----------------------------------------------------------------------------------------------------
  Function List_Wage_Changes(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Wage_Change(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Wage_Change(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Wage_Change(p Hashmap);
end Ui_Vhr347;
/
create or replace package body Ui_Vhr347 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Wage_Changes(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Journal_Ids  Array_Number := Nvl(p.o_Array_Number('journal_ids'), Array_Number());
    v_Count        number := v_Journal_Ids.Count;
    v_Wage_Change  Gmap;
    v_Wage_Changes Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select k.Company_Id,
                             k.Filial_Id,
                             k.Modified_Id,
                             k.Journal_Id,
                             k.Page_Id,
                             k.Employee_Id,
                             k.Staff_Id,
                             w.Change_Date,
                             case m.Pcode
                               when Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly then
                                Uit_Hpr.c_Salary_Type_Hourly
                               when Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily then
                                Uit_Hpr.c_Salary_Type_Daily
                               when Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly then
                                Uit_Hpr.c_Salary_Type_Monthly
                               when Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized then
                                Uit_Hpr.c_Salary_Type_Monthly_Summarized
                             end as Salary_Type,
                             (select d.Indicator_Value
                                from Hpd_Page_Indicators d
                               where d.Company_Id = v_Company_Id
                                 and d.Filial_Id = v_Filial_Id
                                 and d.Page_Id = Ot.Page_Id
                                 and d.Indicator_Id = Ot.Indicator_Id) as Salary_Amount
                        from Hpd_Journal_Pages k
                        join Hpd_Wage_Changes w
                          on w.Company_Id = v_Company_Id
                         and w.Filial_Id = v_Filial_Id
                         and w.Page_Id = k.Page_Id
                        join Hpd_Oper_Type_Indicators Ot
                          on Ot.Company_Id = v_Company_Id
                         and Ot.Filial_Id = v_Filial_Id
                         and Ot.Page_Id = k.Page_Id
                        join Mpr_Oper_Types m
                          on m.Company_Id = v_Company_Id
                         and m.Oper_Type_Id = Ot.Oper_Type_Id
                         and m.Pcode in (Hpr_Pref.c_Pcode_Oper_Type_Wage_Hourly,
                                         Hpr_Pref.c_Pcode_Oper_Type_Wage_Daily,
                                         Hpr_Pref.c_Pcode_Oper_Type_Wage_Monthly,
                                         Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized)
                       where k.Company_Id = v_Company_Id
                         and k.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or k.Journal_Id member of v_Journal_Ids)
                         and exists (select 1
                                from Hpd_Journals j
                               where j.Company_Id = v_Company_Id
                                 and j.Filial_Id = v_Filial_Id
                                 and j.Journal_Id = k.Journal_Id
                                 and (select count(*)
                                        from Hpd_Journal_Pages Pg
                                       where Pg.Company_Id = j.Company_Id
                                         and Pg.Filial_Id = j.Filial_Id
                                         and Pg.Journal_Id = j.Journal_Id) = 1
                                 and j.Posted = 'Y')) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Wage_Change := Gmap();
    
      v_Wage_Change.Put('journal_id', r.Journal_Id);
      v_Wage_Change.Put('page_id', r.Page_Id);
      v_Wage_Change.Put('employee_id', r.Employee_Id);
      v_Wage_Change.Put('staff_id', r.Staff_Id);
      v_Wage_Change.Put('change_date', r.Change_Date);
      v_Wage_Change.Put('salary_type', r.Salary_Type);
      v_Wage_Change.Put('salary_amount', r.Salary_Amount);
    
      v_Last_Id := r.Modified_Id;
    
      v_Wage_Changes.Push(v_Wage_Change.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Wage_Changes, --
                                       i_Modified_Id => v_Last_Id);
  end;
  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p         Hashmap,
    i_Journal Hpd_Journals%rowtype,
    i_Page_Id number := null
  ) is
    p_Wage_Change       Hpd_Pref.Wage_Change_Journal_Rt;
    p_Indicator         Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt();
    p_Oper_Type         Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt();
    v_Page_Id           number;
    v_Employee_Id       number := p.r_Number('employee_id');
    v_Wage_Indicator_Id number := Href_Util.Indicator_Id(i_Company_Id => i_Journal.Company_Id,
                                                         i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
    v_Change_Date       date := p.r_Date('change_date');
  begin
    Hpd_Util.Wage_Change_Journal_New(o_Journal         => p_Wage_Change,
                                     i_Company_Id      => i_Journal.Company_Id,
                                     i_Filial_Id       => i_Journal.Filial_Id,
                                     i_Journal_Id      => i_Journal.Journal_Id,
                                     i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Journal.Company_Id,
                                                                                   i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Wage_Change),
                                     i_Journal_Number  => i_Journal.Journal_Number,
                                     i_Journal_Date    => v_Change_Date,
                                     i_Journal_Name    => i_Journal.Journal_Name);
  
    Hpd_Util.Indicator_Add(p_Indicator       => p_Indicator,
                           i_Indicator_Id    => v_Wage_Indicator_Id,
                           i_Indicator_Value => p.r_Number('salary_amount'));
  
    Hpd_Util.Oper_Type_Add(p_Oper_Type     => p_Oper_Type,
                           i_Oper_Type_Id  => Uit_Hpr.Get_Salary_Type_Id(p.r_Varchar2('salary_type')),
                           i_Indicator_Ids => Array_Number(v_Wage_Indicator_Id));
  
    v_Page_Id := Coalesce(i_Page_Id, Uit_Hpd.Get_Page_Id(i_Journal.Journal_Id));
  
    Hpd_Util.Journal_Add_Wage_Change(p_Journal     => p_Wage_Change,
                                     i_Page_Id     => v_Page_Id,
                                     i_Staff_Id    => Href_Util.Get_Primary_Staff_Id(i_Company_Id   => i_Journal.Company_Id,
                                                                                     i_Filial_Id    => i_Journal.Filial_Id,
                                                                                     i_Employee_Id  => v_Employee_Id,
                                                                                     i_Period_Begin => v_Change_Date,
                                                                                     i_Period_End   => v_Change_Date),
                                     i_Change_Date => v_Change_Date,
                                     i_Indicators  => p_Indicator,
                                     i_Oper_Types  => p_Oper_Type);
  
    Hpd_Api.Wage_Change_Journal_Save(p_Wage_Change);
  
    Hpd_Api.Journal_Post(i_Company_Id => p_Wage_Change.Company_Id,
                         i_Filial_Id  => p_Wage_Change.Filial_Id,
                         i_Journal_Id => p_Wage_Change.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Create_Wage_Change(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
    v_Page_Id number := Hpd_Next.Page_Id;
  begin
    r_Journal.Company_Id := Ui.Company_Id;
    r_Journal.Filial_Id  := Ui.Filial_Id;
    r_Journal.Journal_Id := Hpd_Next.Journal_Id;
  
    save(p, r_Journal, v_Page_Id);
  
    return Fazo.Zip_Map('journal_id', r_Journal.Journal_Id, 'page_id', v_Page_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Wage_Change(p Hashmap) is
    r_Journal Hpd_Journals%rowtype;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                           i_Filial_Id  => r_Journal.Filial_Id,
                           i_Journal_Id => r_Journal.Journal_Id,
                           i_Repost     => true);
  
    save(p, r_Journal);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Wage_Change(p Hashmap) is
    v_Journal_Id number := p.r_Number('journal_id');
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  
    Hpd_Api.Journal_Delete(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  end;

end Ui_Vhr347;
/
