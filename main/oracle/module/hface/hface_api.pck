create or replace package Hface_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Match_Photo
  (
    i_Company_Id number,
    i_Photo_Sha  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Photo_Vector_Calculated
  (
    i_Company_Id   number,
    i_Photo_Sha    varchar2,
    i_Photo_Vector Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Duplicate_Prevention_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  );
end Hface_Api;
/
create or replace package body Hface_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Match_Photo
  (
    i_Company_Id number,
    i_Photo_Sha  varchar2
  ) is
    v_Vector      Hface_Photo_Vectors%rowtype;
    v_Match_Score number;
  begin
    if not z_Hface_Calculated_Photos.Exist(i_Company_Id => i_Company_Id, --
                                           i_Photo_Sha  => i_Photo_Sha) then
      return;
    end if;
  
    v_Vector := z_Hface_Photo_Vectors.Take(i_Photo_Sha);
  
    if v_Vector.Photo_Sha is null then
      return;
    end if;
  
    for r in (select q.*
                from Hface_Calculated_Photos q
                join Hface_Photo_Vectors p
                  on p.Photo_Sha = q.Photo_Sha
               where q.Company_Id = i_Company_Id
                 and q.Photo_Sha <> i_Photo_Sha
                 and not exists (select 1
                        from Hface_Matched_Photos Mp
                       where Mp.Company_Id = i_Company_Id
                         and Mp.Matched_Sha = i_Photo_Sha))
    loop
      v_Match_Score := Hface_Util.Calc_Euclidian_Distance(i_Fr_Photo_Sha => i_Photo_Sha,
                                                          i_Sc_Photo_Sha => r.Photo_Sha);
    
      continue when v_Match_Score > Hface_Pref.c_Actual_Threshold;
    
      Hface_Core.Save_Photo_Match(i_Company_Id  => i_Company_Id,
                                  i_Photo_Sha   => i_Photo_Sha,
                                  i_Matched_Sha => r.Photo_Sha,
                                  i_Match_Score => v_Match_Score);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Photo_Vector_Calculated
  (
    i_Company_Id   number,
    i_Photo_Sha    varchar2,
    i_Photo_Vector Array_Varchar2
  ) is
  begin
    Hface_Core.Save_Photo_Vector_Calculated(i_Company_Id   => i_Company_Id,
                                            i_Photo_Sha    => i_Photo_Sha,
                                            i_Photo_Vector => i_Photo_Vector);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Duplicate_Prevention_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Hface_Pref.c_Duplicate_Prevention,
                           i_Value      => 'N');
    return;
  
    if i_Value not in ('Y', 'N') then
      Hface_Error.Raise_002;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Hface_Pref.c_Duplicate_Prevention,
                           i_Value      => Nvl(i_Value, 'N'));
  end;

end Hface_Api;
/
