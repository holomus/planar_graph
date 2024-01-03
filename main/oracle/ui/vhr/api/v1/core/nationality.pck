create or replace package Ui_Vhr460 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Nationalities(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Nationality(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------       
  Procedure Update_Nationality(p Hashmap);
  ----------------------------------------------------------------------------------------------------       
  Procedure Delete_Nationality(p Hashmap);
end Ui_Vhr460;
/
create or replace package body Ui_Vhr460 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Nationalities(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Nationality_Ids Array_Number := Nvl(p.o_Array_Number('nationality_ids'), Array_Number());
    v_Count           number := v_Nationality_Ids.Count;
    v_Nationality     Gmap;
    v_Nationalities   Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Href_Nationalities q
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Nationality_Id member of v_Nationality_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Nationality := Gmap();
    
      v_Nationality.Put('nationality_id', r.Nationality_Id);
      v_Nationality.Put('name', r.Name);
      v_Nationality.Put('state', r.State);
      v_Nationality.Put('code', r.Code);
    
      v_Last_Id := r.Modified_Id;
    
      v_Nationalities.Push(v_Nationality.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Nationalities, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p                Hashmap,
    i_Nationality_Id number
  ) is
    r_Nationality Href_Nationalities%rowtype;
    v_State       varchar2(1) := z_Href_Nationalities.Take(i_Company_Id => Ui.Company_Id, i_Nationality_Id => i_Nationality_Id).State;
  begin
    r_Nationality.Company_Id     := Ui.Company_Id;
    r_Nationality.Nationality_Id := i_Nationality_Id;
    r_Nationality.Name           := p.r_Varchar2('name');
    r_Nationality.State          := Nvl(v_State, 'A');
    r_Nationality.Code           := p.o_Varchar2('code');
  
    Href_Api.Nationality_Save(i_Nationality => r_Nationality);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Nationality(p Hashmap) return Hashmap is
    v_Nationality_Id number := Href_Next.Nationality_Id;
  begin
    save(p, v_Nationality_Id);
  
    return Fazo.Zip_Map('nationality_id', v_Nationality_Id);
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Update_Nationality(p Hashmap) is
    v_Nationality_Id number := p.r_Varchar2('nationality_id');
  begin
    z_Href_Nationalities.Lock_Only(i_Company_Id     => Ui.Company_Id,
                                   i_Nationality_Id => v_Nationality_Id);
  
    save(p, v_Nationality_Id);
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Delete_Nationality(p Hashmap) is
  begin
    Href_Api.Nationality_Delete(i_Company_Id     => Ui.Company_Id,
                                i_Nationality_Id => p.r_Varchar2('nationality_id'));
  end;

end Ui_Vhr460;
/
