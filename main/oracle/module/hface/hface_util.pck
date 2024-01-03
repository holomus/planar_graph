create or replace package Hface_Util is
  ----------------------------------------------------------------------------------------------------
  Function Photo_Vector_Exists(i_Photo_Sha varchar2) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Euclidian_Distance
  (
    i_Fr_Photo_Sha varchar2,
    i_Sc_Photo_Sha varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Duplicate_Prevention(i_Company_Id number) return varchar2;
end Hface_Util;
/
create or replace package body Hface_Util is
  ----------------------------------------------------------------------------------------------------
  Function Photo_Vector_Exists(i_Photo_Sha varchar2) return boolean is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hface_Photo_Vectors q
     where q.Photo_Sha = i_Photo_Sha;
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Photo_Vector(i_Photo_Sha varchar2) return Json_Array_t is
    result clob;
  begin
    select q.Photo_Vector
      into result
      from Hface_Photo_Vectors q
     where q.Photo_Sha = i_Photo_Sha;
  
    return Json_Array_t(result);
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Euclidian_Distance
  (
    i_Fr_Photo_Sha varchar2,
    i_Sc_Photo_Sha varchar2
  ) return number is
    V1 Json_Array_t;
    V2 Json_Array_t;
  
    result number := 0;
    v_Kv   number;
  begin
    V1 := Take_Photo_Vector(i_Fr_Photo_Sha);
    V2 := Take_Photo_Vector(i_Sc_Photo_Sha);
  
    if V1 is null or V2 is null then
      return Hface_Pref.c_Big_Euclidian_Distance;
    end if;
  
    if V1.Get_Size <> V2.Get_Size then
      return Hface_Pref.c_Big_Euclidian_Distance;
    end if;
  
    for i in 1 .. V1.Get_Size
    loop
      v_Kv := V1.Get_Number(i - 1) - V2.Get_Number(i - 1);
    
      result := result + v_Kv * v_Kv;
    end loop;
  
    return Power(result, 0.5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Duplicate_Prevention(i_Company_Id number) return varchar2 is
  begin
    return 'N';
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Hface_Pref.c_Duplicate_Prevention),
               'N');
  end;

end Hface_Util;
/
