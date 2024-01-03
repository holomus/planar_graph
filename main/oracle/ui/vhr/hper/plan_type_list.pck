create or replace package Ui_Vhr132 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr132;
/
create or replace package body Ui_Vhr132 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query(p Hashmap) return Fazo_Query is
    v_Division_Id Array_Number;
    v_Matrix      Matrix_Varchar2;
    v_Param       Hashmap := Hashmap();
    q             Fazo_Query;
  begin
    if p.Has('division_id') then
      v_Division_Id := p.o_Array_Number('division_id');
    end if;
  
    v_Param.Put('company_id', Ui.Company_Id);
    v_Param.Put('filial_id', Ui.Filial_Id);
    v_Param.Put('division_id', v_Division_Id);
  
    q := Fazo_Query('select q.*
                       from hper_plan_types q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id' || --
                    case
                      when v_Division_Id is not null then
                       ' and (q.c_divisions_exist = ''N''
                          or exists (select 1
                                from hper_plan_type_divisions s
                               where s.company_id = q.company_id
                                 and s.filial_id = q.filial_id
                                 and s.plan_type_id = q.plan_type_id
                                 and s.division_id member of :division_id))'
                      else
                       null
                    end,
                    v_Param);
  
    q.Number_Field('plan_type_id', 'plan_group_id', 'order_no');
    q.Varchar2_Field('name', 'calc_kind', 'extra_amount_enabled', 'state', 'code');
  
    v_Matrix := Hper_Util.Calc_Kinds;
    q.Option_Field('calc_kind_name', 'calc_kind', v_Matrix(1), v_Matrix(2));
    q.Option_Field('extra_amount_enabled_name',
                   'extra_amount_enabled',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Refer_Field('group_name',
                  'plan_group_id',
                  'hper_plan_groups',
                  'plan_group_id',
                  'name',
                  'select * from hper_plan_groups q where q.company_id = :company_id');
  
    q.Map_Field('group_order_no',
                'select q.order_no
                   from hper_plan_groups q 
                  where q.company_id = :company_id
                    and q.filial_id = :filial_id
                    and q.plan_group_id = $plan_group_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Ids Array_Number := p.r_Array_Number('plan_type_id');
  begin
    for i in 1 .. v_Ids.Count
    loop
      Hper_Api.Plan_Type_Delete(i_Company_Id   => Ui.Company_Id,
                                i_Filial_Id    => Ui.Filial_Id,
                                i_Plan_Type_Id => v_Ids(i));
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Hper_Plan_Types
       set Company_Id           = null,
           Filial_Id            = null,
           Plan_Type_Id         = null,
           name                 = null,
           Plan_Group_Id        = null,
           Calc_Kind            = null,
           With_Part            = null,
           Extra_Amount_Enabled = null,
           State                = null,
           Code                 = null,
           Order_No             = null,
           c_Divisions_Exist    = null;
    update Hper_Plan_Type_Divisions
       set Company_Id   = null,
           Filial_Id    = null,
           Plan_Type_Id = null,
           Division_Id  = null;
    update Hper_Plan_Groups
       set Company_Id    = null,
           Filial_Id     = null,
           Plan_Group_Id = null,
           name          = null,
           State         = null,
           Order_No      = null;
  end;

end Ui_Vhr132;
/
