create or replace package Ui_Vhr253 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr253;
/
create or replace package body Ui_Vhr253 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Hrm_Wage_Scales%rowtype;
  begin
    r_Data := z_Hrm_Wage_Scales.Load(i_Company_Id    => Ui.Company_Id,
                                     i_Filial_Id     => Ui.Filial_Id,
                                     i_Wage_Scale_Id => p.r_Number('wage_scale_id'));
  
    return z_Hrm_Wage_Scales.To_Map(r_Data, --
                                    z.Wage_Scale_Id,
                                    z.Name,
                                    z.Full_Name,
                                    z.State);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Hrm_Wage_Scales%rowtype;
  begin
    r_Data := z_Hrm_Wage_Scales.To_Row(p, z.Name, z.Full_Name, z.State);
  
    r_Data.Company_Id    := Ui.Company_Id;
    r_Data.Filial_Id     := Ui.Filial_Id;
    r_Data.Wage_Scale_Id := Hrm_Next.Wage_Scale_Id;
  
    Hrm_Api.Wage_Scale_Save(r_Data);
  
    return z_Hrm_Wage_Scales.To_Map(r_Data, z.Wage_Scale_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hrm_Wage_Scales%rowtype;
  begin
    r_Data := z_Hrm_Wage_Scales.Lock_Load(i_Company_Id    => Ui.Company_Id,
                                          i_Filial_Id     => Ui.Filial_Id,
                                          i_Wage_Scale_Id => p.r_Number('wage_scale_id'));
  
    z_Hrm_Wage_Scales.To_Row(r_Data, --
                             p,
                             z.Name,
                             z.Full_Name,
                             z.State);
  
    Hrm_Api.Wage_Scale_Save(r_Data);
  
    return z_Hrm_Wage_Scales.To_Map(r_Data, z.Wage_Scale_Id, z.Name);
  end;

end Ui_Vhr253;
/
