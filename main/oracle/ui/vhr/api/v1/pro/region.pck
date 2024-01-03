create or replace package Ui_Vhr420 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Regions(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Region(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Region(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Region(p Hashmap);
end Ui_Vhr420;
/
create or replace package body Ui_Vhr420 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Regions(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Region_Ids Array_Number := Nvl(p.o_Array_Number('region_ids'), Array_Number());
    v_Count      number := v_Region_Ids.Count;
    v_Region     Gmap;
    v_Regions    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Md_Regions q
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Region_Id member of v_Region_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Region := Gmap();
    
      v_Region.Put('name', r.Name);
      v_Region.Put('region_id', r.Region_Id);
      v_Region.Put('parent_id', r.Parent_Id);
      v_Region.Put('latlng', r.Latlng);
      v_Region.Put('code', r.Code);
      v_Region.Put('state', r.State);
    
      v_Last_Id := r.Modified_Id;
    
      v_Regions.Push(v_Region.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Regions, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p        Hashmap,
    i_Region Md_Regions%rowtype
  ) is
    r_Region Md_Regions%rowtype := i_Region;
  
    --------------------------------------------------
    Function Get_Region_Kind(i_Parent_Id number) return varchar2 is
      r_Parent Md_Regions%rowtype;
    begin
      r_Parent := z_Md_Regions.Take(i_Company_Id => Ui.Company_Id, i_Region_Id => i_Parent_Id);
    
      case
        when r_Parent.Region_Kind is null then
          return Md_Pref.Rk_Country;
        when r_Parent.Region_Kind = Md_Pref.Rk_Country then
          return Md_Pref.Rk_Region;
        when r_Parent.Region_Kind = Md_Pref.Rk_Region then
          return Md_Pref.Rk_Town;
        when r_Parent.Region_Kind = Md_Pref.Rk_Town then
          return Md_Pref.Rk_District;
      end case;
    
      b.Raise_Error('district cannot have subregions');
    end;
  begin
    r_Region.Name        := p.r_Varchar2('name');
    r_Region.Parent_Id   := p.o_Number('parent_id');
    r_Region.Latlng      := p.o_Varchar2('latlng');
    r_Region.Code        := p.o_Varchar2('code');
    r_Region.State       := Nvl(r_Region.State, 'A');
    r_Region.Region_Kind := Get_Region_Kind(r_Region.Parent_Id);
  
    Md_Api.Region_Save(r_Region);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Region(p Hashmap) return Hashmap is
    r_Region Md_Regions%rowtype;
  begin
    r_Region.Company_Id := Ui.Company_Id;
    r_Region.Region_Id  := Md_Next.Region_Id;
  
    save(p, r_Region);
  
    return Fazo.Zip_Map('region_id', r_Region.Region_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Region(p Hashmap) is
    r_Region Md_Regions%rowtype;
  begin
    r_Region := z_Md_Regions.Lock_Load(i_Company_Id => Ui.Company_Id,
                                       i_Region_Id  => p.r_Number('region_id'));
  
    save(p, r_Region);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Region(p Hashmap) is
  begin
    Md_Api.Region_Delete(i_Company_Id => Ui.Company_Id, --
                         i_Region_Id  => p.r_Number('region_id'));
  end;

end Ui_Vhr420;
/
