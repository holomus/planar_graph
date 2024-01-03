create or replace package Ui_Vhr422 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Oper_Types(p Hashmap) return Json_Object_t;
end Ui_Vhr422;
/
create or replace package body Ui_Vhr422 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Oper_Types(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Oper_Type_Ids Array_Number := Nvl(p.o_Array_Number('oper_type_ids'), Array_Number());
    v_Count         number := v_Oper_Type_Ids.Count;
    v_Oper_Type     Gmap;
    v_Oper_Types    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select q.*, Ot.Oper_Group_Id, Ot.Estimation_Type, Ot.Estimation_Formula
                        from Mpr_Oper_Types q
                        join Hpr_Oper_Types Ot
                          on Ot.Company_Id = q.Company_Id
                         and Ot.Oper_Type_Id = q.Oper_Type_Id
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Oper_Type_Id member of v_Oper_Type_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Oper_Type := Gmap();
    
      v_Oper_Type.Put('name', r.Name);
      v_Oper_Type.Put('short_name', r.Short_Name);
      v_Oper_Type.Put('oper_type_id', r.Oper_Type_Id);
      v_Oper_Type.Put('operation_kind', r.Operation_Kind);
      v_Oper_Type.Put('oper_group_id', r.Oper_Group_Id);
      v_Oper_Type.Put('estimation_type', r.Estimation_Type);
      v_Oper_Type.Put('estimation_formula', r.Estimation_Formula);
      v_Oper_Type.Put('short_name', r.Short_Name);
      v_Oper_Type.Put('incode_tax_rate', r.Income_Tax_Rate);
      v_Oper_Type.Put('pension_tax_rate', r.Pension_Payment_Rate);
      v_Oper_Type.Put('social_payment_rate', r.Social_Payment_Rate);
      v_Oper_Type.Put('note', r.Note);
      v_Oper_Type.Put('code', r.Code);
      v_Oper_Type.Put('state', r.State);
    
      v_Last_Id := r.Modified_Id;
    
      v_Oper_Types.Push(v_Oper_Type.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Oper_Types, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr422;
/
