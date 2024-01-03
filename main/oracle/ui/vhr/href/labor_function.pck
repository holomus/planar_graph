create or replace package Ui_Vhr48 is
  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr48;
/
create or replace package body Ui_Vhr48 is
  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Labor_Functions,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Labor_Functions%rowtype;
  begin
    r_Data := z_Href_Labor_Functions.Load(i_Company_Id        => Ui.Company_Id,
                                          i_Labor_Function_Id => p.r_Number('labor_function_id'));
  
    return z_Href_Labor_Functions.To_Map(r_Data,
                                         z.Labor_Function_Id,
                                         z.Name,
                                         z.Description,
                                         z.Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Labor_Functions%rowtype;
  begin
    r_Data := z_Href_Labor_Functions.To_Row(p, z.Name, z.Description, z.Code);
  
    r_Data.Company_Id        := Ui.Company_Id;
    r_Data.Labor_Function_Id := Href_Next.Labor_Function_Id;
  
    Href_Api.Labor_Function_Save(r_Data);
  
    return z_Href_Labor_Functions.To_Map(r_Data, z.Labor_Function_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Labor_Functions%rowtype;
  begin
    r_Data := z_Href_Labor_Functions.Lock_Load(i_Company_Id        => Ui.Company_Id,
                                               i_Labor_Function_Id => p.r_Number('labor_function_id'));
  
    z_Href_Labor_Functions.To_Row(r_Data, p, z.Name, z.Description, z.Code);
  
    Href_Api.Labor_Function_Save(r_Data);
  
    return z_Href_Labor_Functions.To_Map(r_Data, z.Labor_Function_Id, z.Name);
  end;

end Ui_Vhr48;
/
