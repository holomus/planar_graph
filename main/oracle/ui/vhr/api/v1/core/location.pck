create or replace package Ui_Vhr345 is
  ---------------------------------------------------------------------------------------------------- 
  Function List_Locations(p Hashmap) return Json_Object_t;
  ---------------------------------------------------------------------------------------------------- 
  Function Create_Location(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Location(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Location(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Employees(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Detach_Employees(p Hashmap);
end Ui_Vhr345;
/
create or replace package body Ui_Vhr345 is
  ---------------------------------------------------------------------------------------------------- 
  Function List_Locations(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Location_Ids Array_Number := Nvl(p.o_Array_Number('location_ids'), Array_Number());
    v_Employee_Ids Array_Number;
    v_Count        number := v_Location_Ids.Count;
    v_Location     Gmap;
    v_Locations    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Htt_Locations q
                       where q.Company_Id = v_Company_Id
                         and (v_Count = 0 or --
                             q.Location_Id member of v_Location_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Location := Gmap();
    
      v_Location.Put('location_id', r.Location_Id);
      v_Location.Put('name', r.Name);
      v_Location.Put('address', r.Address);
      v_Location.Put('latlng', r.Latlng);
      v_Location.Put('accuracy', r.Accuracy);
      v_Location.Put('code', r.Code);
      v_Location.Put('state', r.State);
    
      if not Ui.Is_Filial_Head then
        select Lp.Person_Id
          bulk collect
          into v_Employee_Ids
          from Htt_Location_Persons Lp
         where Lp.Company_Id = v_Company_Id
           and Lp.Filial_Id = Ui.Filial_Id
           and Lp.Location_Id = r.Location_Id
           and not exists (select 1
                  from Htt_Blocked_Person_Tracking Bp
                 where Bp.Company_Id = Lp.Company_Id
                   and Bp.Filial_Id = Lp.Filial_Id
                   and Bp.Employee_Id = Lp.Person_Id);
      
        v_Location.Put('employee_ids', v_Employee_Ids);
      end if;
    
      v_Last_Id := r.Modified_Id;
    
      v_Locations.Push(v_Location.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Locations, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure save
  (
    p          Hashmap,
    i_Location Htt_Locations%rowtype
  ) is
    r_Location Htt_Locations%rowtype := i_Location;
  begin
    r_Location.Name       := p.r_Varchar2('name');
    r_Location.Address    := p.o_Varchar2('address');
    r_Location.Latlng     := p.o_Varchar2('latlng');
    r_Location.Accuracy   := p.o_Varchar2('accuracy');
    r_Location.Code       := p.o_Varchar2('code');
    r_Location.State      := Coalesce(p.o_Varchar2('state'), r_Location.State, 'A');
    r_Location.Prohibited := Nvl(r_Location.Prohibited, 'N');
  
    Htt_Api.Location_Save(r_Location);
  
    if not Ui.Is_Filial_Head then
      Htt_Api.Location_Add_Filial(i_Company_Id  => r_Location.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => r_Location.Location_Id);
    end if;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Create_Location(p Hashmap) return Hashmap is
    r_Location Htt_Locations%rowtype;
  begin
    r_Location.Company_Id  := Ui.Company_Id;
    r_Location.Location_Id := Htt_Next.Location_Id;
  
    save(p, r_Location);
  
    return Fazo.Zip_Map('location_id', r_Location.Location_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Location(p Hashmap) is
    r_Location Htt_Locations%rowtype;
  begin
    r_Location := z_Htt_Locations.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                            i_Location_Id => p.r_Number('location_id'));
  
    save(p, r_Location);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Location(p Hashmap) is
  begin
    Htt_Api.Location_Delete(i_Company_Id  => Ui.Company_Id,
                            i_Location_Id => p.r_Number('location_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Employees(p Hashmap) is
    v_Location_Id  number := p.r_Number('location_id');
    v_Employee_Ids Array_Number := p.r_Array_Number('employee_ids');
  begin
    Htt_Api.Location_Add_Filial(i_Company_Id  => Ui.Company_Id,
                                i_Filial_Id   => Ui.Filial_Id,
                                i_Location_Id => v_Location_Id);
  
    for i in 1 .. v_Employee_Ids.Count
    loop
      Htt_Api.Location_Add_Person(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Id,
                                  i_Person_Id   => v_Employee_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach_Employees(p Hashmap) is
    v_Location_Id  number := p.r_Number('location_id');
    v_Employee_Ids Array_Number := p.r_Array_Number('employee_ids');
  begin
    for i in 1 .. v_Employee_Ids.Count
    loop
      Htt_Api.Location_Remove_Person(i_Company_Id  => Ui.Company_Id,
                                     i_Filial_Id   => Ui.Filial_Id,
                                     i_Location_Id => v_Location_Id,
                                     i_Person_Id   => v_Employee_Ids(i));
    end loop;
  end;

end Ui_Vhr345;
/
