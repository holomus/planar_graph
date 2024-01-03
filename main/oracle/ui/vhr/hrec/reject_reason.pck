create or replace package Ui_Vhr569 is
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
end Ui_Vhr569;
/
create or replace package body Ui_Vhr569 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Hrec_Reject_Reasons,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Hrec_Reject_Reasons,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Hrec_Reject_Reasons%rowtype;
  begin
    r_Data := z_Hrec_Reject_Reasons.Load(i_Company_Id       => Ui.Company_Id,
                                         i_Reject_Reason_Id => p.r_Number('reject_reason_id'));
  
    return z_Hrec_Reject_Reasons.To_Map(r_Data,
                                        z.Reject_Reason_Id,
                                        z.Name,
                                        z.State,
                                        z.Order_No,
                                        z.Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Hrec_Reject_Reasons%rowtype;
  begin
    r_Data := z_Hrec_Reject_Reasons.To_Row(p, z.Name, z.State, z.Order_No, z.Code);
  
    r_Data.Company_Id       := Ui.Company_Id;
    r_Data.Reject_Reason_Id := Hrec_Next.Reject_Reason_Id;
  
    Hrec_Api.Reject_Reason_Save(r_Data);
  
    return z_Hrec_Reject_Reasons.To_Map(r_Data, z.Reject_Reason_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hrec_Reject_Reasons%rowtype;
  begin
    r_Data := z_Hrec_Reject_Reasons.Lock_Load(i_Company_Id       => Ui.Company_Id,
                                              i_Reject_Reason_Id => p.r_Number('reject_reason_id'));
  
    z_Hrec_Reject_Reasons.To_Row(r_Data, p, z.Name, z.State, z.Order_No, z.Code);
  
    Hrec_Api.Reject_Reason_Save(r_Data);
  
    return z_Hrec_Reject_Reasons.To_Map(r_Data, z.Reject_Reason_Id, z.Name);
  end;

end Ui_Vhr569;
/
