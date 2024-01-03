create or replace package Ui_Vhr490 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Query_Measures return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr490;
/
create or replace package body Ui_Vhr490 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique(i_Company_Id   => Ui.Company_Id,
                                  i_Filial_Id    => Ui.Filial_Id,
                                  i_Table        => Zt.Hsc_Drivers,
                                  i_Column       => z.Name,
                                  i_Column_Value => p.o_Varchar2('name'),
                                  i_Check_Case   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Measures return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mr_measures',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'product_kind',
                                 Mr_Pref.c_Pk_Inventory,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('measure_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Hsc_Drivers%rowtype;
    result Hashmap;
  begin
    r_Data := z_Hsc_Drivers.Load(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Driver_Id  => p.r_Number('driver_id'));
  
    result := z_Hsc_Drivers.To_Map(r_Data, z.Driver_Id, z.Name, z.Measure_Id, z.State, z.Code);
  
    Result.Put('measure_name',
               z_Mr_Measures.Load(i_Company_Id => r_Data.Company_Id, --
               i_Measure_Id => r_Data.Measure_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Hsc_Drivers%rowtype;
  begin
    r_Data := z_Hsc_Drivers.To_Row(p, z.Name, z.Measure_Id, z.State);
  
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Filial_Id  := Ui.Filial_Id;
    r_Data.Driver_Id  := Hsc_Next.Driver_Id;
  
    Hsc_Api.Driver_Save(r_Data);
  
    return z_Hsc_Drivers.To_Map(r_Data, z.Driver_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hsc_Drivers%rowtype;
  begin
    r_Data := z_Hsc_Drivers.Lock_Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Driver_Id  => p.r_Number('driver_id'));
  
    z_Hsc_Drivers.To_Row(r_Data, p, z.Name, z.Measure_Id, z.State);
  
    Hsc_Api.Driver_Save(r_Data);
  
    return z_Hsc_Drivers.To_Map(r_Data, z.Driver_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mr_Measures
       set Company_Id = null,
           Measure_Id = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr490;
/
