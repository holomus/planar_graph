create or replace package Ui_Vhr43 is
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Files(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Save_File(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del_File(p Hashmap);
end Ui_Vhr43;
/
create or replace package body Ui_Vhr43 is
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Files(p Hashmap) return Arraylist is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    select Array_Varchar2(q.Title,
                          q.Note,
                          q.File_Sha,
                          (select s.File_Name
                             from Biruni_Files s
                            where s.Sha = q.File_Sha))
      bulk collect
      into v_Matrix
      from Mr_Person_Files q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_File(p Hashmap) return Hashmap is
    v_Person_Id number := p.r_Number('person_id');
    r_Data      Mr_Person_Files%rowtype;
    result      Hashmap;
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    r_Data.Company_Id := Ui.Company_Id;
  
    z_Mr_Person_Files.To_Row(r_Data, p, z.File_Sha, z.Title, z.Note);
  
    r_Data.Person_Id := v_Person_Id;
  
    Mr_Api.Person_Add_File(r_Data);
  
    result := z_Mr_Person_Files.To_Map(r_Data, z.Title, z.Note, z.File_Sha);
  
    Result.Put('file_name', z_Biruni_Files.Load(r_Data.File_Sha).File_Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del_File(p Hashmap) is
    v_Person_Id number := p.r_Number('person_id');
  begin
    Uit_Href.Assert_Access_To_Employee(v_Person_Id);
  
    Mr_Api.Person_Remove_File(i_Company_Id => Ui.Company_Id,
                              i_Person_Id  => v_Person_Id,
                              i_File_Sha   => p.r_Varchar2('file_sha'));
  end;

end Ui_Vhr43;
/
