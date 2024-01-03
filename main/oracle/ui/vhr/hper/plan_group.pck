create or replace package Ui_Vhr131 is
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr131;
/
create or replace package body Ui_Vhr131 is
  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Hper_Plan_Groups%rowtype;
  begin
    r_Data := z_Hper_Plan_Groups.Load(i_Company_Id    => Ui.Company_Id,
                                      i_Filial_Id     => Ui.Filial_Id,
                                      i_Plan_Group_Id => p.r_Number('plan_group_id'));
  
    return z_Hper_Plan_Groups.To_Map(r_Data, --
                                     z.Plan_Group_Id,
                                     z.Name,
                                     z.State,
                                     z.Order_No);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap is
    r_Data Hper_Plan_Groups%rowtype;
  begin
    r_Data := z_Hper_Plan_Groups.To_Row(p, --
                                        z.Name,
                                        z.State,
                                        z.Order_No);
  
    r_Data.Company_Id    := Ui.Company_Id;
    r_Data.Filial_Id     := Ui.Filial_Id;
    r_Data.Plan_Group_Id := Hper_Next.Plan_Group_Id;
  
    Hper_Api.Plan_Group_Save(r_Data);
  
    return z_Hper_Plan_Groups.To_Map(r_Data, z.Plan_Group_Id, z.Name);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hper_Plan_Groups%rowtype;
  begin
    r_Data := z_Hper_Plan_Groups.Lock_Load(i_Company_Id    => Ui.Company_Id,
                                           i_Filial_Id     => Ui.Filial_Id,
                                           i_Plan_Group_Id => p.r_Number('plan_group_id'));
  
    z_Hper_Plan_Groups.To_Row(r_Data, p, z.Name, z.State, z.Order_No);
  
    Hper_Api.Plan_Group_Save(r_Data);
  
    return z_Hper_Plan_Groups.To_Map(r_Data, z.Plan_Group_Id, z.Name);
  end;

end Ui_Vhr131;
/
