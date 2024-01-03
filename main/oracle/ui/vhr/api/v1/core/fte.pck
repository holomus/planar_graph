create or replace package Ui_Vhr349 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Ftes(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Create_Fte(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Fte(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Fte(p Hashmap);
end Ui_Vhr349;
/
create or replace package body Ui_Vhr349 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Ftes(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Fte_Ids Array_Number := Nvl(p.o_Array_Number('fte_ids'), Array_Number());
    v_Count   number := v_Fte_Ids.Count;
    v_Fte     Gmap;
    v_Ftes    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Href_Ftes q
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Fte_Id member of v_Fte_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Fte := Gmap();
    
      v_Fte.Put('fte_id', r.Fte_Id);
      v_Fte.Put('name', r.Name);
      v_Fte.Put('value', r.Fte_Value);
    
      v_Last_Id := r.Modified_Id;
    
      v_Ftes.Push(v_Fte.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Ftes, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p        Hashmap,
    i_Fte_Id number
  ) is
    r_Fte Href_Ftes%rowtype;
  begin
    r_Fte.Company_Id := Ui.Company_Id;
    r_Fte.Fte_Id     := i_Fte_Id;
    r_Fte.Name       := p.r_Varchar2('name');
    r_Fte.Fte_Value  := p.r_Varchar2('value');
  
    Href_Api.Fte_Save(r_Fte);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Create_Fte(p Hashmap) return Hashmap is
    v_Fte_Id number := Href_Next.Fte_Id;
  begin
    save(p, v_Fte_Id);
  
    return Fazo.Zip_Map('fte_id', v_Fte_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Fte(p Hashmap) is
  begin
    z_Href_Ftes.Lock_Only(i_Company_Id => Ui.Company_Id, i_Fte_Id => p.r_Number('fte_id'));
  
    save(p, p.r_Number('fte_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Fte(p Hashmap) is
  begin
    Href_Api.Fte_Delete(i_Company_Id => Ui.Company_Id, i_Fte_Id => p.r_Number('fte_id'));
  end;

end Ui_Vhr349;
/
