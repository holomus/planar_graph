create or replace package Ui_Vhr496 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure save(p Hashmap);
end Ui_Vhr496;
/
create or replace package body Ui_Vhr496 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_division_groups',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id),
                    true);
  
    q.Number_Field('division_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Division_Group_Id,
                          (select s.Name
                             from Mhr_Division_Groups s
                            where s.Company_Id = t.Company_Id
                              and s.Division_Group_Id = t.Division_Group_Id))
      bulk collect
      into v_Matrix
      from Hsc_Object_Groups t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id;
  
    Result.Put('object_groups', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    v_Setting Hsc_Pref.Setting_Rt;
  begin
    Hsc_Util.Setting_New(o_Setting          => v_Setting,
                         i_Company_Id       => Ui.Company_Id,
                         i_Filial_Id        => Ui.Filial_Id,
                         i_Object_Group_Ids => p.r_Array_Number('object_group_ids'));
  
    Hsc_Api.Setting_Save(v_Setting);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Division_Groups
       set Company_Id = null,
           name       = null;
  end;

end Ui_Vhr496;
/
