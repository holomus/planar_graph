create or replace package Ui_Vhr584 is
  ----------------------------------------------------------------------------------------------------
  Function Download_Person_Shas return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Procedure Upload_Photo_Shas(i_Data Json_Array_t);
end Ui_Vhr584;
/
create or replace package body Ui_Vhr584 is
  ----------------------------------------------------------------------------------------------------
  Function Download_Person_Shas return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Hiring_Date_Limit    date := Trunc(sysdate) + 30;
    v_Dismissal_Date_Limit date := Trunc(sysdate) - 30;
  
    v_Person  Gmap;
    v_Persons Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    for c in (select *
                from (select q.*,
                             (select Json_Arrayagg(Json_Object('photo_sha' value Pp.Photo_Sha,
                                                               'is_main' value Pp.Is_Main))
                                from Htt_Person_Photos Pp
                               where Pp.Company_Id = q.Company_Id
                                 and Pp.Person_Id = q.Person_Id) Photos
                        from Md_Persons q
                       where q.Company_Id = v_Company_Id
                         and q.Code is not null
                         and exists (select 1
                                from Href_Staffs St
                               where St.Company_Id = q.Company_Id
                                 and St.Employee_Id = q.Person_Id
                                 and St.State = 'A'
                                 and St.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                                 and St.Hiring_Date <= v_Hiring_Date_Limit
                                 and (St.Dismissal_Date is null or
                                     St.Dismissal_Date >= v_Dismissal_Date_Limit))
                         and exists (select 1
                                from Htt_Person_Photos Pt
                               where Pt.Company_Id = q.Company_Id
                                 and Pt.Person_Id = q.Person_Id)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Person := Gmap();
    
      v_Person.Put('person_id', c.Person_Id);
      v_Person.Put('person_code', c.Code);
      v_Person.Put('photos', Glist(Json_Array_t(c.Photos)));
    
      v_Last_Id := c.Modified_Id;
    
      v_Persons.Push(v_Person.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Persons, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Upload_Photo_Shas(i_Data Json_Array_t) is
    v_Persons   Glist := Glist();
    v_Person    Gmap := Gmap();
    v_Photos    Glist;
    v_Photo     Gmap := Gmap();
    v_Photo_Sha Htt_Person_Photos.Photo_Sha%type;
    v_Is_Main   varchar2(1);
    v_Person_Id number;
  begin
    v_Persons.Val := i_Data;
  
    for i in 1 .. v_Persons.Count
    loop
      v_Person.Val := v_Persons.r_Gmap(i);
      v_Photos     := v_Person.r_Glist('photos');
    
      v_Person_Id := Md_Util.Take_Person_Id_By_Code(i_Company_Id => Ui.Company_Id,
                                                    i_Code       => v_Person.r_Varchar2('person_code'));
    
      continue when v_Person_Id is null;
    
      for j in 1 .. v_Photos.Count
      loop
        v_Photo.Val := v_Photos.r_Gmap(j);
        v_Is_Main   := Nvl(v_Photo.o_Varchar2('is_main'), 'N');
        v_Photo_Sha := v_Photo.r_Varchar2('photo_sha');
      
        continue when v_Photo_Sha is null;
        continue when Nvl(v_Photo.r_Varchar2('photo_uploaded'), 'N') = 'N';
      
        Htt_Api.Person_Save_Photo(i_Company_Id => Ui.Company_Id,
                                  i_Person_Id  => v_Person_Id,
                                  i_Photo_Sha  => v_Photo_Sha,
                                  i_Is_Main    => v_Is_Main);
      
        if v_Is_Main = 'Y' then
          Md_Api.Person_Update(i_Company_Id => Ui.Company_Id,
                               i_Person_Id  => v_Person_Id,
                               i_Photo_Sha  => Option_Varchar2(v_Photo_Sha));
        end if;
      end loop;
    end loop;
  end;

end Ui_Vhr584;
/
