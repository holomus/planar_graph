create or replace package Ui_Vhr157 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr157;
/
create or replace package body Ui_Vhr157 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Person    Htt_Persons%rowtype;
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap;
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
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
  
    return result;
  end;

end Ui_Vhr157;
/
