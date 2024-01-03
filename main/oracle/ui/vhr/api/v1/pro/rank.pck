create or replace package Ui_Vhr425 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Ranks(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Rank(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Rank(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Rank(p Hashmap);
end Ui_Vhr425;
/
create or replace package body Ui_Vhr425 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Ranks(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Rank_Ids Array_Number := Nvl(p.o_Array_Number('rank_ids'), Array_Number());
    v_Count    number := v_Rank_Ids.Count;
    v_Rank     Gmap;
    v_Ranks    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select q.*
                        from Mhr_Ranks q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or --
                             q.Rank_Id member of v_Rank_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Rank := Gmap();
    
      v_Rank.Put('name', r.Name);
      v_Rank.Put('rank_id', r.Rank_Id);
      v_Rank.Put('order_no', r.Order_No);
      v_Rank.Put('code', r.Code);
    
      v_Last_Id := r.Modified_Id;
    
      v_Ranks.Push(v_Rank.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Ranks, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p         Hashmap,
    i_Rank_Id number
  ) is
    r_Rank Mhr_Ranks%rowtype;
  begin
    r_Rank.Company_Id := Ui.Company_Id;
    r_Rank.Filial_Id  := Ui.Filial_Id;
    r_Rank.Rank_Id    := i_Rank_Id;
    r_Rank.Name       := p.r_Varchar2('name');
    r_Rank.Order_No   := p.o_Varchar2('order_no');
    r_Rank.Code       := p.o_Varchar2('code');
  
    Mhr_Api.Rank_Save(r_Rank);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Rank(p Hashmap) return Hashmap is
    v_Rank_Id number := Mhr_Next.Rank_Id;
  begin
    save(p, v_Rank_Id);
  
    return Fazo.Zip_Map('rank_id', v_Rank_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Rank(p Hashmap) is
    v_Rank_Id number := p.r_Number('rank_id');
  begin
    z_Mhr_Ranks.Lock_Only(i_Company_Id => Ui.Company_Id, --
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Rank_Id    => v_Rank_Id);
  
    save(p, v_Rank_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Rank(p Hashmap) is
  begin
    Mhr_Api.Rank_Delete(i_Company_Id => Ui.Company_Id, --
                        i_Filial_Id  => Ui.Filial_Id,
                        i_Rank_Id    => p.r_Number('rank_id'));
  end;

end Ui_Vhr425;
/
