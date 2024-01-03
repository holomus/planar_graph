create or replace package Ui_Vhr341 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Dismissal_Reasons(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Create_Dismissal_Reason(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Dismissal_Reason(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Dismissal_Reason(p Hashmap);
end Ui_Vhr341;
/
create or replace package body Ui_Vhr341 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Dismissal_Reasons(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Dismissal_Reason_Ids Array_Number := Nvl(p.o_Array_Number('dismissal_reason_ids'),
                                               Array_Number());
    v_Count                number := v_Dismissal_Reason_Ids.Count;
    v_Dismissal_Reason     Gmap;
    v_Dismissal_Reasons    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Href_Dismissal_Reasons q
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Dismissal_Reason_Id member of v_Dismissal_Reason_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Dismissal_Reason := Gmap();
    
      v_Dismissal_Reason.Put('name', r.Name);
      v_Dismissal_Reason.Put('dismissal_reason_id', r.Dismissal_Reason_Id);
      v_Dismissal_Reason.Put('description', r.Description);
      v_Dismissal_Reason.Put('reason_type', r.Reason_Type);
    
      v_Last_Id := r.Modified_Id;
    
      v_Dismissal_Reasons.Push(v_Dismissal_Reason.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Dismissal_Reasons, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p                     Hashmap,
    i_Dismissal_Reason_Id number
  ) is
    r_Dismissal_Reason Href_Dismissal_Reasons%rowtype;
  begin
    r_Dismissal_Reason.Company_Id          := Ui.Company_Id;
    r_Dismissal_Reason.Dismissal_Reason_Id := i_Dismissal_Reason_Id;
    r_Dismissal_Reason.Name                := p.r_Varchar2('name');
    r_Dismissal_Reason.Description         := p.o_Varchar2('description');
    r_Dismissal_Reason.Reason_Type         := p.r_Varchar2('reason_type');
  
    Href_Api.Dismissal_Reason_Save(r_Dismissal_Reason);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Create_Dismissal_Reason(p Hashmap) return Hashmap is
    v_Dismissal_Reason_Id number := Href_Next.Dismissal_Reason_Id;
  begin
    save(p, v_Dismissal_Reason_Id);
  
    return Fazo.Zip_Map('dismissal_reason_id', v_Dismissal_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Dismissal_Reason(p Hashmap) is
    v_Dismissal_Reason_Id number := p.r_Number('dismissal_reason_id');
  begin
    z_Href_Dismissal_Reasons.Lock_Only(i_Company_Id          => Ui.Company_Id,
                                       i_Dismissal_Reason_Id => v_Dismissal_Reason_Id);
  
    save(p, v_Dismissal_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Dismissal_Reason(p Hashmap) is
  begin
    Href_Api.Dismissal_Reason_Delete(i_Company_Id          => Ui.Company_Id,
                                     i_Dismissal_Reason_Id => p.r_Number('dismissal_reason_id'));
  end;

end Ui_Vhr341;
/
