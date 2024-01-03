create or replace package Ui_Vhr153 is
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Merital_Status(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Person_Family_Members(p Hashmap) return Arraylist;
end Ui_Vhr153;
/
create or replace package body Ui_Vhr153 is
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Merital_Status(p Hashmap) return Arraylist is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    select Array_Varchar2((select w.Name
                            from Href_Marital_Statuses w
                           where w.Company_Id = q.Company_Id
                             and w.Marital_Status_Id = q.Marital_Status_Id),
                          q.Start_Date)
      bulk collect
      into v_Matrix
      from Href_Person_Marital_Statuses q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Person_Family_Members(p Hashmap) return Arraylist is
    v_Matrix    Matrix_Varchar2;
    v_Person_Id number := p.r_Number('person_id');
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Person_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    select Array_Varchar2(q.Name,
                          (select w.Name
                             from Href_Relation_Degrees w
                            where w.Company_Id = q.Company_Id
                              and w.Relation_Degree_Id = q.Relation_Degree_Id),
                          q.Birthday,
                          q.Workplace,
                          Decode(q.Is_Dependent, 'Y', Ui.t_Yes, Ui.t_No),
                          Decode(q.Is_Private, 'Y', Ui.t_Yes, Ui.t_No))
      bulk collect
      into v_Matrix
      from Href_Person_Family_Members q
     where q.Company_Id = Ui.Company_Id
       and q.Person_Id = v_Person_Id;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

end Ui_Vhr153;
/
