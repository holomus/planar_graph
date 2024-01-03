create or replace package Ui_Vhr156 is
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Experiences(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Work_Places(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Awards(p Hashmap) return Arraylist;
end Ui_Vhr156;
/
create or replace package body Ui_Vhr156 is
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Experiences(p Hashmap) return Arraylist is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    select Array_Varchar2((select w.Name
                            from Href_Experience_Types w
                           where w.Company_Id = q.Company_Id
                             and w.Experience_Type_Id = q.Experience_Type_Id),
                          q.Is_Working,
                          Decode(q.Is_Working, 'Y', Ui.t_Yes, Ui.t_No),
                          q.Start_Date,
                          q.Num_Year,
                          q.Num_Month,
                          q.Num_Day)
      bulk collect
      into v_Matrix
      from Href_Person_Experiences q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Work_Places(p Hashmap) return Arraylist is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    select Array_Varchar2(q.Start_Date,
                          q.End_Date,
                          q.Organization_Name,
                          q.Job_Title,
                          q.Organization_Address)
      bulk collect
      into v_Matrix
      from Href_Person_Work_Places q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Awards(p Hashmap) return Arraylist is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    select Array_Varchar2((select w.Name
                            from Href_Awards w
                           where w.Company_Id = q.Company_Id
                             and w.Award_Id = q.Award_Id),
                          q.Doc_Title,
                          q.Doc_Number,
                          q.Doc_Date)
      bulk collect
      into v_Matrix
      from Href_Person_Awards q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

end Ui_Vhr156;
/
