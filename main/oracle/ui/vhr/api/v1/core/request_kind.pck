create or replace package Ui_Vhr457 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Request_Kinds(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Request_Kind(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Request_Kind(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Request_Kind(p Hashmap);
end Ui_Vhr457;
/
create or replace package body Ui_Vhr457 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Request_Kinds(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Request_Kind_Ids Array_Number := Nvl(p.o_Array_Number('request_kind_ids'), Array_Number());
    v_Count            number := v_Request_Kind_Ids.Count;
    v_Request_Kind     Gmap;
    v_Request_Kinds    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Htt_Request_Kinds q
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Request_Kind_Id member of v_Request_Kind_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Request_Kind := Gmap();
    
      v_Request_Kind.Put('request_kind_id', r.Request_Kind_Id);
      v_Request_Kind.Put('name', r.Name);
      v_Request_Kind.Put('time_kind_id', r.Time_Kind_Id);
      v_Request_Kind.Put('annually_limited', r.Annually_Limited);
      v_Request_Kind.Put('day_count_type', r.Day_Count_Type);
      v_Request_Kind.Put('annual_day_limit', r.Annual_Day_Limit);
      v_Request_Kind.Put('user_permitted', r.User_Permitted);
      v_Request_Kind.Put('allow_unused_time', r.Allow_Unused_Time);
      v_Request_Kind.Put('request_restriction_days', r.Request_Restriction_Days);
      v_Request_Kind.Put('carryover_policy', r.Carryover_Policy);
      v_Request_Kind.Put('carryover_cap_days', r.Carryover_Cap_Days);
      v_Request_Kind.Put('carryover_expires_days', r.Carryover_Expires_Days);
      v_Request_Kind.Put('state', r.State);
    
      v_Last_Id := r.Modified_Id;
    
      v_Request_Kinds.Push(v_Request_Kind.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Request_Kinds, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p              Hashmap,
    i_Request_Kind Htt_Request_Kinds%rowtype
  ) is
    r_Request_Kind Htt_Request_Kinds%rowtype := i_Request_Kind;
  begin
    r_Request_Kind.Name                     := p.r_Varchar2('name');
    r_Request_Kind.Time_Kind_Id             := p.r_Number('time_kind_id');
    r_Request_Kind.Annually_Limited         := p.r_Varchar2('annually_limited');
    r_Request_Kind.Day_Count_Type           := p.r_Varchar2('day_count_type');
    r_Request_Kind.Annual_Day_Limit         := p.o_Number('annual_day_limit');
    r_Request_Kind.User_Permitted           := p.r_Varchar2('user_permitted');
    r_Request_Kind.Allow_Unused_Time        := p.r_Varchar2('allow_unused_time');
    r_Request_Kind.Request_Restriction_Days := p.o_Number('request_restriction_days');
    r_Request_Kind.Carryover_Policy         := p.o_Varchar2('carryover_policy');
    r_Request_Kind.Carryover_Cap_Days       := p.o_Number('carryover_cap_days');
    r_Request_Kind.Carryover_Expires_Days   := p.o_Number('carryover_expires_days');
    r_Request_Kind.State                    := Nvl(i_Request_Kind.State, 'A');
  
    Htt_Api.Request_Kind_Save(r_Request_Kind);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Request_Kind(p Hashmap) return Hashmap is
    r_Request_Kind Htt_Request_Kinds%rowtype;
  begin
    r_Request_Kind.Company_Id      := Ui.Company_Id;
    r_Request_Kind.Request_Kind_Id := Htt_Next.Request_Kind_Id;
  
    save(p, r_Request_Kind);
  
    return Fazo.Zip_Map('request_kind_id', r_Request_Kind.Request_Kind_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Request_Kind(p Hashmap) is
    r_Request_Kind Htt_Request_Kinds%rowtype;
  begin
    r_Request_Kind := z_Htt_Request_Kinds.Lock_Load(i_Company_Id      => Ui.Company_Id,
                                                    i_Request_Kind_Id => p.r_Number('request_kind_id'));
  
    save(p, r_Request_Kind);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Request_Kind(p Hashmap) is
  begin
    Htt_Api.Request_Kind_Delete(i_Company_Id      => Ui.Company_Id,
                                i_Request_Kind_Id => p.r_Number('request_kind_id'));
  end;

end Ui_Vhr457;
/
