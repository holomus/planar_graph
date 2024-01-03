create or replace package Ui_Vhr424 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Business_Trip_Reasons(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Create_Business_Trip_Reason(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Business_Trip_Reason(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Business_Trip_Reason(p Hashmap);
end Ui_Vhr424;
/
create or replace package body Ui_Vhr424 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Business_Trip_Reasons(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Business_Trip_Reason_Ids Array_Number := Nvl(p.o_Array_Number('reason_ids'), Array_Number());
    v_Count                    number := v_Business_Trip_Reason_Ids.Count;
    v_Business_Trip_Reason     Gmap;
    v_Business_Trip_Reasons    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Href_Business_Trip_Reasons q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or --
                             q.Reason_Id member of v_Business_Trip_Reason_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Business_Trip_Reason := Gmap();
    
      v_Business_Trip_Reason.Put('reason_id', r.Reason_Id);
      v_Business_Trip_Reason.Put('name', r.Name);
      v_Business_Trip_Reason.Put('state', r.State);
      v_Business_Trip_Reason.Put('code', r.Code);
    
      v_Last_Id := r.Modified_Id;
    
      v_Business_Trip_Reasons.Push(v_Business_Trip_Reason.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Business_Trip_Reasons, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p                      Hashmap,
    i_Business_Trip_Reason Href_Business_Trip_Reasons%rowtype
  ) is
    r_Business_Trip_Reason Href_Business_Trip_Reasons%rowtype := i_Business_Trip_Reason;
  begin
    r_Business_Trip_Reason.Name  := p.r_Varchar2('name');
    r_Business_Trip_Reason.State := Nvl(r_Business_Trip_Reason.State, 'A');
    r_Business_Trip_Reason.Code  := p.o_Varchar2('code');
  
    Href_Api.Business_Trip_Reason_Save(r_Business_Trip_Reason);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Create_Business_Trip_Reason(p Hashmap) return Hashmap is
    r_Business_Trip_Reason Href_Business_Trip_Reasons%rowtype;
  begin
    r_Business_Trip_Reason.Company_Id := Ui.Company_Id;
    r_Business_Trip_Reason.Filial_Id  := Ui.Filial_Id;
    r_Business_Trip_Reason.Reason_Id  := Href_Next.Business_Trip_Reason_Id;
  
    save(p, r_Business_Trip_Reason);
  
    return Fazo.Zip_Map('reason_id', r_Business_Trip_Reason.Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Business_Trip_Reason(p Hashmap) is
    r_Business_Trip_Reason Href_Business_Trip_Reasons%rowtype;
  begin
    r_Business_Trip_Reason := z_Href_Business_Trip_Reasons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                                     i_Filial_Id  => Ui.Filial_Id,
                                                                     i_Reason_Id  => p.r_Number('reason_id'));
  
    save(p, r_Business_Trip_Reason);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Business_Trip_Reason(p Hashmap) is
  begin
    Href_Api.Business_Trip_Reason_Delete(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Reason_Id  => p.r_Number('reason_id'));
  end;

end Ui_Vhr424;
/
