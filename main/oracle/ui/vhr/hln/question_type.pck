create or replace package Ui_Vhr210 is
  ---------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr210;
/
create or replace package body Ui_Vhr210 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
  begin
    return Fazo.Zip_Map('state',
                        'A',
                        'group_name',
                        z_Hln_Question_Groups.Load(i_Company_Id => Ui.Company_Id, --
                        i_Filial_Id => Ui.Filial_Id, --
                        i_Question_Group_Id => p.r_Number('question_group_id')).Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Hln_Question_Types%rowtype;
    result Hashmap;
  begin
    r_Data := z_Hln_Question_Types.Load(i_Company_Id       => Ui.Company_Id,
                                        i_Filial_Id        => Ui.Filial_Id,
                                        i_Question_Type_Id => p.r_Number('question_type_id'));
  
    result := z_Hln_Question_Types.To_Map(r_Data,
                                          z.Question_Group_Id,
                                          z.Question_Type_Id,
                                          z.Name,
                                          z.Code,
                                          z.Order_No,
                                          z.State,
                                          z.Pcode);
    Result.Put('group_name',
               z_Hln_Question_Groups.Load(i_Company_Id => Ui.Company_Id, --
               i_Filial_Id => Ui.Filial_Id, --
               i_Question_Group_Id => r_Data.Question_Group_Id).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Hln_Question_Types%rowtype;
  begin
    r_Data := z_Hln_Question_Types.To_Row(p,
                                          z.Question_Group_Id,
                                          z.Name,
                                          z.Code,
                                          z.Order_No,
                                          z.State);
  
    r_Data.Company_Id       := Ui.Company_Id;
    r_Data.Filial_Id        := Ui.Filial_Id;
    r_Data.Question_Type_Id := Hln_Next.Question_Type_Id;
  
    Hln_Api.Question_Type_Save(r_Data);
  
    return Fazo.Zip_Map('question_type_id', r_Data.Question_Type_Id, 'name', r_Data.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hln_Question_Types%rowtype;
  begin
    r_Data := z_Hln_Question_Types.Lock_Load(i_Company_Id       => Ui.Company_Id,
                                             i_Filial_Id        => Ui.Filial_Id,
                                             i_Question_Type_Id => p.r_Number('question_type_id'));
  
    z_Hln_Question_Types.To_Row(r_Data, --
                                p,
                                z.Name,
                                z.Code,
                                z.Order_No,
                                z.State);
  
    Hln_Api.Question_Type_Save(r_Data);
  
    return Fazo.Zip_Map('question_type_id', r_Data.Question_Type_Id, 'name', r_Data.Name);
  end;

end Ui_Vhr210;
/
