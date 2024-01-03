create or replace package Ui_Vhr674 is
  ----------------------------------------------------------------------------------------------------  
  Function Training_Subject_Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr674;
/
create or replace package body Ui_Vhr674 is
  ----------------------------------------------------------------------------------------------------  
  Function Training_Subject_Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_training_subjects',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('subject_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Name_Is_Unique(p Hashmap) return varchar2 is
    v_Dummy      varchar2(1);
    v_Lower_Name Hln_Training_Subject_Groups.Name%type := Lower(p.o_Varchar2('name'));
  begin
    select 'x'
      into v_Dummy
      from Hln_Training_Subject_Groups q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and Lower(q.Name) = v_Lower_Name;
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
  begin
    return Fazo.Zip_Map('state', 'A');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    v_Matrix Matrix_Varchar2;
    r_Data   Hln_Training_Subject_Groups%rowtype;
    result   Hashmap;
  begin
    r_Data := z_Hln_Training_Subject_Groups.Load(i_Company_Id       => Ui.Company_Id,
                                                 i_Filial_Id        => Ui.Filial_Id,
                                                 i_Subject_Group_Id => p.r_Number('subject_group_id'));
  
    result := z_Hln_Training_Subject_Groups.To_Map(r_Data,
                                                   z.Subject_Group_Id,
                                                   z.Name,
                                                   z.Code,
                                                   z.State);
  
    select Array_Varchar2(q.Subject_Id,
                          (select w.Name
                             from Hln_Training_Subjects w
                            where w.Company_Id = q.Company_Id
                              and w.Filial_Id = q.Filial_Id
                              and w.Subject_Id = q.Subject_Id))
      bulk collect
      into v_Matrix
      from Hln_Training_Subject_Group_Subjects q
     where q.Company_Id = r_Data.Company_Id
       and q.Filial_Id = r_Data.Filial_Id
       and q.Subject_Group_Id = r_Data.Subject_Group_Id;
  
    Result.Put('training_subjects', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    i_Subject_Group_Id number,
    p                  Hashmap
  ) return Hashmap is
    v_Subject_Group Hln_Pref.Training_Subject_Group_Rt;
  begin
    v_Subject_Group.Company_Id       := Ui.Company_Id;
    v_Subject_Group.Filial_Id        := Ui.Filial_Id;
    v_Subject_Group.Subject_Group_Id := i_Subject_Group_Id;
    v_Subject_Group.Name             := p.r_Varchar2('name');
    v_Subject_Group.Code             := p.o_Varchar2('code');
    v_Subject_Group.State            := p.r_Varchar2('state');
    v_Subject_Group.Subject_Ids      := Nvl(p.o_Array_Number('subject_ids'), Array_Number());
  
    Hln_Api.Training_Subject_Group_Save(v_Subject_Group);
  
    return Fazo.Zip_Map('subject_group_id',
                        v_Subject_Group.Subject_Group_Id,
                        'name',
                        v_Subject_Group.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hln_Next.Training_Subject_Group_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Data Hln_Training_Subject_Groups%rowtype;
  begin
    r_Data := z_Hln_Training_Subject_Groups.Lock_Load(i_Company_Id       => Ui.Company_Id,
                                                      i_Filial_Id        => Ui.Filial_Id,
                                                      i_Subject_Group_Id => p.r_Number('subject_group_id'));
  
    return save(r_Data.Subject_Group_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hln_Training_Subjects
       set Company_Id = null,
           Filial_Id  = null,
           Subject_Id = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr674;
/
