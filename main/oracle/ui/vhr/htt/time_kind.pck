create or replace package Ui_Vhr73 is
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Time_Kinds return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr73;
/
create or replace package body Ui_Vhr73 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('plan_load', Htt_Pref.c_Request_Type_Part_Of_Day, 'state', 'A');
  
    Result.Put('plan_loads', Fazo.Zip_Matrix_Transposed(Htt_Util.Plan_Loads));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Time_Kind Htt_Time_Kinds%rowtype;
    result      Hashmap;
  begin
    r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => Ui.Company_Id,
                                         i_Time_Kind_Id => p.r_Number('time_kind_id'));
  
    result := z_Htt_Time_Kinds.To_Map(r_Time_Kind,
                                      z.Time_Kind_Id,
                                      z.Name,
                                      z.Letter_Code,
                                      z.Digital_Code,
                                      z.Parent_Id,
                                      z.Plan_Load,
                                      z.Bg_Color,
                                      z.Color,
                                      z.Timesheet_Coef,
                                      z.State,
                                      z.Pcode);
  
    Result.Put('parent_id_name',
               z_Htt_Time_Kinds.Take(i_Company_Id => r_Time_Kind.Company_Id, i_Time_Kind_Id => r_Time_Kind.Parent_Id).Name);
    Result.Put('plan_loads', Fazo.Zip_Matrix_Transposed(Htt_Util.Plan_Loads));
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Time_Kinds return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Query  := 'select q.time_kind_id,
                        q.name,
                        q.plan_load
                   from htt_time_kinds q
                  where q.company_id = :company_id
                    and q.parent_id is null';
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id);
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('time_kind_id');
    q.Varchar2_Field('name', 'plan_load');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    i_Time_Kind_Id number,
    p              Hashmap
  ) return Hashmap is
    r_Time_Kind Htt_Time_Kinds%rowtype;
  begin
    r_Time_Kind := z_Htt_Time_Kinds.To_Row(p, --
                                           z.Name,
                                           z.Letter_Code,
                                           z.Digital_Code,
                                           z.Parent_Id,
                                           z.Plan_Load,
                                           z.Bg_Color,
                                           z.Color,
                                           z.Timesheet_Coef,
                                           z.State);
  
    r_Time_Kind.Company_Id   := Ui.Company_Id;
    r_Time_Kind.Time_Kind_Id := i_Time_Kind_Id;
  
    Htt_Api.Time_Kind_Save(r_Time_Kind);
  
    return z_Htt_Time_Kinds.To_Map(r_Time_Kind, z.Time_Kind_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Htt_Next.Time_Kind_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    v_Time_Kind_Id number := p.r_Number('time_kind_id');
  begin
    z_Htt_Time_Kinds.Lock_Only(i_Company_Id   => Ui.Company_Id, --
                               i_Time_Kind_Id => v_Time_Kind_Id);
  
    return save(v_Time_Kind_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           Parent_Id    = null,
           name         = null,
           Plan_Load    = null;
  end;

end Ui_Vhr73;
/
