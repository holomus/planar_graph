create or replace package Ui_Vhr488 is
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
end Ui_Vhr488;
/
create or replace package body Ui_Vhr488 is
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
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Hsc_Processes%rowtype;
  begin
    r_Data := z_Hsc_Processes.Load(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Process_Id => p.r_Number('process_id'));
  
    return z_Hsc_Processes.To_Map(r_Data, z.Process_Id, z.Name, z.State);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Hsc_Processes%rowtype;
  begin
    r_Data := z_Hsc_Processes.To_Row(p, z.Name, z.State);
  
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Filial_Id  := Ui.Filial_Id;
    r_Data.Process_Id := Hsc_Next.Process_Id;
  
    Hsc_Api.Process_Save(r_Data);
  
    return z_Hsc_Processes.To_Map(r_Data, z.Process_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hsc_Processes%rowtype;
  begin
    r_Data := z_Hsc_Processes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Ui.Filial_Id,
                                        i_Process_Id => p.r_Number('process_id'));
  
    z_Hsc_Processes.To_Row(r_Data, p, z.Name, z.State);
  
    Hsc_Api.Process_Save(r_Data);
  
    return z_Hsc_Processes.To_Map(r_Data, z.Process_Id, z.Name);
  end;

end Ui_Vhr488;
/
