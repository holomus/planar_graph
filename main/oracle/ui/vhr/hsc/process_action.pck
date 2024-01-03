create or replace package Ui_Vhr492 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr492;
/
create or replace package body Ui_Vhr492 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return 'Y';
  
    -- TODO:
    return Href_Util.Check_Unique(i_Company_Id   => Ui.Company_Id,
                                  i_Filial_Id    => Ui.Filial_Id,
                                  i_Table        => Zt.Hsc_Process_Actions,
                                  i_Column       => z.Name,
                                  i_Column_Value => p.o_Varchar2('name'),
                                  i_Check_Case   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    v_Process_Id number := p.r_Number('process_id');
  begin
    return Fazo.Zip_Map('process_id', --
                        v_Process_Id,
                        'process_name',
                        z_Hsc_Processes.Load(i_Company_Id => Ui.Company_Id, --                        
                        i_Filial_Id => Ui.Filial_Id, i_Process_Id => v_Process_Id).Name,
                        'state',
                        'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Hsc_Process_Actions%rowtype;
    result Hashmap;
  begin
    r_Data := z_Hsc_Process_Actions.Load(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_Action_Id  => p.r_Number('action_id'));
  
    result := z_Hsc_Process_Actions.To_Map(r_Data, z.Action_Id, z.Name, z.State);
  
    Result.Put('process_name',
               z_Hsc_Processes.Load(i_Company_Id => r_Data.Company_Id, --                        
               i_Filial_Id => r_Data.Filial_Id, i_Process_Id => r_Data.Process_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Hsc_Process_Actions%rowtype;
  begin
    r_Data := z_Hsc_Process_Actions.To_Row(p, z.Process_Id, z.Name, z.State);
  
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Filial_Id  := Ui.Filial_Id;
    r_Data.Action_Id  := Hsc_Next.Process_Action_Id;
  
    Hsc_Api.Process_Action_Save(r_Data);
  
    return z_Hsc_Process_Actions.To_Map(r_Data, z.Action_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hsc_Process_Actions%rowtype;
  begin
    r_Data := z_Hsc_Process_Actions.Lock_Load(i_Company_Id => Ui.Company_Id,
                                              i_Filial_Id  => Ui.Filial_Id,
                                              i_Action_Id  => p.r_Number('action_id'));
  
    z_Hsc_Process_Actions.To_Row(r_Data, p, z.Name, z.State);
  
    Hsc_Api.Process_Action_Save(r_Data);
  
    return z_Hsc_Process_Actions.To_Map(r_Data, z.Action_Id, z.Name);
  end;

end Ui_Vhr492;
/
