create or replace package Ui_Vhr167 is
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
end Ui_Vhr167;
/
create or replace package body Ui_Vhr167 is
  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Sick_Leave_Reasons,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Sick_Leave_Reasons%rowtype;
  begin
    r_Data := z_Href_Sick_Leave_Reasons.Load(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Reason_Id  => p.r_Number('reason_id'));
  
    return z_Href_Sick_Leave_Reasons.To_Map(r_Data,
                                            z.Reason_Id,
                                            z.Name,
                                            z.Coefficient,
                                            z.State,
                                            z.Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Sick_Leave_Reasons%rowtype;
  begin
    r_Data := z_Href_Sick_Leave_Reasons.To_Row(p, z.Name, z.Coefficient, z.State, z.Code);
  
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Filial_Id  := Ui.Filial_Id;
    r_Data.Reason_Id  := Href_Next.Sick_Leave_Reason_Id;
  
    Href_Api.Sick_Leave_Reason_Save(r_Data);
  
    return z_Href_Sick_Leave_Reasons.To_Map(r_Data, z.Reason_Id, z.Name, z.Coefficient);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Sick_Leave_Reasons%rowtype;
  begin
    r_Data := z_Href_Sick_Leave_Reasons.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                  i_Filial_Id  => Ui.Filial_Id,
                                                  i_Reason_Id  => p.r_Number('reason_id'));
  
    z_Href_Sick_Leave_Reasons.To_Row(r_Data, p, z.Name, z.Coefficient, z.State, z.Code);
  
    Href_Api.Sick_Leave_Reason_Save(r_Data);
  
    return z_Href_Sick_Leave_Reasons.To_Map(r_Data, z.Reason_Id, z.Name, z.Coefficient);
  end;

end Ui_Vhr167;
/
