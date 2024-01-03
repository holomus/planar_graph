create or replace package Ui_Vhr344 is
  ----------------------------------------------------------------------------------------------------
  Function List_Schedule_Changes(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Schedule_Change(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Schedule_Change(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Schedule_Change(p Hashmap);
end Ui_Vhr344;
/
create or replace package body Ui_Vhr344 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Schedule_Changes(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Journal_Ids      Array_Number := Nvl(p.o_Array_Number('journal_ids'), Array_Number());
    v_Count            number := v_Journal_Ids.Count;
    v_Schedule_Change  Gmap;
    v_Schedule_Changes Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select Jp.Company_Id,
                             Jp.Filial_Id,
                             Jp.Modified_Id,
                             Jp.Journal_Id,
                             Jp.Page_Id,
                             Jp.Employee_Id,
                             Jp.Staff_Id,
                             s.Begin_Date,
                             (select Ps.Schedule_Id
                                from Hpd_Page_Schedules Ps
                               where Ps.Company_Id = v_Company_Id
                                 and Ps.Filial_Id = v_Filial_Id
                                 and Ps.Page_Id = Jp.Page_Id) as Schedule_Id
                        from Hpd_Journal_Pages Jp
                        join Hpd_Schedule_Changes s
                          on s.Company_Id = Jp.Company_Id
                         and s.Filial_Id = Jp.Filial_Id
                         and s.Journal_Id = Jp.Journal_Id
                       where Jp.Company_Id = v_Company_Id
                         and Jp.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or Jp.Journal_Id member of v_Journal_Ids)
                         and exists (select 1
                                from Hpd_Journals j
                               where j.Company_Id = v_Company_Id
                                 and j.Filial_Id = v_Filial_Id
                                 and j.Journal_Id = Jp.Journal_Id
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
      v_Schedule_Change := Gmap();
    
      v_Schedule_Change.Put('journal_id', r.Journal_Id);
      v_Schedule_Change.Put('page_id', r.Page_Id);
      v_Schedule_Change.Put('employee_id', r.Employee_Id);
      v_Schedule_Change.Put('staff_id', r.Staff_Id);
      v_Schedule_Change.Put('change_date', r.Begin_Date);
      v_Schedule_Change.Put('schedule_id', r.Schedule_Id);
    
      v_Last_Id := r.Modified_Id;
    
      v_Schedule_Changes.Push(v_Schedule_Change.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Schedule_Changes, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p         Hashmap,
    i_Journal Hpd_Journals%rowtype,
    i_Page_Id number := null
  ) is
    p_Schedule_Change Hpd_Pref.Schedule_Change_Journal_Rt;
    v_Page_Id         number;
    v_Change_Date     date := p.r_Date('change_date');
    r_Schedule_Change Hpd_Schedule_Changes%rowtype;
  begin
    r_Schedule_Change := z_Hpd_Schedule_Changes.Take(i_Company_Id => i_Journal.Company_Id,
                                                     i_Filial_Id  => i_Journal.Filial_Id,
                                                     i_Journal_Id => i_Journal.Journal_Id);
  
    Hpd_Util.Schedule_Change_Journal_New(o_Journal        => p_Schedule_Change,
                                         i_Company_Id     => i_Journal.Company_Id,
                                         i_Filial_Id      => i_Journal.Filial_Id,
                                         i_Journal_Id     => i_Journal.Journal_Id,
                                         i_Journal_Number => i_Journal.Journal_Number,
                                         i_Journal_Date   => v_Change_Date,
                                         i_Journal_Name   => i_Journal.Journal_Name,
                                         i_Division_Id    => r_Schedule_Change.Division_Id,
                                         i_Begin_Date     => v_Change_Date,
                                         i_End_Date       => r_Schedule_Change.End_Date);
  
    v_Page_Id := Coalesce(i_Page_Id, Uit_Hpd.Get_Page_Id(i_Journal.Journal_Id));
  
    Hpd_Util.Journal_Add_Schedule_Change(p_Journal     => p_Schedule_Change,
                                         i_Page_Id     => v_Page_Id,
                                         i_Staff_Id    => Href_Util.Get_Primary_Staff_Id(i_Company_Id   => i_Journal.Company_Id,
                                                                                         i_Filial_Id    => i_Journal.Filial_Id,
                                                                                         i_Employee_Id  => p.r_Number('employee_id'),
                                                                                         i_Period_Begin => v_Change_Date,
                                                                                         i_Period_End   => v_Change_Date),
                                         i_Schedule_Id => p.r_Number('schedule_id'));
  
    Hpd_Api.Schedule_Change_Journal_Save(p_Schedule_Change);
  
    Hpd_Api.Journal_Post(i_Company_Id => p_Schedule_Change.Company_Id,
                         i_Filial_Id  => p_Schedule_Change.Filial_Id,
                         i_Journal_Id => p_Schedule_Change.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Create_Schedule_Change(p Hashmap) return Hashmap is
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
  Procedure Update_Schedule_Change(p Hashmap) is
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
  Procedure Delete_Schedule_Change(p Hashmap) is
    v_Journal_Id number := p.r_Number('journal_id');
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  
    Hpd_Api.Journal_Delete(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  end;

end Ui_Vhr344;
/
