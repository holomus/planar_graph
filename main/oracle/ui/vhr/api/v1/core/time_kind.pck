create or replace package Ui_Vhr416 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Time_Kinds(p Hashmap) return Json_Object_t;
end Ui_Vhr416;
/
create or replace package body Ui_Vhr416 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Time_Kinds(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Time_Kind_Ids Array_Number := Nvl(p.o_Array_Number('time_kind_ids'), Array_Number());
    v_Count         number := v_Time_Kind_Ids.Count;
    v_Time_Kind     Gmap;
    v_Time_Kinds    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Htt_Time_Kinds q
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Time_Kind_Id member of v_Time_Kind_Ids)
                         and q.Parent_Id is null) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Time_Kind := Gmap();
    
      v_Time_Kind.Put('name', r.Name);
      v_Time_Kind.Put('time_kind_id', r.Time_Kind_Id);
      v_Time_Kind.Put('letter_code', r.Letter_Code);
      v_Time_Kind.Put('digital_code', r.Digital_Code);
    
      v_Last_Id := r.Modified_Id;
    
      v_Time_Kinds.Push(v_Time_Kind.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Time_Kinds, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr416;
/
