create or replace package Ui_Vhr418 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Fixed_Term_Bases(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------  
  Function Create_Fixed_Term_Base(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Fixed_Term_Base(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Fixed_Term_Base(p Hashmap);
end Ui_Vhr418;
/
create or replace package body Ui_Vhr418 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Fixed_Term_Bases(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Fixed_Term_Base_Ids Array_Number := Nvl(p.o_Array_Number('fixed_term_base_ids'),
                                              Array_Number());
    v_Count               number := v_Fixed_Term_Base_Ids.Count;
    v_Fixed_Term_Base     Gmap;
    v_Fixed_Term_Bases    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Href_Fixed_Term_Bases q
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Fixed_Term_Base_Id member of v_Fixed_Term_Base_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Fixed_Term_Base := Gmap();
    
      v_Fixed_Term_Base.Put('fixed_term_base_id', r.Fixed_Term_Base_Id);
      v_Fixed_Term_Base.Put('name', r.Name);
      v_Fixed_Term_Base.Put('text', r.Text);
      v_Fixed_Term_Base.Put('state', r.State);
      v_Fixed_Term_Base.Put('code', r.Code);
    
      v_Last_Id := r.Modified_Id;
    
      v_Fixed_Term_Bases.Push(v_Fixed_Term_Base.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Fixed_Term_Bases, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p                 Hashmap,
    i_Fixed_Term_Base Href_Fixed_Term_Bases%rowtype
  ) is
    r_Fixed_Term_Base Href_Fixed_Term_Bases%rowtype := i_Fixed_Term_Base;
  begin
    r_Fixed_Term_Base.Name  := p.r_Varchar2('name');
    r_Fixed_Term_Base.Text  := p.o_Varchar2('text');
    r_Fixed_Term_Base.Code  := p.o_Varchar2('code');
    r_Fixed_Term_Base.State := Nvl(r_Fixed_Term_Base.State, 'A');
  
    Href_Api.Fixed_Term_Base_Save(r_Fixed_Term_Base);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Create_Fixed_Term_Base(p Hashmap) return Hashmap is
    r_Fixed_Term_Base Href_Fixed_Term_Bases%rowtype;
  begin
    r_Fixed_Term_Base.Company_Id         := Ui.Company_Id;
    r_Fixed_Term_Base.Fixed_Term_Base_Id := Href_Next.Fixed_Term_Base_Id;
  
    save(p, r_Fixed_Term_Base);
  
    return Fazo.Zip_Map('fixed_term_base_id', r_Fixed_Term_Base.Fixed_Term_Base_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Fixed_Term_Base(p Hashmap) is
    r_Fixed_Term_Base Href_Fixed_Term_Bases%rowtype;
  begin
    r_Fixed_Term_Base := z_Href_Fixed_Term_Bases.Lock_Load(i_Company_Id         => Ui.Company_Id,
                                                           i_Fixed_Term_Base_Id => p.r_Number('fixed_term_base_id'));
  
    save(p, r_Fixed_Term_Base);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Fixed_Term_Base(p Hashmap) is
  begin
    Href_Api.Fixed_Term_Base_Delete(i_Company_Id         => Ui.Company_Id,
                                    i_Fixed_Term_Base_Id => p.r_Number('fixed_term_base_id'));
  end;

end Ui_Vhr418;
/
