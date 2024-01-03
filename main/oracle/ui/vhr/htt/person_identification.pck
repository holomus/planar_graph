create or replace package Ui_Vhr90 is
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Regen_Qrcode(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Upload_Images(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure save(p Hashmap);
end Ui_Vhr90;
/
create or replace package body Ui_Vhr90 is
  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('duplicate_prevention', Hface_Util.Duplicate_Prevention(Ui.Company_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Person    Htt_Persons%rowtype;
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap := Hashmap();
  begin
    r_Person := z_Htt_Persons.Take(i_Company_Id => Ui.Company_Id, --
                                   i_Person_Id  => v_Person_Id);
  
    result := z_Htt_Persons.To_Map(r_Person, --
                                   z.Pin,
                                   z.Pin_Code,
                                   z.Rfid_Code,
                                   z.Qr_Code);
  
    select Array_Varchar2(k.File_Name, t.Photo_Sha, t.Is_Main)
      bulk collect
      into v_Matrix
      from Htt_Person_Photos t
      join Biruni_Files k
        on k.Sha = t.Photo_Sha
     where t.Company_Id = r_Person.Company_Id
       and t.Person_Id = r_Person.Person_Id
     order by Nullif(t.Is_Main, 'Y') nulls first, k.Created_On desc;
  
    Result.Put('person_id', v_Person_Id);
    Result.Put('photos', Fazo.Zip_Matrix(v_Matrix));
  
    -- fprints
    select Array_Varchar2(w.Finger_No,
                           Hzk_Util.t_Finger(w.Finger_No),
                           case
                             when w.Finger_No < 5 then
                              Hzk_Pref.c_Hand_Side_Left
                             else
                              Hzk_Pref.c_Hand_Side_Right
                           end,
                           q.Tmp)
      bulk collect
      into v_Matrix
      from Hzk_Person_Fprints q
     right join (select level - 1 as Finger_No
                   from Dual
                 connect by level <= 10) w
        on q.Finger_No = w.Finger_No
       and q.Company_Id = r_Person.Company_Id
       and q.Person_Id = r_Person.Person_Id
     order by w.Finger_No;
  
    Result.Put('fingers', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('hands', Fazo.Zip_Matrix_Transposed(Hzk_Util.Hand_Sides));
    Result.Put('track_by_qr_code',
               Hes_Util.Staff_Track_Settings(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_User_Id => v_Person_Id).Track_By_Qr_Code);
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Regen_Qrcode(p Hashmap) return Hashmap is
  begin
    return Fazo.Zip_Map('qr_code', Htt_Util.Qr_Code_Gen(i_Person_Id => p.r_Number('person_id')));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector(p Hashmap) return Runtime_Service is
  begin
    return Uit_Hface.Calculate_Photo_Vector(i_Person_Id  => p.r_Number('person_id'),
                                            i_Photo_Shas => p.r_Array_Varchar2('photo_shas'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Upload_Images(p Hashmap) return Hashmap is
  begin
    return p;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure save(p Hashmap) is
    v_Person         Htt_Pref.Person_Rt;
    v_Person_Fprints Hzk_Pref.Person_Fprints_Rt;
    v_List           Arraylist;
    v_Item           Hashmap;
    v_Person_Id      number := p.r_Number('person_id');
  begin
    Htt_Util.Person_New(o_Person     => v_Person,
                        i_Company_Id => Ui.Company_Id,
                        i_Person_Id  => v_Person_Id,
                        i_Pin        => p.o_Varchar2('pin'),
                        i_Pin_Code   => p.o_Number('pin_code'),
                        i_Rfid_Code  => p.o_Varchar2('rfid_code'),
                        i_Qr_Code    => p.o_Varchar2('qr_code'));
  
    v_List := p.r_Arraylist('photos');
  
    for i in 1 .. v_List.Count
    loop
      v_Item := Treat(v_List.r_Hashmap(i) as Hashmap);
    
      Htt_Util.Person_Add_Photo(p_Person    => v_Person,
                                i_Photo_Sha => v_Item.r_Varchar2('photo_sha'),
                                i_Is_Main   => v_Item.r_Varchar2('is_main'));
    end loop;
  
    Htt_Api.Person_Save(v_Person);
  
    -- fprints
    Hzk_Util.Person_Fprints_New(o_Person_Fprints => v_Person_Fprints,
                                i_Company_Id     => v_Person.Company_Id,
                                i_Person_Id      => v_Person.Person_Id);
  
    v_List := p.r_Arraylist('fprints');
  
    for i in 1 .. v_List.Count
    loop
      v_Item := Treat(v_List.r_Hashmap(i) as Hashmap);
    
      Hzk_Util.Person_Fprints_Add_Fprint(p_Person_Fprints => v_Person_Fprints,
                                         i_Finger_No      => v_Item.r_Number('finger_no'),
                                         i_Tmp            => v_Item.o_Varchar2('tmp'));
    end loop;
  
    Hzk_Api.Person_Fprint_Save(v_Person_Fprints);
  end;

end Ui_Vhr90;
/
