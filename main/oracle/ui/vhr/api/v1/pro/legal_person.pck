create or replace package Ui_Vhr427 is
  ----------------------------------------------------------------------------------------------------
  Function List_Legal_Persons(p Hashmap) return Json_Object_t;
end Ui_Vhr427;
/
create or replace package body Ui_Vhr427 is
  ----------------------------------------------------------------------------------------------------
  Function List_Legal_Persons(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Person_Ids Array_Number := Nvl(p.o_Array_Number('legal_person_ids'), Array_Number());
    v_Cnt        number := v_Person_Ids.Count;
  
    v_Person  Gmap;
    v_Persons Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select s.Person_Id,
                             s.Name,
                             s.Short_Name,
                             s.Latlng,
                             s.State,
                             w.Address,
                             w.Address_Guide,
                             q.Company_Id,
                             q.Modified_Id
                        from Mr_Legal_Persons s
                        join Md_Persons q
                          on q.Company_Id = s.Company_Id
                         and q.Person_Id = s.Person_Id
                        left join Mr_Person_Details w
                          on w.Company_Id = s.Company_Id
                         and w.Person_Id = s.Person_Id
                       where s.Company_Id = v_Company_Id
                         and (v_Cnt = 0 or s.Person_Id member of v_Person_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Person := Gmap();
    
      v_Person.Put('legal_person_id', r.Person_Id);
      v_Person.Put('name', r.Name);
      v_Person.Put('short_name', r.Short_Name);
      v_Person.Put('latlng', r.Latlng);
      v_Person.Put('address', r.Address);
      v_Person.Put('address_guide', r.Address_Guide);
      v_Person.Put('state', r.State);
    
      v_Last_Id := r.Modified_Id;
    
      v_Persons.Push(v_Person.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Persons, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr427;
/
