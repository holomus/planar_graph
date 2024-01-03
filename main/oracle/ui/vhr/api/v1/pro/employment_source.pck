create or replace package Ui_Vhr417 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Employment_Sources(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Create_Employment_Source(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Employment_Source(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Employment_Source(p Hashmap);
end Ui_Vhr417;
/
create or replace package body Ui_Vhr417 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Employment_Sources(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Source_Ids Array_Number := Nvl(p.o_Array_Number('source_ids'), Array_Number());
    v_Count      number := v_Source_Ids.Count;
    v_Source     Gmap;
    v_Sources    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Href_Employment_Sources q
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Source_Id member of v_Source_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Source := Gmap();
    
      v_Source.Put('source_id', r.Source_Id);
      v_Source.Put('name', r.Name);
      v_Source.Put('kind', r.Kind);
      v_Source.Put('order_no', r.Order_No);
      v_Source.Put('state', r.State);
    
      v_Last_Id := r.Modified_Id;
    
      v_Sources.Push(v_Source.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Sources, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p        Hashmap,
    i_Source Href_Employment_Sources%rowtype
  ) is
    r_Source Href_Employment_Sources%rowtype := i_Source;
  begin
    r_Source.Name     := p.r_Varchar2('name');
    r_Source.Kind     := p.r_Varchar2('kind');
    r_Source.Order_No := p.o_Varchar2('order_no');
    r_Source.State    := Nvl(r_Source.State, 'A');
  
    Href_Api.Employment_Source_Save(r_Source);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Create_Employment_Source(p Hashmap) return Hashmap is
    r_Source Href_Employment_Sources%rowtype;
  begin
    r_Source.Company_Id := Ui.Company_Id;
    r_Source.Source_Id  := Href_Next.Employment_Source_Id;
  
    save(p, r_Source);
  
    return Fazo.Zip_Map('source_id', r_Source.Source_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Employment_Source(p Hashmap) is
    r_Source Href_Employment_Sources%rowtype;
  begin
    r_Source := z_Href_Employment_Sources.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                    i_Source_Id  => p.r_Number('source_id'));
  
    save(p, r_Source);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Employment_Source(p Hashmap) is
  begin
    Href_Api.Employment_Source_Delete(i_Company_Id => Ui.Company_Id,
                                      i_Source_Id  => p.r_Number('source_id'));
  end;

end Ui_Vhr417;
/
