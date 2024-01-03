create or replace package Ui_Vhr643 is
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
end Ui_Vhr643;
/
create or replace package body Ui_Vhr643 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Hrec_Vacancy_Types,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Hrec_Vacancy_Types,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Type Hrec_Vacancy_Types%rowtype;
  begin
    r_Type := z_Hrec_Vacancy_Types.Load(i_Company_Id      => Ui.Company_Id,
                                        i_Vacancy_Type_Id => p.r_Number('vacancy_type_id'));
  
    return z_Hrec_Vacancy_Types.To_Map(r_Type, z.Vacancy_Type_Id, z.Name, z.Code, z.State);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap is
    r_Type Hrec_Vacancy_Types%rowtype;
  begin
    r_Type := z_Hrec_Vacancy_Types.To_Row(p, z.Name, z.Code, z.State);
  
    r_Type.Company_Id       := Ui.Company_Id;
    r_Type.Vacancy_Group_Id := p.r_Number('vacancy_group_id');
    r_Type.Vacancy_Type_Id  := Hrec_Next.Vacancy_Type_Id;
  
    Hrec_Api.Vacancy_Type_Save(r_Type);
  
    return Fazo.Zip_Map('vacancy_type_id', r_Type.Vacancy_Type_Id, 'name', r_Type.Name);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap is
    r_Type Hrec_Vacancy_Types%rowtype;
  begin
    r_Type := z_Hrec_Vacancy_Types.Lock_Load(i_Company_Id      => Ui.Company_Id,
                                             i_Vacancy_Type_Id => p.r_Number('vacancy_type_id'));
  
    z_Hrec_Vacancy_Types.To_Row(r_Type, p, z.Name, z.Code, z.State);
  
    Hrec_Api.Vacancy_Type_Save(r_Type);
  
    return Fazo.Zip_Map('vacancy_type_id', r_Type.Vacancy_Type_Id, 'name', r_Type.Name);
  end;

end Ui_Vhr643;
/
