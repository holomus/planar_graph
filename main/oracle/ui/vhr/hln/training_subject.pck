create or replace package Ui_Vhr237 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr237;
/
create or replace package body Ui_Vhr237 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Hln_Training_Subjects%rowtype;
  begin
    r_Data := z_Hln_Training_Subjects.Load(i_Company_Id => Ui.Company_Id,
                                           i_Filial_Id  => Ui.Filial_Id,
                                           i_Subject_Id => p.r_Number('subject_id'));
  
    return z_Hln_Training_Subjects.To_Map(r_Data, z.Subject_Id, z.Name, z.Code, z.State);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Hln_Training_Subjects%rowtype;
  begin
    r_Data := z_Hln_Training_Subjects.To_Row(p, z.Name, z.Code, z.State);
  
    r_Data.Company_Id := Ui.Company_Id;
    r_Data.Filial_Id  := Ui.Filial_Id;
    r_Data.Subject_Id := Hln_Next.Subject_Id;
  
    Hln_Api.Training_Subject_Save(r_Data);
  
    return z_Hln_Training_Subjects.To_Map(r_Data, z.Subject_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hln_Training_Subjects%rowtype;
  begin
    r_Data := z_Hln_Training_Subjects.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Subject_Id => p.r_Number('subject_id'));
  
    z_Hln_Training_Subjects.To_Row(r_Data, p, z.Name, z.Code, z.State);
  
    Hln_Api.Training_Subject_Save(r_Data);
  
    return z_Hln_Training_Subjects.To_Map(r_Data, z.Subject_Id, z.Name);
  end;

end Ui_Vhr237;
/
