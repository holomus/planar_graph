create or replace package Ui_Vhr50 is
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr50;
/
create or replace package body Ui_Vhr50 is
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('reason_type', Href_Pref.c_Dismissal_Reasons_Type_Positive);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Dismissal_Reasons%rowtype;
  begin
    r_Data := z_Href_Dismissal_Reasons.Load(i_Company_Id          => Ui.Company_Id,
                                            i_Dismissal_Reason_Id => p.r_Number('dismissal_reason_id'));
    return z_Href_Dismissal_Reasons.To_Map(r_Data,
                                           z.Dismissal_Reason_Id,
                                           z.Name,
                                           z.Description,
                                           z.Reason_Type);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Dismissal_Reasons%rowtype;
  begin
    r_Data := z_Href_Dismissal_Reasons.To_Row(p, z.Name, z.Description, z.Reason_Type);
  
    r_Data.Company_Id          := Ui.Company_Id;
    r_Data.Dismissal_Reason_Id := Href_Next.Dismissal_Reason_Id;
  
    Href_Api.Dismissal_Reason_Save(r_Data);
  
    return z_Href_Dismissal_Reasons.To_Map(r_Data, z.Dismissal_Reason_Id, z.Name, z.Reason_Type);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Dismissal_Reasons%rowtype;
  begin
    r_Data := z_Href_Dismissal_Reasons.Lock_Load(i_Company_Id          => Ui.Company_Id,
                                                 i_Dismissal_Reason_Id => p.r_Number('dismissal_reason_id'));
    z_Href_Dismissal_Reasons.To_Row(r_Data, p, z.Name, z.Description, z.Reason_Type);
    Href_Api.Dismissal_Reason_Save(r_Data);
  
    return z_Href_Dismissal_Reasons.To_Map(r_Data, z.Dismissal_Reason_Id, z.Name, z.Reason_Type);
  end;

end Ui_Vhr50;
/
