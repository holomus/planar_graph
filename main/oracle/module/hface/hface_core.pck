create or replace package Hface_Core is
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Photo_Match
  (
    i_Company_Id  number,
    i_Photo_Sha   varchar2,
    i_Matched_Sha varchar2,
    i_Match_Score number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Photo_Vector_Calculated
  (
    i_Company_Id   number,
    i_Photo_Sha    varchar2,
    i_Photo_Vector Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Match_Photos(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Function Recognition_Runtime_Service
  (
    i_Response_Procedure varchar2,
    i_Action             varchar2,
    i_Api_Uri            varchar2 := Hface_Pref.c_Recognition_Route_Embed,
    i_Http_Method        varchar2 := Href_Pref.c_Http_Method_Post,
    i_Data               Gmap := Gmap(),
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service;
end Hface_Core;
/
create or replace package body Hface_Core is
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Photo_Match
  (
    i_Company_Id  number,
    i_Photo_Sha   varchar2,
    i_Matched_Sha varchar2,
    i_Match_Score number
  ) is
  begin
    z_Hface_Matched_Photos.Save_One(i_Company_Id  => i_Company_Id,
                                    i_Photo_Sha   => i_Photo_Sha,
                                    i_Matched_Sha => i_Matched_Sha,
                                    i_Match_Score => Round(i_Match_Score, 2));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Photo_Vector_Save
  (
    i_Photo_Sha    varchar2,
    i_Photo_Vector Array_Varchar2
  ) is
    v_Vector clob := Fazo.To_Json(i_Photo_Vector).As_Clob();
  begin
    update Hface_Photo_Vectors q
       set q.Photo_Vector = v_Vector
     where q.Photo_Sha = i_Photo_Sha;
  
    if sql%notfound then
      insert into Hface_Photo_Vectors
        (Photo_Sha, Photo_Vector)
      values
        (i_Photo_Sha, v_Vector);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Photo_Vector_Calculated
  (
    i_Company_Id number,
    i_Photo_Sha  varchar2
  ) is
  begin
    if not Hface_Util.Photo_Vector_Exists(i_Photo_Sha) then
      return;
    end if;
  
    z_Hface_Calculated_Photos.Insert_Try(i_Company_Id => i_Company_Id, --
                                         i_Photo_Sha  => i_Photo_Sha,
                                         i_Photo_Id   => Hface_Next.Calculated_Photo_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Photo_Vector_Calculated
  (
    i_Company_Id   number,
    i_Photo_Sha    varchar2,
    i_Photo_Vector Array_Varchar2
  ) is
  begin
    Photo_Vector_Save(i_Photo_Sha    => i_Photo_Sha, --
                      i_Photo_Vector => i_Photo_Vector);
  
    Set_Photo_Vector_Calculated(i_Company_Id => i_Company_Id, --
                                i_Photo_Sha  => i_Photo_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Match_Photos(i_Company_Id number) is
    v_Match_Score number;
  begin
    delete Hface_Matched_Photos q
     where q.Company_Id = i_Company_Id;
  
    for r in (select Ph.Photo_Sha, Hp.Photo_Sha Matched_Sha
                from Hface_Calculated_Photos Ph
                join Hface_Calculated_Photos Hp
                  on Ph.Company_Id = Hp.Company_Id
                 and Ph.Photo_Id < Hp.Photo_Id
               where Ph.Company_Id = i_Company_Id)
    loop
      v_Match_Score := Hface_Util.Calc_Euclidian_Distance(i_Fr_Photo_Sha => r.Photo_Sha,
                                                          i_Sc_Photo_Sha => r.Matched_Sha);
    
      continue when v_Match_Score > Hface_Pref.c_Actual_Threshold;
    
      Save_Photo_Match(i_Company_Id  => i_Company_Id,
                       i_Photo_Sha   => r.Photo_Sha,
                       i_Matched_Sha => r.Matched_Sha,
                       i_Match_Score => v_Match_Score);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Recognition_Runtime_Service
  (
    i_Response_Procedure varchar2,
    i_Action             varchar2,
    i_Api_Uri            varchar2 := Hface_Pref.c_Recognition_Route_Embed,
    i_Http_Method        varchar2 := Href_Pref.c_Http_Method_Post,
    i_Data               Gmap := Gmap(),
    i_Action_In          varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap,
    i_Action_Out         varchar2 := Biruni_Pref.c_Rs_Action_In_Out_Hashmap
  ) return Runtime_Service is
    r_Settings Hface_Service_Settings%rowtype := z_Hface_Service_Settings.Take(Hface_Pref.c_Recognition_Settings_Code);
  
    v_Service Runtime_Service;
    v_Details Hashmap := Hashmap();
  begin
    if r_Settings.Host is null then
      Hface_Error.Raise_001;
    end if;
  
    v_Details.Put('username', r_Settings.Username);
    v_Details.Put('password', r_Settings.Password);
  
    v_Details.Put('action', i_Action);
    v_Details.Put('url', r_Settings.Host || i_Api_Uri);
    v_Details.Put('method', i_Http_Method);
  
    v_Service := Runtime_Service(Hface_Pref.c_Recognition_Runtime_Service_Name);
    v_Service.Set_Detail(v_Details);
    v_Service.Set_Data(Fazo.Read_Clob(i_Data.Val.To_Clob()));
  
    v_Service.Set_Response_Procedure(Response_Procedure => i_Response_Procedure,
                                     Action_In          => i_Action_In,
                                     Action_Out         => i_Action_Out);
  
    return v_Service;
  end;

end Hface_Core;
/
