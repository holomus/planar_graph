create or replace package Ui_Vhr415 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Indicators(p Hashmap) return Json_Object_t;
end Ui_Vhr415;
/
create or replace package body Ui_Vhr415 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Indicators(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Wage_Indicator_Group number;
  
    v_Indicator_Ids Array_Number := Nvl(p.o_Array_Number('indicator_ids'), Array_Number());
    v_Count         number := v_Indicator_Ids.Count;
    v_Indicator     Gmap;
    v_Indicators    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    v_Wage_Indicator_Group := Href_Util.Indicator_Group_Id(i_Company_Id => v_Company_Id,
                                                           i_Pcode      => Href_Pref.c_Pcode_Indicator_Group_Wage);
  
    for r in (select *
                from (select *
                        from Href_Indicators q
                       where q.Company_Id = v_Company_Id
                         and q.Indicator_Group_Id = v_Wage_Indicator_Group
                         and (v_Count = 0 or --
                             q.Indicator_Id member of v_Indicator_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Indicator := Gmap();
    
      v_Indicator.Put('indicator_id', r.Indicator_Id);
      v_Indicator.Put('name', r.Name);
      v_Indicator.Put('short_name', r.Short_Name);
      v_Indicator.Put('identifier', r.Identifier);
      v_Indicator.Put('state', r.State);
    
      v_Last_Id := r.Modified_Id;
    
      v_Indicators.Push(v_Indicator.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Indicators, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr415;
/
