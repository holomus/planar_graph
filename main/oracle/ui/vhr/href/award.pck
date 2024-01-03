create or replace package Ui_Vhr29 is
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
end Ui_Vhr29;
/
create or replace package body Ui_Vhr29 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Awards,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Awards%rowtype;
  begin
    r_Data := z_Href_Awards.Load(i_Company_Id => Ui.Company_Id,
                                 i_Award_Id   => p.r_Number('award_id'));
  
    return z_Href_Awards.To_Map(r_Data, z.Award_Id, z.Name, z.State);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Awards%rowtype;
  begin
    r_Data := z_Href_Awards.To_Row(p, z.Name, z.State);
  
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Award_Id   := Href_Next.Award_Id;
  
    Href_Api.Award_Save(r_Data);
  
    return z_Href_Awards.To_Map(r_Data, z.Award_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Awards%rowtype;
  begin
    r_Data := z_Href_Awards.Lock_Load(i_Company_Id => Ui.Company_Id,
                                      i_Award_Id   => p.r_Number('award_id'));
  
    z_Href_Awards.To_Row(r_Data, p, z.Name, z.State);
  
    Href_Api.Award_Save(r_Data);
  
    return z_Href_Awards.To_Map(r_Data, z.Award_Id, z.Name);
  end;

end Ui_Vhr29;
/
