create or replace package Ui_Vhr10 is
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
end Ui_Vhr10;
/
create or replace package body Ui_Vhr10 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Specialties,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Specialties,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Specialties%rowtype;
  begin
    r_Data := z_Href_Specialties.Load(i_Company_Id   => Ui.Company_Id,
                                      i_Specialty_Id => p.r_Number('specialty_id'));
  
    return z_Href_Specialties.To_Map(r_Data, z.Specialty_Id, z.Name, z.Kind, z.State, z.Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Specialties%rowtype;
  begin
    r_Data := z_Href_Specialties.To_Row(p, z.Name, z.Kind, z.Parent_Id, z.State, z.Code);
  
    r_Data.Company_Id   := Ui.Company_Id;
    r_Data.Specialty_Id := Href_Next.Specialty_Id;
  
    Href_Api.Specialty_Save(r_Data);
  
    return z_Href_Specialties.To_Map(r_Data, z.Specialty_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Specialties%rowtype;
  begin
    r_Data := z_Href_Specialties.Lock_Load(i_Company_Id   => Ui.Company_Id,
                                           i_Specialty_Id => p.r_Number('specialty_id'));
  
    z_Href_Specialties.To_Row(r_Data, p, z.Name, z.State, z.Code);
  
    Href_Api.Specialty_Save(r_Data);
  
    return z_Href_Specialties.To_Map(r_Data, z.Specialty_Id, z.Name);
  end;

end Ui_Vhr10;
/
