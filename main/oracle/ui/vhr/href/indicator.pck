create or replace package Ui_Vhr58 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Indicator_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Identifier_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr58;
/
create or replace package body Ui_Vhr58 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Indicator_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_indicator_groups', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('indicator_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Identifier_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique(i_Company_Id   => Ui.Company_Id,
                                  i_Table        => Zt.Href_Indicators,
                                  i_Column       => z.Identifier,
                                  i_Column_Value => p.o_Varchar2('identifier'),
                                  i_Check_Case   => 'Y');
  
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Indicator Href_Indicators%rowtype;
    result      Hashmap;
  begin
    r_Indicator := z_Href_Indicators.Load(i_Company_Id   => Ui.Company_Id,
                                          i_Indicator_Id => p.r_Number('indicator_id'));
  
    result := z_Href_Indicators.To_Map(r_Indicator,
                                       z.Indicator_Id,
                                       z.Indicator_Group_Id,
                                       z.Name,
                                       z.Short_Name,
                                       z.Identifier,
                                       z.State);
  
    Result.Put('indicator_group_name',
               z_Href_Indicator_Groups.Take(i_Company_Id => r_Indicator.Company_Id, i_Indicator_Group_Id => r_Indicator.Indicator_Group_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Indicator Href_Indicators%rowtype;
  begin
    r_Indicator := z_Href_Indicators.To_Row(p,
                                            z.Indicator_Group_Id,
                                            z.Name,
                                            z.Short_Name,
                                            z.Identifier,
                                            z.State);
  
    r_Indicator.Company_Id   := Ui.Company_Id;
    r_Indicator.Indicator_Id := Href_Next.Indicator_Id;
  
    Href_Api.Indicator_Save(r_Indicator);
  
    return z_Href_Indicators.To_Map(r_Indicator, z.Indicator_Id, z.Name, z.Identifier);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Indicator Href_Indicators%rowtype;
  begin
    r_Indicator := z_Href_Indicators.Lock_Load(i_Company_Id   => Ui.Company_Id,
                                               i_Indicator_Id => p.r_Number('indicator_id'));
  
    z_Href_Indicators.To_Row(r_Indicator,
                             p,
                             z.Indicator_Group_Id,
                             z.Name,
                             z.Short_Name,
                             z.Identifier,
                             z.State);
  
    Href_Api.Indicator_Save(r_Indicator);
  
    return z_Href_Indicators.To_Map(r_Indicator, z.Indicator_Id, z.Name, z.Identifier);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Href_Indicator_Groups
       set Company_Id         = null,
           Indicator_Group_Id = null,
           name               = null;
  end;

end Ui_Vhr58;
/
