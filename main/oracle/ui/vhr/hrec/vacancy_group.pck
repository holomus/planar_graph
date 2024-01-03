create or replace package Ui_Vhr641 is
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
end Ui_Vhr641;
/
create or replace package body Ui_Vhr641 is
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Name(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Hrec_Vacancy_Groups,
                                       i_Name       => p.o_Varchar2('name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique_Code(i_Company_Id => Ui.Company_Id,
                                       i_Table      => Zt.Hrec_Vacancy_Groups,
                                       i_Code       => p.o_Varchar2('code'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A', 'is_required', 'N');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Group Hrec_Vacancy_Groups%rowtype;
  begin
    r_Group := z_Hrec_Vacancy_Groups.Load(i_Company_Id       => Ui.Company_Id,
                                          i_Vacancy_Group_Id => p.r_Number('vacancy_group_id'));
  
    return z_Hrec_Vacancy_Groups.To_Map(r_Group,
                                        z.Vacancy_Group_Id,
                                        z.Name,
                                        z.Order_No,
                                        z.Is_Required,
                                        z.Code,
                                        z.State);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap is
    r_Group Hrec_Vacancy_Groups%rowtype;
  begin
    r_Group := z_Hrec_Vacancy_Groups.To_Row(p, z.Name, z.Order_No, z.Is_Required, z.Code, z.State);
  
    r_Group.Company_Id       := Ui.Company_Id;
    r_Group.Vacancy_Group_Id := Hrec_Next.Vacancy_Group_Id;
    r_Group.Multiple_Select  := 'N';
  
    Hrec_Api.Vacancy_Group_Save(r_Group);
  
    return Fazo.Zip_Map('vacancy_group_id', r_Group.Vacancy_Group_Id, 'name', r_Group.Name);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap is
    r_Group Hrec_Vacancy_Groups%rowtype;
  begin
    r_Group := z_Hrec_Vacancy_Groups.Lock_Load(i_Company_Id       => Ui.Company_Id,
                                               i_Vacancy_Group_Id => p.r_Number('vacancy_group_id'));
  
    z_Hrec_Vacancy_Groups.To_Row(r_Group, p, z.Name, z.Order_No, z.Is_Required, z.Code, z.State);
  
    Hrec_Api.Vacancy_Group_Save(r_Group);
  
    return Fazo.Zip_Map('vacancy_group_id', r_Group.Vacancy_Group_Id, 'name', r_Group.Name);
  end;

end Ui_Vhr641;
/
