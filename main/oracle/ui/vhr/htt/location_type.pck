create or replace package Ui_Vhr160 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr160;
/
create or replace package body Ui_Vhr160 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Location_Type Htt_Location_Types%rowtype;
  begin
    r_Location_Type := z_Htt_Location_Types.Load(i_Company_Id       => Ui.Company_Id,
                                                 i_Location_Type_Id => p.r_Number('location_type_id'));
  
    return z_Htt_Location_Types.To_Map(r_Location_Type,
                                       z.Location_Type_Id,
                                       z.Name,
                                       z.Color,
                                       z.State,
                                       z.Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Location_Type_Id number,
    p                  Hashmap
  ) return Hashmap is
    r_Location_Type Htt_Location_Types%rowtype;
  begin
    z_Htt_Location_Types.To_Row(r_Location_Type,
                                p,
                                z.Location_Type_Id,
                                z.Name,
                                z.Color,
                                z.State,
                                z.Code);
  
    r_Location_Type.Company_Id       := Ui.Company_Id;
    r_Location_Type.Location_Type_Id := i_Location_Type_Id;
  
    Htt_Api.Location_Type_Save(r_Location_Type);
  
    return z_Htt_Location_Types.To_Map(r_Location_Type, z.Location_Type_Id, z.Name, z.Color);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Htt_Next.Location_Type_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    v_Location_Type_Id number := p.r_Number('location_type_id');
  begin
    z_Htt_Location_Types.Lock_Only(i_Company_Id       => Ui.Company_Id,
                                   i_Location_Type_Id => v_Location_Type_Id);
  
    return save(v_Location_Type_Id, p);
  end;

end Ui_Vhr160;
/
