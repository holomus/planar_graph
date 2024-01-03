create or replace package Ui_Vhr20 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr20;
/
create or replace package body Ui_Vhr20 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Lang_Levels,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Lang_Levels,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Lang_Levels%rowtype;
  begin
    r_Data := z_Href_Lang_Levels.Load(i_Company_Id    => Ui.Company_Id,
                                      i_Lang_Level_Id => p.r_Number('lang_level_id'));
  
    return z_Href_Lang_Levels.To_Map(r_Data, z.Lang_Level_Id, z.Name, z.State, z.Order_No, z.Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Lang_Levels%rowtype;
  begin
    r_Data := z_Href_Lang_Levels.To_Row(p, z.Name, z.State, z.Order_No, z.Code);
  
    r_Data.Company_Id    := Ui.Company_Id;
    r_Data.Lang_Level_Id := Href_Next.Lang_Level_Id;
  
    Href_Api.Lang_Level_Save(r_Data);
  
    return z_Href_Lang_Levels.To_Map(r_Data, z.Lang_Level_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Lang_Levels%rowtype;
  begin
    r_Data := z_Href_Lang_Levels.Lock_Load(i_Company_Id    => Ui.Company_Id,
                                           i_Lang_Level_Id => p.r_Number('lang_level_id'));
  
    z_Href_Lang_Levels.To_Row(r_Data, p, z.Name, z.State, z.Order_No, z.Code);
  
    Href_Api.Lang_Level_Save(r_Data);
  
    return z_Href_Lang_Levels.To_Map(r_Data, z.Lang_Level_Id, z.Name);
  end;

end Ui_Vhr20;
/
