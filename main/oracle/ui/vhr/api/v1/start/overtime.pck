create or replace package Ui_Vhr462 is
  ---------------------------------------------------------------------------------------------------- 
  Function List_Overtimes(p Hashmap) return Json_Object_t;
  ---------------------------------------------------------------------------------------------------- 
  Function Create_Overtime(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Overtime(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Overtime(p Hashmap);
end Ui_Vhr462;
/
create or replace package body Ui_Vhr462 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR462:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function List_Overtimes(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Staff_Ids   Array_Number := Nvl(p.o_Array_Number('staff_ids'), Array_Number());
    v_Staff_Count number := v_Staff_Ids.Count;
  
    v_Overtime  Gmap;
    v_Days      Glist;
    v_Day       Gmap;
    v_Overtimes Glist := Glist();
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select q.Journal_Id,
                             Jo.Modified_Id,
                             Jo.Staff_Id,
                             Jo.Begin_Date,
                             Jo.End_Date,
                             Jo.Overtime_Id
                        from Hpd_Journals q
                        join Hpd_Journal_Overtimes Jo
                          on Jo.Company_Id = q.Company_Id
                         and Jo.Filial_Id = q.Filial_Id
                         and Jo.Journal_Id = q.Journal_Id
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Staff_Count = 0 or Jo.Staff_Id member of v_Staff_Ids)
                         and q.Posted = 'Y') Qr
               where Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Overtime := Gmap();
    
      v_Days := Glist();
      for c in (select d.Overtime_Date, Round(d.Overtime_Seconds / 60, 2) Overtime_Minutes
                  from Hpd_Overtime_Days d
                 where d.Company_Id = v_Company_Id
                   and d.Filial_Id = v_Filial_Id
                   and d.Staff_Id = r.Staff_Id
                   and d.Overtime_Id = r.Overtime_Id
                 order by d.Overtime_Date)
      loop
        v_Day := Gmap();
      
        v_Day.Put('date', c.Overtime_Date);
        v_Day.Put('overtime_minutes', c.Overtime_Minutes);
      
        v_Days.Push(v_Day.Val);
      end loop;
    
      v_Overtime.Put('days', v_Days);
      v_Overtime.Put('journal_id', r.Journal_Id);
      v_Overtime.Put('staff_id', r.Staff_Id);
      v_Overtime.Put('begin_date', r.Begin_Date);
      v_Overtime.Put('end_date', r.End_Date);
    
      v_Last_Id := r.Modified_Id;
    
      v_Overtimes.Push(v_Overtime.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Overtimes, i_Modified_Id => v_Last_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure save
  (
    p         Hashmap,
    i_Journal Hpd_Journals%rowtype
  ) is
    v_Journal       Hpd_Pref.Overtime_Journal_Rt;
    v_Overtime      Hpd_Pref.Overtime_Nt;
    v_Overtime_List Arraylist;
    v_Overtime_Cell Hashmap;
  
    v_Staff_Id number := p.r_Number('staff_id');
    v_Month    date := Trunc(p.r_Date('month'), 'MON');
  begin
    Hpd_Util.Overtime_Journal_New(o_Overtime_Journal => v_Journal,
                                  i_Company_Id       => Ui.Company_Id,
                                  i_Filial_Id        => Ui.Filial_Id,
                                  i_Journal_Id       => i_Journal.Journal_Id,
                                  i_Journal_Number   => i_Journal.Journal_Number,
                                  i_Journal_Name     => i_Journal.Journal_Name,
                                  i_Journal_Date     => Trunc(sysdate));
  
    v_Overtime_List := p.r_Arraylist('days');
    v_Overtime      := Hpd_Pref.Overtime_Nt();
  
    for j in 1 .. v_Overtime_List.Count
    loop
      v_Overtime_Cell := Treat(v_Overtime_List.r_Hashmap(j) as Hashmap);
    
      Hpd_Util.Overtime_Add(p_Overtimes        => v_Overtime,
                            i_Overtime_Date    => v_Overtime_Cell.r_Date('date'),
                            i_Overtime_Seconds => v_Overtime_Cell.r_Number('overtime_minutes') * 60);
    end loop;
  
    Hpd_Util.Journal_Add_Overtime(p_Journal     => v_Journal,
                                  i_Staff_Id    => v_Staff_Id,
                                  i_Month       => v_Month,
                                  i_Overtime_Id => Coalesce(Uit_Hpd.Get_Overtime_Id(i_Journal_Id => v_Journal.Journal_Id),
                                                            Hpd_Next.Overtime_Id),
                                  i_Overtimes   => v_Overtime);
  
    Hpd_Api.Overtime_Journal_Save(v_Journal);
  
    Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                         i_Filial_Id  => v_Journal.Filial_Id,
                         i_Journal_Id => v_Journal.Journal_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Create_Overtime(p Hashmap) return Hashmap is
    r_Journal Hpd_Journals%rowtype;
  begin
    r_Journal.Company_Id := Ui.Company_Id;
    r_Journal.Filial_Id  := Ui.Filial_Id;
    r_Journal.Journal_Id := Hpd_Next.Journal_Id;
  
    save(p, r_Journal);
  
    return Fazo.Zip_Map('journal_id', r_Journal.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Overtime(p Hashmap) is
    r_Journal Hpd_Journals%rowtype;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => r_Journal.Journal_Id);
  
    save(p, r_Journal);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Overtime(p Hashmap) is
    v_Journal_Id number := p.r_Number('journal_id');
  begin
    Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  
    Hpd_Api.Journal_Delete(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id);
  end;

end Ui_Vhr462;
/
