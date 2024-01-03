create or replace package Ui_Vhr419 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Oper_Groups(p Hashmap) return Json_Object_t;
end Ui_Vhr419;
/
create or replace package body Ui_Vhr419 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Oper_Groups(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Oper_Group_Ids Array_Number := Nvl(p.o_Array_Number('oper_group_ids'), Array_Number());
    v_Count          number := v_Oper_Group_Ids.Count;
    v_Oper_Group     Gmap;
    v_Oper_Groups    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Hpr_Oper_Groups q
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Oper_Group_Id member of v_Oper_Group_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Oper_Group := Gmap();
    
      v_Oper_Group.Put('oper_group_id', r.Oper_Group_Id);
      v_Oper_Group.Put('name', r.Name);
      v_Oper_Group.Put('operation_kind', r.Operation_Kind);
      v_Oper_Group.Put('estimation_type', r.Estimation_Type);
      v_Oper_Group.Put('estimation_formula', r.Estimation_Formula);
    
      v_Last_Id := r.Modified_Id;
    
      v_Oper_Groups.Push(v_Oper_Group.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Oper_Groups, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr419;
/
