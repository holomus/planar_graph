create or replace package Ui_Vhr337 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Divisions(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Create_Division(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Division(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Division(p Hashmap);
end Ui_Vhr337;
/
create or replace package body Ui_Vhr337 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Divisions(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Count        number := v_Division_Ids.Count;
    v_Division     Gmap;
    v_Divisions    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Mhr_Divisions q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or --
                             q.Division_Id member of v_Division_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Division := Gmap();
    
      v_Division.Put('division_id', r.Division_Id);
      v_Division.Put('name', r.Name);
      v_Division.Put('parent_id', r.Parent_Id);
      v_Division.Put('opened_date', r.Opened_Date);
      v_Division.Put('closed_date', r.Closed_Date);
      v_Division.Put('code', r.Code);
      v_Division.Put('state', r.State);
    
      v_Last_Id := r.Modified_Id;
    
      v_Divisions.Push(v_Division.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Divisions, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p          Hashmap,
    i_Division Mhr_Divisions%rowtype
  ) is
    r_Division Mhr_Divisions%rowtype := i_Division;
  begin
    r_Division.Name        := p.r_Varchar2('name');
    r_Division.Parent_Id   := p.o_Number('parent_id');
    r_Division.Opened_Date := p.r_Date('opened_date');
    r_Division.Closed_Date := p.o_Date('closed_date');
    r_Division.State       := Nvl(r_Division.State, 'A');
    r_Division.Code        := p.o_Varchar2('code');
  
    Mhr_Api.Division_Save(r_Division);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Create_Division(p Hashmap) return Hashmap is
    r_Division Mhr_Divisions%rowtype;
  begin
    r_Division.Company_Id  := Ui.Company_Id;
    r_Division.Filial_Id   := Ui.Filial_Id;
    r_Division.Division_Id := Mhr_Next.Division_Id;
  
    save(p, r_Division);
  
    return Fazo.Zip_Map('division_id', r_Division.Division_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Division(p Hashmap) is
    r_Division Mhr_Divisions%rowtype;
  begin
    r_Division := z_Mhr_Divisions.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                            i_Filial_Id   => Ui.Filial_Id,
                                            i_Division_Id => p.r_Number('division_id'));
  
    save(p, r_Division);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Division(p Hashmap) is
  begin
    Mhr_Api.Division_Delete(i_Company_Id  => Ui.Company_Id,
                            i_Filial_Id   => Ui.Filial_Id,
                            i_Division_Id => p.r_Number('division_id'));
  end;

end Ui_Vhr337;
/
