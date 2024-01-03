create or replace package Uit_Hface is
  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector
  (
    i_Person_Id     number,
    i_Photo_Shas    Array_Varchar2,
    i_Check_Setting boolean := true
  ) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector_Response(i_Data Hashmap) return Hashmap;
end Uit_Hface;
/
create or replace package body Uit_Hface is
  ----------------------------------------------------------------------------------------------------
  g_Person_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init
  (
    i_Person_Id     number := null,
    i_Check_Setting boolean := true
  ) is
  begin
    g_Person_Id := i_Person_Id;
  
    if i_Check_Setting and Hface_Util.Duplicate_Prevention(Ui.Company_Id) = 'N' then
      Hface_Error.Raise_005;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector
  (
    i_Person_Id     number,
    i_Photo_Shas    Array_Varchar2,
    i_Check_Setting boolean := true
  ) return Runtime_Service is
    v_Data Gmap := Gmap();
  begin
    Init(i_Person_Id, i_Check_Setting);
  
    v_Data.Put('company_id', Ui.Company_Id);
    v_Data.Put('photo_shas', i_Photo_Shas);
  
    return Hface_Core.Recognition_Runtime_Service(i_Response_Procedure => 'uit_hface.calculate_photo_vector_response',
                                                  i_Action             => Hface_Pref.c_Rs_Action_Calculate_Vector,
                                                  i_Api_Uri            => Hface_Pref.c_Recognition_Route_Embed,
                                                  i_Data               => v_Data);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calculate_Photo_Vector_Response(i_Data Hashmap) return Hashmap is
    v_Photo_Shas     Array_Varchar2 := i_Data.Keyset();
    v_Vector         Array_Varchar2;
    v_Matched_Photos Matrix_Varchar2 := Matrix_Varchar2();
    v_Error_Code     varchar2(10);
    result           Hashmap := Hashmap();
  
    v_Photo_Sha varchar2(64);
  
    --------------------------------------------------
    Function Load_Matched_Photos
    (
      i_Company_Id number,
      i_Photo_Sha  varchar2
    ) return Matrix_Varchar2 is
      v_Matches Matrix_Varchar2;
    begin
      select Array_Varchar2(Np.Person_Id,
                            Np.Name,
                            q.Matched_Sha,
                            q.Match_Score,
                            Round(1 - q.Match_Score / Hface_Pref.c_Euclidian_Threshold, 2) * 100)
        bulk collect
        into v_Matches
        from Hface_Matched_Photos q
        join Htt_Person_Photos Pp
          on Pp.Company_Id = i_Company_Id
         and Pp.Photo_Sha = q.Matched_Sha
         and Pp.Person_Id <> Nvl(g_Person_Id, -1)
        join Mr_Natural_Persons Np
          on Np.Company_Id = i_Company_Id
         and Np.Person_Id = Pp.Person_Id
       where q.Company_Id = i_Company_Id
         and q.Photo_Sha = i_Photo_Sha;
    
      return v_Matches;
    end;
  
  begin
    v_Error_Code := i_Data.o_Varchar2('error_code');
  
    if v_Error_Code is not null then
      if v_Error_Code = Hface_Pref.c_Df_No_Face_Found_Exception then
        Result.Put('error', Hface_Error.Error_Map_003);
      elsif v_Error_Code = Hface_Pref.c_Cf_Connection_Failure then
        Result.Put('error', Hface_Error.Error_Map_004);
      else
        b.Raise_Not_Implemented;
      end if;
    
      return result;
    end if;
  
    for i in 1 .. v_Photo_Shas.Count
    loop
      v_Photo_Sha := v_Photo_Shas(i);
    
      v_Vector := i_Data.r_Array_Varchar2(v_Photo_Sha);
    
      Hface_Api.Save_Photo_Vector_Calculated(i_Company_Id   => Ui.Company_Id,
                                             i_Photo_Sha    => v_Photo_Sha,
                                             i_Photo_Vector => v_Vector);
    
      Hface_Api.Match_Photo(i_Company_Id => Ui.Company_Id, --
                            i_Photo_Sha  => v_Photo_Sha);
    
      v_Matched_Photos := v_Matched_Photos multiset union all
                          Load_Matched_Photos(i_Company_Id => Ui.Company_Id, --
                                              i_Photo_Sha  => v_Photo_Sha);
    end loop;
  
    if v_Matched_Photos.Count > 0 then
      Result.Put('matched_photos', Fazo.Zip_Matrix(v_Matched_Photos));
    end if;
  
    return result;
  end;

end Uit_Hface;
/
