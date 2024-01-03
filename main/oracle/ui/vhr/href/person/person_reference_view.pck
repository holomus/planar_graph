create or replace package Ui_Vhr150 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr150;
/
create or replace package body Ui_Vhr150 is
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
  
    select Array_Varchar2((select w.Name
                            from Href_Reference_Types w
                           where w.Company_Id = q.Company_Id
                             and w.Reference_Type_Id = q.Reference_Type_Id),
                          q.Ref_Number,
                          q.Ref_Date,
                          q.Start_Date,
                          q.End_Date,
                          q.Name)
      bulk collect
      into v_Matrix
      from Href_Person_References q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    Result.Put('person_references', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

end Ui_Vhr150;
/
