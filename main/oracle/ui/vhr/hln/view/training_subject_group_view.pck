create or replace package Ui_Vhr675 is
  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr675;
/
create or replace package body Ui_Vhr675 is
  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap is
    r_Data          Hln_Training_Subject_Groups%rowtype;
    v_Subject_Names varchar2(4000);
    result          Hashmap;
  begin
    r_Data := z_Hln_Training_Subject_Groups.Load(i_Company_Id       => Ui.Company_Id,
                                                 i_Filial_Id        => Ui.Filial_Id,
                                                 i_Subject_Group_Id => p.r_Number('subject_group_id'));
  
    result := z_Hln_Training_Subject_Groups.To_Map(r_Data,
                                                   z.Subject_Group_Id,
                                                   z.Name,
                                                   z.Code,
                                                   z.State,
                                                   z.Created_On,
                                                   z.Modified_On);
  
    select Listagg((select w.Name
                     from Hln_Training_Subjects w
                    where w.Company_Id = q.Company_Id
                      and w.Filial_Id = q.Filial_Id
                      and w.Subject_Id = q.Subject_Id),
                   ', ')
      into v_Subject_Names
      from Hln_Training_Subject_Group_Subjects q
     where q.Company_Id = r_Data.Company_Id
       and q.Filial_Id = r_Data.Filial_Id
       and q.Subject_Group_Id = r_Data.Subject_Group_Id;
  
    Result.Put('subject_names', v_Subject_Names);
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
  
    return result;
  end;

end Ui_Vhr675;
/
