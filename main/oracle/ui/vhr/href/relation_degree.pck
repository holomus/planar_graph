create or replace package Ui_Vhr22 is
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
end Ui_Vhr22;
/
create or replace package body Ui_Vhr22 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Relation_Degrees,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Relation_Degrees,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Relation_Degrees%rowtype;
  begin
    r_Data := z_Href_Relation_Degrees.Load(i_Company_Id         => Ui.Company_Id,
                                           i_Relation_Degree_Id => p.r_Number('relation_degree_Id'));
  
    return z_Href_Relation_Degrees.To_Map(r_Data, z.Relation_Degree_Id, z.Name, z.State, z.Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Relation_Degrees%rowtype;
  begin
    r_Data := z_Href_Relation_Degrees.To_Row(p, z.Name, z.State, z.Code);
  
    r_Data.Company_Id         := Ui.Company_Id;
    r_Data.Relation_Degree_Id := Href_Next.Relation_Degree_Id;
  
    Href_Api.Relation_Degree_Save(r_Data);
  
    return z_Href_Relation_Degrees.To_Map(r_Data, z.Relation_Degree_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Relation_Degrees%rowtype;
  begin
    r_Data := z_Href_Relation_Degrees.Lock_Load(i_Company_Id         => Ui.Company_Id,
                                                i_Relation_Degree_Id => p.r_Number('relation_degree_id'));
  
    z_Href_Relation_Degrees.To_Row(r_Data, p, z.Name, z.State, z.Code);
  
    Href_Api.Relation_Degree_Save(r_Data);
  
    return z_Href_Relation_Degrees.To_Map(r_Data, z.Relation_Degree_Id, z.Name);
  end;

end Ui_Vhr22;
/
