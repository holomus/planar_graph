create or replace package Ui_Vhr71 is
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
end Ui_Vhr71;
/
create or replace package body Ui_Vhr71 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Fixed_Term_Bases,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Fixed_Term_Bases,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Fixed_Term_Bases%rowtype;
    result Hashmap;
  begin
    r_Data := z_Href_Fixed_Term_Bases.Load(i_Company_Id         => Ui.Company_Id,
                                           i_Fixed_Term_Base_Id => p.r_Number('fixed_term_base_id'));
  
    result := z_Href_Fixed_Term_Bases.To_Map(r_Data,
                                             z.Fixed_Term_Base_Id,
                                             z.Name,
                                             z.Text,
                                             z.State,
                                             z.Code);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Fixed_Term_Bases%rowtype;
  begin
    r_Data := z_Href_Fixed_Term_Bases.To_Row(p, z.Name, z.Text, z.State, z.Code);
  
    r_Data.Company_Id         := Ui.Company_Id;
    r_Data.Fixed_Term_Base_Id := Href_Next.Fixed_Term_Base_Id;
  
    Href_Api.Fixed_Term_Base_Save(r_Data);
  
    return z_Href_Fixed_Term_Bases.To_Map(r_Data, z.Fixed_Term_Base_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Fixed_Term_Bases%rowtype;
  begin
    r_Data := z_Href_Fixed_Term_Bases.Lock_Load(i_Company_Id         => Ui.Company_Id,
                                                i_Fixed_Term_Base_Id => p.r_Number('fixed_term_base_id'));
  
    z_Href_Fixed_Term_Bases.To_Row(r_Data, p, z.Name, z.Text, z.State, z.Code);
  
    Href_Api.Fixed_Term_Base_Save(r_Data);
  
    return z_Href_Fixed_Term_Bases.To_Map(r_Data, z.Fixed_Term_Base_Id, z.Name);
  end;

end Ui_Vhr71;
/
