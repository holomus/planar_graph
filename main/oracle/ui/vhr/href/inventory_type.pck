create or replace package Ui_Vhr466 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr466;
/
create or replace package body Ui_Vhr466 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Inventory_Types,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Inventory_Types%rowtype;
  begin
    r_Data := z_Href_Inventory_Types.Load(i_Company_Id        => Ui.Company_Id,
                                          i_Inventory_Type_Id => p.r_Number('inventory_type_id'));
  
    return z_Href_Inventory_Types.To_Map(r_Data, z.Inventory_Type_Id, z.Name, z.State);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Inventory_Types%rowtype;
  begin
    r_Data := z_Href_Inventory_Types.To_Row(p, z.Name, z.State);
  
    r_Data.Company_Id        := Ui.Company_Id;
    r_Data.Inventory_Type_Id := Href_Next.Inventory_Type_Id;
  
    Href_Api.Inventory_Type_Save(r_Data);
  
    return z_Href_Inventory_Types.To_Map(r_Data, z.Inventory_Type_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Inventory_Types%rowtype;
  begin
    r_Data := z_Href_Inventory_Types.Lock_Load(i_Company_Id        => Ui.Company_Id,
                                               i_Inventory_Type_Id => p.r_Number('inventory_type_id'));
  
    z_Href_Inventory_Types.To_Row(r_Data, p, z.Name, z.State);
  
    Href_Api.Inventory_Type_Save(r_Data);
  
    return z_Href_Inventory_Types.To_Map(r_Data, z.Inventory_Type_Id, z.State);
  end;

end Ui_Vhr466;
/
