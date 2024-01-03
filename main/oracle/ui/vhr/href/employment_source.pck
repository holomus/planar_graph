create or replace package Ui_Vhr142 is
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr142;
/
create or replace package body Ui_Vhr142 is
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('state', 'A');
    Result.Put('kind', Href_Pref.c_Employment_Source_Kind_Hiring);
    Result.Put('kind_name',
               Href_Util.t_Employment_Source(Href_Pref.c_Employment_Source_Kind_Hiring));
    Result.Put('kinds', Fazo.Zip_Matrix(Href_Util.Employment_Source_Kinds));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Employment_Sources%rowtype;
    result Hashmap;
  begin
    r_Data := z_Href_Employment_Sources.Load(i_Company_Id => Ui.Company_Id,
                                             i_Source_Id  => p.r_Number('source_id'));
  
    result := z_Href_Employment_Sources.To_Map(r_Data,
                                               z.Source_Id,
                                               z.Name,
                                               z.Kind,
                                               z.Order_No,
                                               z.State);
  
    Result.Put('kind_name', Href_Util.t_Employment_Source(r_Data.Kind));
    Result.Put('kinds', Fazo.Zip_Matrix(Href_Util.Employment_Source_Kinds));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Employment_Sources%rowtype;
  begin
    r_Data := z_Href_Employment_Sources.To_Row(p, z.Name, z.Kind, z.Order_No, z.State);
  
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Source_Id  := Href_Next.Employment_Source_Id;
  
    Href_Api.Employment_Source_Save(r_Data);
  
    return z_Href_Employment_Sources.To_Map(r_Data, z.Source_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Employment_Sources%rowtype;
  begin
    r_Data := z_Href_Employment_Sources.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                  i_Source_Id  => p.r_Number('source_id'));
  
    z_Href_Employment_Sources.To_Row(r_Data, p, z.Name, z.Kind, z.Order_No, z.State);
  
    Href_Api.Employment_Source_Save(r_Data);
  
    return z_Href_Employment_Sources.To_Map(r_Data, z.Source_Id, z.Name);
  end;

end Ui_Vhr142;
/
