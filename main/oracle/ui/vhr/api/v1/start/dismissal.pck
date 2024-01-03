create or replace package Ui_Vhr346 is
  ----------------------------------------------------------------------------------------------------
  Function List_Dismissals(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Dismissal(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Dismissal(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Dismissal(p Hashmap);
end Ui_Vhr346;
/
create or replace package body Ui_Vhr346 is
  ----------------------------------------------------------------------------------------------------
  Function List_Dismissals(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Journal_Ids     Array_Number := Nvl(p.o_Array_Number('journal_ids'), Array_Number());
    v_Count           number := v_Journal_Ids.Count;
    v_Journal_Type_Id number := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                         i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
    v_Dismissal       Gmap;
    v_Dismissals      Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select w.Dismissal_Date, --
                             w.Dismissal_Reason_Id,
                             w.Note,
                             q.Journal_Id,
                             q.Page_Id,
                             q.Employee_Id,
                             q.Staff_Id,
                             q.Company_Id,
                             q.Filial_Id,
                             q.Modified_Id
                        from Hpd_Journal_Pages q
                        join Hpd_Dismissals w
                          on w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Page_Id = q.Page_Id
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or --                 
                             q.Journal_Id member of v_Journal_Ids)
                         and exists (select 1
                                from Hpd_Journals j
                               where j.Company_Id = v_Company_Id
                                 and j.Filial_Id = v_Filial_Id
                                 and j.Journal_Id = q.Journal_Id
                                 and j.Journal_Type_Id = v_Journal_Type_Id
                                 and j.Posted = 'Y')) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Dismissal := Gmap();
    
      v_Dismissal.Put('dismissal_date', r.Dismissal_Date);
      v_Dismissal.Put('journal_id', r.Journal_Id);
      v_Dismissal.Put('page_id', r.Page_Id);
      v_Dismissal.Put('employee_id', r.Employee_Id);
      v_Dismissal.Put('staff_id', r.Staff_Id);
      v_Dismissal.Put('reason_id', r.Dismissal_Reason_Id);
      v_Dismissal.Put('note', r.Note);
    
      v_Last_Id := r.Modified_Id;
    
      v_Dismissals.Push(v_Dismissal.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Dismissals, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p         Hashmap,
    i_Journal Hpd_Journals%rowtype,
    i_Page_Id number := null
  ) is
    p_Journal        Hpd_Pref.Dismissal_Journal_Rt;
    v_Dismissal_Date date := p.r_Date('dismissal_date');
    v_Page_Id        number;
    r_Dismissal      Hpd_Dismissals%rowtype;
  begin
    Hpd_Util.Dismissal_Journal_New(o_Journal         => p_Journal,
                                   i_Company_Id      => i_Journal.Company_Id,
                                   i_Filial_Id       => i_Journal.Filial_Id,
                                   i_Journal_Id      => i_Journal.Journal_Id,
                                   i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Journal.Company_Id,
                                                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
                                   i_Journal_Number  => i_Journal.Journal_Number,
                                   i_Journal_Date    => v_Dismissal_Date,
                                   i_Journal_Name    => i_Journal.Journal_Name);
  
    v_Page_Id := Coalesce(i_Page_Id, Uit_Hpd.Get_Page_Id(i_Journal_Id => i_Journal.Journal_Id));
  
    r_Dismissal := z_Hpd_Dismissals.Take(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Page_Id    => v_Page_Id);
  
    Hpd_Util.Journal_Add_Dismissal(p_Journal              => p_Journal,
                                   i_Page_Id              => v_Page_Id,
                                   i_Staff_Id             => Href_Util.Get_Primary_Staff_Id(i_Company_Id   => i_Journal.Company_Id,
                                                                                            i_Filial_Id    => i_Journal.Filial_Id,
                                                                                            i_Employee_Id  => p.r_Number('employee_id'),
                                                                                            i_Period_Begin => v_Dismissal_Date,
                                                                                            i_Period_End   => v_Dismissal_Date),
                                   i_Dismissal_Date       => v_Dismissal_Date,
                                   i_Dismissal_Reason_Id  => p.o_Number('reason_id'),
                                   i_Employment_Source_Id => r_Dismissal.Employment_Source_Id,
                                   i_Based_On_Doc         => r_Dismissal.Based_On_Doc,
                                   i_Note                 => p.o_Varchar2('note'));
  
    Hpd_Api.Dismissal_Journal_Save(p_Journal);
  
    Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                         i_Filial_Id  => p_Journal.Filial_Id,
                         i_Journal_Id => p_Journal.Journal_Id);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Dismissal(p Hashmap) return Hashmap is
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
  Procedure Update_Dismissal(p Hashmap) is
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
  Procedure Delete_Dismissal(p Hashmap) is
    v_Journal_Id number := p.r_Number('journal_id');
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  
    Hpd_Api.Journal_Delete(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  end;

end Ui_Vhr346;
/
