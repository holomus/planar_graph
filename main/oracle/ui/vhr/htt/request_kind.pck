create or replace package Ui_Vhr117 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Time_Kinds return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr117;
/
create or replace package body Ui_Vhr117 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Time_Kinds return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_time_kinds',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'requestable', 'Y', 'state', 'A'),
                    true);
  
    q.Number_Field('time_kind_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('day_count_types', Fazo.Zip_Matrix_Transposed(Htt_Util.Day_Count_Types));
    Result.Put('carryover_policies', Fazo.Zip_Matrix_Transposed(Htt_Util.Carryover_Policies));
    Result.Put('cp_zero', Htt_Pref.c_Carryover_Policy_Zero);
    Result.Put('cp_cap', Htt_Pref.c_Carryover_Policy_Cap);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('annually_limited',
                           'N',
                           'user_permitted',
                           'N',
                           'day_count_type',
                           Htt_Pref.c_Day_Count_Type_Work_Days,
                           'request_with_restriction_days',
                           'N',
                           'allow_unused_time',
                           'N',
                           'carryover_policy',
                           Htt_Pref.c_Carryover_Policy_All);
  
    Result.Put('state', 'A');
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data Htt_Request_Kinds%rowtype;
    result Hashmap;
  begin
    r_Data := z_Htt_Request_Kinds.Load(i_Company_Id      => Ui.Company_Id,
                                       i_Request_Kind_Id => p.r_Number('request_kind_id'));
  
    result := z_Htt_Request_Kinds.To_Map(r_Data,
                                         z.Request_Kind_Id,
                                         z.Name,
                                         z.Time_Kind_Id,
                                         z.Annually_Limited,
                                         z.Day_Count_Type,
                                         z.Annual_Day_Limit,
                                         z.User_Permitted,
                                         z.Allow_Unused_Time,
                                         z.Request_Restriction_Days,
                                         z.Carryover_Cap_Days,
                                         z.Carryover_Expires_Days,
                                         z.State,
                                         z.Pcode);
  
    if r_Data.Request_Restriction_Days is not null then
      Result.Put('request_with_restriction_days', 'Y');
    else
      Result.Put('request_with_restriction_days', 'N');
    end if;
  
    Result.Put('carryover_policy', Nvl(r_Data.Carryover_Policy, Htt_Pref.c_Carryover_Policy_All));
    Result.Put('time_kind_id_name',
               z_Htt_Time_Kinds.Take(i_Company_Id => r_Data.Company_Id, i_Time_Kind_Id => r_Data.Time_Kind_Id).Name);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    i_Request_Kind_Id number,
    p                 Hashmap
  ) return Hashmap is
    r_Request_Kind Htt_Request_Kinds%rowtype;
  begin
  
    z_Htt_Request_Kinds.To_Row(r_Request_Kind,
                               p,
                               z.Name,
                               z.Time_Kind_Id,
                               z.Annually_Limited,
                               z.Day_Count_Type,
                               z.Annual_Day_Limit,
                               z.User_Permitted,
                               z.Allow_Unused_Time,
                               z.Request_Restriction_Days,
                               z.Carryover_Policy,
                               z.Carryover_Cap_Days,
                               z.Carryover_Expires_Days,
                               z.State);
  
    -- z_Htt_Time_Kinds 
    r_Request_Kind.Company_Id      := Ui.Company_Id;
    r_Request_Kind.Request_Kind_Id := i_Request_Kind_Id;
  
    Htt_Api.Request_Kind_Save(r_Request_Kind);
  
    return Fazo.Zip_Map('request_kind_id',
                        i_Request_Kind_Id,
                        'name',
                        r_Request_Kind.Name,
                        'user_permitted',
                        r_Request_Kind.User_Permitted,
                        'plan_load',
                        z_Htt_Time_Kinds.Load(i_Company_Id => r_Request_Kind.Company_Id, --
                        i_Time_Kind_Id => r_Request_Kind.Time_Kind_Id).Plan_Load,
                        'annually_limited',
                        r_Request_Kind.Annually_Limited);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Htt_Next.Request_Kind_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    v_Request_Kind_Id number := p.r_Number('request_kind_id');
  begin
    z_Htt_Request_Kinds.Lock_Only(i_Company_Id      => Ui.Company_Id,
                                  i_Request_Kind_Id => v_Request_Kind_Id);
  
    return save(v_Request_Kind_Id, p);
  end;

end Ui_Vhr117;
/
