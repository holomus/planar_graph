create or replace package Ui_Vhr455 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Requests(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Request(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Request(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Request(p Hashmap);
end Ui_Vhr455;
/
create or replace package body Ui_Vhr455 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Requests(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Request_Ids Array_Number := Nvl(p.o_Array_Number('request_ids'), Array_Number());
    v_Count       number := v_Request_Ids.Count;
    v_Request     Gmap;
    v_Requests    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Htt_Requests q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or --
                             q.Request_Id member of v_Request_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Request := Gmap();
    
      v_Request.Put('request_id', r.Request_Id);
      v_Request.Put('request_kind_id', r.Request_Kind_Id);
      v_Request.Put('staff_id', r.Staff_Id);
      v_Request.Put('begin_time', r.Begin_Time);
      v_Request.Put('end_time', r.End_Time);
      v_Request.Put('request_type', r.Request_Type);
      v_Request.Put('manager_note', r.Manager_Note);
      v_Request.Put('note', r.Note);
      v_Request.Put('accrual_kind', r.Accrual_Kind);
      v_Request.Put('status', r.Status);
      v_Request.Put('barcode', r.Barcode);
    
      v_Last_Id := r.Modified_Id;
    
      v_Requests.Push(v_Request.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Requests, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p            Hashmap,
    i_Request_Id number
  ) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request.Company_Id      := Ui.Company_Id;
    r_Request.Filial_Id       := Ui.Filial_Id;
    r_Request.Request_Id      := i_Request_Id;
    r_Request.Request_Kind_Id := p.r_Number('request_kind_id');
    r_Request.Staff_Id        := p.r_Number('staff_id');
    r_Request.Begin_Time      := p.r_Date('begin_time');
    r_Request.End_Time        := p.r_Date('end_time');
    r_Request.Request_Type    := p.r_Varchar2('request_type');
    r_Request.Manager_Note    := p.o_Varchar2('manager_note');
    r_Request.Note            := p.o_Varchar2('note');
    r_Request.Accrual_Kind    := Nvl(p.o_Varchar2('accrual_kind'), Htt_Pref.c_Accrual_Kind_Plan);
    r_Request.Status          := Htt_Pref.c_Request_Status_New;
  
    Htt_Api.Request_Save(r_Request);
  
    Htt_Api.Request_Complete(i_Company_Id => Ui.Company_Id,
                             i_Filial_Id  => Ui.Filial_Id,
                             i_Request_Id => i_Request_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Request(p Hashmap) return Hashmap is
    v_Request_Id number := Htt_Next.Request_Id;
  begin
    save(p, v_Request_Id);
  
    return Fazo.Zip_Map('request_id', v_Request_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Request(p Hashmap) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Request_Id => p.r_Number('request_id'));
  
    if r_Request.Status <> Htt_Pref.c_Request_Status_New then
      Htt_Api.Request_Reset(i_Company_Id => r_Request.Company_Id,
                            i_Filial_Id  => r_Request.Filial_Id,
                            i_Request_Id => r_Request.Request_Id);
    end if;
  
    save(p, r_Request.Request_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Request(p Hashmap) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Request_Id => p.r_Number('request_id'));
  
    if r_Request.Status <> Htt_Pref.c_Request_Status_New then
      Htt_Api.Request_Reset(i_Company_Id => r_Request.Company_Id,
                            i_Filial_Id  => r_Request.Filial_Id,
                            i_Request_Id => r_Request.Request_Id);
    end if;
  
    Htt_Api.Request_Delete(i_Company_Id => r_Request.Company_Id,
                           i_Filial_Id  => r_Request.Filial_Id,
                           i_Request_Id => r_Request.Request_Id);
  end;

end Ui_Vhr455;
/
