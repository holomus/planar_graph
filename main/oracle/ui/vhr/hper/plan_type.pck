create or replace package Ui_Vhr133 is
  Function Query_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Task_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr133;
/
create or replace package body Ui_Vhr133 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hper_plan_groups',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('plan_group_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Task_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('ms_task_types',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'task_group_id',
                                 Ms_Pref.Task_Group_Id(i_Company_Id => Ui.Company_Id,
                                                       i_Pcode      => Hper_Pref.c_Pcode_Task_Group_Plan),
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('task_type_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap := Hashmap;
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
    Result.Put('calc_kinds', Fazo.Zip_Matrix_Transposed(Hper_Util.Calc_Kinds));
    Result.Put('sale_kinds', Fazo.Zip_Matrix_Transposed(Hper_Util.Sale_Kinds));
    Result.Put('ck_manual', Hper_Pref.c_Calc_Kind_Manual);
    Result.Put('ck_task', Hper_Pref.c_Calc_Kind_Task);
    Result.Put('ck_external', Hper_Pref.c_Calc_Kind_External);
  
    return result;
  
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model(p Hashmap) return Hashmap is
    r_Data Hper_Plan_Groups%rowtype;
    result Hashmap;
  begin
    r_Data := z_Hper_Plan_Groups.Take(i_Company_Id    => Ui.Company_Id,
                                      i_Filial_Id     => Ui.Filial_Id,
                                      i_Plan_Group_Id => p.o_Number('plan_group_id'));
  
    result := Fazo.Zip_Map('plan_group_id',
                           r_Data.Plan_Group_Id,
                           'plan_group_name',
                           r_Data.Name,
                           'calc_kind',
                           Hper_Pref.c_Calc_Kind_Manual,
                           'with_part',
                           'N',
                           'task_group_id',
                           Ms_Pref.Task_Group_Id(i_Company_Id => Ui.Company_Id,
                                                 i_Pcode      => Hper_Pref.c_Pcode_Task_Group_Plan),
                           'extra_amount_enabled',
                           'N');
  
    Result.Put('sale_kind', Hper_Pref.c_Sale_Kind_Personal);
    Result.Put('state', 'A');
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data         Hper_Plan_Types%rowtype;
    v_Division_Ids Array_Number;
    v_Matrix       Matrix_Varchar2;
    result         Hashmap := Hashmap();
  begin
    r_Data := z_Hper_Plan_Types.Load(i_Company_Id   => Ui.Company_Id,
                                     i_Filial_Id    => Ui.Filial_Id,
                                     i_Plan_Type_Id => p.r_Number('plan_type_id'));
  
    result := z_Hper_Plan_Types.To_Map(r_Data, --
                                       z.Plan_Type_Id,
                                       z.Name,
                                       z.Plan_Group_Id,
                                       z.Calc_Kind,
                                       z.With_Part,
                                       z.Extra_Amount_Enabled,
                                       z.Sale_Kind,
                                       z.State,
                                       z.Order_No,
                                       z.Code);
  
    Result.Put('plan_group_name',
               z_Hper_Plan_Groups.Take(i_Company_Id => r_Data.Company_Id, i_Filial_Id => r_Data.Filial_Id, i_Plan_Group_Id => r_Data.Plan_Group_Id).Name);
  
    Result.Put('task_group_id',
               Ms_Pref.Task_Group_Id(i_Company_Id => Ui.Company_Id,
                                     i_Pcode      => Hper_Pref.c_Pcode_Task_Group_Plan));
  
    select q.Division_Id
      bulk collect
      into v_Division_Ids
      from Hper_Plan_Type_Divisions q
     where q.Company_Id = r_Data.Company_Id
       and q.Filial_Id = r_Data.Filial_Id
       and q.Plan_Type_Id = r_Data.Plan_Type_Id;
  
    Result.Put('division_ids', v_Division_Ids);
  
    select Array_Varchar2(q.Task_Type_Id, w.Name)
      bulk collect
      into v_Matrix
      from Hper_Plan_Type_Task_Types q
      join Ms_Task_Types w
        on w.Company_Id = q.Company_Id
       and w.Task_Type_Id = q.Task_Type_Id
     where q.Company_Id = r_Data.Company_Id
       and q.Filial_Id = r_Data.Filial_Id
       and q.Plan_Type_Id = r_Data.Plan_Type_Id
     order by w.Order_No, Lower(w.Name);
  
    Result.Put('task_types', Fazo.Zip_Matrix(v_Matrix));
  
    -- plan rules
    select Array_Varchar2(Nullif(q.From_Percent, 0), q.To_Percent, q.Plan_Percent)
      bulk collect
      into v_Matrix
      from Hper_Plan_Type_Rules q
     where q.Company_Id = r_Data.Company_Id
       and q.Filial_Id = r_Data.Filial_Id
       and q.Plan_Type_Id = r_Data.Plan_Type_Id
     order by q.From_Percent;
  
    Result.Put('rules', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Plan_Type_Id number,
    p              Hashmap
  ) return Hashmap is
    v_Plan_Type Hper_Pref.Plan_Type_Rt;
    r_Data      Hper_Plan_Types%rowtype;
    r_Group     Hper_Plan_Groups%rowtype;
    v_Rules     Arraylist := Nvl(p.o_Arraylist('rules'), Arraylist());
    v_Rule      Hashmap;
    result      Hashmap := Hashmap();
  begin
    Hper_Util.Plan_Type_New(o_Plan_Type            => v_Plan_Type,
                            i_Company_Id           => Ui.Company_Id,
                            i_Filial_Id            => Ui.Filial_Id,
                            i_Plan_Type_Id         => i_Plan_Type_Id,
                            i_Name                 => p.r_Varchar2('name'),
                            i_Plan_Group_Id        => p.o_Number('plan_group_id'),
                            i_Calc_Kind            => p.r_Varchar2('calc_kind'),
                            i_Extra_Amount_Enabled => p.r_Varchar2('extra_amount_enabled'),
                            i_With_Part            => p.r_Varchar2('with_part'),
                            i_Sale_Kind            => p.r_Varchar2('sale_kind'),
                            i_State                => p.r_Varchar2('state'),
                            i_Code                 => p.o_Varchar2('code'),
                            i_Order_No             => p.o_Number('order_no'),
                            i_Division_Ids         => p.o_Array_Number('division_ids'),
                            i_Task_Type_Ids        => p.o_Array_Number('task_type_ids'));
  
    for i in 1 .. v_Rules.Count
    loop
      v_Rule := Treat(v_Rules.r_Hashmap(i) as Hashmap);
    
      Hper_Util.Plan_Type_Add_Rule(p_Plan_Type    => v_Plan_Type,
                                   i_From_Percent => v_Rule.o_Number('from_percent'),
                                   i_To_Percent   => v_Rule.o_Number('to_percent'),
                                   i_Plan_Percent => v_Rule.o_Number('plan_percent'));
    end loop;
  
    Hper_Api.Plan_Type_Save(v_Plan_Type);
  
    r_Group := z_Hper_Plan_Groups.Take(i_Company_Id    => r_Data.Company_Id,
                                       i_Filial_Id     => r_Data.Filial_Id,
                                       i_Plan_Group_Id => r_Data.Plan_Group_Id);
  
    Result.Put('plan_type_id', v_Plan_Type.Plan_Type_Id);
    Result.Put('name', v_Plan_Type.Name);
    Result.Put('calc_kind', v_Plan_Type.Calc_Kind);
    Result.Put('order_no', v_Plan_Type.Order_No);
    Result.Put('code', v_Plan_Type.Code);
    Result.Put('group_name', r_Group.Name);
    Result.Put('group_order_no', r_Group.Order_No);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hper_Next.Plan_Type_Id, p);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Edit(p Hashmap) return Hashmap is
    v_Plan_Type_Id number := p.r_Number('plan_type_id');
  begin
    z_Hper_Plan_Types.Lock_Only(i_Company_Id   => Ui.Company_Id,
                                i_Filial_Id    => Ui.Filial_Id,
                                i_Plan_Type_Id => v_Plan_Type_Id);
  
    return save(v_Plan_Type_Id, p);
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
    update Ms_Task_Types
       set Company_Id    = null,
           Task_Type_Id  = null,
           Task_Group_Id = null,
           name          = null,
           State         = null,
           Order_No      = null;
  end;

end Ui_Vhr133;
/
