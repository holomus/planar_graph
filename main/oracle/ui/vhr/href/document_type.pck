create or replace package Ui_Vhr114 is
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
end Ui_Vhr114;
/
create or replace package body Ui_Vhr114 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Document_Types,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Document_Types,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('is_required', 'N', 'state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Document_Types%rowtype;
  begin
    r_Data := z_Href_Document_Types.Load(i_Company_Id  => Ui.Company_Id,
                                         i_Doc_Type_Id => p.r_Number('doc_type_id'));
  
    return z_Href_Document_Types.To_Map(r_Data,
                                        z.Doc_Type_Id,
                                        z.Name,
                                        z.Is_Required,
                                        z.State,
                                        z.Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Document_Types%rowtype;
  begin
    r_Data := z_Href_Document_Types.To_Row(p, z.Name, z.Is_Required, z.State, z.Code);
  
    r_Data.Company_Id  := Ui.Company_Id;
    r_Data.Doc_Type_Id := Href_Next.Document_Type_Id;
  
    Href_Api.Document_Type_Save(r_Data);
  
    return z_Href_Document_Types.To_Map(r_Data, z.Doc_Type_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Document_Types%rowtype;
  begin
    r_Data := z_Href_Document_Types.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                              i_Doc_Type_Id => p.r_Number('doc_type_id'));
  
    z_Href_Document_Types.To_Row(r_Data, p, z.Name, z.Is_Required, z.State, z.Code);
  
    Href_Api.Document_Type_Save(r_Data);
  
    return z_Href_Document_Types.To_Map(r_Data, z.Doc_Type_Id, z.Name);
  end;

end Ui_Vhr114;
/
