create or replace package Ui_Vhr421 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Sick_Leave_Reasons(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Create_Sick_Leave_Reason(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Sick_Leave_Reason(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Sick_Leave_Reason(p Hashmap);
end Ui_Vhr421;
/
create or replace package body Ui_Vhr421 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Sick_Leave_Reasons(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Sick_Leave_Reason_Ids Array_Number := Nvl(p.o_Array_Number('reason_ids'), Array_Number());
    v_Count                 number := v_Sick_Leave_Reason_Ids.Count;
    v_Sick_Leave_Reason     Gmap;
    v_Sick_Leave_Reasons    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Href_Sick_Leave_Reasons q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or --
                             q.Reason_Id member of v_Sick_Leave_Reason_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Sick_Leave_Reason := Gmap();
    
      v_Sick_Leave_Reason.Put('reason_id', r.Reason_Id);
      v_Sick_Leave_Reason.Put('name', r.Name);
      v_Sick_Leave_Reason.Put('coefficient', r.Coefficient);
      v_Sick_Leave_Reason.Put('state', r.State);
      v_Sick_Leave_Reason.Put('code', r.Code);
    
      v_Last_Id := r.Modified_Id;
    
      v_Sick_Leave_Reasons.Push(v_Sick_Leave_Reason.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Sick_Leave_Reasons, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p                   Hashmap,
    i_Sick_Leave_Reason Href_Sick_Leave_Reasons%rowtype
  ) is
    r_Sick_Leave_Reason Href_Sick_Leave_Reasons%rowtype := i_Sick_Leave_Reason;
  begin
    r_Sick_Leave_Reason.Name        := p.r_Varchar2('name');
    r_Sick_Leave_Reason.Coefficient := p.r_Varchar2('coefficient');
    r_Sick_Leave_Reason.State       := Nvl(r_Sick_Leave_Reason.State, 'A');
    r_Sick_Leave_Reason.Code        := p.o_Varchar2('code');
  
    Href_Api.Sick_Leave_Reason_Save(r_Sick_Leave_Reason);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Create_Sick_Leave_Reason(p Hashmap) return Hashmap is
    r_Sick_Leave_Reason Href_Sick_Leave_Reasons%rowtype;
  begin
    r_Sick_Leave_Reason.Company_Id := Ui.Company_Id;
    r_Sick_Leave_Reason.Filial_Id  := Ui.Filial_Id;
    r_Sick_Leave_Reason.Reason_Id  := Href_Next.Sick_Leave_Reason_Id;
  
    save(p, r_Sick_Leave_Reason);
  
    return Fazo.Zip_Map('reason_id', r_Sick_Leave_Reason.Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Sick_Leave_Reason(p Hashmap) is
    r_Sick_Leave_Reason Href_Sick_Leave_Reasons%rowtype;
  begin
    r_Sick_Leave_Reason := z_Href_Sick_Leave_Reasons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                               i_Filial_Id  => Ui.Filial_Id,
                                                               i_Reason_Id  => p.r_Number('reason_id'));
  
    save(p, r_Sick_Leave_Reason);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Sick_Leave_Reason(p Hashmap) is
  begin
    z_Href_Sick_Leave_Reasons.Delete_One(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Reason_Id  => p.r_Number('reason_id'));
  end;

end Ui_Vhr421;
/
