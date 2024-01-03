create or replace package Ui_Vhr4 is
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
end Ui_Vhr4;
/
create or replace package body Ui_Vhr4 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Edu_Stages,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Href_Edu_Stages,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Href_Edu_Stages%rowtype;
    result Hashmap;
  begin
    r_Data := z_Href_Edu_Stages.Load(i_Company_Id   => Ui.Company_Id,
                                     i_Edu_Stage_Id => p.r_Number('edu_stage_id'));
  
    result := z_Href_Edu_Stages.To_Map(r_Data, z.Edu_Stage_Id, z.Name, z.State, z.Code, z.Order_No);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Data Href_Edu_Stages%rowtype;
  begin
    r_Data := z_Href_Edu_Stages.To_Row(p, z.Name, z.State, z.Code, z.Order_No);
  
    r_Data.Company_Id   := Ui.Company_Id;
    r_Data.Edu_Stage_Id := Href_Next.Edu_Stage_Id;
  
    Href_Api.Edu_Stage_Save(r_Data);
  
    return z_Href_Edu_Stages.To_Map(r_Data, z.Edu_Stage_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Href_Edu_Stages%rowtype;
  begin
    r_Data := z_Href_Edu_Stages.Lock_Load(i_Company_Id   => Ui.Company_Id,
                                          i_Edu_Stage_Id => p.r_Number('edu_stage_id'));
  
    z_Href_Edu_Stages.To_Row(r_Data, p, z.Name, z.State, z.Code, z.Order_No);
  
    Href_Api.Edu_Stage_Save(r_Data);
  
    return z_Href_Edu_Stages.To_Map(r_Data, z.Edu_Stage_Id, z.Name);
  end;

end Ui_Vhr4;
/
