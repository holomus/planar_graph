create or replace package Ui_Vhr423 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Robots(p Hashmap) return Json_Object_t;
end Ui_Vhr423;
/
create or replace package body Ui_Vhr423 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Robots(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Robot_Ids Array_Number := Nvl(p.o_Array_Number('position_ids'), Array_Number());
    v_Count     number := v_Robot_Ids.Count;
    v_Robot     Gmap;
    v_Robots    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select q.*,
                             Rb.Opened_Date,
                             Rb.Closed_Date,
                             Rb.Schedule_Id,
                             Rb.Rank_Id,
                             Rb.Description
                        from Mrf_Robots q
                        join Hrm_Robots Rb
                          on Rb.Company_Id = q.Company_Id
                         and Rb.Filial_Id = q.Filial_Id
                         and Rb.Robot_Id = q.Robot_Id
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or --
                             q.Robot_Id member of v_Robot_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Robot := Gmap();
    
      v_Robot.Put('name', r.Name);
      v_Robot.Put('robot_id', r.Robot_Id);
      v_Robot.Put('opened_date', r.Opened_Date);
      v_Robot.Put('closed_date', r.Closed_Date);
      v_Robot.Put('division_id', r.Division_Id);
      v_Robot.Put('job_id', r.Job_Id);
      v_Robot.Put('rank_id', r.Rank_Id);
      v_Robot.Put('schedule_id', r.Schedule_Id);
      v_Robot.Put('description', r.Description);
      v_Robot.Put('code', r.Code);
      v_Robot.Put('state', r.State);
    
      v_Last_Id := r.Modified_Id;
    
      v_Robots.Push(v_Robot.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Robots, --
                                       i_Modified_Id => v_Last_Id);
  end;
end Ui_Vhr423;
/
