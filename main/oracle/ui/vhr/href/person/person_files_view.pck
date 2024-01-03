create or replace package Ui_Vhr151 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr151;
/
create or replace package body Ui_Vhr151 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
    result      Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
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
  
    Result.Put('person_files', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

end Ui_Vhr151;
/
