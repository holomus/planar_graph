create or replace package Ui_Vhr208 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr208;
/
create or replace package body Ui_Vhr208 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A', 'is_required', 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Hln_Question_Groups%rowtype;
  begin
    r_Data := z_Hln_Question_Groups.Load(i_Company_Id        => Ui.Company_Id,
                                         i_Filial_Id         => Ui.Filial_Id,
                                         i_Question_Group_Id => p.r_Number('question_group_id'));
  
    return z_Hln_Question_Groups.To_Map(r_Data,
                                        z.Question_Group_Id,
                                        z.Name,
                                        z.Code,
                                        z.Is_Required,
                                        z.Order_No,
                                        z.State);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Hln_Question_Groups%rowtype;
  begin
    r_Data := z_Hln_Question_Groups.To_Row(p, z.Name, z.Code, z.Is_Required, z.Order_No, z.State);
  
    r_Data.Company_Id        := Ui.Company_Id;
    r_Data.Filial_Id         := Ui.Filial_Id;
    r_Data.Question_Group_Id := Hln_Next.Question_Group_Id;
  
    Hln_Api.Question_Group_Save(r_Data);
  
    return Fazo.Zip_Map('question_group_id', r_Data.Question_Group_Id, 'name', r_Data.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hln_Question_Groups%rowtype;
  begin
    r_Data := z_Hln_Question_Groups.Lock_Load(i_Company_Id        => Ui.Company_Id,
                                              i_Filial_Id         => Ui.Filial_Id,
                                              i_Question_Group_Id => p.r_Number('question_group_id'));
  
    z_Hln_Question_Groups.To_Row(r_Data, p, z.Name, z.Code, z.Is_Required, z.Order_No, z.State);
  
    Hln_Api.Question_Group_Save(r_Data);
  
    return Fazo.Zip_Map('question_group_id', r_Data.Question_Group_Id, 'name', r_Data.Name);
  end;

end Ui_Vhr208;
/
