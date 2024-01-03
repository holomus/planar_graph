create or replace package Ui_Vhr130 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr130;
/
create or replace package body Ui_Vhr130 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hper_plan_groups',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('plan_group_id', 'order_no');
    q.Varchar2_Field('name', 'state');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Map_Field('plan_type_count',
                'select count(1)
                   from hper_plan_types q
                  where q.company_id = :company_id
                    and q.filial_id = :filial_id
                    and q.plan_group_id = $plan_group_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Ids Array_Number := Fazo.Sort(p.r_Array_Number('plan_group_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Hper_Api.Plan_Group_Delete(i_Company_Id    => Ui.Company_Id, --
                                 i_Filial_Id     => Ui.Filial_Id,
                                 i_Plan_Group_Id => v_Ids(i));
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Hper_Plan_Groups
       set Company_Id    = null,
           Filial_Id     = null,
           Plan_Group_Id = null,
           name          = null,
           State         = null,
           Order_No      = null;
    update Hper_Plan_Types
       set Company_Id    = null,
           Filial_Id     = null,
           Plan_Group_Id = null;
  end;

end Ui_Vhr130;
/
