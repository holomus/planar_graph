create or replace package Ui_Vhr311 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr311;
/
create or replace package body Ui_Vhr311 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Ftes,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Ftes%rowtype;
  begin
    r_Data := z_Href_Ftes.Lock_Load(i_Company_Id => Ui.Company_Id, i_Fte_Id => p.r_Number('fte_id'));
  
    return z_Href_Ftes.To_Map(r_Data, z.Fte_Id, z.Name, z.Fte_Value, z.Order_No, z.Pcode);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Ftes%rowtype;
  begin
    r_Data := z_Href_Ftes.To_Row(p, z.Name, z.Fte_Value, z.Order_No);
  
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Fte_Id     := Href_Next.Fte_Id;
  
    Href_Api.Fte_Save(r_Data);
  
    return z_Href_Ftes.To_Map(r_Data, z.Fte_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Ftes%rowtype;
  begin
    r_Data := z_Href_Ftes.Lock_Load(i_Company_Id => Ui.Company_Id, i_Fte_Id => p.r_Number('fte_id'));
  
    z_Href_Ftes.To_Row(r_Data, p, z.Name, z.Fte_Value, z.Order_No);
  
    Href_Api.Fte_Save(r_Data);
  
    return z_Href_Ftes.To_Map(r_Data, z.Fte_Id, z.Name);
  end;

end Ui_Vhr311;
/
