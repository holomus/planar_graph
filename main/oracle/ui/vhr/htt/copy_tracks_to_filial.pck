create or replace package Ui_Vhr498 is
  ----------------------------------------------------------------------------------------------------
  Function Load_Data(P1 Json_Object_t) return Json_Array_t;
  ----------------------------------------------------------------------------------------------------
  Function Model return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Procedure Copy_Tracks(P1 Json_Object_t);
end Ui_Vhr498;
/
create or replace package body Ui_Vhr498 is
  ----------------------------------------------------------------------------------------------------
  Function Load_Data(P1 Json_Object_t) return Json_Array_t is
    p              Gmap := Gmap;
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Employee_Ids Array_Number;
    v_Date         date := Trunc(sysdate);
    result         Glist := Glist;
  begin
    p.Val          := P1;
    v_Employee_Ids := p.o_Array_Number('employee_ids');
  
    for r in (select s.Employee_Id,
                     (select Np.Name
                        from Mr_Natural_Persons Np
                       where Np.Company_Id = v_Company_Id
                         and Np.Person_Id = s.Employee_Id) as name,
                     (select e.Employee_Number
                        from Mhr_Employees e
                       where e.Company_Id = v_Company_Id
                         and e.Filial_Id = v_Filial_Id
                         and e.Employee_Id = s.Employee_Id) as Employee_Number,
                     s.Hiring_Date,
                     (select d.Name
                        from Mhr_Divisions d
                       where d.Company_Id = v_Company_Id
                         and d.Filial_Id = v_Filial_Id
                         and d.Division_Id = s.Division_Id) as Division_Name,
                     (select j.Name
                        from Mhr_Jobs j
                       where j.Company_Id = v_Company_Id
                         and j.Filial_Id = v_Filial_Id
                         and j.Job_Id = s.Job_Id) as Job_Name,
                     (select count(*)
                        from Htt_Tracks t
                       where t.Company_Id = v_Company_Id
                         and t.Person_Id = s.Employee_Id
                         and t.Track_Date >= s.Hiring_Date
                         and t.Filial_Id in (select f.Filial_Id
                                               from Md_Filials f
                                              where f.Company_Id = v_Company_Id
                                                and f.Filial_Id <> v_Filial_Id
                                                and f.State = 'A')
                         and exists (select Lp.Location_Id
                                from Htt_Location_Persons Lp
                               where Lp.Company_Id = v_Company_Id
                                 and Lp.Filial_Id = v_Filial_Id
                                 and Lp.Location_Id = t.Location_Id
                                 and Lp.Person_Id = s.Employee_Id)
                         and not exists (select *
                                from Htt_Tracks T1
                               where T1.Company_Id = v_Company_Id
                                 and T1.Filial_Id = v_Filial_Id
                                 and T1.Track_Time = t.Track_Time
                                 and T1.Person_Id = t.Person_Id
                                 and Nvl(T1.Device_Id, -1) = Nvl(t.Device_Id, -1)
                                 and T1.Original_Type = t.Original_Type)) as Tracks_Count
                from Href_Staffs s
               where s.Company_Id = v_Company_Id
                 and s.Filial_Id = v_Filial_Id
                 and (v_Employee_Ids is null or
                     s.Employee_Id in (select *
                                          from table(v_Employee_Ids)))
                 and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                 and s.State = 'A'
                 and s.Hiring_Date <= v_Date
                 and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Date))
    loop
      continue when r.Tracks_Count = 0;
    
      Result.Push(Array_Varchar2(r.Employee_Id,
                                 r.Name,
                                 r.Employee_Number,
                                 r.Hiring_Date,
                                 r.Division_Name,
                                 r.Job_Name,
                                 r.Tracks_Count));
    end loop;
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Json_Object_t is
    result Gmap := Gmap;
  begin
    Result.Put('sk_primary', Href_Pref.c_Staff_Kind_Primary);
    Result.Put('ss_working', Href_Pref.c_Staff_Status_Working);
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Copy_Tracks(P1 Json_Object_t) is
    p Gmap := Gmap;
  begin
    p.Val := P1;
  
    Htt_Api.Copy_Tracks_To_Filial(i_Company_Id   => Ui.Company_Id,
                                  i_Filial_Id    => Ui.Filial_Id,
                                  i_Employee_Ids => p.r_Array_Number('employee_ids'));
  end;

end Ui_Vhr498;
/
